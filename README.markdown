[![Build Status](https://travis-ci.org/repeatedly/xxhash-d.png)](https://travis-ci.org/repeatedly/xxhash-d)

# xxhash-d

D implementation of xxhash.

# Install

xxhash-d is only one file. Please copy src/xxhash.d onto your project.

# Usage

## xxhashOf function.

```d
import xxhash;

uint hashed = xxhashOf(cast(ubyte[])"D-man is so cute");
```

## XXHash object

XXHash provides std.digest like API.

```d
import xxhash;

XXHash xh;
xh.start();
foreach (chunk; chunks(cast(ubyte[])"D-man is so cute!", 2))
    xh.put(chunk);
auto hashed = xh.finish();
```

# Benchmark

Please run example/bench.d. On my environment(Mac OS X, 2.7 GHz Intel Core i7), result is below:

```sh
1000000 loops (msecs) : smaller is better
crc32Of:   429
md5Of:     1932
sha1Of:    3495
xxhashOf:  47
XXHash:    76
siphashOf: 142
SipHash:   866
```

# Link

* [xxhash - Extremely fast non-cryptographic hash algorithm](https://code.google.com/p/xxhash/)

  official site

# Copyright

    Copyright (c) 2014- Masahiro Nakagawa

Distributed under the Boost Software License, Version 1.0.
