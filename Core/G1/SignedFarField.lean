/-
A2.2 / K4 signed far-field analytic layer.

The primitive object is the actual signed far-field integral.  This file does
not assume the desired signed-CZ estimate.  K4's physical directional model is
made explicit: magnitude is carried by `mag`, while the contraction consumes
directions `xi x` and `xi y`.  This removes the previous double-counting risk
where raw `omega y` entered both the contraction and `mag y`.
-/
import Mathlib

noncomputable section

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

/-- Signed directional integrand. `mag` carries vorticity magnitude, while
`D` consumes direction data. -/
def signedFarIntegrand
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (x y : Point3)
    (xi : VectorField3)
    (mag phi : ScalarField3) : ℝ :=
  Kdata.kernel (x - y) * D.contract (xi x) (xi y) * mag y * phi y

/-- Far-region indicator with explicit cutoff radius. -/
def farRegionIntegrand
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (geom : FarFieldGeometry)
    (xi : VectorField3)
    (mag phi : ScalarField3)
    (y : Point3) : ℝ :=
  if geom.rho ≤ ‖y - geom.center‖ then
    signedFarIntegrand Kdata D geom.center y xi mag phi
  else 0

/-- Actual signed far-field integral used by A2.2. -/
def signedFarFieldIntegral
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (geom : FarFieldGeometry)
    (xi : VectorField3)
    (mag phi : ScalarField3) : ℝ :=
  ∫ y, farRegionIntegrand Kdata D geom xi mag phi y

/-! ## K4.1 -- scalar strain-kernel specification -/

structure CZKernelSpec (Kdata : StrainKernelData) : Prop where
  measurable : Measurable Kdata.kernel
  Csize : ℝ
  Cgrad : ℝ
  hCsize : 0 ≤ Csize
  hCgrad : 0 ≤ Cgrad
  size_bound : ∀ z : Point3, z ≠ 0 →
    |Kdata.kernel z| ≤ Csize / ‖z‖ ^ 3
  /-- Typed homogeneity contract for a concrete scalar strain-kernel component. -/
  homogeneous_degree_three : ∀ (a : ℝ), 0 < a → ∀ z : Point3,
    Kdata.kernel (a⁻¹ • z) = a ^ 3 * Kdata.kernel z
  /-- Smoothness/gradient estimate remains an explicit analytic debt until the
      concrete strain kernel derivative is encoded. -/
  gradient_decay : Prop
  /-- Spherical/annular mean-zero remains an explicit analytic debt. -/
  annular_mean_zero : Prop

/-! ## K4.2 -- exact integrability debt -/

def FarFieldIntegrable
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (geom : FarFieldGeometry)
    (xi : VectorField3)
    (mag phi : ScalarField3) : Prop :=
  Integrable (farRegionIntegrand Kdata D geom xi mag phi)

structure FarFieldTailControl (phi : ScalarField3) : Prop where
  compact_support : HasCompactSupport phi

/-! ## K4.3 -- cancellation witness, never an OPEN_CZ marker -/

structure SignedCancellationWitness
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (geom : FarFieldGeometry)
    (xi : VectorField3)
    (mag phi : ScalarField3) : Prop where
  integrable : FarFieldIntegrable Kdata D geom xi mag phi
  cancelledIntegrand : Point3 → ℝ
  cancelledIntegrable : Integrable cancelledIntegrand
  cancellation_identity :
    signedFarFieldIntegral Kdata D geom xi mag phi =
      ∫ y, cancelledIntegrand y

/-! ## Scaling firewall

`SignedDirectionContraction` is now applied only to direction fields.  To audit
raw-vorticity scaling without assuming any special algebraic law for `D`, we
hold `xi` fixed and scale only the independent magnitude field.  The exact
integrand is then homogeneous of degree one in that magnitude.  In particular,
there is no hidden second factor of raw vorticity inside `D.contract`.
-/

def MagnitudeScalingDegreeOne
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (x y : Point3)
    (xi : VectorField3)
    (mag phi : ScalarField3) : Prop :=
  ∀ (a : ℝ),
    signedFarIntegrand Kdata D x y xi (fun z => a * mag z) phi =
      a * signedFarIntegrand Kdata D x y xi mag phi

theorem signedFarIntegrand_magnitude_degree_one
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (x y : Point3)
    (xi : VectorField3)
    (mag phi : ScalarField3) :
    MagnitudeScalingDegreeOne Kdata D x y xi mag phi := by
  intro a
  simp [signedFarIntegrand]
  ring

/-- The sub-cutoff scale regime required by the desired linear gain. -/
structure SubcutoffScale where
  r rho : ℝ
  hr : 0 ≤ r
  hrho : 0 < rho
  hr_le_rho : r ≤ rho

def SubcutoffScale.ratio (s : SubcutoffScale) : ℝ := s.r / s.rho

theorem SubcutoffScale.ratio_nonneg (s : SubcutoffScale) : 0 ≤ s.ratio := by
  exact div_nonneg s.hr s.hrho.le

theorem SubcutoffScale.ratio_le_one (s : SubcutoffScale) : s.ratio ≤ 1 := by
  exact (div_le_one s.hrho).2 s.hr_le_rho

/-! ## K4 endpoint target -- deliberately not a theorem -/

def SignedCZLinearGainTarget
    (farFieldSqAvg Cfar omegaL2 : ℝ)
    (s : SubcutoffScale) : Prop :=
  farFieldSqAvg ≤ Cfar * (omegaL2 ^ 2 / s.rho ^ 3) * s.ratio

end G1Audit
