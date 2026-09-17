# A2.2 historical bridge recovery

Historical source recovered from `ShantiDraconis/navier-stokes-critical-barrier-audit` at commit `f4a688bcc940847f7d8084756fa9ff241c36a28f`, file `formal/G1/DynamicCampanato.lean`.

## What is already formally available there

The historical file proves the algebraic/dyadic part:

- `betaCampanato = 1`;
- the far-field target is explicitly scaled with the linear factor `r / rhoStar`;
- `betaCampanato_energy_only` proves this factor is bounded by one for `0 <= r <= rhoStar`;
- `iterate_linear_barrier` derives the one-step barrier arithmetic;
- `iterate_to_half_scale` closes the half-scale step **conditional on** `2*gamma*C + 2*A <= C`;
- `gamma_lt_half_of_barrier_condition` proves `gamma < 1/2` from that preservation condition when `C>0` and `A>0`.

This is useful because it identifies the correct coefficient inequality without inventing a new `SubcriticalBudget` formula.

## What remains open in the historical source

The same file explicitly marks:

- `FarFieldAveragedBound.OPEN_CZ`;
- `StretchFarSignedOpenCZ.OPEN_CZ`;
- `DiffusionHalfContraction.produced_by_diffusion : Prop`;
- `PDEToDynamicCampanatoBridge.no_hDynamic_circularity : Prop`.

Therefore the historical source does **not** independently prove the analytic coefficient budget. It already records the exact open analytic bridge.

## Specification correction for current successor

Current `SubcriticalBudget gamma A C := gamma + A*C < 1/2` is not the historically recovered barrier condition. The recovered dyadic preservation condition is

`2*gamma*C + 2*A <= C`,

equivalently `gamma*C + A <= C/2`.

The current successor must not silently identify these formulas. Any replacement must be logged as a specification correction and recompiled.

## Scientific status

- dyadic/Campanato arithmetic: historical PROVED_LEAN candidate, must be imported/reconstructed and compiled in this repo;
- linear `r/rhoStar` scaling arithmetic: historical PROVED_LEAN candidate;
- signed CZ cancellation gain: OPEN_BRIDGE;
- diffusion-produced half contraction: OPEN_BRIDGE;
- derivation of the preservation inequality from the PDE estimates: OPEN_BRIDGE;
- A2.2 aggregate: OPEN_BRIDGE.

No claim of Navier–Stokes regularity or A2.2 promotion follows from this recovery.