# A/B semantic firewall

Parent mechanical certificate:
`a6022f128d87103c4045d893b68471f05def316f`

This audit attacks the *current abstract factorization surface*, not the
Navier--Stokes equations.

It tests three independent failure modes:

1. **A is not automatic from its type signature.**
   A concrete toy interpretation makes `ActualNS` true while
   `SignedCZLinearGainTarget` is false.

2. **Statewise Cfar is not a uniform Cfar.**
   The current type `Cfar : State -> Real` can absorb an unbounded
   state family. Lean constructs a family for which every state has its own
   valid Cfar but no single real Cfar works for all states.

3. **B is not automatic from a true K4 target.**
   A toy interpretation has a true zero SignedCZ target while
   `TerminalFlexibleG1 0` is impossible.

Classification:
- BARE A AUTOMATIC CLOSURE: REFUTED
- BARE B AUTOMATIC CLOSURE: REFUTED
- STATEWISE -> UNIFORM Cfar: REFUTED
- ActualNS -> concrete uniform signed-CZ theorem: OPEN_BRIDGE
- Signed-CZ mathematics: OPEN
- Navier--Stokes regularity: OPEN

These are semantic negative controls. They do not claim a PDE counterexample.
