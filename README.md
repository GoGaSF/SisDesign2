# Global Student Portal – Neo4j Dependency Graph + Stability Metrics

This repository contains a dependency graph for a Global Student Portal (multi-university architecture),
stored in Neo4j. Dependencies are modeled as (A)-[:DEPENDS_ON]->(B).

## Stability Metrics (Clean Architecture)
- Fan-in: incoming dependencies count
- Fan-out: outgoing dependencies count
- Instability I = Fan-out / (Fan-in + Fan-out)

Metrics are computed and stored as node properties:
- c.fanIn, c.fanOut, c.instability

## Queries that were used
MATCH (a:Component {name:"Registration Service"})-[:DEPENDS_ON]->(b:Component)
RETURN a.name AS from, b.name AS to;

Метрики (Fan-in, Fan-out, Instability) без сохранения
MATCH (c:Component)
RETURN
  c.name AS component,
  size((c)<-[:DEPENDS_ON]-()) AS fanIn,
  size((c)-[:DEPENDS_ON]->()) AS fanOut,
  CASE
    WHEN (size((c)<-[:DEPENDS_ON]-()) + size((c)-[:DEPENDS_ON]->())) = 0 THEN 0.0
    ELSE
      toFloat(size((c)-[:DEPENDS_ON]->())) /
      toFloat(size((c)<-[:DEPENDS_ON]-()) + size((c)-[:DEPENDS_ON]->()))
  END AS instability
ORDER BY instability DESC, component ASC;

Метрики + сохранение (миграция 03)
Это тот же расчёт, но с SET c.fanIn=..., c.fanOut=..., c.instability=...

## Stucter project
global-student-portal-neo4j/
  docker-compose.yml
  migrations/
    01_constraints.cypher
    02_seed_graph.cypher
    03_compute_metrics.cypher
  README.md

## Run
```bash
docker compose up -d
docker exec -i gsp-neo4j cypher-shell -u neo4j -p neo4jpass < migrations/01_constraints.cypher
docker exec -i gsp-neo4j cypher-shell -u neo4j -p neo4jpass < migrations/02_seed_graph.cypher
docker exec -i gsp-neo4j cypher-shell -u neo4j -p neo4jpass < migrations/03_compute_metrics.cypher
