/-
A2.2 successor harness: laundering-free mathematical boundary.

Scientific boundary: the missing analytic Campanato recurrence and the strict
subcritical budget are conclusions to be independently established, not raw
inputs hidden in data structures.
-/
import G1.WeakDiffusionIBP
import G1.SignedFarField
import G1.DynamicCampanato

noncomputable section

namespace G1Audit

def A2WeightedIBPResult (d : WeightedDualityComponent) : Prop :=
  d.lapPair = -d.bulk - d.cutoffCross - d.weightCross

structure A2SignedCancellationInputs where
  farValue : ℝ
  nu : ℝ
  diffusionBulk : ℝ
  Ckappa : ℝ
  gradUSq : ℝ
  Jr : ℝ
  remainder : ℝ
  gamma : ℝ
  hnu : 0 < nu
  hgamma_nonneg : 0 ≤ gamma
  hdiff_nonneg : 0 ≤ diffusionBulk
  hgrad_nonneg : 0 ≤ gradUSq
  hJ_nonneg : 0 ≤ Jr
  cancellation :
    |farValue| ≤ gamma * nu * diffusionBulk + Ckappa * gradUSq * Jr + remainder

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
  hvalue : value = signedFarField Kdata D geom xi omega mag phi

structure CampanatoProfile where
  J : ℝ → ℝ
  nonneg : ∀ r, 0 ≤ J r

structure CampanatoFromWeightedInputs where
  duality : WeightedDualityComponent
  weightedIBP : A2WeightedIBPResult duality
  signedFar : A2SignedFarFieldInput
  cancellation : A2SignedCancellationInputs
  scaling : A2RhoScalingData
  profile : CampanatoProfile
  C : ℝ
  hC_nonneg : 0 ≤ C

def CampanatoOneStep (I : CampanatoFromWeightedInputs) : Prop :=
  I.profile.J (I.scaling.r / 2) ≤
    I.cancellation.gamma * I.profile.J I.scaling.r +
      I.scaling.A * I.scaling.ratio

/-- Result object: both fields must be derived; neither is raw input data. -/
structure A2DerivedContraction (I : CampanatoFromWeightedInputs) where
  oneStep : CampanatoOneStep I
  gamma_lt_half : I.cancellation.gamma < (1 : ℝ) / 2

/-- Strict contraction requires a separately established subcritical budget. -/
theorem contraction_from_independent_budget
    (I : CampanatoFromWeightedInputs)
    (hclosure : LinearClosure I.cancellation.gamma I.scaling.A I.C)
    (hbudget : SubcriticalBudget I.cancellation.gamma I.scaling.A I.C) :
    I.cancellation.gamma < (1 : ℝ) / 2 := by
  exact gamma_lt_half_of_subcriticalBudget hclosure hbudget

theorem testA2_2_signedFarField_visible (I : CampanatoFromWeightedInputs) :
    I.signedFar.value =
      signedFarField I.signedFar.Kdata I.signedFar.D I.signedFar.geom
        I.signedFar.xi I.signedFar.omega I.signedFar.mag I.signedFar.phi := by
  exact I.signedFar.hvalue

end G1Audit
