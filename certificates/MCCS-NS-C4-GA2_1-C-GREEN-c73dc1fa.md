# MCCS Campanato A2.1 Certificate

Certificate ID: `MCCS-NS-C4-GA2_1-C-GREEN-c73dc1fa`

- Repository: `ShantiDraconis/campanato-lean`
- Frozen source SHA: `c73dc1fabda7487bbd43d66d83d69f1aafe4d243`
- Freeze ref: `freeze/a2-1-c73dc1fa`
- CI workflow: `check-a2-1`
- CI run: `35145389851`
- CI job: `104959961950`
- Result: `SUCCESS`
- Lean: `4.32.1`
- Scope: reconstructed `Core/G1` plus `A2/TestA2-1.lean`

## Verified gates

1. Environment/toolchain setup: GREEN.
2. Lake manifest/dependency resolution: GREEN.
3. Mathlib cache/dependencies: GREEN.
4. `lake build G1`: GREEN.
5. `lake env lean A2/TestA2-1.lean`: GREEN.
6. forbidden-placeholder firewall used by this workflow: GREEN.
7. certificate-summary step: GREEN.

## Scientific boundary

This certificate proves reproducible mechanical compilation and the checks explicitly executed by CI at the frozen SHA. It does **not** promote the analytic obligations represented in the source as open propositions into proved Navier–Stokes mathematics, and it does not claim global regularity.

## Provenance

The preceding failed run `35130288336` compiled both the G1 library and A2.1 baseline successfully but the textual firewall matched a forbidden keyword inside a provenance comment. Commit `c73dc1fa...` removed that comment-only false positive without changing the mathematical declarations. Run `35145389851` then completed every workflow step successfully.
