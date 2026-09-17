# K4 directional-model decision

## Status

MCCS v2 specification correction; not a proof of the signed-CZ endpoint.

## Historical ambiguity removed

The earlier active integrand used both

- `D.contract (xi x) (omega y)`, and
- a separate multiplicative `mag y`.

For the directional strain/coherence model this mixes direction and raw
vorticity magnitude and prevents a well-defined degree-zero directional
fingerprint.  The successor uses

`D.contract (xi x) (xi y) * mag y`.

Thus magnitude is represented exactly once, by `mag`, and `D` receives only
direction data.  This is a statement correction, not a new analytic
hypothesis.  The predecessor commit remains in history.

## Scaling consequence

`K4ScalingAudit.requiredRhoExponent sK sD = 2*sK + 2*sD - 3`.
For the strain-kernel fingerprint `sK = 3` and a directional contraction
`sD = 0`, the historical endpoint exponent is `p = 3`.

The code does **not** claim that this scaling identity proves cancellation,
integrability, coherence, the dyadic estimate, or the final linear gain.
Those remain independent analytic obligations.

## Anti-laundering decision

A first draft introduced a predicate whose conclusion compared
`D.contract (xi x) (xi y)` with itself under a scalar parameter.  That would
have been vacuous.  It was immediately replaced by the non-vacuous theorem
`signedFarIntegrand_magnitude_degree_one`, which proves directly that scaling
the independent magnitude field scales the exact active integrand linearly.

## Active scientific boundary

- kernel scaling algebra: formal candidate
- direction/magnitude separation: explicit in the primitive integrand
- magnitude scaling theorem: proved in Lean source, pending CI
- exact integrability: OPEN_BRIDGE
- signed cancellation: OPEN_BRIDGE
- coherence estimate: OPEN_BRIDGE
- dyadic/global estimate: OPEN_BRIDGE
- historical `rho^-3 * (r/rho)` endpoint: TARGET only

No `OPEN_CZ`, `sorry`, `admit`, or custom analytic axiom is introduced by this
decision.
