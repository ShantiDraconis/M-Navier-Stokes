/-
A2.2 signed far-field analytic interface.

This successor replaces the earlier pointwise reconstruction scaffold.  The
far contribution is now an actual integral over the region outside rho.  No
cancellation estimate, integrability claim, Campanato recurrence, or
Navier--Stokes regularity theorem is assumed here.
-/
import Mathlib

noncomputable section

namespace G1Audit

abbrev VectorField3 := EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)
abbrev ScalarField3 := EuclideanSpace ℝ (Fin 3) → ℝ

structure StrainKernelData where
  kernel : EuclideanSpace ℝ (Fin 3) → ℝ

structure SignedDirectionContraction where
  contract : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3) → ℝ

structure FarFieldGeometry where
  center : EuclideanSpace ℝ (Fin 3)
  rho : ℝ
  hrho : 0 < rho

/-- Signed bilinear integrand at center x against source point y. -/
def signedFarIntegrand
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (x y : EuclideanSpace ℝ (Fin 3))
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
    (y : EuclideanSpace ℝ (Fin 3)) : ℝ :=
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

end G1Audit
