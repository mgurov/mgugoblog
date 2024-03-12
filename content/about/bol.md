---
title: "5 years at Bol"
date: 2020-06-16T08:19:01+02:00
summary: "2015-2020 I spent at [bol.com](./bol/) , one of the largest online retailers of the Netherlands."
hide_date: true
---

2015-2020 I worked at [bol.com](https://bol.com), one of the largest online retailers of the Netherlands. Mainly with feature teams in Logistics and Purchasing domains, but also with platform teams. 

Highlights: 

* pioneered the use of Docker for CI testing against the real databases (Oracle, Postgres) and messaging (Oracle AQ, bol.com’s and google’s proprietary pub/sub).

* paved the way for the adoption of Postgres and within a company originally deeply rooted in Oracle (java dev side).

* served as a feature team liaison to the platform teams on the topics of database use and in-flight data consistency (messaging guarantees).

* spearheaded the development and adoption of "Data Quality Service" - a tool that allows feature teams to check the consistency of their data that they send to Data Lake against the operational source, with in-flight, volume and performance considerations covered.

* was among the first voices raising awareness about the integrated testing environments becoming useless. Since then, I continuously preach testing microservices in isolation (dockerized databases and messaging queues, (http-)mocked external services) and on production (canary releases, shadow runs a.k.a. dark releases). Developed and presented at multiple conferences a [talk about testing on/in production](https://mgurov.github.io/talks/testing-on-production/) .

* implemented, accidentally, [trunk-based development](https://mgurov.github.io/talks/trunk-based-delivery/) with a purchasing IT team. Two years later, still in full action and rocks.

* participated, on the feature teams side, in a transition from monoliths to microservices, from own data center to the public cloud of google. 

* built and successfully promoted (internally) an array of command line and UI tools that help feature teams in their everyday activities, e.g. deploying application through multiple environment (saves up to 10 mins per deployment, multiple times a day for high-performing teams), checking application status and builds, tracking error logs from elastic search as actionable items. 

* actively promote and support a transition from GWT and Vaadin-based internal UI frameworks to a modern SPA approach (Single Page Application, react js or angular). Provide examples, consultancy, and trainings to the teams joining the movement. Advocate for this approach to platform and security teams. 

* facilitated the adoption of BDD/Cucumber instead of predominant (at that time at bol.com) Fitnesse for integrated testing. Further, spread the use of cucumber at all tiers of the testing pyramid. Ended up ditching cucumber in favor of plain JUnit in all of the current codebases.

* supported switch from JMeter to [Gatling](https://gatling.io) as a performance testing tool: with one of the first teams to employ Gatling, helped platform teams to adopt it into the performance centre of bol.com, gave internal presentations and support on using Gatling within the company. Two years later, we were one of the first teams to drop the performance testing discipline as not relevant, and focused on monitoring production instead.

* facilitate knowledge sharing by hosting regular “Brown Bags” sessions by and for enthusiastic developers.

* active public speaker since 2019: https://mgurov.github.io/talks/ 

* toolchain: java, kotlin, go, junit, docker, postgres, pub/sub, react.js, cypress, Google Cloud (in particular - BigQuery, Kubernetes, PubSub).