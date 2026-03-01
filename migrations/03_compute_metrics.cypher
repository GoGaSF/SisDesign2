MATCH (c:Component)
WITH
  c,
  size( (c)<-[:DEPENDS_ON]-() ) AS fanIn,
  size( (c)-[:DEPENDS_ON]->() ) AS fanOut
WITH
  c, fanIn, fanOut,
  CASE
    WHEN (fanIn + fanOut) = 0 THEN 0.0
    ELSE toFloat(fanOut) / toFloat(fanIn + fanOut)
  END AS instability
SET
  c.fanIn = fanIn,
  c.fanOut = fanOut,
  c.instability = instability
RETURN c.name AS component, fanIn, fanOut, instability
ORDER BY instability DESC, component ASC;
