"""
Module: ppr

Subset-sum aggregation of modular factor degrees (Pemantle–Peres–Rivin).

"""

# Pemantle–Peres–Rivin subset-sum intersection machinery.

def subset_sum_bitset(degrees, n):
    '''
    Return an int bitset with bit k set iff k is a subset sum of `degrees`.
    '''
    bits = 1
    mask = (1 << (n+1)) - 1
    for d in degrees:
        bits |= (bits << d)
        bits &= mask
    return bits

def ppr_irreducibility_attempt(f, primes_to_try=50):
    '''
    Attempt to certify irreducible over QQ using PPR subset-sum intersections.
    Returns dict with status, primes_used, and witnesses.
    '''
    F = f.clear_denominators()[0]
    n = F.degree()
    disc = ZZ(F.discriminant())
    bad = set(disc.prime_factors())

    S = (1 << (n+1)) - 1
    witnesses = []
    used = 0

    for p in primes_first_n(100000):
        if p in bad:
            continue
        fp = F.change_ring(GF(p))
        degs = sorted([g.degree() for g,e in fp.factor()])
        bits = subset_sum_bitset(degs, n)
        S &= bits
        used += 1
        witnesses.append((p, tuple(degs)))

        proper = [k for k in range(1, n) if (S >> k) & 1]
        if not proper:
            return {"status":"certified_irreducible", "primes_used":used, "witnesses":witnesses}

        if used >= primes_to_try:
            break

    proper = [k for k in range(1, n) if (S >> k) & 1]
    return {"status":"inconclusive", "primes_used":used, "surviving_degrees":proper, "witnesses":witnesses}
