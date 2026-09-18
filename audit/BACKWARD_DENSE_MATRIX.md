# Backward-dense semantic matrix — maximal NS frontier

This matrix uses the six mandatory dimensions:
HYPOTHESIS_MATCH, CONCLUSION_MATCH, QUANTIFIER_MATCH, SCALING_MATCH,
CONSTANT_MATCH, AXIOM_AUDIT.

## FINAL

Target meaning: global smooth continuation for every admissible three-dimensional
incompressible Navier--Stokes datum in the selected Clay-class formulation.

Current Lean surface: `final_if_G5_exists`.

- HYPOTHESIS_MATCH: PARTIAL — `ActualNS` is still an abstract predicate.
- CONCLUSION_MATCH: PARTIAL — `GlobalRegularity` is still an abstract predicate.
- QUANTIFIER_MATCH: LOGICALLY CORRECT at the abstract-state level; concrete Clay-class
  quantifiers remain to be instantiated.
- SCALING_MATCH: inherited from the instantiated PDE predicates; not yet concrete here.
- CONSTANT_MATCH: downstream constants are hidden behind exact theorem obligations,
  not asserted numerically.
- AXIOM_AUDIT: no project axiom/sorry/admit in the new compression source;
  external ESS remains an explicitly external theorem match.

Verdict: `WIRING / NOT A PRIZE CLAIM`.

## G5_NS — the one real mathematical frontier

Statement:
`ActualNS -> FlexibleG1`.

FlexibleG1 requests constants/functions satisfying:

`0 <= theta < 1`

`a in L1(0,T)`

`stretch <= theta * nu * z + a * y`.

- HYPOTHESIS_MATCH: OPEN — must be derived from actual NSE, not from a critical
  regularity criterion.
- CONCLUSION_MATCH: EXACT for the current Gronwall closure route.
- QUANTIFIER_MATCH: requires uniform control over the full target maximal interval
  (or a terminal interval plus the already-smooth earlier interval).
- SCALING_MATCH: must be verified for every proposed K4/coherence realization.
- CONSTANT_MATCH: requires a strict margin `theta < 1`; no numerical smallness of
  the final L3 bound is required.
- AXIOM_AUDIT: OPEN theorem, never represented by axiom/sorry/structure-field proof.

Verdict: `FRONTEIRA_REAL`.

## K4-A — ActualNS -> SignedCZLinearGainTarget

- HYPOTHESIS_MATCH: OPEN.
- CONCLUSION_MATCH: exact current signed-CZ linear-gain target.
- QUANTIFIER_MATCH: must hold at all relevant centers/scales/times needed by G5.
- SCALING_MATCH: p=3 bookkeeping has a proved degree condition; actual kernel/direction
  realization still must satisfy it.
- CONSTANT_MATCH: Cfar must be uniform in the required regime.
- AXIOM_AUDIT: no promotion from witness packaging.

Verdict: `SUBOBLIGATION_INSIDE_G5`.

## K4-B — SignedCZLinearGainTarget -> FlexibleG1

- HYPOTHESIS_MATCH: OPEN.
- CONCLUSION_MATCH: must produce theta<1 and an L1-time defect, not merely an
  unsigned pointwise estimate.
- QUANTIFIER_MATCH: uniform time/scale conversion required.
- SCALING_MATCH: must preserve the critical scaling.
- CONSTANT_MATCH: the gain must beat the viscous coefficient after all constants.
- AXIOM_AUDIT: OPEN.

Verdict: `SUBOBLIGATION_INSIDE_G5`.

## G5 -> enstrophy

The new file kernel-proves the algebraic differential inequality from exact
enstrophy balance + FlexibleG1. The full Gronwall integration needs the ordinary
trajectory regularity/absolute-continuity hypotheses supplied by the concrete
smooth-solution model.

Verdict: `PROVED_ALGEBRA / STANDARD_ANALYSIS_TO_INSTANTIATE`.

## Enstrophy -> critical L3

Paper-level route:

`energy + enstrophy -> H1 -> L6 -> interpolation(L2,L6) -> L3`.

The historical audit correctly notes that no Littlewood--Paley G2/G3 macro-gates
are needed for this route.

Verdict: `STANDARD_ANALYSIS / CONCRETE_LEAN_FORMALIZATION_PENDING`.

## L-infinity_t L3_x -> continuation

External theorem: Escauriaza--Seregin--Sverak endpoint regularity.

Verdict: `EXTERNAL_CLASSICAL / EXACT_HYPOTHESIS_MAPPING_PENDING`.

## Compression result

Real macro-frontiers after compression: **1**.

`G5_NS = ActualNS -> FlexibleG1`.

K4-A and K4-B are attack surfaces inside G5, not extra macro-gates.
Everything after G5 is downstream analysis/external theorem matching and must
remain visible, but does not represent another new Navier--Stokes conjectural
mechanism.
