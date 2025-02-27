SELECT count(*) FROM GRAPH_TABLE (lsqb
    MATCH (c:Country)<-[ipo:City_isPartOf_Country]-(c1:City)<-[ilo:Person_isLocatedIn]-(p:Person)<-[hm:hasMember]-(f:Forum)-[co:containerOf]->(po:Post)<-[ro:replyOf_Post]-(c2:Comment)-[ht:Comment_HasTag]->(t:Tag)-[ht2:hasType]->(tc:TagClass)
)