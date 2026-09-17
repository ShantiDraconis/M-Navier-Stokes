/-
A2.2 reconstruction: algebraic dynamic Campanato bookkeeping.

Provenance:
  origin: reconstructed
  date: 2026-09-17
  branch: next/a2-2-math

Audit boundary:
  LinearClosure records only sign/boundedness data.  It deliberately contains
  no strict contraction statement and cannot imply gamma < 1/2 by itself.
  Any subcritical budget must therefore be supplied by an independently proved
  theorem/certificate downstream.
-/
import Mathlib

noncomputable section

namespace G1Audit

/-- Assumption-safe algebraic bookkeeping; no A2.2 target is encoded here. -/
def LinearClosure (gamma A C : ℝ) : Prop :=
  0 ≤ gamma ∧ 0 ≤ A ∧ 0 ≤ C

/-- Explicit downstream budget proposition, kept separate from raw closure data. -/
def SubcriticalBudget (gamma A C : ℝ) : Prop :=
  gamma + A * C < (1 : ℝ) / 2

/-- A separately established subcritical budget yields strict contraction. -/
theorem gamma_lt_half_of_subcriticalBudget
    {gamma A C : ℝ}
    (hclosure : LinearClosure gamma A C)
    (hbudget : SubcriticalBudget gamma A C) :
    gamma < (1 : ℝ) / 2 := by
  rcases hclosure with ⟨hgamma, hA, hC⟩
  have hAC : 0 ≤ A * C := mul_nonneg hA hC
  unfold SubcriticalBudget at hbudget
  linarith

end G1Audit
