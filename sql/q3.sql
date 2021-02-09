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
