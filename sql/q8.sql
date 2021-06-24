SELECT count(*)
FROM Message_hasTag_Tag
JOIN Comment_replyOf_Message
  ON Message_hasTag_Tag.MessageId = Comment_replyOf_Message.ParentMessageId
JOIN Comment_hasTag_Tag AS cht1
  ON Comment_replyOf_Message.CommentId = cht1.CommentId
LEFT JOIN Comment_hasTag_Tag AS cht2
       ON Message_hasTag_Tag.TagId = cht2.TagId
      AND Comment_replyOf_Message.CommentId = cht2.CommentId
    WHERE Message_hasTag_Tag.TagId != cht1.TagId
      AND cht2.TagId IS NULL;
