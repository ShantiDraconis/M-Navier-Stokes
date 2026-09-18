# Navier–Stokes maximal-frontier compression

Status: `RED_PRESERVED / REPAIR_PENDING_CI`

## Frozen source union

The audit branch starts at:

- base commit: `e000acfb2a3926a7f2327290bc38ea6c3aeeb152`
- base date: `2026-09-18T00:31:14Z`
- base tree: `924787224544d270cc77c52001c9a5bb54d3c30d`

Divergent historical artifacts were imported first by their exact original Git
blobs, before any compatibility repair:

- `K4DenseAssembly.lean`
  - origin commit: `76acf5b3be15ff1308024f416a8371c41e94e5f4`
  - origin date: `2026-09-17T15:26:04Z`
  - frozen origin blob: `3b1c090bfc4bdf7c45a5ef87de5111313276c03d`
- `K4ExplicitRieszKernel.lean`
  - origin commit: `823be9b2e6c722fd4a664493c4c53553071192ff`
  - origin date: `2026-09-18T02:08:14Z`
  - frozen origin blob: `a969dd16f8890caa37fbfbbd09da1435297da889`

No historical SHA or blob is rewritten.

## RED run 1

- source commit: `831dd42c6dff7e2b2551a50da4164289503f7df7`
- source tree: `f15e0e25dc942de8fd8e369ebe01f4f6e0814758`
- commit time: `2026-09-18T09:15:38Z`
- workflow run: `35328607508`
- job: `105547454634`
- completed: `2026-09-18T09:19:54Z`
- conclusion: `RED_BUILD`

What passed before the failure:

- pinned Lean installation: GREEN
- dependencies/cache: GREEN
- source proof-hole scan: GREEN
- source project-axiom scan: GREEN
- source `: True` specification scan: GREEN

The RED was mechanical:

1. `K4DenseAssembly.lean` used geometric-series proof syntax incompatible
   with the current pinned Mathlib API.
2. `K4HabitabilityReduction.lean` declared Type-valued constructors using
   `theorem` instead of `def`, and used the obsolete identifier
   `hasCompactSupport_zero`; current Mathlib exposes `HasCompactSupport.zero`.

The `sorryAx` printed during failed elaboration of `zero_tail_control` was
recovery output caused by the unresolved identifier. It was not present in the
source; the static source scan had already passed.

Pre-repair blobs:

- `K4DenseAssembly.lean`: `3b1c090bfc4bdf7c45a5ef87de5111313276c03d`
- `K4HabitabilityReduction.lean`: `c0ac086af7be9616c822bd85395870a509951990`

## Maximum real frontier

All lower-level routes are compressed into one problem-specific research gate:

**G5_NS**

`ActualNS -> FlexibleG1`

where `FlexibleG1` means that on the target maximal-solution interval there
exist a scalar `theta` and defect coefficient `a(t)` satisfying:

- `0 <= theta < 1`;
- `a` is integrable in time;
- `stretching(t) <= theta * nu * z(t) + a(t) * y(t)`.

The current branch formalizes the exact algebraic consequence:

`y'(t) + 2*(1-theta)*nu*z(t) <= 2*a(t)*y(t)`.

Thus the three research themes previously separated as joint coherence,
weighted exceptional-tail control, and energy-integrable nonlinear gain are
sub-obligations feeding one output. They are not three extra macro-gates.

## K4 candidate factorization

The current K4 approach is represented as:

`ActualNS -> SignedCZLinearGainTarget -> FlexibleG1`.

Both arrows remain OPEN. The composition theorem does not assume either arrow
inside a hidden structure.

## Hypothetical maximum closure

If G5_NS were proved from actual Navier–Stokes data, and the downstream theorem
interfaces were matched exactly, the route would be:

`ActualNS -> FlexibleG1 -> uniform enstrophy -> L-infinity_t L3_x -> ESS continuation -> no finite maximal time`.

This is the maximum legitimate hypothetical closure currently identified.
It is not an unconditional solution claim.

## Independent I-core

Pinned independently:

- I source SHA: `b8b1da782366a581fccd1118c389a2e191b67f0b`
- I source tree: `320300ea2a637eaab4e5c052cb3fef3fca65f77c`
- I audit seal: `919fc815ae713f05e5f8d781636f89e74e8fbbbc`
- current I-to-NS bridge status: `NO_BRIDGE_CLAIM`
