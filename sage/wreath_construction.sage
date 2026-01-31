"""
Module: wreath_construction

Construct imprimitive examples via resultants Res_u(P(u),Q(u,x)).

"""

# Wreath-style constructions via resultants (no QQbar embeddings).
#
# Core idea:
#   Given P(u) in QQ[u] (monic), and Q(u,x) in QQ[u,x],
#   define F(x) = Res_u(P(u), Q(u,x)) in QQ[x].
# This equals ∏_{P(u_i)=0} Q(u_i, x) and produces degree (deg P)*(deg_x Q).

def wreath_from_resultant(Pu, Qux):
    '''
    Pu: monic polynomial in QQ[u]
    Qux: polynomial in QQ[u,x]
    Returns F(X) = Res_u(Pu(u), Qux(u,X)) in QQ[X].
    '''
    u, x = Qux.parent().gens()
    if Pu.leading_coefficient() != 1:
        raise ValueError("Pu must be monic.")
    Res = Pu.resultant(Qux, u)
    Rx.<X> = QQ[]
    return Rx(Res(x=X))

def make_C3_wreath_Sn(n, base_poly=None):
    '''
    Construct degree 3n example using:
      P(u) = u^n - u - 1 (default)
      Q(u,x) = x^3 + (-(u+3)/2)x^2 + ((u-3)/2)x + 1
    '''
    A.<u,x> = PolynomialRing(QQ, 2, order='lex')
    P = (u^n - u - 1) if base_poly is None else base_poly
    Q = x^3 + (-QQ(1)/2*u - QQ(3)/2)*x^2 + (QQ(1)/2*u - QQ(3)/2)*x + 1
    return wreath_from_resultant(P, Q)

def make_generic_wreath(p, n, base_poly=None, inner_form="x^p + u*x + 1"):
    '''
    Construct degree pn examples; inner is generic and typically yields S_p over the base field.
    '''
    A.<u,x> = PolynomialRing(QQ, 2, order='lex')
    P = (u^n - u - 1) if base_poly is None else base_poly
    if inner_form == "x^p + u*x + 1":
        Q = x^p + u*x + 1
    elif inner_form == "x^p + (u+1)*x + 1":
        Q = x^p + (u+1)*x + 1
    else:
        raise ValueError("Unknown inner_form")
    return wreath_from_resultant(P, Q)
