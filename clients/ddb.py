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

run_query(con, "1", """
  SELECT count(*)
  FROM place_isPartOf_place, place p1, place p2, person_isLocatedIn_place, forum_hasModerator_person,
    forum_containerOf_post, comment_replyOf_post, comment_hasTag_tag, tag_hasType_tagclass  
  WHERE place_isPartOf_place.Place1Id = p1.id
    AND p1.label = 'City'
    AND place_isPartOf_place.Place2Id = p2.id
    AND p2.label = 'Country'
    AND person_isLocatedIn_place.PlaceId = place_isPartOf_place.Place1Id
    AND forum_hasModerator_person.PersonId = person_isLocatedIn_place.PersonId
    AND forum_containerOf_post.ForumId = forum_hasModerator_person.ForumId
    AND forum_containerOf_post.PostId = comment_replyOf_post.ParentPostId
    AND comment_hasTag_tag.CommentId =  comment_replyOf_post.CommentId
    AND comment_hasTag_tag.TagId = tag_hasType_tagclass.TagId;
""")

run_query(con, "2", """
  SELECT count(*), count(person_likes_message.PersonId), count(comment_replyOf_message.CommentId)
  FROM message_hasTag_tag
  JOIN message_hasCreator_person
    ON message_hasTag_tag.MessageId = message_hasCreator_person.MessageId
  LEFT JOIN comment_replyOf_message 
    ON comment_replyOf_message.ParentMessageId = message_hasTag_tag.MessageId
  LEFT JOIN person_likes_message
    ON person_likes_message.MessageId = message_hasTag_tag.MessageId;
  """)

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


run_query(con, "4", """
  SELECT count(*)
  FROM person_knows_person, comment_hasCreator_person, comment_replyOf_post, post_hasCreator_person
  WHERE person_knows_person.Person1Id = comment_hasCreator_person.PersonId
    AND comment_hasCreator_person.CommentId = comment_replyOf_post.CommentId
    AND comment_replyOf_post.ParentPostId = post_hasCreator_person.PostId
    AND post_hasCreator_person.PersonId = person_knows_person.Person2Id;
  """)

# run_query(con, "5", """
#   SELECT count(*)
#   FROM person_isLocatedIn_place as pilip1, person_isLocatedIn_place as pilip2, person_isLocatedIn_place as pilip3, place_isPartOf_place as pipop1,
#     person_knows_person as pkp1, person_knows_person pkp2, person_knows_person pkp3, place_isPartOf_place as pipop2, place_isPartOf_place as pipop3, place p1,
#     place p4, place p5, place p6
#   WHERE pilip1.PlaceId = pipop1.Place1Id
#     AND pilip2.PlaceId = pipop2.Place1Id
#     AND pilip3.PlaceId = pipop3.Place1Id
#     AND pipop1.Place2Id = p1.id
#     AND pipop2.Place2Id = p1.id
#     AND pipop3.Place2Id = p1.id
#     AND p1.label = 'Country'
#     AND pilip1.PlaceId = p4.id
#     AND pilip2.PlaceId = p5.id
#     AND pilip3.PlaceId = p6.id
#     AND p4.label = 'City' 
#     AND p5.label = 'City'
#     AND p6.label = 'City'
#     AND pilip1.PersonId = pkp1.Person1Id
#     AND pilip2.PersonId = pkp1.Person2Id
#     AND pilip2.PersonId = pkp2.Person1Id
#     AND pilip3.PersonId = pkp2.Person2Id
#     AND pilip3.PersonId = pkp3.Person1Id
#     AND pilip1.PersonId = pkp3.Person2Id;
# """)

run_query(con, "5", """
  select count(*)
  FROM person_isLocatedIn_place pilip1, person_isLocatedIn_place pilip2, person_isLocatedIn_place pilip3,
    place p1, place p2, place p3, place p4, place_isPartOf_place as pipop1, place_isPartOf_place as pipop2,
    place_isPartOf_place as pipop3, person_knows_person as pkp1, person_knows_person pkp2, person_knows_person pkp3
  WHERE pilip1.PlaceId = p1.id
    AND p1.label = 'City'
    AND p1.id = pipop1.Place1Id
    AND pipop1.Place2Id = p4.id
    AND p4.label = 'Country'
    AND pilip2.PlaceId = p2.id
    AND p2.label = 'City'
    AND p2.id = pipop2.Place1Id
    AND pipop2.Place2Id = p4.id
    AND pilip3.PlaceId = p3.id
    AND p3.label = 'City'
    AND p3.id = pipop3.Place1Id
    AND pipop3.Place2Id = p4.id
    AND pilip1.PersonId = pkp1.Person1Id
    AND pilip2.PersonId = pkp1.Person2Id
    AND pilip2.PersonId = pkp2.Person1Id
    AND pilip3.PersonId = pkp2.Person2Id
    AND pilip3.PersonId = pkp3.Person1Id
    AND pilip1.PersonId = pkp3.Person2Id;
  """)

