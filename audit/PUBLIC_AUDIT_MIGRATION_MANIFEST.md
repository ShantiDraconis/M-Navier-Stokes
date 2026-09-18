# Public Audit → M-Navier-Stokes migration manifest

Status: SOURCE_CATALOG_ONLY / NO_MATHEMATICAL_PROMOTION
Target base: 823be9b2e6c722fd4a664493c4c53553071192ff
Source repository: ShantiDraconis/navier-stokes-critical-barrier-audit
Source main: f4a688bcc940847f7d8084756fa9ff241c36a28f

## Safety contract

This manifest records provenance only. No source theorem, interface, status label, or certificate is promoted by its presence here.
Every migration must be classified EXACT, ADAPTED, ANALOGY_ONLY, or CROSS_REPO_INCOMPATIBLE and must be reproduced in the target Lean environment before certification.
Frozen/certified refs are not modified.

## Source anchors

| Target | Source anchor | Source path / role | Initial classification | Open obligation |
|---|---|---|---|---|
| K4 | f4a688bcc940847f7d8084756fa9ff241c36a28f | formal/G1/DynamicCampanato.lean: FarFieldAveragedBound / StretchFarSignedOpenCZ | ADAPTED_CANDIDATE | OPEN_CZ remains explicit; no signed gain imported |
| K4 | f4a688bcc940847f7d8084756fa9ff241c36a28f | audit/76_stretchFar_signed_blocking.md | ANALOGY_ONLY / obstruction record | prove independent signed cancellation with beta=1 |
| K5 | f4a688bcc940847f7d8084756fa9ff241c36a28f | formal/G1/DynamicCampanato.lean: DiffusionHalfContraction | INTERFACE_ONLY | produced_by_diffusion is a Prop; derive contraction from PDE/diffusion |
| K6 | 90918de35e3997239b66940a119b77eefd614add | audit/pde-to-dynamic-campanato-20260913 | ADAPTED_CANDIDATE | derive near-field gain from XiEpsPDE without hDynamic |
| K6 | f4a688bcc940847f7d8084756fa9ff241c36a28f | audit/75_pde_to_dynamic_campanato_blocking.md | SPECIFICATION_ANCHOR | preserve exact identity, beta=1, barrier 2*gamma*C+2*A<=C |
| K7 | f4a688bcc940847f7d8084756fa9ff241c36a28f | formal/G1/DynamicCampanato.lean: CampanatoIterationStep | ADAPTED_CANDIDATE | replace stored analytic contracts by K4-K6 proofs |
| K8 | 31869e70b3262497afccef17eb571b40bfce6eed | audit/closure-target-tree-v56 | ANALOGY_ONLY until proposition match | assemble only after K4-K7 |
| A2→G1 | feee79e5b7bee2f27a1bf44bc22f9d05b9364a9d | audit/g1-dynamic-q-20260913 | REVIEW_REQUIRED | ActualNS→signed depletion remains open in source main |
| G1 | 74f5413f14016c548d8c1d8ea407bef5adad0236 | audit/g1-beta-multiprover-20260913 | REVIEW_REQUIRED | geometry→signed stretching was OPEN_BRIDGE |
| G1 | 61c11fccf0c2cae0233ad0b001d182e9623f4f48 | audit/g1-prize-standard-v4-20260913 | REVIEW_REQUIRED | exact prize-domain proposition match required |
| G1→G2 | f4a688bcc940847f7d8084756fa9ff241c36a28f | G1_FORMALIZATION_STATUS.md | LOGIC/CERTIFICATE_CANDIDATE | reproduce differential bookkeeping and Gronwall |
| G2→G3 | f4a688bcc940847f7d8084756fa9ff241c36a28f | audit/66_g1_g4_expanded_closure_program.md | FORMALIZATION_TARGET | concrete projector/Sobolev/div-curl setting required |
| G3 | f4a688bcc940847f7d8084756fa9ff241c36a28f | audit/66_g1_g4_expanded_closure_program.md | PROVED_LOGIC_ON_EXPLICIT_PREMISES | reproduce exact premises |
| G3→G4 | f4a688bcc940847f7d8084756fa9ff241c36a28f | audit/66_g1_g4_expanded_closure_program.md | EXTERNAL_INTERFACE | exact ESS hypothesis map required |
| G4→NS_final | f4a688bcc940847f7d8084756fa9ff241c36a28f | closure program | SPECIFIED_ONLY | unconditional global regularity not established |

## Source boundary preserved verbatim in meaning

- stretchFar / signed cancellation: OPEN_CZ.
- near-field improvement must be derived from XiEpsPDE + diffusion, not hDynamic.
- betaCampanato = 1.
- barrier preservation requires 2*gamma*C + 2*A <= C.
- G1 signed nonlinear control remains OPEN_BRIDGE in the source audit.
- G4 is an external ESS mapping problem.
- NAVIER_STOKES_GLOBAL_REGULARITY is not established by the source audit.

## Promotion checklist

A candidate may enter a target gate only after:
1. exact source SHA/path/theorem recorded;
2. hypothesis, conclusion, quantifier, scaling, constant and domain comparison;
3. classification EXACT or ADAPTED;
4. target Lean module compiles;
5. no sorry/admit/new axiom;
6. #print axioms audited;
7. assumption-laundering and circularity checks pass;
8. target SHA + Actions run/job recorded;
9. only then create cert/freeze refs.

Countdown remains 12 until a mathematical obligation is actually certified.
