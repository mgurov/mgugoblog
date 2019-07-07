---
title: "GCP Bucket as a Distributed Locking Primitive"
date: 2019-07-07T11:31:10+02:00
tags: [gcp, distributed locking]
---

I was looking for a simple way to prevent business users executing same slow and expensive action simultaneously. Something like a lock file, but more distributed. And I wasn't very much in the mood of setting up Hazelcast or Zookeper, or a database for this kind of a trivial task. 

<!--more-->

The app I worked with happened to use google storage buckets, which apparently offers good consistency guarantees: https://cloud.google.com/storage/docs/consistency

This means: if you have an access to a bucket, you can get an exclusive distributed lock a very simple way (example in kotlin):

```
val lock = bucket.create(lockPath, "".toByteArray(), 
    Bucket.BlobTargetOption.doesNotExist())
```

No need to be a member of a cluster, sit on the same environment or at all be in the environment. You can do a lock, or remove it, from your workstation with the `gsutil` if you have to.

There's of course a caveat. GCS won't handle TTL's for you. Not in a convenient for this case manner. Should one of your workers fail to clean the lock up after finishing their job, you have to either remove the lock manually, or add creation/mutation timestamp check to the code yourself.
Still, as a simple or temporary solution GCS is a very handy option, IMHO.


