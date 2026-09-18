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


## RED run 2

- source commit: `f57efdba5e57f41b7d8a4647cf81238e9c5dc122`
- source tree: `ed34b81d4d3e9fc1865c7962cbd8163813fd6bbd`
- commit time: `2026-09-18T09:23:47Z`
- workflow run: `35329315533`
- job: `105549712198`
- completed: `2026-09-18T09:28:23Z`
- conclusion: `RED_BUILD`

Progress before the failure:

- static proof-gap/axiom/True scan: GREEN
- K4DenseAssembly: GREEN after compatibility repair
- K4HabitabilityReduction: GREEN after compatibility repair

Remaining mechanical failures:

1. `K4KernelNondegeneracy.lean`: `subst w.Kdata` is invalid in Lean 4.32
   because `subst` expects a variable reference; repaired by rewriting with `hK`.
2. `K4ExplicitRieszKernel.lean`: the historical coordinate-function literal no
   longer elaborates directly as `EuclideanSpace ℝ (Fin 3)`; repaired using
   `EuclideanSpace.single (0 : Fin 3) 1`. The oddness proof is made explicit.

Any `sorryAx` printed in this RED arose from elaborator recovery after those
errors. The source scan remained GREEN.


## Run 3 — build GREEN, semantic firewall RED

- source commit: `cc681980b0bf53267fce9aba7e7ff465c7994d86`
- source tree: `aa5dac66ad782658864defb573d9acf35a0d3728`
- workflow run: `35329861796`
- job: `105551466246`
- completed: `2026-09-18T09:35:10Z`
- overall conclusion: `RED_FIREWALL`

All Lean/build stages were GREEN:

- source proof-gap scan: GREEN
- `lake build G1`: GREEN, 8672 jobs
- `MaximalFrontier.lean`: GREEN
- `K4DenseAssembly.lean`: GREEN
- `K4ExplicitRieszKernel.lean`: GREEN
- `K4KernelNondegeneracy.lean`: GREEN

The only failure was the conservative static laundering detector. It treated
the proposition-family fields

- `UniformEnstrophy : State -> Prop`
- `CriticalL3 : State -> Prop`
- `GlobalRegularity : State -> Prop`

as if they were proof-carrying premises because their *types* contain an arrow.
That is a parser false positive: these fields name predicates; they do not
supply proofs of any instance of those predicates.

The successor repair excludes bare predicate-family types from premise/result
intersection while retaining quantified implication and relational proof-field
checks.

## Successor compression

The maximal frontier is weakened to the terminal sufficient form:

```text
G5_NS = ActualNS -> TerminalFlexibleG1
```

with an existential terminal time `t0<T*`. This is strictly weaker than
requiring the same estimate from time zero and is sufficient for the intended
first-singular-time contradiction route.

The frozen independent I-core is now vendored by exact source blob and enters
the test harness only through the theorem `I_core_closed`. The new
`G5FromClosedI_iff_G5` theorem proves that this already-closed beginning
cannot hide the open G5 bridge.
