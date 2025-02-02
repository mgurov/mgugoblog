---
title: "Java Integration Tests v Spring Context – when less is more"
date: 2019-07-06T23:13:31+02:00
description: "when less is more"
tags: [spring, TDD]
weight: 10

---

When doing integration testing within a Spring (Boot) based project, we tend to use some sort of Spring context. Setting it up isn't free. Careless tests composition can lead to much time wasted on re-creating those contexts, and will make running tests painfully long very quickly. There are simple techniques of keeping this overhead to the minimum. Ideally – start only one test context for the whole run.

<!--more-->



A pristine Spring Boot [project](https://github.com/mgurov/javaspringtestcontext/tree/pristine) with web module takes 5 seconds to execute the only test provided (`mvn clean test-compile compile && mvn test` ). 2wo of those seconds were taken by the startup of the Spring context. Adding more test methods doesn't add much to the overall execution time: there's no extra overhead cost as the SpringRunner is clever enough to reuse the context. Things turn different if I, say, [dirty the context](https://github.com/mgurov/javaspringtestcontext/blob/master/src/test/java/com/github/mgurov/javaspringtestcontext/DirtyContextTests.java):

```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class DirtyContextTests {

   @Test
   @DirtiesContext
   public void test1() {
   }

   @Test
   @DirtiesContext
   public void test2() {
   }
...
}
```

Suddenly, we see the Spring Boot logo repeating multiple times in the logs. A new Spring context is setup for every test method (unless you put annotation at the class level). This will add a noticeable overhead for any realistic number of tests by itself, not to mention that a real Spring context usually takes some more time to instantiate. Let's simulate this in our demo project:

```java
@Component
public class HeavierBean {
    public HeavierBean(@Value("${delay-sping-context-startup-ms:1000}") long delay) {
        try {
            TimeUnit.MILLISECONDS.sleep(delay);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
}
```

Now, every test marked as "dirty" will add a toll of a second for the context cleanup. Six of such tests drive the cost of the full test suite from 6 (5 + 1 artificial delay) to ~15 seconds. In real life it's not uncommon to see dozens of seconds startup time for a reasonably fit Spring-Boot powered micro-service. This overhead can quickly become quite an annoyance. And there are many other ways to trigger this new context creation, e.g.

[Change properties](https://github.com/mgurov/javaspringtestcontext/blob/master/src/test/java/com/github/mgurov/javaspringtestcontext/ChangePropertiesTests.java):

```java
@RunWith(SpringRunner.class)
@SpringBootTest(properties = "blah=fooe")
public class ChangePropertiesTests {

   @Test
   ...
}
```

[Add custom configuration](https://github.com/mgurov/javaspringtestcontext/blob/master/src/test/java/com/github/mgurov/javaspringtestcontext/AddCustomConfigurationTests.java):

```
@RunWith(SpringRunner.class)
@SpringBootTest
public class AddCustomConfigurationTests {

    @Test
    ...
    @TestConfiguration
    public static class CustomConfiguration {
        @Bean
        public HeavierBean customOrOverriddenBean() {
            return new HeavierBean(500L);
        }
    }
}
```

[Mock one of the components](https://github.com/mgurov/javaspringtestcontext/blob/master/src/test/java/com/github/mgurov/javaspringtestcontext/MockedDependencyTests.java):

```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class MockedDependencyTests {

   @MockBean
   private HeavierBean heavierBeanMock;

   @Test
   ...
}
```

In fact, it's quite difficult *not to pay much extra* for starting all those Spring contexts, especially if you simply follow the Spring documentation on testing.

### My Solution
One and only one Spring context. This isn't the only possible approach, but I prefer it for the simplicity.

#### Never ever @DirtiesContext.
Have a test changing configuration? Make it explicit or maybe rethink testing approach.

Need reset some state, like caches? Go directly to the cache manager and reset there. Much faster and explicit.

Need reset database (in-mem, docker, whatever)? Consider explicitly cleaning the data, or better yet - write tests that don't demand data cleanup. Stay tuned to see how.

#### One configuration.
As close as possible to production, with some aspects tailored for test run, e.g. cron jobs disabled to avoid interference; external call retries disabled or set to minimum.

Want to test something with different properties? Consider doing it without the Spring context (unit-testing style).

Alternatively, you can set a property explicitly into a Spring-managed component and safely reset back to the standard configuration at the teardown. This is bit hacky, but done carefully is simple enough and works just fine, especially when the project exercises trunk-based development and feature toggles don't tend to stay for long in the codebase.

TBH, it's not per se wrong to have mutliple test configurations. In such case, I would advise to be careful in keeping the number of distinct configurations to the necessary minimum, watching how Spring [reuses test contexts](https://docs.spring.io/spring/docs/current/spring-framework-reference/testing.html#testcontext-ctx-management-caching).

#### No mocking.
Well, no mocking of internal components, at least not within the Spring context.
Need mock external services? Instantiate your connectors as mocks. Once and forever in that single context. Even better, push mocking out of your service boundaries by using [WireMock](http://wiremock.org/) or similar.

#### Further Reading.

Spring's documentation on [testing](https://docs.spring.io/spring/docs/current/spring-framework-reference/testing.html#integration-testing), and in particular the section on the [context caching](https://docs.spring.io/spring/docs/current/spring-framework-reference/testing.html#testcontext-ctx-management-caching).

Testing section of the Spring Boot documentation https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-testing.html#boot-features-testing

Baeldung on Spring Tests https://www.baeldung.com/spring-tests

More in-depth discussion of the topic by Andy Wilkinson @ Spring I/O 2019 {{< utube 5sjFn9BsAds>}}