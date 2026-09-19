# External OpenAI Navier-Stokes final-proof audit

Pinned upstream:
- repo: `openai/NavierStokesAndEuler`
- SHA: `f9e8bc5b38b6e212696e8a30e3e91517af887bbd`
- submitted solution module: `NavierStokes.ComparatorSolution`
- comparator config: `ComparatorChallenges/NavierStokes.json`

This audit is intentionally separate from the local G5 regularity route.
It verifies the upstream alternatives (C) and (D) directly against the independent
Comparator challenge. A PASS certifies a kernel-checked formal proof at the pinned
upstream SHA under the permitted standard Lean axioms. It does not certify peer
review, publication acceptance, or prize eligibility.

Local G5 remains independently classified and is not promoted by this audit.
