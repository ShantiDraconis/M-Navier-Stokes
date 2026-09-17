# A2.2 Research Workbench — Provisional Reference Calculation

## Status and epistemic boundary

**Artifact class:** RESEARCH_WORKBENCH / PROVISIONAL_REFERENCE  
**Gate:** A2.2  
**Purpose:** preserve authorship/provenance of the proposed numerical navigation method before the missing analytic modules and proofs exist.  

This artifact is **not** a proof, GREEN certificate, PROVED_LEAN result, verified value of gamma, or assertion that the A2.2 bridge is true. The numerical constants below are explicitly provisional/hypothetical reference values. They must be replaced by values derived from the eventual definitions/proofs of `SignedFarField`, `DynamicCampanato`, the exact `J_r`, and the effective scale regime.

It records a research method and a quantitative target for subsequent derivation.

## Reference quantity

For workbench navigation, use a sextuple

`n = (v, I, q, alpha, tau, state)`

where:
- `v`: nominal reference value;
- `I = [v_min,v_max]`: propagated reference interval;
- `q = (q_pass,q_fail)`: empirical test-support coordinates over a documented test class T; **not probability of mathematical truth**;
- `alpha`: approximation/truncation order;
- `tau`: working tolerance;
- `state`: workbench state.

These coordinates guide research. Formal proof, not q, establishes universal validity.

## Provisional inputs

Reference inputs supplied for the bridge calculation:

- WeightedIBP reference: `(0.24, [0.22,0.27], (0.95,0.05), 2, 0.02, VERIFIED)`
- SignedFarField reference: `(0.14, [0.11,0.18], (0.90,0.10), 2, 0.03, VERIFIED)`

These are not claimed to have been derived from existing `SignedFarField.lean` or `DynamicCampanato.lean`; those modules are not yet available in the certified chain.

## Harmonic reference calculation

Candidate model:

`gamma_h = (1/4) * (1 + C_dep * beta)`, with `beta = r/rho`.

Using provisional `beta = 0.1`, `C_dep = 0.4`:

`gamma_h = 0.25 * 1.04 = 0.26`.

With provisional uncertainties `delta C_dep = 0.05`, `delta beta = 0.02`, first-order reference propagation gives approximately

`delta = 0.25 * (0.4*0.02 + 0.05*0.1) = 0.00325`.

Reference record:

`gamma_h = (0.26, [0.2568,0.2633], (0.95,0.05), 2, 0.01, VERIFIED)`.

## Source/error reference calculation

Candidate model:

`gamma_w = C_P * beta^2`.

Using provisional `C_P = 14`, `beta = 0.1`:

`gamma_w = 14 * 0.01 = 0.14`.

With `delta C_P = 1.5` and refined `delta beta = 0.005`, first-order reference propagation:

`delta = 14*2*0.1*0.005 + 1.5*0.01 = 0.029`.

Reference record:

`gamma_w = (0.14, [0.111,0.169], (0.90,0.10), 2, 0.03, VERIFIED)`.

## Provisional composition

Reference addition gives:

- nominal: `gamma = 0.26 + 0.14 = 0.40`;
- interval: `[0.2568+0.111, 0.2633+0.169] = [0.3678,0.4323]`;
- empirical support coordinate under the provisional multiplicative convention: `q_pass = 0.95*0.90 = 0.855`, `q_fail = 0.145`;
- approximation order: `min(2,2)=2`;
- tolerance: `0.01+0.03=0.04`.

Thus the provisional reference object is

`gamma_ref = (0.40, [0.3678,0.4323], (0.855,0.145), 2, 0.04, VERIFIED)`.

The workbench margin against `1/2` is

`0.5 - (0.4323 + 0.04) = 0.0277`.

This is a **navigation margin only**; it is not a proof of `gamma < 1/2`.

## Candidate reformulation reference

If a legitimate mathematical reformulation changes the approximation from linear to order 2 and a future derivation actually supports

`gamma_h = (0.18, [0.174,0.187], (0.95,0.05), 3, 0.02, VERIFIED)`,

then with the same provisional `gamma_w`:

- nominal `gamma = 0.32`;
- interval `[0.285,0.356]`;
- support coordinate `(0.855,0.145)`;
- order `min(3,2)=2`;
- tolerance `0.05`;
- reference margin `0.5-(0.356+0.05)=0.094`.

This is a candidate target for investigation, **not an established A2.2 result**. Any such reformulation requires `delta_from_original` and `legitimacy_review`.

## Test-class bookkeeping proposal

A proposed finite workbench accounting example is `45` elementary test instances generated from documented model families/operations. Example counts such as `38/45`, `43/45`, or an alleged `|CE \\ T| = 2` are **not measured results** until the actual test registry is generated and executed. They are preserved here only as the proposed accounting method.

No finite test coverage proves absence of counterexamples outside T. Universal closure requires the formal bridge proof.

## Required replacement data

Before any numerical statement in this document may be promoted beyond provisional reference status, derive and record:

1. the exact definition and normalization of `J_r`;
2. actual constants replacing provisional `C_dep` and `C_P`;
3. the effective admissible range of `beta = r/rho`;
4. the generated and executed test class T;
5. measured test-support counts;
6. the exact bridge statement and dependency cone;
7. formal Lean proofs and clean axiom audits for any result promoted to PROVED_LEAN.

## Authorship/provenance intent

This file deliberately preserves the proposed A2.2 quantitative workbench methodology and its provisional calculations in Git history before the analytic bridge is closed. Its existence establishes a timestamped repository record of the research formulation; it does **not** establish priority over independently created work by itself and does not establish mathematical correctness.

## Promotion rule

This artifact must never be used as a dependency that converts provisional constants into a theorem. Production `Core/G1/` proofs must derive their constants independently. When effective values become available, create a successor derivation artifact and retain this file unchanged as historical provenance.
