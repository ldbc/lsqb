SELECT count(*)
FROM message_hasTag_Tag
JOIN message_hasCreator_Person
  ON message_hasTag_Tag.MessageId = message_hasCreator_Person.MessageId
LEFT JOIN Comment_replyOf_message 
  ON Comment_replyOf_message.ParentMessageId = message_hasTag_Tag.MessageId
LEFT JOIN Person_likes_message
  ON Person_likes_message.MessageId = message_hasTag_Tag.MessageId;
