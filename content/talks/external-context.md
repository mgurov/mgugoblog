---
title: "WIP: External domain context with Ktor and Kotlin DSL for expressive and resilient testing"
summary: "Learn how to build meaningful functional tests in isolation. The highlights of this technique are the minimal deviation from the production configuration or code, and very limited use of mocking. Thanks to higher tier positioning on the testing pyramid, the tests written with this technique are quite implementation-agnostic, and excel in supporting structural refactorings or high-level documentation of the component behavior."
date: 2022-01-31T22:52:38+02:00
tags: [TDD, Kotlin, talks]
weight: 2000
---

There’s no simple “right” way to build a test suite for a non-trivial service. The divide-and-conquer techniques like hexagonal ports-and-adaptors decomposition, or consumer-driven contract testing - are frequently discussed, but there’s little discourse on how to sustainably build tests with larger span - in the middle of the testing pyramid - but still in isolation and before deploying to production or staging environments. 

Not anymore - in this presentation, I’ll demonstrate a wholistic approach for building meaningful functional tests in isolation. The highlights of this technique are the minimal deviation from the production configuration or code, and very limited use of mocking. Thanks to higher tier positioning on the testing pyramid, the tests written with this technique are quite implementation-agnostic, and excel in supporting structural refactorings or high-level documentation of the component behavior.

I’ll use Spring on Kotlin as an example of a production service, and Ktor to emulate dependencies. The DSL power of Kotlin will be leveraged to define the “external context” in terms of “our” domain - so that tests start to tell stories instead of speaking technicalities.
