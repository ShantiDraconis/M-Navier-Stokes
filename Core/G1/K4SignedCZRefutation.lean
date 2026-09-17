/-
K4 signed-CZ adversarial frontier.
This does NOT claim a counterexample to SignedCZLinearGainTarget.
It proves the exact blindness property needed by the radial/constant-direction
attack: the current directional observable vanishes on constant direction fields.
-/
import G1.K4SignedCZDefs

noncomputable section
open MeasureTheory Metric
namespace G1Audit

/-- Constant direction fields are invisible to the current angular/local
oscillation observable, at every center and radius. -/
theorem directionalOscillation_constant_zero
    (v x : Point3) (r : ℝ) :
    directionalOscillation (fun _ => v) x r = 0 := by
  simp [directionalOscillation]

/-- A mechanically checkable statement of what remains to turn angular
blindness into a genuine counterexample: construct admissible signed-CZ data
whose far-field square average is strictly positive for a constant-direction
field.  This is a definition of the witness predicate, not an assumption. -/
def AngularBlindCounterexampleWitness : Prop :=
  ∃ (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (center : Point3) (rho : ℝ) (hrho : 0 < rho)
    (v : Point3) (mag phi : ScalarField3) (r : ℝ),
      0 < r ∧ r ≤ rho ∧
      0 < FarFieldSqAvg Kdata D center rho hrho (fun _ => v) mag phi r

/-- If an AngularBlindCounterexampleWitness is constructed, the proposed
square-function domination by the single current directional observable is
false, because its right-hand side is zero. -/
theorem angular_blind_witness_refutes_single_oscillation_domination
    (h : AngularBlindCounterexampleWitness) :
    ∃ (Kdata : StrainKernelData) (D : SignedDirectionContraction)
      (center : Point3) (rho : ℝ) (hrho : 0 < rho)
      (v : Point3) (mag phi : ScalarField3) (r : ℝ),
        0 < r ∧ r ≤ rho ∧
        FarFieldSqAvg Kdata D center rho hrho (fun _ => v) mag phi r >
          (directionalOscillation (fun _ => v) center r) ^ 2 := by
  rcases h with ⟨Kdata, D, center, rho, hrho, v, mag, phi, r, hr, hrle, hpos⟩
  refine ⟨Kdata, D, center, rho, hrho, v, mag, phi, r, hr, hrle, ?_⟩
  simpa [directionalOscillation_constant_zero] using hpos

#print axioms directionalOscillation_constant_zero
#print axioms angular_blind_witness_refutes_single_oscillation_domination

end G1Audit
