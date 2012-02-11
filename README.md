cache.d
=======
`cache.d` is a utility for caching function calls in D.

Example
-------

    import cache;
    import std.stdio;
    
    void main() {
        // makes an empty cache
        Cache!(typeof(&factorial)) cache = createCache(&factorial);
        
        // excecutes the function
        writeln(cache(3));
        
        // looks it up in the cache
        writeln(cache(3));
    }
    
    ulong factorial(ulong n) {
        ulong r;
        for(r=0; n>0; n--) {
            r *= n;
        }
        return r;
    }
    
Contributing
------------
Pull requests are appreciated.

