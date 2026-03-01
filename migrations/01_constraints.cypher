CREATE CONSTRAINT component_name_unique IF NOT EXISTS
FOR (c:Component) REQUIRE c.name IS UNIQUE;
