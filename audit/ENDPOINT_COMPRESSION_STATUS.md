# Endpoint compression status

The maximal compressed route is intentionally separated into one real new
mathematical bridge plus downstream theorem matching.

## One real macro-gate

`G5_NS : ActualNS -> TerminalFlexibleG1`

with

`exists t0 theta a,`

- `0 <= t0 < T*`,
- `0 <= theta < 1`,
- `a in L1(t0,T*)`,
- `stretch <= theta * nu * z + a*y` on `(t0,T*)`.

This is weaker than requiring signed depletion on the entire maximal interval.

## Kernel-checked internal consequences targeted by this branch

- StrictG1 -> decay differential inequality.
- StrictG1 -> full FlexibleG1.
- full FlexibleG1 -> terminal FlexibleG1.
- terminal FlexibleG1 + exact enstrophy balance -> terminal Gronwall differential inequality.
- K4-A + K4-B -> G5_NS.
- G5_NS + exact downstream theorem interfaces -> FINAL_STATEMENT.

## Maximum hypothetical route

`ActualNS`
→ `TerminalFlexibleG1`
→ terminal Gronwall/enstrophy bound
→ energy + div-curl + Sobolev + interpolation
→ `L-infinity_t L3_x`
→ exact Escauriaza-Seregin-Sverak endpoint
→ regular continuation
→ no finite maximal singular time.

## What is still not manufactured

- a concrete Clay-grade Lean definition/instantiation of `ActualNS`;
- ActualNS -> K4 signed-CZ linear gain;
- K4 signed-CZ linear gain -> terminal FlexibleG1;
- a fully internal Lean formalization of the downstream PDE/Sobolev/ESS chain.

Those obligations remain visible. No `sorry`, `admit`, project `axiom`, or
vacuous `: True` is permitted to change their status.
