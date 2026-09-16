/-
Minimal A2.1 API reconstruction from frozen source
navier-stokes-critical-barrier-audit@79140147ba92fe290b4178f92ff7d77ec3271198
source full-file blob 6404c72eb6f2e41d850bce8d542610b254f33105.
This file intentionally exposes only definitions consumed by TestA2-1; it is
NOT claimed byte-identical to the historical full module and proves no new
analytic statement.
-/
import G1.XiEpsPDE
import Mathlib
noncomputable section
open MeasureTheory Metric
namespace G1Audit
def spatialIntegralScalar (f : ScalarField) : ℝ := ∫ x, f x ∂(volume : Measure Vec3)
def spatialIntegralVector (f : VectorField) : Vec3 := ∫ x, f x ∂(volume : Measure Vec3)
def bochnerPair (v w : VectorField) : ℝ := spatialIntegralScalar (fun x => inner ℝ (v x) (w x))
def ballVolume (r : ℝ) (c : Vec3) : ℝ := (volume (Metric.ball c r)).toReal
def ballIntegralVector (r : ℝ) (c : Vec3) (f : VectorField) : Vec3 := ∫ x in Metric.ball c r, f x ∂(volume : Measure Vec3)
def avgBallVector (r : ℝ) (c : Vec3) (f : VectorField) : Vec3 := (ballVolume r c)⁻¹ • ballIntegralVector r c f
end G1Audit
