---
title: "WIP – Sprinkle sprinkle Kotlin sugar - small big shifts in test preparation"
summary: "How to bring joy back to TDD with Kotlin again"
date: 2019-07-07T12:51:38+02:00
draft: true
tags: [TDD, Kotlin, talks]
---

Do your automated tests serve you well? Or does it seem like they are deliberately getting in a way, slowing down any change? Has the “given”’s preparation become an arduous journey littered with shortcuts? 

Ever increasing delivery pace raises the bar for the test automation quality. Many teams are good at producing decent test coverage, but often at the price of tests maintainability, which can quickly become a bottleneck. Advanced testing frameworks like Cucumber, Spock, etc., can bring remedy to some of these pains, but add its own complexity, overhead and compromises.

With the help of Kotlin’s language features such as named functional parameters, default parameter values, and especially DSLs (Type-Safe Builders), the expressiveness of tests can be drastically improved. Add a modern assertion framework like AssertJ, and even plain JUnit can be a very versatile testing tool for both unit- and functional testing with relatively low overhead and entry barrier.

This demo will show how to use the features of Kotlin to fight the rising complexities of the automated test data preparation. The material is based on the real-world experience of using Kotlin for testing of backend micro-services (Kotlin or vanilla Java) at bol.com - one of the largest webshops in the Netherlands.