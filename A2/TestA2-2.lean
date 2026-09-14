/-
A2/TestA2-2.lean

Isolated harness for issue #29 (A2.2 campanato_from_weighted).

Parent branch: a2.1-weightedIBP
Certified immutable baseline:
  SHA 79140147ba92fe290b4178f92ff7d77ec3271198
  run 34794423292 SUCCESS

Required ingredients are explicit in this file:
  * weighted IBP output;
  * signed far-field term from G1.SignedFarField;
  * cancellation/gain as a separate analytic obligation;
  * rho scaling;
  * the compiled linear Campanato closure condition.

This file does NOT promote A2 and does NOT assert unconditional NSE regularity.
-/

import G1.WeakDiffusionIBP
import G1.SignedFarField
import G1.DynamicCampanato

noncomputable section

namespace G1Audit

/-- The exact weighted-IBP target inherited from issue #28. -/
def A2WeightedIBPResult (d : WeightedDualityComponent) : Prop :=
  d.lapPair = -d.bulk - d.cutoffCross - d.weightCross

/--
Explicit signed far-field cancellation/gain obligation.  This is intentionally
separate from the Campanato conclusion: proving this field is part of A2.2,
not something that may be hidden inside the final recurrence.
-/
structure A2SignedCancellationData where
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
  hgamma_half : gamma < (1 : ℝ) / 2
  hdiff_nonneg : 0 ≤ diffusionBulk
  hgrad_nonneg : 0 ≤ gradUSq
  hJ_nonneg : 0 ≤ Jr
  cancellation :
    |farValue| ≤ gamma * nu * diffusionBulk + Ckappa * gradUSq * Jr + remainder

/--
The scale variables are visible at the type level.  `rho` is never erased into
an unnamed constant, and the linear error keeps the dimensionless ratio r/rho.
-/
structure A2RhoScalingData where
  rho : ℝ
  r : ℝ
  A : ℝ
  hrho : 0 < rho
  hr : 0 < r
  hr_le_rho : r ≤ rho
  hA : 0 ≤ A

/-- Dimensionless A2 scale ratio. -/
def A2RhoScalingData.ratio (s : A2RhoScalingData) : ℝ := s.r / s.rho

/-- The scaling ratio lies in [0,1] on the Campanato range. -/
theorem A2RhoScalingData.ratio_mem_unit_interval (s : A2RhoScalingData) :
    0 ≤ s.ratio ∧ s.ratio ≤ 1 := by
  constructor
  · exact div_nonneg (le_of_lt s.hr) (le_of_lt s.hrho)
  · exact (div_le_one s.hrho).2 s.hr_le_rho

/--
Witness that issue #29 is using the actual signed-far-field architecture from
step 24 rather than replacing it by an L-infinity surrogate.
-/
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

/--
All non-algebraic inputs required before the existing Campanato arithmetic can
be invoked.  The final recurrence is not stored as a field.
-/
structure CampanatoFromWeightedInputs where
  duality : WeightedDualityComponent
  weightedIBP : A2WeightedIBPResult duality
  signedFar : A2SignedFarFieldInput
  cancellation : A2SignedCancellationData
  scaling : A2RhoScalingData
  C : ℝ
  hC_nonneg : 0 ≤ C
  closure : LinearClosure cancellation.gamma scaling.A C

/--
Concrete target for issue #29.  This is the scale-improving recurrence that must
be proved from `CampanatoFromWeightedInputs`; it is not assumed by the input
structure.
-/
def CampanatoFromWeightedTarget
    (I : CampanatoFromWeightedInputs)
    (Jr JrHalf : ℝ) : Prop :=
  JrHalf ≤ I.cancellation.gamma * Jr + I.scaling.A * I.scaling.ratio

/--
The already-compiled arithmetic consequence of the closure condition.  This
lemma is intentionally algebraic only; the missing A2.2 work is to derive the
one-step recurrence from weighted IBP + signed cancellation + rho scaling.
-/
theorem testA2_2_closure_implies_gamma_half
    (I : CampanatoFromWeightedInputs)
    (hA_pos : 0 < I.scaling.A)
    (hC_pos : 0 < I.C) :
    I.cancellation.gamma < (1 : ℝ) / 2 := by
  exact gamma_lt_half_of_linearClosure hA_pos hC_pos I.closure

/--
Audit guard: the actual SignedFarField value remains syntactically present in
A2.2 and can be recovered without rewriting it into a different route.
-/
theorem testA2_2_signedFarField_visible (I : CampanatoFromWeightedInputs) :
    I.signedFar.value =
      signedFarField I.signedFar.Kdata I.signedFar.D I.signedFar.geom
        I.signedFar.xi I.signedFar.omega I.signedFar.mag I.signedFar.phi := by
  exact I.signedFar.hvalue

end G1Audit