/-
Semantic reconstruction from navier-stokes-critical-barrier-audit
source commit 79140147ba92fe290b4178f92ff7d77ec3271198
source blob 36535db9394ed32216ef67cb57c085d6e855cc65
No mathematical strengthening.
-/
import G1.WeakDerivBridge
import Mathlib
noncomputable section
namespace G1Audit
abbrev ScalarField := Vec3 → ℝ
abbrev VectorField := Vec3 → Vec3
def magEps (ω : VectorField) (ε : ℝ) (x : Vec3) : ℝ := Real.sqrt (‖ω x‖ ^ 2 + ε ^ 2)
def xiEps (ω : VectorField) (ε : ℝ) (x : Vec3) : Vec3 := (magEps ω ε x)⁻¹ • ω x
theorem magEps_nonneg (ω : VectorField) (ε : ℝ) (x : Vec3) : 0 ≤ magEps ω ε x := Real.sqrt_nonneg _
theorem magEps_pos (ω : VectorField) (ε : ℝ) (hε : 0 < ε) (x : Vec3) : 0 < magEps ω ε x := by
  unfold magEps
  apply Real.sqrt_pos.2
  nlinarith [sq_nonneg ‖ω x‖, sq_pos_of_pos hε]
theorem magEps_ne_zero (ω : VectorField) (ε : ℝ) (hε : 0 < ε) (x : Vec3) : magEps ω ε x ≠ 0 := ne_of_gt (magEps_pos ω ε hε x)
structure XiEpsRemainderBudget where
  gradUEpsSq : ℝ → ℝ
  remainderSize : ℝ → ℝ
  Crem : ℝ
  hgrad_nonneg : ∀ t, 0 ≤ gradUEpsSq t
  hrem_nonneg : ∀ t, 0 ≤ remainderSize t
  hCrem_nonneg : 0 ≤ Crem
  cutoff_free : ∀ t, remainderSize t ≤ Crem * gradUEpsSq t
structure XiEpsPDE where
  ε : ℝ
  hε : 0 < ε
  ν : ℝ
  hν : 0 < ν
  omegaEps : VectorField
  uEps : VectorField
  DtXi : VectorField
  projectedStretch : VectorField
  lapXi : VectorField
  logGradDotGradXi : VectorField
  R1Numerator : VectorField
  R1 : VectorField
  R2Numerator : VectorField
  R2 : VectorField
  hR1_def : ∀ x, R1 x = (magEps omegaEps ε x)⁻¹ • R1Numerator x
  hR2_def : ∀ x, R2 x = (ε ^ 2 * (magEps omegaEps ε x)⁻¹ ^ 3) • R2Numerator x
  equation : ∀ x, DtXi x = projectedStretch x + ν • lapXi x + (2 * ν) • logGradDotGradXi x + R1 x + R2 x
  remainderBudget : XiEpsRemainderBudget
def XiEpsPDE.xi (h : XiEpsPDE) : VectorField := xiEps h.omegaEps h.ε
theorem XiEpsPDE.R1_denominator_ne_zero (h : XiEpsPDE) (x : Vec3) : magEps h.omegaEps h.ε x ≠ 0 := magEps_ne_zero h.omegaEps h.ε h.hε x
theorem XiEpsPDE.R2_denominator_ne_zero (h : XiEpsPDE) (x : Vec3) : magEps h.omegaEps h.ε x ≠ 0 := magEps_ne_zero h.omegaEps h.ε h.hε x
inductive XiEpsPDEStatus | definedExactEquation | remainderCutoffFree | localizedIdentityProved | signedFarFieldOpen deriving DecidableEq, Repr
end G1Audit
