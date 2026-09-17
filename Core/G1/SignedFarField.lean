/-
A2.2 / K4 signed far-field analytic layer.

This file keeps the actual signed far-field integral as the primitive object.
K4 does not define an output estimate to make it true.  Instead it records the
minimal analytic contracts that a later proof must discharge.

Scientific boundary:
* kernel size/cancellation/integrability are explicit;
* the current scalar kernel model is retained for compatibility with A2.2;
* no theorem below derives the signed-CZ gain;
* no OPEN_CZ proposition is consumed as a proof.
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

/-- Signed bilinear integrand at center x against source point y. -/
def signedFarIntegrand
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (x y : Point3)
    (xi omega : VectorField3)
    (mag phi : ScalarField3) : ℝ :=
  Kdata.kernel (x - y) * D.contract (xi x) (omega y) * mag y * phi y

/-- Far-region indicator.  The cutoff radius is explicit in the definition. -/
def farRegionIntegrand
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (geom : FarFieldGeometry)
    (xi omega : VectorField3)
    (mag phi : ScalarField3)
    (y : Point3) : ℝ :=
  if geom.rho ≤ ‖y - geom.center‖ then
    signedFarIntegrand Kdata D geom.center y xi omega mag phi
  else 0

/-- Actual signed far-field integral used by the A2.2 interface. -/
def signedFarFieldIntegral
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (geom : FarFieldGeometry)
    (xi omega : VectorField3)
    (mag phi : ScalarField3) : ℝ :=
  ∫ y, farRegionIntegrand Kdata D geom xi omega mag phi y

/-! ## K4.1 -- kernel specification

The active A2.2 model currently has a scalar kernel.  We therefore state the
contracts for that scalar kernel rather than silently changing its type to a
vector or matrix kernel.  A later faithful Biot--Savart/strain specialization
may refine this representation componentwise.
-/

structure CZKernelSpec (Kdata : StrainKernelData) : Prop where
  measurable : Measurable Kdata.kernel
  Csize : ℝ
  Cgrad : ℝ
  hCsize : 0 ≤ Csize
  hCgrad : 0 ≤ Cgrad
  size_bound : ∀ z : Point3, z ≠ 0 →
    |Kdata.kernel z| ≤ Csize / ‖z‖ ^ 3
  /-- Analytic smoothness/gradient estimate.  It remains an explicit contract
      until the concrete strain kernel and its derivative are encoded. -/
  gradient_decay : Prop
  /-- Spherical/annular mean-zero cancellation for the concrete kernel. -/
  annular_mean_zero : Prop

/-! ## K4.2 -- integrability debt made explicit -/

/-- Integrability of the exact active far-region integrand.  This prevents the
Lebesgue integral's default value for non-integrable functions from being
mistaken for an analytic signed-CZ estimate. -/
def FarFieldIntegrable
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (geom : FarFieldGeometry)
    (xi omega : VectorField3)
    (mag phi : ScalarField3) : Prop :=
  Integrable (farRegionIntegrand Kdata D geom xi omega mag phi)

/-- A compact-support route is one possible sufficient input for tail control,
but compact support alone is not claimed here to prove integrability: bounds
on the remaining factors are also required. -/
structure FarFieldTailControl (phi : ScalarField3) : Prop where
  compact_support : HasCompactSupport phi

/-! ## K4.3 -- cancellation contract

A rigorous polar-coordinate subtraction theorem requires the concrete kernel,
surface measure on S^2, change-of-variables, and integrability.  Until those
are formalized, we expose the exact mathematical content that must be proved,
without making it an assumption of the A2.2 conclusion.
-/

/-- A signed cancellation witness must produce an actual equality for the
existing integral, not a Boolean/Prop marker named OPEN_CZ. -/
structure SignedCancellationWitness
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (geom : FarFieldGeometry)
    (xi omega : VectorField3)
    (mag phi : ScalarField3) : Prop where
  integrable : FarFieldIntegrable Kdata D geom xi omega mag phi
  cancelledIntegrand : Point3 → ℝ
  cancelledIntegrable : Integrable cancelledIntegrand
  cancellation_identity :
    signedFarFieldIntegral Kdata D geom xi omega mag phi =
      ∫ y, cancelledIntegrand y

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

/-- The historically recovered beta=1 endpoint, represented as a target
proposition.  No field in CZKernelSpec or SignedCancellationWitness contains
this target. -/
def SignedCZLinearGainTarget
    (farFieldSqAvg Cfar omegaL2 : ℝ)
    (s : SubcutoffScale) : Prop :=
  farFieldSqAvg ≤ Cfar * (omegaL2 ^ 2 / s.rho ^ 3) * s.ratio

end G1Audit
