/-
A2.2 successor harness after fixing the signed far-field integral interface.

Predecessor frozen boundary:
  82799845504653252e2a688ffd917aa9822485e1

Scientific boundary: CampanatoOneStep and SubcriticalBudget remain separate
open obligations.  Neither is stored in raw input data.
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
  omega : VectorField3
  mag : ScalarField3
  phi : ScalarField3
  value : ℝ
  hvalue : value = signedFarFieldIntegral Kdata D geom xi omega mag phi

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
  hC_nonneg : 0 ≤ C
  signedCancellation :
    |signedFar.value| ≤
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

/-- Conditional algebra only: this does not establish SubcriticalBudget. -/
theorem contraction_from_independent_budget
    (I : CampanatoFromWeightedInputs)
    (hclosure : LinearClosure I.cancellationData.gamma I.scaling.A I.C)
    (hbudget : SubcriticalBudget I.cancellationData.gamma I.scaling.A I.C) :
    I.cancellationData.gamma < (1 : ℝ) / 2 := by
  exact gamma_lt_half_of_subcriticalBudget hclosure hbudget

/-- Reproved after the pointwise scaffold was replaced by the integral object. -/
theorem testA2_2_signedFarField_visible (I : CampanatoFromWeightedInputs) :
    I.signedFar.value =
      signedFarFieldIntegral I.signedFar.Kdata I.signedFar.D I.signedFar.geom
        I.signedFar.xi I.signedFar.omega I.signedFar.mag I.signedFar.phi := by
  exact I.signedFar.hvalue

#print A2RhoScalingData.ratio
#print CampanatoOneStep
#print LinearClosure
#print SubcriticalBudget
#print gamma_lt_half_of_subcriticalBudget
#print contraction_from_independent_budget

end G1Audit
