/-
Recovered verbatim from navier-stokes-critical-barrier-audit
source commit 79140147ba92fe290b4178f92ff7d77ec3271198
source blob b2285ef0a550c601757525b232e8985111f69140
-/
import Mathlib.Analysis.Distribution.Sobolev
import Mathlib.Analysis.InnerProductSpace.PiL2
noncomputable section
open TemperedDistribution
open scoped SchwartzMap Real Laplacian LineDeriv BigOperators
namespace G1Audit
abbrev Vec3 := EuclideanSpace ℝ (Fin 3)
abbrev SpaceTime := EuclideanSpace ℝ (Fin 4)
abbrev ScalarDist := 𝓢'(SpaceTime, ℂ)
def timeDirection : SpaceTime := EuclideanSpace.single (0 : Fin 4) 1
def spatialDirection (k : Fin 3) : SpaceTime := EuclideanSpace.single k.succ 1
structure WeakXiSpaceTime where
  xiDist : Fin 3 → ScalarDist
  hXiH1 : ∀ i, MemSobolev 1 2 (xiDist i)
def WeakXiSpaceTime.dtDist (h : WeakXiSpaceTime) (i : Fin 3) : ScalarDist := ∂_{timeDirection} (h.xiDist i)
def WeakXiSpaceTime.dxDist (h : WeakXiSpaceTime) (i k : Fin 3) : ScalarDist := ∂_{spatialDirection k} (h.xiDist i)
def WeakXiSpaceTime.spatialLapDist (h : WeakXiSpaceTime) (i : Fin 3) : ScalarDist := ∑ k : Fin 3, ∂_{spatialDirection k} (∂_{spatialDirection k} (h.xiDist i))
theorem WeakXiSpaceTime.memSobolev_one_two (h : WeakXiSpaceTime) (i : Fin 3) : MemSobolev 1 2 (h.xiDist i) := h.hXiH1 i
theorem WeakXiSpaceTime.lineDeriv_memSobolev_zero (h : WeakXiSpaceTime) (i : Fin 3) (m : SpaceTime) : MemSobolev 0 2 (∂_{m} (h.xiDist i)) := by simpa using (h.hXiH1 i).lineDerivOp (m := m)
theorem WeakXiSpaceTime.dt_memSobolev_zero (h : WeakXiSpaceTime) (i : Fin 3) : MemSobolev 0 2 (h.dtDist i) := by exact h.lineDeriv_memSobolev_zero i timeDirection
theorem WeakXiSpaceTime.dx_memSobolev_zero (h : WeakXiSpaceTime) (i k : Fin 3) : MemSobolev 0 2 (h.dxDist i k) := by exact h.lineDeriv_memSobolev_zero i (spatialDirection k)
inductive WeakDerivBridgeStatus
  | componentwiseSpaceTimeSobolevDefined | weakFirstDerivativesH0 | weakTimeDerivativeH0 | threeSpatialDerivativesH0 | weakSpatialLaplacianDistributionDefined | laplacianL1LocNotRequired | openWeightedProductRule | openMaterialDerivativePairing
  deriving DecidableEq, Repr
end G1Audit
