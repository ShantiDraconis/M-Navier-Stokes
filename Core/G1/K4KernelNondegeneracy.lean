/- 
K4 kernel nondegeneracy reduction.

This stays inside the existing K4 macro-gate. It proves that the degenerate
zero kernel can satisfy structural CZ/cancellation packaging but can never
satisfy the strict far-field positivity required by
AdmissibleAngularBlindWitness. Hence a genuine witness must use a nonzero
kernel; positivity cannot be obtained from packaging alone.

Historical source:
  commit e000acfb2a3926a7f2327290bc38ea6c3aeeb152
This revision only replaces a Lean-4.32-invalid field subst by rewriting.
-/
import G1.K4HabitabilityReduction

noncomputable section
open MeasureTheory Metric
namespace G1Audit

def zeroStrainKernelData : StrainKernelData :=
  ⟨fun _ : Point3 => (0 : ℝ)⟩

theorem signedFarIntegrand_zero_kernel
    (D : SignedDirectionContraction) (x y : Point3)
    (xi : VectorField3) (mag phi : ScalarField3) :
    signedFarIntegrand zeroStrainKernelData D x y xi mag phi = 0 := by
  simp [signedFarIntegrand, zeroStrainKernelData]

theorem farRegionIntegrand_zero_kernel
    (D : SignedDirectionContraction) (geom : FarFieldGeometry)
    (xi : VectorField3) (mag phi : ScalarField3) (y : Point3) :
    farRegionIntegrand zeroStrainKernelData D geom xi mag phi y = 0 := by
  simp [farRegionIntegrand, signedFarIntegrand, zeroStrainKernelData]

theorem signedFarFieldIntegral_zero_kernel
    (D : SignedDirectionContraction) (geom : FarFieldGeometry)
    (xi : VectorField3) (mag phi : ScalarField3) :
    signedFarFieldIntegral zeroStrainKernelData D geom xi mag phi = 0 := by
  simp [signedFarFieldIntegral, farRegionIntegrand,
    signedFarIntegrand, zeroStrainKernelData]

theorem signedFarFieldAt_zero_kernel
    (D : SignedDirectionContraction) (rho : ℝ) (hrho : 0 < rho)
    (xi : VectorField3) (mag phi : ScalarField3) (x : Point3) :
    signedFarFieldAt zeroStrainKernelData D rho hrho xi mag phi x = 0 := by
  simp [signedFarFieldAt, signedFarFieldIntegral, farRegionIntegrand,
    signedFarIntegrand, zeroStrainKernelData]

theorem localBallSqIntegral_zero_kernel
    (D : SignedDirectionContraction) (center : Point3)
    (rho : ℝ) (hrho : 0 < rho)
    (xi : VectorField3) (mag phi : ScalarField3) (r : ℝ) :
    localBallSqIntegral zeroStrainKernelData D center rho hrho xi mag phi r = 0 := by
  simp [localBallSqIntegral, signedFarFieldAt, signedFarFieldIntegral,
    farRegionIntegrand, signedFarIntegrand, zeroStrainKernelData]

theorem farFieldSqAvg_zero_kernel
    (D : SignedDirectionContraction) (center : Point3)
    (rho : ℝ) (hrho : 0 < rho)
    (xi : VectorField3) (mag phi : ScalarField3) (r : ℝ) :
    FarFieldSqAvg zeroStrainKernelData D center rho hrho xi mag phi r = 0 := by
  simp [FarFieldSqAvg, localBallSqIntegral, signedFarFieldAt,
    signedFarFieldIntegral, farRegionIntegrand, signedFarIntegrand,
    zeroStrainKernelData]

theorem no_admissible_witness_with_zero_kernel
    (w : AdmissibleAngularBlindWitness)
    (hK : w.Kdata = zeroStrainKernelData) : False := by
  have hzero :
      FarFieldSqAvg w.Kdata w.D w.center w.rho w.hrho
        (fun _ : Point3 => w.v) w.mag w.phi w.r = 0 := by
    rw [hK]
    exact farFieldSqAvg_zero_kernel w.D w.center w.rho w.hrho
      (fun _ : Point3 => w.v) w.mag w.phi w.r
  linarith [w.farField_pos]

#print axioms signedFarIntegrand_zero_kernel
#print axioms farRegionIntegrand_zero_kernel
#print axioms signedFarFieldIntegral_zero_kernel
#print axioms signedFarFieldAt_zero_kernel
#print axioms localBallSqIntegral_zero_kernel
#print axioms farFieldSqAvg_zero_kernel
#print axioms no_admissible_witness_with_zero_kernel

end G1Audit
