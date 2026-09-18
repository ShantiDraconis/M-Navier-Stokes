# Closed -> Open -> Closed certification chain

## Frozen beginning

The beginning of the chain is not represented by an assumed proposition.
The exact Lean sources from the independent I repository are vendored without
content changes from:

- repository: `ShantiDraconis/meta-mathematics-indeterminate-I`
- source commit: `b8b1da782366a581fccd1118c389a2e191b67f0b`
- source tree: `320300ea2a637eaab4e5c052cb3fef3fca65f77c`
- independent audit seal: `919fc815ae713f05e5f8d781636f89e74e8fbbbc`

The CI recomputes every vendored Git blob hash before compiling it.

The start is divided exactly into the four internal I gates:

| Gate | Lean property | Certificate range | Status |
|---|---|---|---|
| I-G1 | `I_G1_FoundationClosed` | C01-C05 | CLOSED / PROVED_LEAN |
| I-G2 | `I_G2_ArithmeticAlgebraClosed` | C06-C09 | CLOSED / PROVED_LEAN |
| I-G3 | `I_G3_InformationAnalysisClosed` | C10-C14 | CLOSED / PROVED_LEAN |
| I-G4 | `I_G4_GeometryClosed` | C15 | CLOSED / PROVED_LEAN |

The theorem `I_core_closed` combines these four results.

## Unique open middle

The only problem-specific macro-frontier is:

```text
G5_NS : ActualNS -> TerminalFlexibleG1
```

To make the user's requested start explicit, the chain also defines:

```text
G5FromClosedI := ICoreClosed -> G5NSBridge
```

and kernel-proves:

```text
G5FromClosedI <-> G5NSBridge
```

This is the anti-laundering invariant: a closed I-core neither proves nor
weakens the open Navier-Stokes bridge.

The terminal target is:

[
exists t_0<T^*, 	heta<1, ain L^1(t_0,T^*) :
mathcal S(t)le	heta
u z(t)+a(t)y(t).
]

## Closed end

The endpoint is closed as **conditional logical composition**, not as an
unconditional Millennium theorem.

The test sequence is:

1. `test_00_I_start_closed`
2. `test_10_frontier_exact`
3. `test_20_K4_factorization`
4. `test_30_terminal_G1_to_gronwall`
5. `test_40_G5_to_uniform_enstrophy`
6. `test_50_enstrophy_to_critical_L3`
7. `test_60_critical_L3_to_final`
8. `test_70_final_closed_conditional`
9. `ClosedOpenClosedChain`

The final shape is therefore:

```text
I-G1 CLOSED
 -> I-G2 CLOSED
 -> I-G3 CLOSED
 -> I-G4 CLOSED
 -> G5_NS OPEN
 -> terminal differential wiring CLOSED
 -> enstrophy/Sobolev/ESS theorem matches
 -> FINAL CLOSED CONDITIONAL
```

The phrase `FINAL CLOSED CONDITIONAL` means the implication has a complete
Lean proof once the explicitly supplied G5 and downstream theorem matches are
present. It does **not** mean unconditional Navier-Stokes global regularity has
been established.

## Required epistemic invariants

- no `sorry`
- no `admit`
- no project `axiom`
- no vacuous `: True` proof field
- frozen I blobs must match their independent source
- G5 remains an explicit proposition, never a structure field renamed as proof
- final theorem must consume G5 explicitly
