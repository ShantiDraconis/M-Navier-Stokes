# OpenAI Navier–Stokes adversarial audit

## Frozen upstream

- Repository: `openai/NavierStokesAndEuler`
- Frozen upstream commit: `f9e8bc5b38b6e212696e8a30e3e91517af887bbd`
- Upstream tree: `a503f07635f200c0f2f9c5361df1fa07f95c4741`
- Observed commit timestamp: 2026-09-10T11:51:24Z (author), 2026-09-10T13:40:53Z (committer)

This directory does not claim an error in the upstream proof. Its purpose is to attempt independent falsification and to distinguish a genuine counterexample from a specification mismatch or a merely untested bridge.

## Status vocabulary

- `UPSTREAM_PROVED`: theorem is proved in the frozen upstream formalization.
- `REPRODUCED_LEAN`: independently reproduced in this repository.
- `TESTED_NO_COUNTEREXAMPLE`: the recorded adversarial tests passed; this is not a proof of semantic completeness.
- `COUNTEREXAMPLE_CANDIDATE`: candidate violates a target while apparently satisfying its premises; independent verification required.
- `COUNTEREXAMPLE_LEAN`: Lean checks both the premises and negation of the target statement in the intended model.
- `SPECIFICATION_GAP`: formal statement is internally consistent but does not establish a documented intended semantic bridge.
- `OPEN_BRIDGE`: required implication has not been proved.
- `OUR_EXTENSION_PROVED`: a strictly additional theorem is proved here with explicit dependency/provenance evidence.

## Attack DAG

`Clay statement -> Comparator statement -> Lean definitions -> hypotheses -> constructed fields -> PDE identity -> divergence-free -> forcing -> smoothness/support/integrability -> energy condition -> finite-time obstruction -> C/D conclusion`

Each arrow receives:
1. statement extraction;
2. exact upstream file/theorem/SHA provenance;
3. premise minimization;
4. model attack;
5. boundary/degenerate-parameter attack;
6. quantifier/domain attack;
7. analytic regularity attack where applicable;
8. independent Lean reproduction when feasible;
9. result classification using the vocabulary above.

## Separation from Campanato proof development

The OpenAI audit is an external adversarial layer. It must not silently add assumptions to `Core/G1` or promote any Campanato `OPEN_BRIDGE`. Conversely, a failure of an upstream lemma does not establish global regularity. A successful upstream blow-up theorem does not close our G1 bridge.

## Evidence rule

Every positive claim requires: upstream SHA + source path + theorem/definition name + exact formal statement or normalized hash + local test SHA + Lean version + Mathlib version + `#print axioms` where applicable + CI run/job + classification.

Every claimed counterexample additionally requires a minimal witness, machine-checkable premise verification, machine-checkable target failure, and an independent semantic check against the paper/Comparator statement.
