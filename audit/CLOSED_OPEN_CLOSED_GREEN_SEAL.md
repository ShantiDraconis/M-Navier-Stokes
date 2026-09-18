# CLOSED -> OPEN -> CLOSED GREEN seal

Source mathematics commit:
`a64dca39cdba2000fab90bce44e0d6f81577fe38`

Source tree:
`b86b37cceaf04f4dc54878865e89c4837c98a4aa`

Certification workflow:
- run: `35332024106`
- job: `105558293721`
- started: `2026-09-18T09:55:12Z`
- completed: `2026-09-18T10:00:38Z`
- conclusion: `SUCCESS`

All certification gates passed:

1. pinned Lean installation — GREEN
2. dependency/cache bootstrap — GREEN
3. exact frozen I blob verification — GREEN
4. source proof-gap scan — GREEN
5. frozen I-core build — GREEN
6. dense G1 + complete chain build — GREEN
7. terminal MaximalFrontier direct compile — GREEN
8. ClosedOpenClosedChain direct compile — GREEN
9. dense K4 direct compile — GREEN
10. assumption-laundering firewall — GREEN
11. scientific boundary assertions — GREEN

Frozen independent I source:
- repository: `ShantiDraconis/meta-mathematics-indeterminate-I`
- source commit: `b8b1da782366a581fccd1118c389a2e191b67f0b`
- source tree: `320300ea2a637eaab4e5c052cb3fef3fca65f77c`
- independent seal: `919fc815ae713f05e5f8d781636f89e74e8fbbbc`

Certified logical status:

```text
I-G1 FOUNDATION             = CLOSED / PROVED_LEAN
I-G2 ARITHMETIC_ALGEBRA     = CLOSED / PROVED_LEAN
I-G3 INFORMATION_ANALYSIS   = CLOSED / PROVED_LEAN
I-G4 GEOMETRY               = CLOSED / PROVED_LEAN

G5_NS                       = OPEN
  ActualNS
  -> TerminalFlexibleG1

POST-G5 DIFFERENTIAL WIRING = CLOSED / PROVED_LEAN
FINAL COMPOSITION           = CLOSED / PROVED_WIRING_CONDITIONAL

UNCONDITIONAL NS REGULARITY = NOT ESTABLISHED
```

Anti-laundering invariant certified in Lean:

```text
G5FromClosedI <-> G5NSBridge
```

Therefore the already-closed I-core cannot hide, weaken or manufacture the
open Navier-Stokes bridge. The only real problem-specific mathematical
frontier remains G5_NS.
