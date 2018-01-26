---
comments: true
date: 2012-10-15T00:00:00Z
description: null
keywords: leaky abstraction, design, oop, ood, objection oriented design, code smell
title: 'Learning From Mistakes: Leaky Abstractions'
url: /2012/10/15/learning-from-mistakes-leaky-abstractions/
---

On the project I’m working on I’ve had a requirement to store and read files
from the file system. Alse the files had to be accessible from the web.

Having a gut feeling that the infrastructure may change as the business will
grow, I decided to hide operations on the file system behind an interface:
``` c#
public interface IFilesStorage {
    string StoreFile(Stream stream, string fileName);
    Stream GetFile(string virtualPath);
    string GetFileUrl(string virtualPath);
    string GetFilePath(string virtualPath);
}
```

As it looks, if someday I’ll need to switch from the file
system to another storage mechanism, I’ll be able to do get the
job done by writing another implementation of the interface.
Right? Wrong! The requirement did come in - I’ve had to store
the files in S3. And only then I realised that IFilesStorage is
a leaky abstraction.

<!--more-->

The problem lies in the last method, GetFilePath. This method
leaks out the implementation detail, that each file has a path
which can be used to access the file from the file system. Of
course, other storage mechanisms can’t provide such
functionality. This bummer makes switching storage mechanism
nearly impossible.

From a [SOLID](http://en.wikipedia.org/wiki/SOLID_%28object-oriented_design%29) point of view, this issue can be seen as a
violation of the Liskov substitution principle: the file system
based implementation of the interface cannot be replaced by
another implementation, as it will break the correctness of the
application.

The solution was to drop the problematic method and get rid of
the dependancy on file paths in the system.

Lesson learned: having abstractions will make the code more testable,
but if you’re aiming for supple design, make
sure your abstractions don’t leak out details about the
underlying architecture.
