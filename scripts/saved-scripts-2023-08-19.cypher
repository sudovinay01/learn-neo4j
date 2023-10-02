//COUNT of nodes by label
MATCH (n) 
RETURN DISTINCT LABELS(n), COUNT(n) ORDER BY COUNT(n) DESC

//COUNT of nodes by label apoc
CALL apoc.meta.stats() YIELD labels
RETURN labels

//CSV apoc.periodic.iterate
CALL apoc.periodic.iterate(
"CALL apoc.load.csv('https://data.neo4j.com/v4.0-intro-neo4j/movies2.csv' )
 YIELD map AS row RETURN row",
 "WITH row.movieId as movieId, row.title AS title, row.genres AS genres,
      toInteger(row.releaseYear) AS releaseYear, toFloat(row.avgVote) AS avgVote,
      collect({id: row.personId, name:row.name, born: toInteger(row.birthYear),
      died: toInteger(row.deathYear),personType: row.personType,
      roles: split(coalesce(row.characters,''),':')}) AS people
 MERGE (m:Movie {id:movieId})
    ON CREATE SET m.title=title, m.avgVote=avgVote,
       m.releaseYear=releaseYear, m.genres=split(genres,':')
 WITH *
 UNWIND people AS person
 MERGE (p:Person {id: person.id})
   ON CREATE SET p.name = person.name, p.born = person.born, p.died = person.died
 WITH  m, person, p
 CALL apoc.do.when(person.personType = 'ACTOR',
      'MERGE (p)-[:ACTED_IN {roles: person.roles}]->(m)
                 ON CREATE SET p:Actor',
      'MERGE (p)-[:DIRECTED]->(m)
          ON CREATE SET p:Director',
      {m:m, p:p, person:person}) YIELD value AS value
       RETURN count(*)  ",
{batchSize: 500}
)

//CSV Distinct values vs all values
LOAD CSV WITH HEADERS FROM "file:///Insights_data_roku_13Jan_10_40_PM.csv" AS row
RETURN count(DISTINCT row.`Conversation ID`), count(row.`Conversation ID`)

//CSV List headres
LOAD CSV WITH HEADERS FROM "file:///Insights_data_roku_13Jan_10_40_PM.csv" AS row
return keys(row) LIMIT 1

//DATABASE CREATE
CREATE DATABASE databaseName

//DATABASE DROP
DROP DATABASE databaseName

//DATABASE TO USE
:use databaseName

//DELETE ALL NODES
MATCH (n) DETACH DELETE n

//DELETE ALL NODES with commite
:auto MATCH (n)
CALL { 
WITH n
DETACH DELETE n
} IN TRANSACTIONS OF 10000 ROWS;

//DELETE NAMED GRAPH
CALL gds.graph.drop('gotGraph')

//DELTE ALL INDEXS
CALL apoc.schema.assert({},{},true) YIELD label, key
RETURN *

//INDEX SHOW ALL
SHOW INDEX 

//node property details
CALL apoc.meta.nodeTypeProperties() 

//RESET STYLE
:style reset

//Search cypher
MATCH p=(a:ENTITIES{type:"BRAND"})
WHERE a.text =~ '(?i).*google.*'
RETURN a.text

//static variable
:param variable => ("value");

//using inbuilt neo4j auto commite
:auto LOAD CSV WITH HEADERS FROM "file:///Insights_data_roku_13Jan_10_40_PM.csv" AS row
CALL {
WITH row
MERGE (post_v:POST{conversation_id:row.`Conversation ID`})
} IN TRANSACTIONS OF 10000 ROWS



//VISUALISE SCHEMA 
CALL db.schema.visualization