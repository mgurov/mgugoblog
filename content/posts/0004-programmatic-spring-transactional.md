---
title: "Spring @Transactional programmatically"
date: 2020-01-12T19:02:56+01:00
draft: false
tags: [spring, TDD]
---

Beware: this post is WIP.

An an enterprise developer, it's easy to get used to the conveniences of Spring (Boot) so much that it becomes an issue on itself. Take `@Transactional`. Arguably, one of the few core features of Spring that does make us more productive in development. But at times it can be slightly inconvenient to rely solely on annotation for transaction boundary setup: 

* It might not be desireable to have a database transaction open throughout the whole request processing, e.g if we do external calls to collect more data, thus introducing latencies that might deplete our db connection pool. 
* It might also be inconvenient and clumsy to set the transactional boundaries exactly at the methods, in particular when it ought to be accessed via proxy only (TODO: a link to the details). 

The simplest approach to overcome this inconvenience is to introduce a simple transactional helper: 

```java
@Component
public class Transactionally {
  @Transactional
  public <T> T run(Supplier<T> block) {
      return block.get();
  }
}
```

And inject it as yet another Spring dependency: 

```java
@Inject
private Transactionally transactionally;

public void doSomething() {
    ....
    var transactionalResult = transactionally.run(() -> {
        ...
    });
}
```


A slightly more evolved, flexible and convenient in a longer run approach might be to follow the advice of the [Spring's documentation on programmatic transactions](https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/data-access.html#transaction-programmatic) and use `TransactionTemplate`:

```kotlin
@Component
class Transactionally(
    transactionManager: PlatformTransactionManager // injected
    ) {

    private val transactionTemplate = TransactionTemplate(transactionManager)

    operator fun <T> invoke(block: ()->T): T? {
        return transactionTemplate.execute {block()}
    }
}

class SomeService(private val transactionally: Transactionally) {

    fun something() {
        ...
        val transactionalResult = transactionally {
            //do transactional stuff
        }
        // the transaction is over
        ...
    }
}
//TODO: check nullability of kotlin params
//TODO: nicer block passing to the template?
```


TODO: Testing reasons.

Links: https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/data-access.html#transaction-declarative-annotations