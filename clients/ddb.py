import duckdb
import time

def run_query(con, query_id, query_spec):
    start = time.time()
    con.execute(query_spec)
    result = con.fetchall()
    end = time.time()
    duration = end - start
    print("Q{}: {:.4f} seconds, {} tuples".format(query_id, duration, result[0][0]))
    return (duration, result)

con = duckdb.connect(database='ddb-scratch/ldbc.duckdb', read_only=True)

run_query(con, 3, """
  SELECT count(*)
  FROM message_hasTag_tag, comment_replyOf_message, comment_hasTag_tag AS comment_hasTag_tag1
  WHERE message_hasTag_tag.MessageId = comment_replyOf_message.ParentMessageId
    AND comment_replyOf_message.CommentId = comment_hasTag_tag1.CommentId
    AND message_hasTag_tag.TagId != comment_hasTag_tag1.TagId
    AND NOT EXISTS (SELECT 1 FROM comment_hasTag_tag AS comment_hasTag_tag2
      WHERE message_hasTag_tag.TagId = comment_hasTag_tag2.TagId
        AND comment_replyOf_message.CommentId = comment_hasTag_tag2.CommentId
    );
  """)
