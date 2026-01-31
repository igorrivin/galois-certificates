"""
Module: evil_twins

Construct evil twins preserving all reductions mod p<B by perturbing coefficients.

"""

# Adversarial 'evil twins' preserving small-prime data via adding multiples of M = ∏_{p<B} p.

def prime_product(bound=100):
    return prod([p for p in primes(bound)])

def perturb_by_prime_product(f, bound=1, primes_bound=100, keep_monic=True):
    '''
    Add random multiples in [-bound, bound] of M=∏_{p<primes_bound} p to each coefficient,
    preserving all congruences mod p<primes_bound.
    '''
    R = f.parent()
    x = R.gen()
    n = f.degree()
    M = prime_product(primes_bound)
    coeffs = f.list()
    new_coeffs = coeffs[:]
    for k in range(len(coeffs)):
        if keep_monic and k == n:
            continue
        t = ZZ.random_element(-bound, bound+1)
        new_coeffs[k] = new_coeffs[k] + t*M
    g = sum(new_coeffs[k] * x^k for k in range(n+1))
    return g.monic() if keep_monic else g, M
