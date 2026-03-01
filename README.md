# Global Student Portal – Neo4j Dependency Graph + Stability Metrics

This repository contains a dependency graph for a Global Student Portal (multi-university architecture),
stored in Neo4j. Dependencies are modeled as (A)-[:DEPENDS_ON]->(B).

## Stability Metrics (Clean Architecture)
- Fan-in: incoming dependencies count
- Fan-out: outgoing dependencies count
- Instability I = Fan-out / (Fan-in + Fan-out)

Metrics are computed and stored as node properties:
- c.fanIn, c.fanOut, c.instability

## Run
```bash
docker compose up -d
docker exec -i gsp-neo4j cypher-shell -u neo4j -p neo4jpass < migrations/01_constraints.cypher
docker exec -i gsp-neo4j cypher-shell -u neo4j -p neo4jpass < migrations/02_seed_graph.cypher
docker exec -i gsp-neo4j cypher-shell -u neo4j -p neo4jpass < migrations/03_compute_metrics.cypher

## Stucter project
global-student-portal-neo4j/
  docker-compose.yml
  migrations/
    01_constraints.cypher
    02_seed_graph.cypher
    03_compute_metrics.cypher
  README.md
