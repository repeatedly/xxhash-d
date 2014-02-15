
import std.stdio;
import std.datetime;
import std.typetuple;

import xxhash;
import std.digest.crc;
import std.digest.md;
import std.digest.sha;

version(USE_SIPHASH) import siphash;

void main()
{
    enum PRIME = 2654435761U;
    ubyte[101] sanityBuffer;
    uint random = PRIME;

    foreach (i; 0..sanityBuffer.length) {
        sanityBuffer[i] = cast(ubyte)(random >> 24);
        random *= random;
    }

    void crc32()
    {
        crc32Of(sanityBuffer[0..1]);
        crc32Of(sanityBuffer);
    }

    void md5()
    {
        md5Of(sanityBuffer[0..1]);
        md5Of(sanityBuffer);
    }

    void sha1()
    {
        sha1Of(sanityBuffer[0..1]);
        sha1Of(sanityBuffer);
    }

    void xxhash1()
    {
        xxhashOf(sanityBuffer[0..1]);
        xxhashOf(sanityBuffer);
    }

    void xxhash2()
    {
        XXHash xhash;

        xhash.start();
        xhash.put(sanityBuffer[0..1]);
        xhash.finish();

        xhash.start();
        xhash.put(sanityBuffer);
        xhash.finish();
    }

    version(USE_SIPHASH)
    {
        ubyte[16] k = cast(ubyte[])"To be|not to be!";

        void siphash1()
        {
            siphash24Of(k, sanityBuffer[0..1]);
            siphash24Of(k, sanityBuffer);
        }

        void siphash2()
        {
            auto sh = SipHash!(2, 4)(k);

            sh.start();
            sh.put(sanityBuffer[0..1]);
            sh.finish();

            sh.start();
            sh.put(sanityBuffer);
            sh.finish();
        }

        alias TypeTuple!(crc32, md5, sha1, xxhash1, xxhash2, siphash1, siphash2) Funcs;
    }
    else 
    {
        alias TypeTuple!(crc32, md5, sha1, xxhash1, xxhash2) Funcs;
    }

    immutable num = 1000000;
    auto times = benchmark!(Funcs)(num);
    writeln(num, " loops (msecs) : smaller is better");
    writeln("crc32Of:   ", times[0].msecs);
    writeln("md5Of:     ", times[1].msecs);
    writeln("sha1Of:    ", times[2].msecs);
    writeln("xxhashOf:  ", times[3].msecs);
    writeln("XXHash:    ", times[4].msecs);
    version(USE_SIPHASH)
    {
        writeln("siphashOf: ", times[5].msecs);
        writeln("SipHash:   ", times[6].msecs);
    }
}
