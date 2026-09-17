/-
A2.2 successor harness with the recovered historical dyadic barrier condition.

Mechanical predecessor frozen at:
  7c6e4f0e00275225aed9a1c16ff63c0a98e8b1e6

Scientific boundary: CampanatoOneStep and BarrierPreservation remain separate
open analytic obligations. Neither is stored as a raw conclusion field.
-/
import G1.WeakDiffusionIBP
import G1.SignedFarField
import G1.DynamicCampanato

noncomputable section
namespace G1Audit

def A2WeightedIBPResult (d : WeightedDualityComponent) : Prop :=
  d.lapPair = -d.bulk - d.cutoffCross - d.weightCross

structure A2SignedCancellationData where
  nu : ℝ
  diffusionBulk : ℝ
  Ckappa : ℝ
  gradUSq : ℝ
  remainder : ℝ
  gamma : ℝ
  hnu : 0 < nu
  hgamma_nonneg : 0 ≤ gamma
  hdiff_nonneg : 0 ≤ diffusionBulk
  hgrad_nonneg : 0 ≤ gradUSq

structure A2RhoScalingData where
  rho : ℝ
  r : ℝ
  A : ℝ
  hrho : 0 < rho
  hr : 0 < r
  hr_le_rho : r ≤ rho
  hA : 0 ≤ A

def A2RhoScalingData.ratio (s : A2RhoScalingData) : ℝ := s.r / s.rho

theorem A2RhoScalingData.ratio_mem_unit_interval (s : A2RhoScalingData) :
    0 ≤ s.ratio ∧ s.ratio ≤ 1 := by
  constructor
  · exact div_nonneg (le_of_lt s.hr) (le_of_lt s.hrho)
  · exact (div_le_one s.hrho).2 s.hr_le_rho

structure A2SignedFarFieldInput where
  Kdata : StrainKernelData
  D : SignedDirectionContraction
  geom : FarFieldGeometry
  xi : VectorField3
  mag : ScalarField3
  phi : ScalarField3

structure CampanatoProfile where
  J : ℝ → ℝ
  nonneg : ∀ r, 0 ≤ J r

structure CampanatoFromWeightedInputs where
  duality : WeightedDualityComponent
  weightedIBP : A2WeightedIBPResult duality
  signedFar : A2SignedFarFieldInput
  cancellationData : A2SignedCancellationData
  scaling : A2RhoScalingData
  profile : CampanatoProfile
  C : ℝ
  hC_pos : 0 < C
  signedCancellation :
    |signedFarFieldIntegral signedFar.Kdata signedFar.D signedFar.geom
        signedFar.xi signedFar.mag signedFar.phi| ≤
      cancellationData.gamma * cancellationData.nu * cancellationData.diffusionBulk +
      cancellationData.Ckappa * cancellationData.gradUSq * profile.J scaling.r +
      cancellationData.remainder

def CampanatoOneStep (I : CampanatoFromWeightedInputs) : Prop :=
  I.profile.J (I.scaling.r / 2) ≤
    I.cancellationData.gamma * I.profile.J I.scaling.r +
      I.scaling.A * I.scaling.ratio

structure A2DerivedContraction (I : CampanatoFromWeightedInputs) where
  oneStep : CampanatoOneStep I
  gamma_lt_half : I.cancellationData.gamma < (1 : ℝ) / 2

/-- Conditional algebra only. BarrierPreservation must be derived independently
    from the analytic estimates; it is not stored in CampanatoFromWeightedInputs. -/
theorem contraction_from_barrier_preservation
    (I : CampanatoFromWeightedInputs)
    (hApos : 0 < I.scaling.A)
    (hbudget : BarrierPreservation I.cancellationData.gamma I.scaling.A I.C) :
    I.cancellationData.gamma < (1 : ℝ) / 2 := by
  exact gamma_lt_half_of_barrier I.hC_pos hApos hbudget

#print A2RhoScalingData.ratio
#print signedFarIntegrand
#print farRegionIntegrand
#print signedFarFieldIntegral
#print CampanatoOneStep
#print LinearClosure
#print BarrierPreservation
#print coefficient_half_of_barrier
#print gamma_lt_half_of_barrier
#print contraction_from_barrier_preservation

end G1Audit
