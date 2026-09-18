# Navier–Stokes maximal-frontier compression

Status at introduction: `AWAITING_CI / NO_PRIZE_CLAIM`

## Frozen source union

This branch is based on:

- `e000acfb2a3926a7f2327290bc38ea6c3aeeb152`
- date: `2026-09-18T00:31:14Z`
- source tree: `924787224544d270cc77c52001c9a5bb54d3c30d`

Two divergent mathematical artifacts are imported by their existing Git blob
objects, preserving their original content exactly:

- `Core/G1/K4DenseAssembly.lean`
  - source commit `76acf5b3be15ff1308024f416a8371c41e94e5f4`
  - date `2026-09-17T15:26:04Z`
  - blob `3b1c090bfc4bdf7c45a5ef87de5111313276c03d`
- `Core/G1/K4ExplicitRieszKernel.lean`
  - source commit `823be9b2e6c722fd4a664493c4c53553071192ff`
  - date `2026-09-18T02:08:14Z`
  - blob `a969dd16f8890caa37fbfbbd09da1435297da889`

No source SHA is rewritten.

## Maximum certified frontier

The current repository can mechanically reach:

1. exact signed far-field definitions and scale bookkeeping;
2. K4 p=3 scaling compatibility conditional on dimensionless direction scaling;
3. constant-direction blindness of the current directional observable;
4. exact reduction of an admissible angular-blind witness to core obligations;
5. exclusion of the zero kernel from any strictly positive far-field witness;
6. a concrete nonzero Riesz-type kernel candidate with basic oddness and size primitives;
7. conditional dyadic shell assembly;
8. Campanato barrier algebra;
9. algebraic conversion of a genuine signed-depletion estimate into a dissipative/Gronwall-ready differential inequality.

The maximum compressed real frontier is therefore

[
oxed{
G5_{NS}:quad
mathrm{ActualNS}
Longrightarrow
exists,	heta<1, ain L^1_t:
mathcal S(t)
le
	heta
u z(t)+a(t)y(t).
}
]

This is encoded by `G1Audit.MaximalFrontier.G5NSBridge`.

## K4 factorization inside the one gate

The K4 program can be tested as the factorization

[
mathrm{ActualNS}
longrightarrow
mathrm{SignedCZLinearGainTarget}
longrightarrow
G1_{mathrm{flex}}.
]

The theorem `k4_factorization_closes_G5` proves only that composition.
Neither arrow is manufactured by a structure field inside the theorem.

The current signed-CZ target is

[
mathrm{FarFieldSqAvg}
le
C_{mathrm{far}}
rac{|omega|_2^2}{ho^3}
rac rho.
]

A genuine proof must establish the target for actual NS data and then show that
this quantitative control is sufficient for flexible signed depletion.

## Why this is the maximal useful compression

Earlier audit material decomposed the missing mathematics into several themes:
joint direction/strain coherence, weighted exceptional-tail control, and an
energy-integrable nonlinear gain. Those are useful attack surfaces, but they
all feed the same mathematical output: flexible G1.

They therefore remain sub-obligations inside G5_NS, not separate macro-gates.

## If G5_NS existed

With the exact enstrophy balance,

[
	frac12 y' + 
u z = mathcal S,
]

the repository now proves algebraically that flexible G1 yields

[
y' + 2(1-	heta)
u z le 2a(t)y.
]

If the downstream theorem matches are supplied:

[
G1_{mathrm{flex}}
Rightarrow
sup_{t<T^*}|omega(t)|_2^2<infty
Rightarrow
uin L^infty_tL^3_x
Rightarrow
	ext{ESS continuation}
Rightarrow
T^*=infty.
]

The last three arrows are not promoted merely because they are classical or
plausible; `DownstreamWiring` keeps their exact theorem obligations visible.

## External endpoint reference

Escauriaza–Seregin–Šverák,
`L_{3,∞}`-solutions of the Navier–Stokes equations and backward uniqueness,
Russian Mathematical Surveys 58:2 (2003), 211–250,
DOI 10.1070/RM2003v058n02ABEH000609.

## Status

- internal algebraic compression: candidate for GREEN after CI
- zero-kernel exclusion: already formalized on source branch
- explicit Riesz candidate: partial analytic development
- ActualNS → SignedCZ target: OPEN
- SignedCZ target → FlexibleG1: OPEN
- direct ActualNS → FlexibleG1: OPEN
- unconditional global regularity: NOT ESTABLISHED
