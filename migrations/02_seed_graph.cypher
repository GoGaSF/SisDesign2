// ---------- Components ----------
UNWIND [
  {name:"Web Client", type:"Client"},
  {name:"Mobile Client", type:"Client"},
  {name:"CDN", type:"Infra"},
  {name:"Global Load Balancer", type:"Infra"},
  {name:"API Gateway", type:"Edge"},
  {name:"BFF Web", type:"Edge"},
  {name:"BFF Mobile", type:"Edge"},

  {name:"Identity Provider", type:"Security"},
  {name:"Tenant Config Service", type:"Service"},

  {name:"User Service", type:"Service"},
  {name:"Student Service", type:"Service"},
  {name:"Course Service", type:"Service"},
  {name:"Registration Service", type:"Service"},
  {name:"Schedule Service", type:"Service"},
  {name:"Grade Service", type:"Service"},
  {name:"Finance Service", type:"Service"},
  {name:"Document Service", type:"Service"},
  {name:"Notification Service", type:"Service"},
  {name:"Search Service", type:"Service"},

  {name:"Analytics ETL", type:"Analytics"},
  {name:"Data Warehouse", type:"Analytics"},

  {name:"Relational DB", type:"Storage"},
  {name:"Object Storage", type:"Storage"},
  {name:"Redis Cache", type:"Storage"},
  {name:"Search Index", type:"Storage"},
  {name:"Event Bus", type:"Messaging"},

  {name:"LMS Adapter", type:"Integration"},
  {name:"Payment Provider Adapter", type:"Integration"},
  {name:"Email/SMS Gateway", type:"Integration"},
  {name:"Audit/Logging Service", type:"Observability"}
] AS row
MERGE (:Component {name: row.name})
SET _.type = row.type;

// ---------- Dependencies (A depends on B) ----------
UNWIND [
  // front door
  {a:"Web Client", b:"CDN"},
  {a:"Mobile Client", b:"CDN"},
  {a:"CDN", b:"Global Load Balancer"},
  {a:"Global Load Balancer", b:"API Gateway"},
  {a:"API Gateway", b:"Identity Provider"},
  {a:"API Gateway", b:"BFF Web"},
  {a:"API Gateway", b:"BFF Mobile"},
  {a:"API Gateway", b:"Tenant Config Service"},

  // BFF -> services
  {a:"BFF Web", b:"User Service"},
  {a:"BFF Web", b:"Student Service"},
  {a:"BFF Web", b:"Course Service"},
  {a:"BFF Web", b:"Registration Service"},
  {a:"BFF Web", b:"Schedule Service"},
  {a:"BFF Web", b:"Grade Service"},
  {a:"BFF Web", b:"Finance Service"},
  {a:"BFF Web", b:"Document Service"},
  {a:"BFF Web", b:"Notification Service"},
  {a:"BFF Web", b:"Search Service"},
  {a:"BFF Web", b:"Tenant Config Service"},

  {a:"BFF Mobile", b:"User Service"},
  {a:"BFF Mobile", b:"Student Service"},
  {a:"BFF Mobile", b:"Course Service"},
  {a:"BFF Mobile", b:"Registration Service"},
  {a:"BFF Mobile", b:"Schedule Service"},
  {a:"BFF Mobile", b:"Grade Service"},
  {a:"BFF Mobile", b:"Finance Service"},
  {a:"BFF Mobile", b:"Document Service"},
  {a:"BFF Mobile", b:"Notification Service"},
  {a:"BFF Mobile", b:"Search Service"},
  {a:"BFF Mobile", b:"Tenant Config Service"},

  // services -> DB
  {a:"User Service", b:"Relational DB"},
  {a:"Student Service", b:"Relational DB"},
  {a:"Course Service", b:"Relational DB"},
  {a:"Registration Service", b:"Relational DB"},
  {a:"Schedule Service", b:"Relational DB"},
  {a:"Grade Service", b:"Relational DB"},
  {a:"Finance Service", b:"Relational DB"},
  {a:"Document Service", b:"Relational DB"},
  {a:"Search Service", b:"Relational DB"},
  {a:"Tenant Config Service", b:"Relational DB"},

  // services -> cache
  {a:"User Service", b:"Redis Cache"},
  {a:"Student Service", b:"Redis Cache"},
  {a:"Course Service", b:"Redis Cache"},
  {a:"Registration Service", b:"Redis Cache"},
  {a:"Schedule Service", b:"Redis Cache"},
  {a:"Grade Service", b:"Redis Cache"},
  {a:"Finance Service", b:"Redis Cache"},
  {a:"Document Service", b:"Redis Cache"},
  {a:"Search Service", b:"Redis Cache"},
  {a:"Tenant Config Service", b:"Redis Cache"},
  {a:"Notification Service", b:"Redis Cache"},

  // storage specifics
  {a:"Document Service", b:"Object Storage"},
  {a:"Search Service", b:"Search Index"},

  // events
  {a:"Registration Service", b:"Event Bus"},
  {a:"Grade Service", b:"Event Bus"},
  {a:"Finance Service", b:"Event Bus"},
  {a:"Document Service", b:"Event Bus"},
  {a:"Notification Service", b:"Event Bus"},
  {a:"Course Service", b:"Event Bus"},
  {a:"Student Service", b:"Event Bus"},
  {a:"User Service", b:"Event Bus"},

  // audit/logging
  {a:"API Gateway", b:"Audit/Logging Service"},
  {a:"BFF Web", b:"Audit/Logging Service"},
  {a:"BFF Mobile", b:"Audit/Logging Service"},
  {a:"User Service", b:"Audit/Logging Service"},
  {a:"Student Service", b:"Audit/Logging Service"},
  {a:"Course Service", b:"Audit/Logging Service"},
  {a:"Registration Service", b:"Audit/Logging Service"},
  {a:"Schedule Service", b:"Audit/Logging Service"},
  {a:"Grade Service", b:"Audit/Logging Service"},
  {a:"Finance Service", b:"Audit/Logging Service"},
  {a:"Document Service", b:"Audit/Logging Service"},
  {a:"Notification Service", b:"Audit/Logging Service"},
  {a:"Search Service", b:"Audit/Logging Service"},
  {a:"Tenant Config Service", b:"Audit/Logging Service"},

  // integrations
  {a:"Course Service", b:"LMS Adapter"},
  {a:"Registration Service", b:"LMS Adapter"},
  {a:"Grade Service", b:"LMS Adapter"},
  {a:"Finance Service", b:"Payment Provider Adapter"},
  {a:"Notification Service", b:"Email/SMS Gateway"},

  // analytics pipeline
  {a:"Analytics ETL", b:"Event Bus"},
  {a:"Analytics ETL", b:"Relational DB"},
  {a:"Analytics ETL", b:"Data Warehouse"},
  {a:"Data Warehouse", b:"Object Storage"}
] AS dep
MATCH (a:Component {name: dep.a})
MATCH (b:Component {name: dep.b})
MERGE (a)-[:DEPENDS_ON]->(b);
