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

# using FROM + WHERE
run_query(con, "3a", """
  SELECT count(*)
  FROM message_hasTag_tag, comment_replyOf_message, comment_hasTag_tag AS cht1
  WHERE message_hasTag_tag.MessageId = comment_replyOf_message.ParentMessageId
    AND comment_replyOf_message.CommentId = cht1.CommentId
    AND message_hasTag_tag.TagId != cht1.TagId
    AND NOT EXISTS (SELECT 1 FROM comment_hasTag_tag AS cht2
      WHERE message_hasTag_tag.TagId = cht2.TagId
        AND comment_replyOf_message.CommentId = cht2.CommentId
    );
  """)

# using JOIN ON
run_query(con, "3b", """
  SELECT count(*)
  FROM message_hasTag_tag
  JOIN comment_replyOf_message
    ON message_hasTag_tag.MessageId = comment_replyOf_message.ParentMessageId
  JOIN comment_hasTag_tag AS cht1
    ON comment_replyOf_message.CommentId = cht1.CommentId
  LEFT JOIN comment_hasTag_tag AS cht2
         ON message_hasTag_tag.TagId = cht2.TagId
        AND comment_replyOf_message.CommentId = cht2.CommentId
  WHERE message_hasTag_tag.TagId != cht1.TagId
    AND cht2.TagId IS NULL;
  """)
