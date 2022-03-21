SELECT count(*)
FROM Message_hasTag_Tag
LEFT JOIN Comment_replyOf_Message 
  ON Comment_replyOf_Message.ParentMessageId = Message_hasTag_Tag.MessageId
LEFT JOIN Person_likes_Message
  ON Person_likes_Message.MessageId = Message_hasTag_Tag.MessageId;
