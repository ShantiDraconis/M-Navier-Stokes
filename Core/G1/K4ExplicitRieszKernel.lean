/-
K4 explicit physical-space kernel candidate.
This file remains inside the single K4 macro-gate.
No CZ conclusion is assumed: each analytic contract is proved locally.
-/
import G1.K4HabitabilityReduction
import Mathlib.Analysis.InnerProductSpace.NormPow

noncomputable section
open MeasureTheory Metric
open scoped RealInnerProductSpace
namespace G1Audit

/-- Fixed first Euclidean direction in R^3. -/
def k4e0 : Point3 := fun i => if i = 0 then 1 else 0

lemma k4e0_norm : ‖k4e0‖ = 1 := by
  rw [EuclideanSpace.norm_eq]
  simp [k4e0]

/-- Scalar degree -3 Riesz-type kernel K(z)=<e0,z>/||z||^4.
Division at z=0 is harmless in Lean and gives K(0)=0. -/
def rieszScalarKernel (z : Point3) : ℝ :=
  inner ℝ k4e0 z / ‖z‖ ^ 4

def rieszScalarKernelData : StrainKernelData :=
  ⟨rieszScalarKernel⟩

lemma rieszScalarKernel_zero : rieszScalarKernel 0 = 0 := by
  simp [rieszScalarKernel]

lemma rieszScalarKernel_odd (z : Point3) :
    rieszScalarKernel (-z) = -rieszScalarKernel z := by
  simp [rieszScalarKernel]

/-- Numerator estimate used by the CZ size certificate. -/
lemma rieszScalarKernel_numerator_bound (z : Point3) :
    |inner ℝ k4e0 z| ≤ ‖z‖ := by
  simpa [k4e0_norm] using (abs_real_inner_le_norm k4e0 z)

/- Pin-local primitives deliberately recorded here so CI verifies the exact
Mathlib API on which the next derivative/cancellation proofs depend. -/
#check hasFDerivAt_norm_rpow
#check abs_real_inner_le_norm
#check Measure.measurePreserving_neg
#check Homeomorph.neg
#check norm_smul
#check innerSL

#print axioms k4e0_norm
#print axioms rieszScalarKernel_zero
#print axioms rieszScalarKernel_odd
#print axioms rieszScalarKernel_numerator_bound

end G1Audit
