"""
Module: irreducibility

One-sided Monte-Carlo irreducibility testing over QQ.

"""

# Monte-Carlo irreducibility tools over QQ.

def factor_degrees_mod_p(f, p):
    fp = f.change_ring(GF(p))
    return sorted([g.degree() for g,e in fp.factor()])

def mc_irreducible_mod_p_certificate(f, primes_to_try=200):
    '''
    One-sided certificate: returns (True, p) if ∃ prime p with f mod p irreducible.
    Returns (False, None) if inconclusive after primes_to_try primes.
    '''
    F = f.clear_denominators()[0]
    n = F.degree()
    disc = ZZ(F.discriminant())
    bad = set(disc.prime_factors())
    tested = 0
    for p in primes_first_n(100000):
        if p in bad:
            continue
        fp = F.change_ring(GF(p))
        fac = fp.factor()
        tested += 1
        if len(fac) == 1 and fac[0][0].degree() == n:
            return True, p
        if tested >= primes_to_try:
            break
    return False, None
