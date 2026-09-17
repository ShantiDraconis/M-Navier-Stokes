/-
K4 habitability reduction after the frozen wiring certificate
49ed2ca1b52e7e99805ade73ab79538e338552f9.

This remains inside the single K4 macro-gate.  It does not assert existence of
an admissible angular-blind witness.  It mechanically identifies which current
contracts are genuine obstructions and which are only packaging.
-/
import G1.AdmissibleAngularBlindWitness

noncomputable section
open MeasureTheory Metric
namespace G1Audit

/-- `SignedCancellationWitness` adds no obstruction beyond integrability in its
current formalization: the original far-region integrand itself is a valid
cancelled integrand. -/
theorem signedCancellationWitness_of_integrable
    (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (geom : FarFieldGeometry) (xi : VectorField3) (mag phi : ScalarField3)
    (hInt : FarFieldIntegrable Kdata D geom xi mag phi) :
    SignedCancellationWitness Kdata D geom xi mag phi := by
  refine ⟨hInt, farRegionIntegrand Kdata D geom xi mag phi, hInt, ?_⟩
  rfl

/-- The zero cutoff has compact support, so `FarFieldTailControl` is inhabited
independently of the kernel and direction data.  This does not help positivity,
because using this particular cutoff annihilates the far field. -/
theorem zero_tail_control : FarFieldTailControl (fun _ : Point3 => (0 : ℝ)) := by
  constructor
  simpa using (hasCompactSupport_zero : HasCompactSupport (fun _ : Point3 => (0 : ℝ)))

/-- Exact reduction of strong angular-blind habitability.  Once the kernel
contracts, compact tail, far-field integrability and strict positivity are
supplied, the current signed-cancellation contract is automatic. -/
theorem admissibleAngularBlindWitness_of_core_obligations
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
