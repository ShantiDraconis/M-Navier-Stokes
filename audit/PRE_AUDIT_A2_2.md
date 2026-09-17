# A2.2 pre-audit record

Classification: PRE-AUDIT BLOCKED / INFRASTRUCTURE + SPECIFICATION GAP. No A2.2 RUN has been performed by this record; therefore no RED/GREEN claim is made.

## Confirmed missing upstream modules
`A2/TestA2-2.lean` imports `G1.SignedFarField` and `G1.DynamicCampanato`. They are absent from the canonical `Core/G1/` tree at this stage. Repository code search found only the harness reference, not an implementation to recover.

## Assumption-laundering findings
1. `A2SignedCancellationData.hgamma_half : gamma < 1/2` stores part of the intended downstream conclusion and is forbidden as proof of that conclusion.
2. `CampanatoFromWeightedInputs.closure : LinearClosure cancellation.gamma scaling.A C` must be unfolded/audited before use. Its provenance and semantic content are currently unresolved because the defining module is missing.
3. `weightedIBP : A2WeightedIBPResult duality` is an input identity. The frozen A2.1 mechanical GREEN does not by itself establish the underlying analytic Green identity independently; its analytic derivation remains a separate scientific obligation.
4. `CampanatoFromWeightedTarget I Jr JrHalf` accepts arbitrary scalar `Jr` and `JrHalf`; no current input links `JrHalf` to an exact Campanato functional. The target therefore cannot yet express the desired analytic recurrence faithfully.

## Reconstruction boundary
Reconstruction of `SignedFarField` and `DynamicCampanato` is an upstream stage and must not import `A2/TestA2-2.lean`. Definitions may be reconstructed only from independently justified semantics/provenance. Central estimates cannot be inserted as fields to satisfy the harness.

## A2.1 immutability
Frozen A2.1 remains identified by commit `c73dc1fabda7487bbd43d66d83d69f1aafe4d243` and its Git tree. Successor commits may add files but do not mutate that historical commit/tree. No A2.1 file is modified by this pre-audit record.

## Exit criteria before A2.2 RUN
- exact `J_r` definition/normalization and approximation class;
- independently reconstructed/audited SignedFarField stage;
- independently reconstructed/audited DynamicCampanato stage;
- removal/separation of target-as-input fields;
- dependency/circularity audit;
- harness compiles locally/CI environment is executable;
- pre-audit of the next gate completed before A2.2 RUN.
