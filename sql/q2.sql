SELECT count(*)
FROM message_hasTag_tag
JOIN message_hasCreator_person
  ON message_hasTag_tag.MessageId = message_hasCreator_person.MessageId
LEFT JOIN comment_replyOf_message 
  ON comment_replyOf_message.ParentMessageId = message_hasTag_tag.MessageId
LEFT JOIN person_likes_message
  ON person_likes_message.MessageId = message_hasTag_tag.MessageId;
