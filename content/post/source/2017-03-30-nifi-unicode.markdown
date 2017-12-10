---
comments: true
date: 2017-03-30T00:00:00Z
keywords: nifi, unicode, utf8, utf-8, executesql
title: 'Apache NiFi: Enabling Unicode Support'
url: /2017/03/30/nifi-unicode/
---

If you're using Apache NiFi to move data around, you might stumble upon Unicode characters turning into question marks. For example, the ExecuteSQL processor does that. To fix this you have to set JVM's default encoding to UTF-8.

<!--more--> 

There are two ways of doing it:

1. Set default encoding using the JAVA_TOOL_OPTIONS environment variable:

```text
export JAVA_TOOL_OPTIONS=-Dfile.encoding=utf8
```

2. Add default encoding parameter to NiFi's bootstrap.conf file:

```text
java.arg.8=-Dfile.encoding=UTF8
```

Of course, adjust the argument's number according to your configuration.

That's it, no more question marks.
