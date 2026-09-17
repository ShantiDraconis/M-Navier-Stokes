/-
K4 MCCS-v2 scaling audit.

Purpose: close the *specification* question before any signed-CZ proof is
attempted.  This file proves only algebraic consequences of explicitly typed
scaling degrees.  It does not assume or claim that the active abstract
SignedDirectionContraction has any particular degree.

For the active far integrand
  K(x-y) * D(xi x, omega y) * mag y * phi y
under 3D NS scaling, omega contributes degree 2, dy contributes degree -3,
and squaring the resulting far integral gives the FarAvg degree.  Hence
  deg(I_far) = sK + sD - 1
  deg(FarAvg) = 2 * (sK + sD - 1).
The historical RHS ||omega||_2^2 / rho^p * (r/rho) has degree 1+p, so
  p = 2*sK + 2*sD - 3.

In particular, for a strain kernel sK=3, the historical p=3 endpoint forces
sD=0.  This is the exact blocker: the current structure stores only an
arbitrary map Point3 -> Point3 -> Real, so degree zero cannot be inferred
without a concrete definition or an explicit proved homogeneity theorem.
-/
import G1.SignedFarField

namespace G1Audit

/-- Scaling metadata is evidence only when accompanied by the corresponding
    homogeneity theorem in the concrete specialization. -/
structure K4ScalingDegrees where
  sK : ℤ
  sD : ℤ

/-- Degree of the actual far integral in the active 3D model. -/
def K4ScalingDegrees.integralDegree (q : K4ScalingDegrees) : ℤ :=
  q.sK + q.sD - 1

/-- Degree of the squared/averaged far quantity. -/
def K4ScalingDegrees.farAvgDegree (q : K4ScalingDegrees) : ℤ :=
  2 * q.integralDegree

/-- The rho exponent forced by matching the FarAvg degree against the
    historical energy scale: ||omega||_2^2 has NS degree 1 and r/rho is
    invariant. -/
def K4ScalingDegrees.requiredRhoExponent (q : K4ScalingDegrees) : ℤ :=
  2 * q.sK + 2 * q.sD - 3

/-- Master exponent identity.  This deliberately separates the kernel and
    contraction degrees; replacing it by sK + 2*sD - 3 would lose one copy of
    the kernel degree introduced by squaring FarAvg. -/
theorem master_scaling_determinant (q : K4ScalingDegrees) :
    1 + q.requiredRhoExponent = q.farAvgDegree := by
  simp [K4ScalingDegrees.requiredRhoExponent,
    K4ScalingDegrees.farAvgDegree, K4ScalingDegrees.integralDegree]
  omega

/-- For the active strain-kernel candidate (degree 3), a degree-zero
    directional contraction gives exactly the historical rho^{-3} target. -/
theorem strain_directional_gives_p3 :
    (K4ScalingDegrees.mk 3 0).requiredRhoExponent = 3 := by
  norm_num [K4ScalingDegrees.requiredRhoExponent]

/-- Conversely, once sK=3 is fixed, p=3 forces sD=0. -/
theorem p3_forces_directional_degree_zero (sD : ℤ)
    (h : (K4ScalingDegrees.mk 3 sD).requiredRhoExponent = 3) : sD = 0 := by
  simp [K4ScalingDegrees.requiredRhoExponent] at h
  omega

/-- A degree-two use of raw vorticity would force rho^{-7}, not rho^{-3}. -/
theorem strain_raw_vorticity_gives_p7 :
    (K4ScalingDegrees.mk 3 2).requiredRhoExponent = 7 := by
  norm_num [K4ScalingDegrees.requiredRhoExponent]

/-- The current abstract contraction carries no homogeneity law.  This type is
    the exact proof obligation a concrete K4 specialization must discharge;
    it is not a field of SignedDirectionContraction and therefore cannot be
    silently laundered into the endpoint. -/
def ContractDegreeZero (D : SignedDirectionContraction) : Prop :=
  ∀ (lambda : ℝ), 0 < lambda → ∀ (xi omega : Point3),
    D.contract xi (lambda • omega) = D.contract xi omega

/-- K4's historical p=3 endpoint is scientifically admissible under the
    strain-kernel scaling only after this contract has been proved for the
    concrete D. -/
def K4P3ScalingAdmissible (D : SignedDirectionContraction) : Prop :=
  ContractDegreeZero D

end G1Audit
