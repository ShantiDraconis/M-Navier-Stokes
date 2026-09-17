/-
K4 signed-CZ admissible angular-blind frontier.
This is still part of the single K4 macro-gate.

Habitability gives a counterexample to domination by the current directional
observable under the four analytic contracts currently formalized in K4.
It does NOT by itself refute SignedCZLinearGainTarget, because no quantitative
bridge from these contracts/directionalOscillation to FarFieldSqAvg is assumed.
-/
import G1.K4SignedCZDefs
import G1.K4SignedCZRefutation

noncomputable section
open MeasureTheory Metric
namespace G1Audit

/-- Strong version of the angular-blind witness using exactly the four analytic
contracts already present in the K4 signed far-field layer. -/
structure AdmissibleAngularBlindWitness where
  Kdata : StrainKernelData
  D : SignedDirectionContraction
  center : Point3
  rho : ℝ
  hrho : 0 < rho
  v : Point3
  mag phi : ScalarField3
  r : ℝ
  hr : 0 < r
  hr_le_rho : r ≤ rho
  czKernel : CZKernelSpec Kdata
  cancellation : KernelCancellationSpec Kdata
  tail : FarFieldTailControl phi
  signed : SignedCancellationWitness
    Kdata D ⟨center, rho, hrho⟩ (fun _ => v) mag phi
  farField_pos :
    0 < FarFieldSqAvg Kdata D center rho hrho (fun _ => v) mag phi r

/-- Forget the additional analytic contracts and recover the previously checked
existential angular-blind witness. -/
def AdmissibleAngularBlindWitness.toAngularBlind
    (w : AdmissibleAngularBlindWitness) : AngularBlindCounterexampleWitness :=
  ⟨w.Kdata, w.D, w.center, w.rho, w.hrho, w.v, w.mag, w.phi, w.r,
    w.hr, w.hr_le_rho, w.farField_pos⟩

/-- Habitability of the strong witness inherits the kernel-checked failure of
single-observable domination.  This conclusion deliberately remains distinct
from SignedCZLinearGainTarget. -/
theorem admissible_angular_blind_witness_refutes_single_oscillation_domination
    (w : AdmissibleAngularBlindWitness) :
    ∃ (Kdata : StrainKernelData) (D : SignedDirectionContraction)
      (center : Point3) (rho : ℝ) (hrho : 0 < rho)
      (v : Point3) (mag phi : ScalarField3) (r : ℝ),
        0 < r ∧ r ≤ rho ∧
        FarFieldSqAvg Kdata D center rho hrho (fun _ => v) mag phi r >
          (directionalOscillation (fun _ => v) center r) ^ 2 := by
  exact angular_blind_witness_refutes_single_oscillation_domination w.toAngularBlind

#print axioms AdmissibleAngularBlindWitness.toAngularBlind
#print axioms admissible_angular_blind_witness_refutes_single_oscillation_domination

end G1Audit
