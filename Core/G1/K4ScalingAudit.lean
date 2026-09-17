/-
K4 MCCS-v2 scaling audit.

Purpose: close the *specification* question before any signed-CZ proof is
attempted. This file proves only algebraic consequences of explicitly typed
scaling degrees. It does not assume or claim that the active abstract
SignedDirectionContraction has any particular degree.

For the active far integrand
  K(x-y) * D(xi x, xi y) * mag y * phi y
under 3D NS scaling, the explicit magnitude contributes degree 2, dy degree
-3, while xi is a dimensionless direction field. If the concrete kernel and
directional contraction have physical scaling degrees sK and sD, then
  deg(I_far) = sK + sD - 1
  deg(FarAvg) = 2 * (sK + sD - 1).
The historical RHS ||omega||_2^2 / rho^p * (r/rho) has degree 1+p, so
  p = 2*sK + 2*sD - 3.

For a strain kernel sK=3, the historical p=3 endpoint therefore requires
sD=0. For the active directional model this is a requirement on the physical
scaling action: xi must be invariant under NS scaling and the concrete
contraction must depend only on such directions. It is NOT the old statement
D xi (lambda • omega) = D xi omega, which incorrectly scales a direction
argument as raw vorticity.
-/
import G1.SignedFarField

namespace G1Audit

structure K4ScalingDegrees where
  sK : ℤ
  sD : ℤ

def K4ScalingDegrees.integralDegree (q : K4ScalingDegrees) : ℤ :=
  q.sK + q.sD - 1

def K4ScalingDegrees.farAvgDegree (q : K4ScalingDegrees) : ℤ :=
  2 * q.integralDegree

def K4ScalingDegrees.requiredRhoExponent (q : K4ScalingDegrees) : ℤ :=
  2 * q.sK + 2 * q.sD - 3

theorem master_scaling_determinant (q : K4ScalingDegrees) :
    1 + q.requiredRhoExponent = q.farAvgDegree := by
  simp [K4ScalingDegrees.requiredRhoExponent,
    K4ScalingDegrees.farAvgDegree, K4ScalingDegrees.integralDegree]
  omega

theorem strain_directional_gives_p3 :
    (K4ScalingDegrees.mk 3 0).requiredRhoExponent = 3 := by
  norm_num [K4ScalingDegrees.requiredRhoExponent]

theorem p3_forces_directional_degree_zero (sD : ℤ)
    (h : (K4ScalingDegrees.mk 3 sD).requiredRhoExponent = 3) : sD = 0 := by
  simp [K4ScalingDegrees.requiredRhoExponent] at h
  omega

theorem strain_raw_vorticity_gives_p7 :
    (K4ScalingDegrees.mk 3 2).requiredRhoExponent = 7 := by
  norm_num [K4ScalingDegrees.requiredRhoExponent]

/-- Physical NS scaling data for the dimensionless direction field.  The
caller must provide the actual scaled direction field; no scaling law is
smuggled into `SignedDirectionContraction`. -/
structure DirectionScalingWitness (xi scaledXi : VectorField3) where
  invariant : scaledXi = xi

/-- Degree-zero admissibility for the active D(xi x, xi y) model follows from
invariance of both direction arguments under the supplied physical scaling.
This is intentionally an equality at the actual arguments, not a false
homogeneity law in a raw-vorticity slot. -/
def ContractDegreeZeroAt
    (D : SignedDirectionContraction) (xi scaledXi : VectorField3) : Prop :=
  ∀ x y : Point3,
    D.contract (scaledXi x) (scaledXi y) = D.contract (xi x) (xi y)

theorem contract_degree_zero_of_direction_invariant
    (D : SignedDirectionContraction) (xi scaledXi : VectorField3)
    (hscale : DirectionScalingWitness xi scaledXi) :
    ContractDegreeZeroAt D xi scaledXi := by
  intro x y
  rw [hscale.invariant]

/-- K4 p=3 scaling admissibility is now tied to an explicit physical scaling
witness rather than an unsupported rescaling of a direction argument. -/
def K4P3ScalingAdmissible
    (D : SignedDirectionContraction) (xi scaledXi : VectorField3) : Prop :=
  DirectionScalingWitness xi scaledXi ∧ ContractDegreeZeroAt D xi scaledXi

end G1Audit
