---
title: "Postgres jsonb_agg children cart"
date: 2019-07-31T16:57:33+02:00
draft: false
tags: [postgres, jsonb]
---

Selecting lists of related entities from RDBMS'es can be a chore at times. Especially when ORM's aren't used or desired. jsonb_agg of postgres can be a convenient workaround for these cases:

<!--more-->

<pre class="hackprecolor2 b--black-10 ba">
select orders.*,
    (select jsonb_agg(joined_lines) from
      (select * 
        from lines 
        where lines.order_id = orders.order_id
      ) joined_lines
    ) as lines
from orders
where ...
;
</pre>

Given we have a vanilla order management system with orders and their lines in separate tables: 

<table class="collapse ba br2 b--black-10">
  <tbody>
    <tr class="striped--light-gray ph3">
      <td class="ph3 tc" colspan=3>orders</td>
    </tr>
    <tr class="striped--light-gray ph3">
      <td class="ph3 tr">id</td>
      <td class="ph3 tr">customer_id</td>
      <td class="ph3 tr">total_value</td>
    </tr>
    <tr class="striped--light-gray">
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">15</td>
    </tr>
    <tr class="striped--light-gray">
      <td class="ph3 tr">2</td>
      <td class="ph3 tr">2</td>
      <td class="ph3 tr">10</td>
    </tr>
  </tbody>
</table>

<p>
<table class="collapse ba br2 b--black-10">
  <tbody>
    <tr class="striped--light-gray ph3">
      <td class="ph3 tc" colspan=4>lines</td>
    </tr>
    <tr class="striped--light-gray ph3">
      <td class="ph3 tr">line_id</td>
      <td class="ph3 tr">order_id</td>
      <td class="ph3 tr">value</td>
    </tr>
    <tr class="striped--light-gray">
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">10</td>
    </tr>
    <tr class="striped--light-gray">
      <td class="ph3 tr">2</td>
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">2</td>
    </tr>
    <tr class="striped--light-gray">
      <td class="ph3 tr">3</td>
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">3</td>
    </tr>
    <tr class="striped--light-gray">
      <td class="ph3 tr">4</td>
      <td class="ph3 tr">2</td>
      <td class="ph3 tr">10</td>
    </tr>
  </tbody>
</table>
</p>

The query above would return a nice representation: 

<table class="collapse ba br2 b--black-10">
  <tbody>
    <tr class="striped--light-gray ph3">
      <td class="ph3">order_id</td>
      <td class="ph3">customer_id</td>
      <td class="ph3">total_value</td>
      <td class="ph3">lines (pretty-formated)</td>
    </tr>
    <tr class="striped--light-gray">
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">15</td>
      <td class="ph3 hackprecolor"><pre>
[
  {"value": 10, "line_id": 1, "order_id": 1}, 
  {"value": 2, "line_id": 2, "order_id": 1}, 
  {"value": 3, "line_id": 3, "order_id": 1}
]</pre></td>
    </tr>
    <tr class="striped--light-gray">
      <td class="ph3 tr">2</td>
      <td class="ph3 tr">2</td>
      <td class="ph3 tr">10</td>
      <td class="ph3 hackprecolor"><pre>[{"value": 10, "line_id": 4, "order_id": 2}]</pre></td>
    </tr>
  </tbody>
</table>

Which we can conveniently process in our application code.

*Warning*: I am not a query optimization expert, so please examine your execution plan carefully before applying the technique. I saw minor deviations in costs for my production queries, but your mileage can differ. 

## Alternative: a simple join

A common way to eagerly select multiple orders with their lines would be to do a join: 

<pre class="hackprecolor2 b--black-10 ba">
SELECT * 
  from orders 
       inner join lines on orders.id = lines.order_id
  WHERE ...
</pre>

This query would produce dataset along the lines of: 

<table class="collapse ba br2 b--black-10">
  <tbody>
    <tr class="striped--light-gray ph3">
      <td class="ph3 tr">order_id</td>
      <td class="ph3 tr">customer_id</td>
      <td class="ph3 tr">total_value</td>
      <td class="ph3 tr">line_id</td>
      <td class="ph3 tr">order_id</td>
      <td class="ph3 tr">value</td>
    </tr>
    <tr class="striped--light-gray">
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">15</td>
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">10</td>
    </tr>
    <tr class="striped--light-gray">
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">15</td>
      <td class="ph3 tr">2</td>
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">2</td>
    </tr>
    <tr class="striped--light-gray">
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">15</td>
      <td class="ph3 tr">2</td>
      <td class="ph3 tr">1</td>
      <td class="ph3 tr">3</td>
    </tr>
    <tr class="striped--light-gray">
      <td class="ph3 tr">2</td>
      <td class="ph3 tr">2</td>
      <td class="ph3 tr">10</td>
      <td class="ph3 tr">4</td>
      <td class="ph3 tr">2</td>
      <td class="ph3 tr">10</td>
    </tr>
  </tbody>
</table>

Mapping onto the `order - lines` structure at the receiving side isn't too complex, but can become a burden with the number of relations joined increasing. 

### See also 

[On sorting within jsonb_agg](https://stackoverflow.com/questions/40652871/postgresql-jsonb-agg-subquery-sort)