# K4 MCCS v2 ledger

## Fingerprints

### FP-K4-A — local directional/cancellation layer

Stable inputs now represented in source:
- dimension: 3 (`Point3`)
- scalar strain-kernel model
- kernel size target: `|K z| <= Csize / ||z||^3`
- typed kernel degree-three homogeneity contract
- direction/magnitude separation: `D.contract (xi x) (xi y) * mag y`
- exact far-region integral retained as primitive

Open analytic obligations:
- replace `gradient_decay : Prop` by a typed gradient estimate
- replace `annular_mean_zero : Prop` by a typed sphere/annulus integral identity
- derive `FarFieldIntegrable` from sufficient hypotheses
- construct `SignedCancellationWitness` rather than assume one
- prove the Campanato-to-directional-oscillation estimate

### FP-K4-B — global/dyadic/linear-gain layer

Scaling law:
`p = 2*sK + 2*sD - 3`.
For the active intended strain/directional fingerprint `(sK,sD)=(3,0)`, `p=3`.

Open analytic obligations:
- define the concrete far-field square-average functional
- prove its normalization and nonnegativity
- prove dyadic shell summability with exact exponent/range
- derive a constant `Cfar` uniform in `r`
- prove `SignedCZLinearGainTarget`; it remains a target, never an input

## Quantifier card for the desired endpoint

The scientifically usable ordering must be equivalent to:

1. fix the concrete kernel/contraction class and their structural constants;
2. fix admissible regularity parameters and `rho > 0`;
3. derive one finite `Cfar` independent of the local radius;
4. for every `r` with `0 <= r <= rho`, prove the bound.

A witness `Cfar` chosen after `r` is forbidden because it would permit hidden
radius dependence.

## Constant ledger

| constant | origin | must be uniform in | status |
|---|---|---|---|
| `Csize` | kernel specification | `x,y,r,rho,omega` | represented |
| `Cgrad` | kernel specification | same | value represented; estimate still opaque |
| `Cdir` | future directional/coherence estimate | `r` | OPEN |
| `CJ` | Campanato input/derived bridge | local radius in certified regime | OPEN at K4 interface |
| `Cdyadic` | shell summation | `r` | OPEN |
| `Cfar` | derived product/sum of proved constants | `r` | OPEN |

No numerical value is certified here.  No constant may depend on an
uncontrolled `L-infinity` vorticity norm unless that dependency is made an
explicit upstream hypothesis and justified as non-circular.

## Counterexample frontier

- kernel without mean-zero: tests necessity of cancellation hypothesis
- insufficient tail decay/integrability: tests exact integral semantics
- raw-vorticity contraction plus separate magnitude: predecessor
  specification mismatch; corrected explicitly, not hidden
- alpha-critical dyadic regime: remains to be computed from the actual shell
  exponent; no preassigned `alpha_max` is certified
- `r = rho`: boundary test required
- zero vorticity/direction: requires a well-defined direction convention in
  the eventual concrete `xi` realization; not repaired by a non-degeneracy
  assumption unless necessity is proved
- concentrated vorticity: tests uniformity of the Campanato/coherence bridge

## MCCS v2 status

Mechanical status of the current HEAD: EXECUTION_PENDING until Actions returns
a completed run.

Scientific status: OPEN_BRIDGE.

Closed/proved candidates:
- K3 dyadic barrier algebra: inherited frozen predecessor
- K4 scaling exponent algebra
- active direction/magnitude separation
- pointwise magnitude scaling of the exact integrand

Still blocking scientific K4:
1. typed kernel cancellation/smoothness;
2. exact integrability;
3. signed cancellation derivation;
4. Campanato/coherence estimate;
5. concrete far-average + dyadic bound;
6. uniform linear gain endpoint.

These are internal obligations of the two K4 fingerprints, not new gates.
