SELECT count(*)
FROM Message_hasTag_Tag
JOIN Comment_replyOf_Message
  ON Message_hasTag_Tag.MessageId = Comment_replyOf_Message.ParentMessageId
JOIN Comment_hasTag_Tag AS cht1
  ON Comment_replyOf_Message.CommentId = cht1.id
LEFT JOIN Comment_hasTag_Tag AS cht2
       ON Message_hasTag_Tag.hasTag_Tag = cht2.hasTag_Tag
      AND Comment_replyOf_Message.CommentId = cht2.id
    WHERE Message_hasTag_Tag.hasTag_Tag != cht1.hasTag_Tag
      AND cht2.hasTag_Tag IS NULL;
