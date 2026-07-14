SELECT count(*) FROM GRAPH_TABLE (
    lsqb
    
    MATCH (c IS Country)
        <-[ipo IS City_isPartOf_Country]-(c1 IS City)
        <-[ilo IS Person_isLocatedIn]-(p IS Person)
        <-[hm IS hasMember]-(f IS Forum)
        -[co IS containerOf]->(po IS Post)
        <-[ro IS replyOf_Post]-(c2 IS Comment)
        -[ht IS Comment_HasTag]->(t IS Tag)
        -[ht2 IS hasType]->(tc IS TagClass)
    
    COLUMNS(1 AS c)
);
