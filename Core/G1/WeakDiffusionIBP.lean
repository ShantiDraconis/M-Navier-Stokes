/-
Semantic reconstruction from frozen source 79140147ba92fe290b4178f92ff7d77ec3271198
source blob 1f8e6dad0ba6a77bceb08be7ac2de5a9ded5d98e.
Open analytic obligations remain explicit; no proof-gap construct added.
-/
import G1.WeakDerivBridge
import G1.VectorLocalRep
import G1.XiEpsPDE
noncomputable section
namespace G1Audit
theorem magEps_sq (omega : VectorField) (eps : ℝ) (x : Vec3) : (magEps omega eps x) ^ 2 = ‖omega x‖ ^ 2 + eps ^ 2 := by
  unfold magEps
  rw [Real.sq_sqrt]
  positivity
theorem norm_le_magEps (omega : VectorField) (eps : ℝ) (x : Vec3) : ‖omega x‖ ≤ magEps omega eps x := by
  have hs := magEps_sq omega eps x
  have hm := magEps_nonneg omega eps x
  have hn : 0 ≤ ‖omega x‖ := norm_nonneg _
  nlinarith [sq_nonneg eps]
theorem xiEps_norm_le_one (omega : VectorField) (eps : ℝ) (heps : 0 < eps) (x : Vec3) : ‖xiEps omega eps x‖ ≤ 1 := by
  have hmpos : 0 < magEps omega eps x := magEps_pos omega eps heps x
  have hdom : ‖omega x‖ ≤ magEps omega eps x := norm_le_magEps omega eps x
  calc
    ‖xiEps omega eps x‖ = (magEps omega eps x)⁻¹ * ‖omega x‖ := by simp [xiEps, norm_smul, Real.norm_eq_abs, abs_of_pos hmpos]
    _ ≤ (magEps omega eps x)⁻¹ * magEps omega eps x := by exact mul_le_mul_of_nonneg_left hdom (inv_nonneg.mpr (le_of_lt hmpos))
    _ = 1 := by exact inv_mul_cancel₀ (ne_of_gt hmpos)
theorem xiEps_sub_mean_norm_le_two (omega : VectorField) (eps : ℝ) (heps : 0 < eps) (m : Vec3) (hm : ‖m‖ ≤ 1) (x : Vec3) : ‖xiEps omega eps x - m‖ ≤ 2 := by
  calc
    ‖xiEps omega eps x - m‖ ≤ ‖xiEps omega eps x‖ + ‖m‖ := norm_sub_le _ _
    _ ≤ 1 + 1 := add_le_add (xiEps_norm_le_one omega eps heps x) hm
    _ = 2 := by norm_num
structure EtaStructuralSobolevData where
  mean : Vec3
  meanNormLeOne : ‖mean‖ ≤ 1
  gradOmegaL2Loc : Prop
  gradMagL2Loc : Prop
  weightedGradXiL2Loc : Prop
  weakMagChainRule : Prop
  weightedXiGradientIdentity : Prop
structure EtaGradientDecomposition where
  cutoffTermL2 : Prop
  magnitudeTermL2 : Prop
  weightedXiTermL2 : Prop
  compactSupport : Prop
  weakGradientIdentity : Prop
inductive EtaAdmissibilityRouteStatus
  | xiBoundProved | oscillationBoundFromMeanBoundProved | meanBoundBochnerJensenOpen | weakMagnitudeChainRuleOpen | weightedXiGradientIdentityOpen | threeTermGradientL2TargetIsolated | compactSupportToH10Open
  deriving DecidableEq, Repr
structure WeightedDualityComponent where
  lapPair : ℝ
  bulk : ℝ
  cutoffCross : ℝ
  weightCross : ℝ
structure WeightedDualityInterface (d : WeightedDualityComponent) where
  testAdmissible : Prop
  greenIdentity : d.lapPair = -(d.bulk + d.cutoffCross + d.weightCross)
  productRuleExpansion : Prop
theorem weightedIBP_component (d : WeightedDualityComponent) (h : WeightedDualityInterface d) : d.lapPair = -d.bulk - d.cutoffCross - d.weightCross := by
  calc
    d.lapPair = -(d.bulk + d.cutoffCross + d.weightCross) := h.greenIdentity
    _ = -d.bulk - d.cutoffCross - d.weightCross := by ring
structure WeightedDualityVector where component : Fin 3 → WeightedDualityComponent
structure WeightedDualityVectorInterface (d : WeightedDualityVector) where componentInterface : ∀ i, WeightedDualityInterface (d.component i)
theorem weightedIBP_vector_component (d : WeightedDualityVector) (h : WeightedDualityVectorInterface d) (i : Fin 3) : (d.component i).lapPair = -(d.component i).bulk - (d.component i).cutoffCross - (d.component i).weightCross := weightedIBP_component (d.component i) (h.componentInterface i)
inductive WeightConventionStatus | directGradientWeightCorrect | logarithmicFormRequiresOutsideMagnitude | extraMagnitudeDenominatorForbidden deriving DecidableEq, Repr
inductive WeakDiffusionDualityStatus | hminusOneH10ArchitectureFormalized | firstDerivativeL2Available | structuralEtaRouteFormalized | testAdmissibilityOpen | weightedProductRuleOpen | greenFormulaOpen | weakIBPNotPromoted deriving DecidableEq, Repr
end G1Audit
