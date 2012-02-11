/++
 + cache.d -- easily allows for creating a cache of function call results
 +
 + The cache is meant for non-trivial functions which might be called often
 + with the same arguments. Upon creating a cache from a function, when one 
 + interfaces with the cache, the function will not be called if the same 
 + arguments are given. This means that pure functions are strongly reccomended.
 +
 + Example:
 + ---
 + import cache;
 + import std.stdio;
 + 
 + void main() {
 +     // makes an empty cache
 +     Cache!(typeof(&factorial)) cache = createCache(&factorial);
 +     writeln(cache(3)); // calculates it
 +     writeln(cache(3)); // looks up in cache
 + }
 +
 + ulong factorial(ulong n) {
 +     ulong r;
 +     for(r=1; n > 0; n--) {
 +         r *= n;
 +     }
 +     return r;
 + }
 + ---
 +
 + Authors: Nathan M. Swan, nathanmswan at gmail dot com
 + Date: February 6th, 2012
 + Copyright: Copyright (C) Nathan M. Swan
 + License: Distributed under the Boost Software License, Version 1.0.
 + Version: 0.1
 +/


module cache;

private {
    import std.algorithm;
    import std.traits;
}

public:

/// The Cache class
/// Params:
///     F = the type of the function
template Cache(F) if (isCallable!(F)) {
    alias CacheT!(F).CacheC Cache;
}

/// Creates a new cache from the function
Cache!(F) createCache(F)(F func) if (isCallable!F) {
    return new Cache!(F)(func);
}

private:


template CacheT(FT) if (isCallable!(FT)) {
    
    // FT is R function(P)
    alias ParameterTypeTuple!FT P;
    alias ReturnType!FT R;
    
    // HP is a hashable version of a tuple, encapsulating a tuple and the
    // hash function
    struct HP {
        P tuple;
        hash_t toHash() {
            hash_t r;
            foreach(t; tuple) {
                // perhaps this should be *=?
                r += typeid(t).getHash(&t);
            }
            return r;
        }
    }

    // the class which encapsulates the cache
    class CacheC {
        
        // if the function with params hasn't been cached, does so,
        // else retrieves from cache
        public R opCall(P ps) {
            HP hp;
            hp.tuple = ps;
            if (hp in cachedata) {
                return cachedata[hp];
            } else {
                R r = func(ps);
                cachedata[hp] = r;
                return r;
            }
        }
        
        private:
        this() { assert(0); }
        this(FT ft) { func = ft; }
        
        // the data
        R[HP] cachedata;
        
        // the function pointer
        FT func;
    }

}
