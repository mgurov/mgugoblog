---
title: "Postres jsonb_agg for children"
date: 2019-07-31T16:57:33+02:00
draft: true
tags: [postgres, jsonb]
---

Selecting lists of related entities from RDBMS'es can be a chore at times, especially when ORM's aren't desired. Postres `jsonb_agg` can be a convenient workaround at times.

<!--more-->

Let's say, we have a vanilla order management system with orders and their lines in separate tables: 


order_id| customer_id | total_value |
--------|-------------|-------------|
   1    |     1       |     15      |
   2    |     2       |     10      |

line_id| order_id | value   |
--------|-------------|-------------|
   1    |     1       |     10      | 
   2    |     1       |     2       |
   3    |     1       |     3       |
   4    |     2       |     10      |
