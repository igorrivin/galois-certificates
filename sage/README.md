# Sage Code

This directory contains a reference SageMath implementation of the Monte-Carlo algorithms described in the accompanying paper.

## What’s here

- **irreducibility.sage**: standard Monte-Carlo irreducibility certificate via irreducibility mod p.
- **ppr.sage**: Pemantle–Peres–Rivin subset-sum aggregation using bitsets.
- **pipeline.sage**: hybrid irreducibility + structure-flag driver.
- **subfields.sage**: arithmetic imprimitivity certificates via subfield extraction.
- **wreath_construction.sage**: construction of imprimitive examples via resultants.
- **evil_twins.sage**: perturbations preserving all mod p<B data (evil twins).

## Quick start

From a Sage session in the repo root:

```sage
load('sage/irreducibility.sage')
load('sage/ppr.sage')
load('sage/pipeline.sage')
load('sage/subfields.sage')
load('sage/wreath_construction.sage')
load('sage/evil_twins.sage')
```

Generate an imprimitive example and certify its block structure:

```sage
F = make_C3_wreath_Sn(8)
info = recognize_block_structure(F, 3)
info['found']
```

## Notes

- All Monte-Carlo tests are one-sided: when they certify, the conclusion is rigorous; otherwise they return 'inconclusive'.
- The code prioritizes clarity and reproducibility over micro-optimizations.
