SELECT count(*)
FROM message_hasTag_Tag
JOIN Comment_replyOf_message
  ON message_hasTag_Tag.MessageId = Comment_replyOf_message.ParentMessageId
JOIN Comment_hasTag_Tag AS cht1
  ON Comment_replyOf_message.CommentId = cht1.CommentId
LEFT JOIN Comment_hasTag_Tag AS cht2
       ON message_hasTag_Tag.TagId = cht2.TagId
      AND Comment_replyOf_message.CommentId = cht2.CommentId
    WHERE message_hasTag_Tag.TagId != cht1.TagId
      AND cht2.TagId IS NULL;
