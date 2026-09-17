# Assumption-Laundering Firewall

Status: normative pre-audit policy for successor gates. This document changes no previously frozen certificate.

## Core criterion
For a target theorem `T : H₁ → ... → Hₙ → C`, every hypothesis must be independently justified as upstream input. A hypothesis is forbidden when it contains `C`, an equivalent form of `C`, or a definitional/algebraic/renamed/re-scaled restatement whose proof would already discharge the target burden.

Structures used as theorem inputs must contain raw data and independently sourced assumptions only. A target property belongs in a theorem conclusion, not in an input structure field.

If a property must be assumed in one context and derived in another, use distinct types/interfaces and record the dependency explicitly. Compilation does not upgrade an assumed property into a derived result.

## A2.2 finding
`A2SignedCancellationData.hgamma_half : gamma < 1/2` intersects the intended A2.2 burden. It must not be consumed as evidence that A2.2 derived `gamma < 1/2`.

`CampanatoFromWeightedInputs.closure : LinearClosure cancellation.gamma scaling.A C` is also subject to semantic audit: if `LinearClosure` already contains or is equivalent to the target contraction/gap, using it to prove the target is laundering unless `LinearClosure` has an independently certified upstream derivation.

`weightedIBP : A2WeightedIBPResult duality` is likewise conditional until the analytic Green/IBP identity has an independent certified derivation; a structure field carrying the identity is not that derivation.

## Required pre-audit checks
1. Enumerate Prop-valued fields of input structures in the dependency cone.
2. Normalize the main theorem conclusion and each hypothesis at least through definitional unfolding and obvious algebraic/renaming equivalences.
3. Flag direct, equivalent, stronger-than-target, or target-containing hypotheses.
4. Require provenance for every surviving nontrivial Prop input: upstream theorem/certificate, external theorem with explicit interface, or explicit CONDITIONAL status.
5. Reject cycles where the theorem or a descendant establishes an input used by the same theorem.
6. A flagged item may be resolved only by independent derivation, legitimate statement change with delta, or explicit conditional classification.

## Mechanical status
Missing imports or incomplete harnesses are `PRE-AUDIT BLOCKED / INFRASTRUCTURE`, not RED. RED is reserved for an executable gate that actually ran and failed.

## Reconstruction rule
Missing upstream modules are reconstructed as independent stages. They must not import the A2 harness they are intended to support and must not encode the downstream target as a field merely to make the harness compile.
