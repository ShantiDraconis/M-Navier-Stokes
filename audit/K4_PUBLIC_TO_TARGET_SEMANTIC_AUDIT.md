# K4 semantic migration audit — public DynamicCampanato → M-Navier-Stokes

Status: SEMANTIC_AUDIT / NO_MATHEMATICAL_PROMOTION

## Immutable anchors
- Source repo: ShantiDraconis/navier-stokes-critical-barrier-audit
- Source SHA: f4a688bcc940847f7d8084756fa9ff241c36a28f
- Source blob: formal/G1/DynamicCampanato.lean @ 104d0ffd84ff250e55f072cdf27308672670adbc
- Target migration parent: 823be9b2e6c722fd4a664493c4c53553071192ff
- Target SignedFarField blob: 64ad1a76d532eda854b8cbe5b6e66ea329b0f885
- Target K4HabitabilityReduction blob: c0ac086af7be9616c822bd85395870a509951990
- Target K4ExplicitRieszKernel blob: a969dd16f8890caa37fbfbbd09da1435297da889

## Proposition crosswalk
| Source | Target | Classification | HYP | CONCL | QUANT | SCALE | CONST |
|---|---|---|---|---|---|---|---|
| FarFieldAveragedBound.estimate + betaCampanato=1 | SignedCZLinearGainTarget | ADAPTED | PASS* | PASS | ADAPTED | PASS | PASS |
| FarFieldAveragedBound.OPEN_CZ | no assumed target gain | EXACT boundary | PASS | PASS | PASS | PASS | n/a |
| StretchFarSignedOpenCZ.OPEN_CZ | K4 signed-CZ obligation | ADAPTED boundary | REVIEW | PASS | REVIEW | PASS | n/a |
| CampanatoIterationStep | downstream A2.2 barrier algebra | ADAPTED_CANDIDATE | REVIEW | REVIEW | REVIEW | PASS | PASS |
| DiffusionHalfContraction.produced_by_diffusion : Prop | future K5 derivation | INTERFACE_ONLY | FAIL as proof | n/a | n/a | n/a | n/a |
| PDEToDynamicCampanatoBridge.no_hDynamic_circularity : Prop | future K6 PDE→barrier | INTERFACE_ONLY | FAIL as proof | n/a | n/a | n/a | n/a |

* Source permits r=0; target SubcutoffScale requires r>0, a strict nondegenerate subdomain appropriate because FarFieldSqAvg divides by ball volume.

## Exact K4 boundary
The source does not prove the signed cancellation/gain; it stores OPEN_CZ as a Prop field. It cannot close K4.

The target separates CZKernelSpec, KernelCancellationSpec, FarFieldIntegrable, SignedCancellationWitness, strict FarFieldSqAvg positivity, and SignedCZLinearGainTarget.

K4HabitabilityReduction is packaging infrastructure: given the real analytic obligations, the current SignedCancellationWitness structure is automatic. It is not the missing signed-CZ theorem.

## Riesz certificate residue
Already mechanically checked: k4e0_norm, rieszScalarKernel_zero, rieszScalarKernel_odd, rieszScalarKernel_numerator_bound.

Still required:
1. size_bound, Csize=1
2. homogeneous_degree_three
3. measurable
4. explicit gradient
5. HasFDerivAt off zero
6. gradient_decay, Cgrad=5
7. annularIntegrable
8. annulus negation invariance
9. annular_mean_zero
10. rieszScalarCZSpec
11. rieszScalarCancellationSpec
12. #print axioms + no sorry/admit/new axiom + CI reproduction

## Fail-closed conclusion
SOURCE_CERTIFICATE = NONE_FOR_K4_SIGNED_GAIN
TARGET_CERTIFICATE = NOT_YET
K4_RIESZ_KERNEL_CERTIFICATE = NOT_YET_CERTIFIED
K4_SIGNED_CANCELLATION = OPEN_BRIDGE
K4_LINEAR_GAIN = OPEN_BRIDGE
K4 = OPEN_MATH
COUNTDOWN = 12
