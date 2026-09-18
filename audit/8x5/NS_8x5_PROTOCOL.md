# Navier–Stokes 8 ⊃ 5 certification — phase 0

WRITE_BRANCH: `audit/multistate-proof-refutation-v1`

## L1 — frozen audit input

`6e17fc115336fef1c30797c2a50806c91567b920`

This exact 40-character SHA is the input audit snapshot. New commits append
test machinery; they do not redefine the frozen input.

## L2 — FROZEN_S1 U-REF

`ShantiDraconis/M-Navier-Stokes@c56d9632facf96e0a5d834b987b30df5fe2563a1/Core/G1/ClosedClosedClosedTarget.lean::I_core_closed`

The source is read-only. CI checks out this exact SHA separately and builds it.

## Outer 8 locks

1. HEAD_EXATO
2. FROZEN_S1
3. ENDPOINT_DEFINITION
4. COMPRESSION
5. 6D_AUDIT containing Sigma=(HC,Q,S,K,A)
6. RESIDUE_CLASSIFIER
7. BUILD
8. NO-PLACEBO

## Initial semantic signature

[
Sigma_{NS,0}=(0,0,0,0,0)
]

Here 0 means **not yet certified MATCH**, not mathematical falsity.

Current residues:

- HC: BLOCKING — concrete ActualNS → terminal flexible G1 theorem absent.
- Q: BLOCKING — source endpoint still uses abstract `State`; exact Clay-class
  quantifier instantiation is not yet a theorem.
- S: REVIEWED — K4 critical scaling machinery exists, but its match to actual NS
  data has not been closed.
- K: BLOCKING — a uniform `theta<1` and integrable defect have not been derived.
- A: REVIEWED/PENDING_CI — source hygiene and anti-laundering machinery exist;
  the new 8⊃5 run must certify them before A becomes 1.

The external lock container may become all GREEN while Sigma still contains
zeros. That is expected and must **not** emit FECHADO-FECHADO-FECHADO.

The sequence of K4 attempts is recorded as
`Sigma_0 -> Sigma_1 -> ... -> (1,1,1,1,1)`.
