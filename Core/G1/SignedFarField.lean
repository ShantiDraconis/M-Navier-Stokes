/-
A2.2 / K4 signed far-field analytic layer.
The endpoint remains a target: no signed-CZ conclusion is assumed.
-/
import Mathlib
import G1.XiEpsLocalizedRealization

noncomputable section
open MeasureTheory Metric
namespace G1Audit

abbrev Point3 := EuclideanSpace ℝ (Fin 3)
abbrev VectorField3 := Point3 → Point3
abbrev ScalarField3 := Point3 → ℝ

structure StrainKernelData where
  kernel : Point3 → ℝ

structure SignedDirectionContraction where
  contract : Point3 → Point3 → ℝ

structure FarFieldGeometry where
  center : Point3
  rho : ℝ
  hrho : 0 < rho

def signedFarIntegrand
    (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (x y : Point3) (xi : VectorField3) (mag phi : ScalarField3) : ℝ :=
  Kdata.kernel (x - y) * D.contract (xi x) (xi y) * mag y * phi y

def farRegionIntegrand
    (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (geom : FarFieldGeometry) (xi : VectorField3) (mag phi : ScalarField3)
    (y : Point3) : ℝ :=
  if geom.rho ≤ ‖y - geom.center‖ then
    signedFarIntegrand Kdata D geom.center y xi mag phi
  else 0

def signedFarFieldIntegral
    (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (geom : FarFieldGeometry) (xi : VectorField3) (mag phi : ScalarField3) : ℝ :=
  ∫ y, farRegionIntegrand Kdata D geom xi mag phi y

/-! FP-K4-A: typed kernel/integrability/cancellation/coherence obligations. -/
structure CZKernelSpec (Kdata : StrainKernelData) where
  measurable : Measurable Kdata.kernel
  Csize : ℝ
  Cgrad : ℝ
  hCsize : 0 ≤ Csize
  hCgrad : 0 ≤ Cgrad
  size_bound : ∀ z : Point3, z ≠ 0 → |Kdata.kernel z| ≤ Csize / ‖z‖ ^ 3
  homogeneous_degree_three : ∀ (a : ℝ), 0 < a → ∀ z : Point3,
    Kdata.kernel (a⁻¹ • z) = a ^ 3 * Kdata.kernel z
  gradKernel : Point3 → Point3
  grad_is_derivative : ∀ z : Point3, z ≠ 0 →
    HasFDerivAt Kdata.kernel (innerSL ℝ (gradKernel z)) z
  gradient_decay : ∀ z : Point3, z ≠ 0 → ‖gradKernel z‖ ≤ Cgrad / ‖z‖ ^ 4

/-- Cancellation is imposed on the actual kernel over concrete annuli, not on
an unrelated auxiliary angular function. -/
structure KernelCancellationSpec (Kdata : StrainKernelData) where
  annularIntegrable : ∀ a b : ℝ, 0 < a → a < b →
    IntegrableOn Kdata.kernel (Metric.closedBall (0 : Point3) b \ Metric.ball (0 : Point3) a)
  annular_mean_zero : ∀ a b : ℝ, 0 < a → a < b →
    ∫ z in (Metric.closedBall (0 : Point3) b \ Metric.ball (0 : Point3) a), Kdata.kernel z = 0

def FarFieldIntegrable
    (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (geom : FarFieldGeometry) (xi : VectorField3) (mag phi : ScalarField3) : Prop :=
  Integrable (farRegionIntegrand Kdata D geom xi mag phi)

structure FarFieldTailControl (phi : ScalarField3) : Prop where
  compact_support : HasCompactSupport phi

structure SignedCancellationWitness
    (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (geom : FarFieldGeometry) (xi : VectorField3) (mag phi : ScalarField3) where
  integrable : FarFieldIntegrable Kdata D geom xi mag phi
  cancelledIntegrand : Point3 → ℝ
  cancelledIntegrable : Integrable cancelledIntegrand
  cancellation_identity :
    signedFarFieldIntegral Kdata D geom xi mag phi = ∫ y, cancelledIntegrand y

def MagnitudeScalingDegreeOne
    (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (x y : Point3) (xi : VectorField3) (mag phi : ScalarField3) : Prop :=
  ∀ (a : ℝ),
    signedFarIntegrand Kdata D x y xi (fun z => a * mag z) phi =
      a * signedFarIntegrand Kdata D x y xi mag phi

theorem signedFarIntegrand_magnitude_degree_one
    (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (x y : Point3) (xi : VectorField3) (mag phi : ScalarField3) :
    MagnitudeScalingDegreeOne Kdata D x y xi mag phi := by
  intro a
  simp [signedFarIntegrand]
  ring

/-! FP-K4-B: actual ball normalization and endpoint bookkeeping. -/
def signedFarFieldAt
    (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (rho : ℝ) (hrho : 0 < rho) (xi : VectorField3) (mag phi : ScalarField3)
    (x : Point3) : ℝ :=
  signedFarFieldIntegral Kdata D ⟨x, rho, hrho⟩ xi mag phi

def localBallSqIntegral
    (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (center : Point3) (rho : ℝ) (hrho : 0 < rho)
    (xi : VectorField3) (mag phi : ScalarField3) (r : ℝ) : ℝ :=
  ∫ x, if ‖x - center‖ ≤ r then
    (signedFarFieldAt Kdata D rho hrho xi mag phi x) ^ 2
  else 0

def FarFieldSqAvg
    (Kdata : StrainKernelData) (D : SignedDirectionContraction)
    (center : Point3) (rho : ℝ) (hrho : 0 < rho)
    (xi : VectorField3) (mag phi : ScalarField3) (r : ℝ) : ℝ :=
  localBallSqIntegral Kdata D center rho hrho xi mag phi r / ballVolume r center

def directionalOscillation (xi : VectorField3) (x : Point3) (r : ℝ) : ℝ :=
  ∫ y in Metric.ball x r, ‖xi y - xi x‖

structure DirectionalCoherenceEstimate (xi : VectorField3) where
  Cdir : ℝ
  hCdir : 0 ≤ Cdir
  bound : ∀ (x : Point3) (r J : ℝ), 0 ≤ r → 0 ≤ J →
    directionalOscillation xi x r ≤ Cdir * r * Real.sqrt J

structure DyadicFarEstimate (shellContribution : ℕ → ℝ) where
  Cdyadic : ℝ
  hCdyadic : 0 ≤ Cdyadic
  hshell_nonneg : ∀ j, 0 ≤ shellContribution j
  shellSummable : Summable shellContribution
  total_bound : ∑' j, shellContribution j ≤ Cdyadic

structure UniformFarConstant where
  Cfar : ℝ
  hCfar : 0 ≤ Cfar

structure SubcutoffScale where
  r : ℝ
  rho : ℝ
  hr : 0 ≤ r
  hrho : 0 < rho
  hr_le_rho : r ≤ rho

def SubcutoffScale.ratio (s : SubcutoffScale) : ℝ := s.r / s.rho

theorem SubcutoffScale.ratio_nonneg (s : SubcutoffScale) : 0 ≤ s.ratio := by
  exact div_nonneg s.hr s.hrho.le

theorem SubcutoffScale.ratio_le_one (s : SubcutoffScale) : s.ratio ≤ 1 := by
  exact (div_le_one s.hrho).2 s.hr_le_rho

def SignedCZLinearGainTarget
    (farFieldSqAvg Cfar omegaL2 : ℝ) (s : SubcutoffScale) : Prop :=
  farFieldSqAvg ≤ Cfar * (omegaL2 ^ 2 / s.rho ^ 3) * s.ratio

end G1Audit
