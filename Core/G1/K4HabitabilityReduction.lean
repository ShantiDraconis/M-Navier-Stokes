/- 
K4 habitability reduction after the frozen wiring certificate
49ed2ca1b52e7e99805ade73ab79538e338552f9.

This remains inside the single K4 macro-gate. It does not assert existence of
an admissible angular-blind witness. It mechanically identifies which current
contracts are genuine obstructions and which are only packaging.

Historical pre-edit blob:
  c0ac086af7be9616c822bd85395870a509951990
-/
import G1.AdmissibleAngularBlindWitness

noncomputable section
open MeasureTheory Metric
namespace G1Audit

/-- The current SignedCancellationWitness structure adds no mathematical
obstruction beyond the integrability premise: using the original integrand as
the cancelled integrand inhabits the structure. Since the codomain is Type,
this is a definition, not a theorem declaration. -/
def signedCancellationWitness_of_integrable
    (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (geom : FarFieldGeometry) (xi : VectorField3) (mag phi : ScalarField3)
    (hInt : FarFieldIntegrable Kdata D geom xi mag phi) :
    SignedCancellationWitness Kdata D geom xi mag phi := by
  refine ⟨hInt, farRegionIntegrand Kdata D geom xi mag phi, hInt, ?_⟩
  rfl

/-- The zero cutoff has compact support. This is a packaging fact only; that
cutoff annihilates the far field and cannot prove strict positivity. -/
theorem zero_tail_control :
    FarFieldTailControl (fun _ : Point3 => (0 : ℝ)) := by
  exact ⟨HasCompactSupport.zero⟩

/-- Exact construction of the witness object once every genuine core
obligation, including strict positivity, is supplied. The codomain is Type, so
this is a definition exposing construction, not a proposition-valued theorem. -/
def admissibleAngularBlindWitness_of_core_obligations
    (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (center : Point3) (rho : ℝ) (hrho : 0 < rho)
    (v : Point3) (mag : ScalarField3) (phi : ScalarField3)
    (r : ℝ) (hr : 0 < r) (hr_le_rho : r ≤ rho)
    (hCZ : CZKernelSpec Kdata)
    (hCancel : KernelCancellationSpec Kdata)
    (hTail : FarFieldTailControl phi)
    (hInt : FarFieldIntegrable Kdata D ⟨center, rho, hrho⟩
      (fun _ : Point3 => v) mag phi)
    (hPos : 0 < FarFieldSqAvg Kdata D center rho hrho
      (fun _ : Point3 => v) mag phi r) :
    AdmissibleAngularBlindWitness := by
  exact {
    Kdata := Kdata
    D := D
    center := center
    rho := rho
    hrho := hrho
    v := v
    mag := mag
    phi := phi
    r := r
    hr := hr
    hr_le_rho := hr_le_rho
    czKernel := hCZ
    cancellation := hCancel
    tail := hTail
    signed := signedCancellationWitness_of_integrable Kdata D
      ⟨center, rho, hrho⟩ (fun _ : Point3 => v) mag phi hInt
    farField_pos := hPos
  }

#print axioms signedCancellationWitness_of_integrable
#print axioms zero_tail_control
#print axioms admissibleAngularBlindWitness_of_core_obligations

end G1Audit
