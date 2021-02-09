SELECT count(*)
FROM message_hasTag_tag, comment_replyOf_message, comment_hasTag_tag AS cht1
WHERE message_hasTag_tag.MessageId = comment_replyOf_message.ParentMessageId
  AND comment_replyOf_message.CommentId = cht1.CommentId
  AND message_hasTag_tag.TagId != cht1.TagId
  AND NOT EXISTS (SELECT 1 FROM comment_hasTag_tag AS cht2
    WHERE message_hasTag_tag.TagId = cht2.TagId
      AND comment_replyOf_message.CommentId = cht2.CommentId
  );
