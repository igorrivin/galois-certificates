"""
Module: subfields

Arithmetic imprimitivity certificates via subfield extraction in Q(alpha).

"""

# Arithmetic imprimitivity certificates via subfields.
from sage.libs.pari import pari

def recognize_block_structure(f, block_size, pari_mem=3_000_000_000):
    '''
    Given f in QQ[x] and block_size d, attempt to certify arithmetic imprimitivity:
      - find degree n/d subfield M in root field K=QQ(a)
      - extract a degree-d relative factor of f over M.
    '''
    pari.allocatemem(pari_mem)
    n = f.degree()
    if n % block_size != 0:
        return {"found": False, "reason": "block_size does not divide degree"}

    block_count = n // block_size
    K.<a> = NumberField(f)
    subs = K.subfields(block_count)
    if not subs:
        return {"found": False, "reason": f"no degree-{block_count} subfield in root field"}

    M, emb, _ = subs[0]
    S.<x> = M[]
    fac = S(f).factor()
    rels = [g for g,e in fac if g.degree() == block_size]
    if not rels:
        return {"found": False, "reason": "subfield found, but no relative factor of that degree", "M": M}

    rel = rels[0]
    val = sum(emb(c) * a^i for i,c in enumerate(rel.list()))
    ok = (val == 0)

    b = emb(M.gen())
    tower = K.relativize(b, names=('m','x'))

    return {"found": True, "K": K, "M": M, "emb": emb, "relative_factor": rel, "rel_ok": ok, "tower": tower}
