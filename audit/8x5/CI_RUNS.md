# 8x5 CI ledger — Navier-Stokes

## Run 1 — RED (mechanical)

- source audit commit: `6560114250a11d42c288d6de980ed10ff25991d7`
- workflow: `audit-8x5-ns`
- run: `35376506438`
- job: `105702322629`
- conclusion: `RED_MODULE_GRAPH`

Passed:

- L1 HEAD_EXATO: GREEN
- L2 FROZEN_S1: GREEN
- L3 ENDPOINT_DEFINITION: GREEN
- L4 COMPRESSION: GREEN

Failure:

L5 attempted to compile `audit/NS_8x5.lean`, whose import referenced the
audit directory as a module prefix even though `audit/` was not declared as
a Lean library/search root.

Classification: `MECHANICAL_RED`, not a semantic change.

Repair:

- add a dedicated `Audit8x5` Lean library rooted at `audit/`;
- use module `Universal8x5`;
- build `Audit8x5` before direct compilation;
- rerun unchanged Sigma_0.
