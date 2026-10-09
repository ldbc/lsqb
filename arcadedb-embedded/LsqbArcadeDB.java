import com.arcadedb.database.Database;
import com.arcadedb.database.DatabaseFactory;
import com.arcadedb.database.RID;
import com.arcadedb.graph.GraphTraversalProviderRegistry;
import com.arcadedb.graph.MutableVertex;
import com.arcadedb.graph.olap.GraphAnalyticalView;
import com.arcadedb.graph.olap.GraphAnalyticalViewRegistry;
import com.arcadedb.query.sql.executor.ResultSet;
import com.arcadedb.schema.Schema;
import com.arcadedb.schema.Type;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * LSQB for ArcadeDB, embedded (in-process).
 *
 * Usage: LsqbArcadeDB (load|post-load|run) SF DB_PATH MERGED_FK_DATA_DIR [WARM_REPS]
 *
 * load:      creates the database (an existing one at DB_PATH is replaced), the schema and loads the data.
 * post-load: defines the Graph Analytical View (CSR) over all vertex and edge types.
 * run:       runs cypher/q1.cypher ... q9.cypher and appends to results/results.csv; with WARM_REPS > 0 every query
 *            is executed once as warm-up (not reported) and the median of WARM_REPS timed runs is written.
 */
public class LsqbArcadeDB {
  static final String[] VERTEX_TYPES = { "Continent", "Country", "City", "University", "Company", "TagClass", "Tag",
      "Person", "Forum", "Post", "Comment" };
  static final String[] EDGE_TYPES = { "IS_PART_OF", "IS_LOCATED_IN", "HAS_MEMBER", "CONTAINER_OF", "REPLY_OF", "HAS_TAG",
      "HAS_TYPE", "HAS_CREATOR", "KNOWS", "LIKES", "HAS_INTEREST", "HAS_MODERATOR", "IS_SUBCLASS_OF", "STUDY_AT", "WORK_AT" };

  // {edge type, csv file, source type, source column, target type, target column}
  static final String[][] EDGES = {
      { "IS_PART_OF", "Country.csv", "Country", "id", "Continent", "ispartof_continent" },
      { "IS_PART_OF", "City.csv", "City", "id", "Country", "ispartof_country" },
      { "IS_SUBCLASS_OF", "TagClass.csv", "TagClass", "id", "TagClass", "issubclassof_tagclass" },
      { "IS_LOCATED_IN", "University.csv", "University", "id", "City", "islocatedin_city" },
      { "IS_LOCATED_IN", "Company.csv", "Company", "id", "Country", "islocatedin_country" },
      { "IS_LOCATED_IN", "Person.csv", "Person", "id", "City", "islocatedin_city" },
      { "IS_LOCATED_IN", "Post.csv", "Post", "id", "Country", "islocatedin_country" },
      { "IS_LOCATED_IN", "Comment.csv", "Comment", "id", "Country", "islocatedin_country" },
      { "HAS_TYPE", "Tag.csv", "Tag", "id", "TagClass", "hastype_tagclass" },
      { "HAS_CREATOR", "Post.csv", "Post", "id", "Person", "hascreator_person" },
      { "CONTAINER_OF", "Post.csv", "Forum", "forum_containerof", "Post", "id" },
      { "HAS_CREATOR", "Comment.csv", "Comment", "id", "Person", "hascreator_person" },
      { "REPLY_OF", "Comment.csv", "Comment", "id", "Post", "replyof_post" },
      { "REPLY_OF", "Comment.csv", "Comment", "id", "Comment", "replyof_comment" },
      { "HAS_MODERATOR", "Forum.csv", "Forum", "id", "Person", "hasmoderator_person" },
      { "HAS_MEMBER", "Forum_hasMember_Person.csv", "Forum", "id", "Person", "hasmember_person" },
      { "HAS_TAG", "Forum_hasTag_Tag.csv", "Forum", "id", "Tag", "hastag_tag" },
      { "HAS_TAG", "Comment_hasTag_Tag.csv", "Comment", "id", "Tag", "hastag_tag" },
      { "HAS_TAG", "Post_hasTag_Tag.csv", "Post", "id", "Tag", "hastag_tag" },
      { "KNOWS", "Person_knows_Person.csv", "Person", "person1id", "Person", "person2id" },
      { "LIKES", "Person_likes_Comment.csv", "Person", "id", "Comment", "likes_comment" },
      { "LIKES", "Person_likes_Post.csv", "Person", "id", "Post", "likes_post" },
      { "HAS_INTEREST", "Person_hasInterest_Tag.csv", "Person", "id", "Tag", "hasinterest_tag" },
      { "STUDY_AT", "Person_studyAt_University.csv", "Person", "id", "University", "studyat_university" },
      { "WORK_AT", "Person_workAt_Company.csv", "Person", "id", "Company", "workat_company" },
  };

  public static void main(String[] args) throws Exception {
    if (args.length < 4) {
      System.err.println("Usage: LsqbArcadeDB (load|post-load|run) SF DB_PATH MERGED_FK_DATA_DIR [WARM_REPS]");
      System.exit(1);
    }
    String mode = args[0], sf = args[1], dbPath = args[2], dataDir = args[3];
    int warmReps = args.length > 4 ? Integer.parseInt(args[4]) : 0;

    switch (mode) {
    case "load" -> load(dbPath, dataDir);
    case "post-load" -> withDatabase(dbPath, db -> buildView(db));
    case "run" -> withDatabase(dbPath, db -> {
      buildView(db);
      run(db, sf, warmReps);
    });
    default -> throw new IllegalArgumentException("Unknown mode " + mode);
    }
  }

  interface Action {
    void accept(Database db) throws Exception;
  }

  static void withDatabase(String dbPath, Action action) throws Exception {
    try (DatabaseFactory factory = new DatabaseFactory(dbPath)) {
      Database db = factory.open();
      try {
        action.accept(db);
      } finally {
        db.close();
      }
    }
  }

  // ---------------------------------------------------------------- load

  static void load(String dbPath, String dataDir) throws Exception {
    deleteDirectory(new File(dbPath));
    try (DatabaseFactory factory = new DatabaseFactory(dbPath)) {
      Database db = factory.create();
      try {
        createSchema(db);

        // Post and Comment extend Message, so the :Message label matches both
        Map<String, Map<Long, RID>> rids = new HashMap<>();
        for (String type : VERTEX_TYPES) {
          Map<Long, RID> map = new HashMap<>();
          db.begin();
          int count = 0;
          try (BufferedReader br = reader(dataDir, type + ".csv")) {
            br.readLine(); // header
            String line;
            while ((line = br.readLine()) != null) {
              long id = Long.parseLong(line.split("\\|", -1)[0]);
              MutableVertex v = db.newVertex(type);
              v.set("cid", id);
              v.save();
              map.put(id, v.getIdentity());
              if (++count % 10_000 == 0) {
                db.commit();
                db.begin();
              }
            }
          }
          db.commit();
          rids.put(type, map);
          System.out.println("  " + type + ": " + count);
        }

        for (String[] e : EDGES)
          loadEdges(db, rids, dataDir, e[0], e[1], e[2], e[3], e[4], e[5]);
      } finally {
        db.close();
      }
    }
  }

  static void createSchema(Database db) {
    Schema schema = db.getSchema();
    for (String t : new String[] { "Continent", "Country", "City", "University", "Company", "TagClass", "Tag", "Person",
        "Forum", "Message" })
      schema.createVertexType(t);
    schema.createVertexType("Post").addSuperType("Message");
    schema.createVertexType("Comment").addSuperType("Message");
    for (String t : new String[] { "Continent", "Country", "City", "University", "Company", "TagClass", "Tag", "Person",
        "Forum", "Message" }) {
      schema.getType(t).createProperty("cid", Type.LONG);
      schema.getType(t).createTypeIndex(Schema.INDEX_TYPE.HASH, true, "cid");
    }
    for (String e : EDGE_TYPES)
      schema.createEdgeType(e);
  }

  static void loadEdges(Database db, Map<String, Map<Long, RID>> rids, String dataDir, String edgeType, String file,
      String fromType, String fromCol, String toType, String toCol) throws IOException {
    Map<Long, RID> from = rids.get(fromType), to = rids.get(toType);
    db.begin();
    int count = 0;
    try (BufferedReader br = reader(dataDir, file)) {
      String[] header = br.readLine().split("\\|", -1);
      int fi = indexOf(header, fromCol), ti = indexOf(header, toCol);
      String line;
      while ((line = br.readLine()) != null) {
        String[] p = line.split("\\|", -1);
        if (p[fi].isEmpty() || p[ti].isEmpty())
          continue;
        RID src = from.get(Long.parseLong(p[fi])), dst = to.get(Long.parseLong(p[ti]));
        if (src == null || dst == null)
          continue;
        src.asVertex().newEdge(edgeType, dst);
        if (++count % 50_000 == 0) {
          db.commit();
          db.begin();
        }
      }
    }
    db.commit();
    System.out.println("  " + edgeType + " (" + file + "): " + count);
  }

  // ---------------------------------------------------------------- Graph Analytical View

  static void buildView(Database db) {
    if ("1".equals(System.getenv("ARCADEDB_NO_GAV"))) {
      System.out.println("Graph Analytical View skipped (ARCADEDB_NO_GAV=1)");
      return;
    }
    GraphAnalyticalView view = GraphAnalyticalViewRegistry.get(db, "lsqb");
    if (view == null)
      GraphAnalyticalView.builder(db).withName("lsqb").withVertexTypes(VERTEX_TYPES).withEdgeTypes(EDGE_TYPES).build();
    if (!GraphTraversalProviderRegistry.awaitAll(db, 600, TimeUnit.SECONDS))
      System.err.println("WARNING: the Graph Analytical View was not ready after 600 s");
    System.out.println("Graph Analytical View ready");
  }

  // ---------------------------------------------------------------- run

  static void run(Database db, String sf, int warmReps) throws Exception {
    String variant = "embedded" + ("1".equals(System.getenv("ARCADEDB_NO_GAV")) ? ", no GAV" : "") + (warmReps > 0 ? ", warm" : "");
    String system = "ArcadeDB-" + System.getenv().getOrDefault("ARCADEDB_VERSION", "unknown");
    try (java.io.FileWriter results = new java.io.FileWriter("results/results.csv", true)) {
      for (int i = 1; i <= 9; i++) {
        System.out.println("Query " + i);
        String query = new String(Files.readAllBytes(Paths.get("cypher/q" + i + ".cypher"))).trim();
        long count;
        double seconds;
        if (warmReps > 0) {
          runQuery(db, query); // warm-up, not reported
          double[] times = new double[warmReps];
          count = -1;
          for (int r = 0; r < warmReps; r++) {
            long t0 = System.nanoTime();
            count = runQuery(db, query);
            times[r] = (System.nanoTime() - t0) / 1e9;
          }
          Arrays.sort(times);
          seconds = times[warmReps / 2];
        } else {
          long t0 = System.nanoTime();
          count = runQuery(db, query);
          seconds = (System.nanoTime() - t0) / 1e9;
        }
        results.write(String.format("%s\t%s\t%s\t%d\t%.4f\t%d%n", system, variant, sf, i, seconds, count));
        results.flush();
      }
    }
  }

  static long runQuery(Database db, String query) {
    db.begin();
    try (ResultSet rs = db.query("opencypher", query)) {
      return ((Number) rs.next().getProperty("count")).longValue();
    } finally {
      db.rollback();
    }
  }

  // ---------------------------------------------------------------- helpers

  static BufferedReader reader(String dir, String file) throws IOException {
    return new BufferedReader(new FileReader(new File(dir, file)), 1 << 20);
  }

  static int indexOf(String[] header, String column) {
    for (int i = 0; i < header.length; i++)
      if (header[i].equals(column))
        return i;
    throw new IllegalArgumentException("Column " + column + " not found in " + Arrays.toString(header));
  }

  static void deleteDirectory(File dir) {
    File[] files = dir.listFiles();
    if (files != null)
      for (File f : files)
        if (f.isDirectory())
          deleteDirectory(f);
        else
          f.delete();
    dir.delete();
  }
}
