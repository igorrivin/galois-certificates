"""
Module: pipeline

Hybrid PPR + standard Monte-Carlo irreducibility, with structure flag.

"""

# End-to-end pipeline: PPR -> (optional) standard MC -> structure flag -> block certificate.
load('sage/ppr.sage')
load('sage/irreducibility.sage')
load('sage/subfields.sage')

def hybrid_irreducibility_and_structure(f, ppr_primes=50, mc_primes=500, block_sizes=None, pari_mem=3_000_000_000):
    '''
    Returns dict with PPR result, MC result, and optional block certificates.
    '''
    out = {"degree": f.degree()}
    ppr = ppr_irreducibility_attempt(f, primes_to_try=ppr_primes)
    out["ppr"] = ppr
    if ppr["status"] == "certified_irreducible":
        out["status"] = "irreducible_certified_by_ppr"
        return out

    ok, p = mc_irreducible_mod_p_certificate(f, primes_to_try=mc_primes)
    out["mc"] = {"certified": ok, "prime": p}
    if not ok:
        out["status"] = "irreducibility_inconclusive"
        return out

    out["status"] = "irreducible_certified_by_mc"
    out["structure_flag"] = "ppr_inconclusive_mc_certified"

    if block_sizes is None:
        n = f.degree()
        block_sizes = [d for d in divisors(n) if 1 < d < n]

    hits = []
    certs = {}
    for d in block_sizes:
        info = recognize_block_structure(f, d, pari_mem=pari_mem)
        if info.get("found", False):
            hits.append(d)
            certs[d] = info
    out["block_sizes_found"] = hits
    out["block_certs"] = certs
    return out
