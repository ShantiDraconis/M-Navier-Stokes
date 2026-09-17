/-
A2.2 reconstruction: signed far-field vocabulary.

Provenance:
  origin: reconstructed
  date: 2026-09-17
  branch: next/a2-2
  historical search: no implementation of G1.SignedFarField was recovered
  from the accessible ShantiDraconis GitHub corpus before this reconstruction.

Audit boundary:
  This module introduces only types and a transparent definition. It proves no
  cancellation estimate, no Campanato recurrence, and no Navier--Stokes
  regularity statement. In particular, no analytic bridge is stored as a
  structure field.
-/
import Mathlib

noncomputable section

namespace G1Audit

abbrev VectorField3 := EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)
abbrev ScalarField3 := EuclideanSpace ℝ (Fin 3) → ℝ

/-- Kernel data kept explicit so later analytic estimates cannot hide constants. -/
structure StrainKernelData where
  kernel : EuclideanSpace ℝ (Fin 3) → ℝ

/-- Signed direction contraction used by the far-field integrand. -/
structure SignedDirectionContraction where
  contract : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3) → ℝ

/-- Geometric parameters of the near/far split. -/
structure FarFieldGeometry where
  center : EuclideanSpace ℝ (Fin 3)
  rho : ℝ
  hrho : 0 < rho

/--
Transparent pointwise signed far-field model.  Integration and the analytic
estimate are deliberately not encoded here; those are separate A2.2 burdens.
-/
def signedFarField
    (Kdata : StrainKernelData)
    (D : SignedDirectionContraction)
    (geom : FarFieldGeometry)
    (xi omega : VectorField3)
    (mag phi : ScalarField3) : ℝ :=
  Kdata.kernel geom.center *
    D.contract (xi geom.center) (omega geom.center) *
    mag geom.center * phi geom.center

end G1Audit
