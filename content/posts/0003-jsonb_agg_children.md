---
title: "Postres jsonb_agg for children"
date: 2019-07-31T16:57:33+02:00
draft: true
tags: [postgres, jsonb]
---

Selecting lists of related entities from RDBMS'es can be a chore at times, especially when ORM's aren't desired. Postres `jsonb_agg` can be a convenient workaround at times.

<!--more-->

## TL;DR

```sql 
select orders.*,
    (select jsonb_agg(joined_lines) from
      (select * from lines where lines.order_id = orders.order_id) joined_lines
    ) as lines
from orders
where ...
;
```

Can be a convenient alternative to simple join (with splitting orders from lines on the application side) or N+1 calls. 

Let's say, we have a vanilla order management system with orders and their lines in separate tables: 

 id| customer_id | total_value |
--------|-------------|-------------|
   1    |     1       |     15      |
   2    |     2       |     10      |

line_id| order_id | value   |
--------|-------------|-------------|
   1    |     1       |     10      | 
   2    |     1       |     2       |
   3    |     1       |     3       |
   4    |     2       |     10      |

The query above would return a nice representation: 

order_id | customer_id | total_value | lines
---------|-------------|-------------|-------
1|	1|	15|	[{"value": 10, "line_id": 1, "order_id": 1}, {"value": 2, "line_id": 2, "order_id": 1}, {"value": 3, "line_id": 3, "order_id": 1}]|
2|	2|	10|	[{"value": 10, "line_id": 4, "order_id": 2}]|

Which we can conveniently process in our application code.

*Warning*: I am not a query optimization expert, so please examine your execution plan carefuly before applying the technique. I saw minor deviation in costs for my production queries, but your mileage can differ. 

## Alternative: a simple join

A common way to eagerly select multiple orders with their lines would be to do an join: 

```sql
SELECT * 
  from orders 
       inner join lines on orders.id = lines.order_id
  WHERE <criteria>
```

This query would produce dataset along the lines of: 

order_id| customer_id | total_value | line_id | order_id | value |
--------|-------------|-------------|---------|----------|-------|
1|	1|	15|	1	|1|	10|
1|	1|	15|	2	|1|	2|
1|	1|	15|	3	|1|	3|
2|	2|	10|	4	|2|	10|

Mapping onto the `order - lines` structure at the receiving side isn't too complex, but can become a burden with the number of relations joined increasing. 

## Alternative: 

### See also 

[On sorting within jsonb_agg](https://stackoverflow.com/questions/40652871/postgresql-jsonb-agg-subquery-sort)

### TODO

When fetching data of one order, we can simply do two queries: `SELECT * FROM orders WHERE order_id = 1` and `SELECT * FROM lines WHERE order_id = 1`, but when we need to select a larger data set this can lead

- check costs again