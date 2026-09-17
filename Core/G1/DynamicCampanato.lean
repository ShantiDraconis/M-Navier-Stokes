/-
A2.2 reconstruction: algebraic dynamic Campanato closure.

Provenance:
  origin: reconstructed
  date: 2026-09-17
  branch: next/a2-2
  historical search: no implementation of G1.DynamicCampanato was recovered
  from the accessible ShantiDraconis GitHub corpus before this reconstruction.

Audit boundary:
  LinearClosure is only an algebraic subcritical-budget condition.  It does not
  contain the A2.2 recurrence and therefore cannot close the analytic bridge by
  assumption.
-/
import Mathlib

noncomputable section

namespace G1Audit

/-- Algebraic budget used after the analytic one-step estimate has been proved. -/
def LinearClosure (gamma A C : ℝ) : Prop :=
  0 ≤ gamma ∧ 0 ≤ A ∧ 0 ≤ C ∧ gamma + A * C < (1 : ℝ) / 2

/-- The closure budget implies the strict contraction required downstream. -/
theorem gamma_lt_half_of_linearClosure
    {gamma A C : ℝ}
    (hA_pos : 0 < A)
    (hC_pos : 0 < C)
    (h : LinearClosure gamma A C) :
    gamma < (1 : ℝ) / 2 := by
  rcases h with ⟨hgamma, hA, hC, hbudget⟩
  have hAC : 0 ≤ A * C := mul_nonneg hA hC
  linarith

end G1Audit
