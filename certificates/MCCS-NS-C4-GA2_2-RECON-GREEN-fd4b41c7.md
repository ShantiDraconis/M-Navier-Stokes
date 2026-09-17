# MCCS A2.2 reconstruction certificate

- problem: NS
- chain: C4
- gate: A2.2-RECONSTRUCTION
- mechanical_status: GREEN
- scientific_status: INFRASTRUCTURE_ONLY
- source_sha: `fd4b41c7efd5c0de85e17795bff9a920c166b113`
- source_tree: `d694de1262596b6c452bbe2bd7db4b214a99aa5e`
- freeze_ref: `freeze/a2-2-reconstruction-fd4b41c7`
- workflow: `check-a2-2`
- run_id: `35173196584`
- job_id: `105049087821`
- run_created_utc: `2026-09-17T02:07:29Z`
- run_completed_utc: `2026-09-17T02:12:06Z`
- conclusion: `success`

## Scope
This certificate establishes only that the reconstructed G1 vocabulary/modules and the then-current A2 harness compile and pass the directed mechanical firewall at the frozen source SHA. It does not certify the analytic A2.2 bridge, the Campanato recurrence, `gamma < 1/2` as a derived PDE estimate, or Navier--Stokes regularity.

## Executed gate
The successful workflow included environment/manifest setup, Mathlib cache, `lake build G1`, A2.1 regression compilation, A2.2 harness compilation, forbidden proof-gap audit, reconstructed bridge-boundary audit, and certificate summary.

## Scientific boundary
At this SHA the harness still contains `hgamma_half` as an input field. Therefore no downstream theorem that merely recovers `gamma < 1/2` from that field is classified as a scientific derivation. The successor mathematical branch must remove/separate that laundering path before scientific promotion.

Historical source objects are immutable: this certificate points to the exact source commit/tree and does not mutate A2.1 or the reconstruction freeze.
