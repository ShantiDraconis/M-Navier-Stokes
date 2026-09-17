/-
A2.2 dynamic Campanato arithmetic.

Specification correction 2026-09-17:
The provisional proposition `gamma + A*C < 1/2` was not the historical
Campanato preservation condition.  The recovered source
`navier-stokes-critical-barrier-audit@f4a688bcc940847f7d8084756fa9ff241c36a28f`
uses `2*gamma*C + 2*A <= C` for the half-scale barrier.

This file formalizes only that algebra.  It does not derive the preservation
condition from the PDE/CZ/diffusion estimates.
-/
import Mathlib

noncomputable section

namespace G1Audit

/-- Sign bookkeeping only; it contains no contraction conclusion. -/
def LinearClosure (gamma A C : ℝ) : Prop :=
  0 ≤ gamma ∧ 0 ≤ A ∧ 0 ≤ C

/-- Historical dyadic half-scale preservation condition. -/
def BarrierPreservation (gamma A C : ℝ) : Prop :=
  2 * gamma * C + 2 * A ≤ C

/-- The historical barrier condition gives the coefficient bound needed for
    the half-scale iteration. -/
theorem coefficient_half_of_barrier
    {gamma A C : ℝ}
    (hbudget : BarrierPreservation gamma A C) :
    gamma * C + A ≤ C / 2 := by
  unfold BarrierPreservation at hbudget
  linarith

/-- With a genuinely positive inhomogeneous term and positive barrier size,
    preservation forces strict gamma < 1/2.  This is algebra only. -/
theorem gamma_lt_half_of_barrier
    {gamma A C : ℝ}
    (hC : 0 < C)
    (hA : 0 < A)
    (hbudget : BarrierPreservation gamma A C) :
    gamma < (1 : ℝ) / 2 := by
  unfold BarrierPreservation at hbudget
  by_contra h
  have hgamma : (1 : ℝ) / 2 ≤ gamma := le_of_not_gt h
  have hmul : C ≤ 2 * gamma * C := by
    nlinarith
  linarith

end G1Audit
