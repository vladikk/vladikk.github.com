---
layout: post
title: "Unicode file names in Python 2.7"
date: 2013-06-01 14:58
comments: true
categories: python
keywords: python, unicode, utf8, utf-8, 2.7
description: 'solving an issue with accessing files and folders with unicode characters in python 2.7'
---
Today I wrote a small script to find and delete duplicate files. To do this task I needed to iterate over files in a specific folder, and calculate md5 checksum for each file:

``` python
for folder, subs, files in os.walk(path):
    for filename in files:
        file_path = os.path.join(folder, filename)
	        with open(file_path, 'rb') as fh:
	        	...
```

If the source folder contains a file or a folder with unicode characters in it, execution of the code results in this bummer:

```
IOError: [Errno 22] invalid mode ('rb') or filename: 'files\\????????? ????? ????????.txt'
```
<!-- more -->

The solution was easy. As it turned out, the os.walk method can return values encoded either as ASCII or as Unicode strings. It chooses the encoding based on the encoding of the "top path" argument. Originally I was passing an ASCII string. Once it was encoded to UTF-8 the problem was solved:
``` python
for folder, subs, files in os.walk(unicode(path, 'utf-8')):
    for filename in files:
        file_path = os.path.join(folder, filename)
```