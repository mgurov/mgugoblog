---
title: "Testing on Production – deep backend edition"
date: 2019-07-07T12:31:38+02:00
draft: false
tags: [testing, talks]
weight: 100
---

Embrace Production as a first-class testing environment to decrease costs and improve quality.

Thorough testing before merging to master is great, but it doesn’t reveal the unknowns. Staging on shared environments tends to be slow, unreliable and costly to support. Why not just learn from the only true environment by conducting safe and efficient experiments?

This talk is based on my experience of increasing the delivery rate within the context of back-end systems of bol.com (one of the biggest online retailers of the Netherlands; logistics and purchasing domains), where correctness is often a bigger concern than performance, and recovery might require a bit more than users hitting the refresh button of their browser. 

Testing on production is often associated with A/B testing or canary releases, but those aren't always the best - or even applicable - techniques. We’ll look instead at shadow and dry runs, controlled experiments, survival of the fittest; how to apply these techniques and what to be aware of.

{{< youtube Rs3Uw8AqkjA>}}

[Slides](https://www.slideshare.net/MykolaGurov/testing-on-production-domcode)

#### Related art

What do you know about testing in production? https://youtu.be/z-ATZTUgaAo Michael Bryzek QCon San Francisco 2016

GTAC 2007: Ed Keyes - Sufficiently Advanced Monitoring is Indistinguishable from Testing https://www.youtube.com/watch?v=uSo8i1N18oc

On Uber's leverage of Multi-tenancy for progressive delivery  https://eng.uber.com/multitenancy-microservice-architecture/

#### Past

Nov. 26 2019 Utrecht, The Netherlands - [DomCode MeetUp](https://www.meetup.com/DomCode/events/266491910) [slides](https://www.slideshare.net/MykolaGurov/testing-on-production-domcode)

Nov. 7 2019, Potstam, Germany – [Agile Testing Days](https://agiletestingdays.com/2019/session/testing-on-production-deep-backend-edition/) [slides](https://www.slideshare.net/secret/oUdcyRirMKel9t)

Nov 1-2 2019, Kyiv, Ukraine - [Devoxx Ukraine](https://devoxx.com.ua/speaker-details/?id=24206) [slides](https://www.slideshare.net/secret/bK8PvSEwIyB7HM) [video](https://www.youtube.com/watch?v=Rs3Uw8AqkjA&list=PLXL-0W_fYXynhNcz9hpL0Ziux3n4ftzvw&index=8)

Oct 28-29 2019, Gdańsk, Poland – [Agile & Automation Days](https://aadays.pl) [slides](https://www.slideshare.net/secret/uxgzndhESoKIZO)

June 2019 [Test Leadership Congress 2019](https://testleadershipcongress2019.sched.com/event/O5K7/testing-on-production-deep-backend-edition)

April 2019 [code.talks commerce](https://commerce.codetalks.de/program#talk-579?event=2) – [video](https://www.youtube.com/watch?v=QN03ERDzHxs&list=PLXL-0W_fYXynhNcz9hpL0Ziux3n4ftzvw&index=3)

[February 2019 meetup](https://www.meetup.com/Continuous-Delivery-Amsterdam/events/258668016/) of [Continuous Delivery Amsterdam](https://www.meetup.com/Continuous-Delivery-Amsterdam)

---