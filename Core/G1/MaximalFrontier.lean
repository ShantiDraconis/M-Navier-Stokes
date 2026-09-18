import Mathlib
import G1.K4DenseAssembly
import G1.K4KernelNondegeneracy
import G1.K4ExplicitRieszKernel
import G1.DynamicCampanato

noncomputable section
open MeasureTheory
namespace G1Audit.MaximalFrontier

/--
Time-dependent scalar data extracted from a smooth Navier--Stokes trajectory.
No regularity conclusion is stored in this structure.
-/
structure TrajectoryData where
  y : ℝ → ℝ
  z : ℝ → ℝ
  stretch : ℝ → ℝ
  nu : ℝ
  hnu : 0 < nu
  hy : ∀ t, 0 ≤ y t
  hz : ∀ t, 0 ≤ z t

/-- Exact enstrophy balance used by the compressed route. -/
def EnstrophyBalance (d : TrajectoryData) : Prop :=
  ∀ t, (1 / 2 : ℝ) * deriv d.y t + d.nu * d.z t = d.stretch t

/--
Strong signed depletion.  This is sufficient for monotone enstrophy decay but
is stronger than the flexible G1 target used below.
-/
def StrictG1 (d : TrajectoryData) : Prop :=
  ∃ δ : ℝ,
    0 < δ ∧ δ ≤ 1 ∧
    ∀ t, d.stretch t ≤ (1 - δ) * d.nu * d.z t

/--
Flexible G1 target on (0,T): a strict dissipative margin plus an L1-in-time
defect multiplying enstrophy.
-/
def FlexibleG1 (T : ℝ) (d : TrajectoryData) : Prop :=
  ∃ (theta : ℝ) (a : ℝ → ℝ),
    0 ≤ theta ∧
    theta < 1 ∧
    IntervalIntegrable a volume 0 T ∧
    ∀ t, t ∈ Set.Ioo 0 T →
      d.stretch t ≤ theta * d.nu * d.z t + a t * d.y t

/-- Differential inequality produced by strict G1. -/
def StrictDecayDifferential (d : TrajectoryData) : Prop :=
  ∃ δ : ℝ,
    0 < δ ∧ δ ≤ 1 ∧
    ∀ t, deriv d.y t + 2 * δ * d.nu * d.z t ≤ 0

/-- Differential inequality produced by flexible G1. -/
def GronwallDifferential
    (T theta : ℝ) (a : ℝ → ℝ) (d : TrajectoryData) : Prop :=
  ∀ t, t ∈ Set.Ioo 0 T →
    deriv d.y t + 2 * (1 - theta) * d.nu * d.z t
      ≤ 2 * a t * d.y t

/-- Pure algebra: exact balance plus strict signed depletion gives decay. -/
theorem strictG1_to_decay
    (d : TrajectoryData)
    (hbal : EnstrophyBalance d)
    (hg1 : StrictG1 d) :
    StrictDecayDifferential d := by
  rcases hg1 with ⟨δ, hδ, hδ1, hs⟩
  refine ⟨δ, hδ, hδ1, ?_⟩
  intro t
  have hb := hbal t
  have hst := hs t
  have hnu : 0 ≤ d.nu := le_of_lt d.hnu
  have hnuz : 0 ≤ d.nu * d.z t := mul_nonneg hnu (d.hz t)
  linarith

/--
Pure algebra: exact balance plus flexible G1 gives the precise Gronwall-ready
differential inequality.  The integration/Gronwall step is deliberately
separate from the PDE frontier.
-/
theorem flexibleG1_to_gronwall
    (T : ℝ) (d : TrajectoryData)
    (hbal : EnstrophyBalance d)
    (hg1 : FlexibleG1 T d) :
    ∃ (theta : ℝ) (a : ℝ → ℝ),
      0 ≤ theta ∧
      theta < 1 ∧
      IntervalIntegrable a volume 0 T ∧
      GronwallDifferential T theta a d := by
  rcases hg1 with ⟨theta, a, htheta0, htheta1, ha, hs⟩
  refine ⟨theta, a, htheta0, htheta1, ha, ?_⟩
  intro t ht
  have hb := hbal t
  have hst := hs t ht
  linarith

/--
The single real Navier--Stokes research frontier after endpoint compression:
derive the flexible G1 inequality from the actual equations, with no critical
regularity bound assumed in advance.
-/
def G5NSBridge {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData) : Prop :=
  ∀ u, ActualNS u → FlexibleG1 (T u) (trajectory u)

/--
K4/signed-CZ factorization surface.  These are definitions of two independent
obligations inside the single G5_NS gate, not additional proof claims.
-/
def ActualNSToK4Target {State : Type}
    (ActualNS : State → Prop)
    (farFieldSqAvg Cfar omegaL2 : State → ℝ)
    (scale : State → SubcutoffScale) : Prop :=
  ∀ u, ActualNS u →
    SignedCZLinearGainTarget
      (farFieldSqAvg u) (Cfar u) (omegaL2 u) (scale u)

def K4TargetToFlexibleG1 {State : Type}
    (T : State → ℝ)
    (trajectory : State → TrajectoryData)
    (farFieldSqAvg Cfar omegaL2 : State → ℝ)
    (scale : State → SubcutoffScale) : Prop :=
  ∀ u,
    SignedCZLinearGainTarget
      (farFieldSqAvg u) (Cfar u) (omegaL2 u) (scale u) →
    FlexibleG1 (T u) (trajectory u)

/-- If both K4 sub-obligations are genuinely proved, they close G5_NS. -/
theorem k4_factorization_closes_G5
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData)
    (farFieldSqAvg Cfar omegaL2 : State → ℝ)
    (scale : State → SubcutoffScale)
    (hNSK4 : ActualNSToK4Target ActualNS farFieldSqAvg Cfar omegaL2 scale)
    (hK4G1 : K4TargetToFlexibleG1
      T trajectory farFieldSqAvg Cfar omegaL2 scale) :
    G5NSBridge ActualNS T trajectory := by
  intro u hu
  exact hK4G1 u (hNSK4 u hu)

/--
Downstream theorem interface.  Its fields are classical/analytic wiring
obligations and are not counted as new research gates.  Every field must be
matched to an exact theorem before a prize-level closure certificate exists.
-/
structure DownstreamWiring {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData) where
  UniformEnstrophy : State → Prop
  CriticalL3 : State → Prop
  GlobalRegularity : State → Prop
  gronwall :
    ∀ u, ActualNS u →
      EnstrophyBalance (trajectory u) →
      FlexibleG1 (T u) (trajectory u) →
      UniformEnstrophy u
  reconstructCritical :
    ∀ u, ActualNS u → UniformEnstrophy u → CriticalL3 u
  essEndpoint :
    ∀ u, ActualNS u → CriticalL3 u → GlobalRegularity u

/--
Hypothetical terminal theorem: if the single G5_NS bridge exists and the
downstream exact theorem matches are supplied, global regularity follows.
This proves composition only; it does not manufacture G5_NS.
-/
theorem final_if_G5_exists
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData)
    (hBalance : ∀ u, ActualNS u → EnstrophyBalance (trajectory u))
    (hG5 : G5NSBridge ActualNS T trajectory)
    (W : DownstreamWiring ActualNS T trajectory) :
    ∀ u, ActualNS u → W.GlobalRegularity u := by
  intro u hu
  have hg1 : FlexibleG1 (T u) (trajectory u) := hG5 u hu
  have hE : W.UniformEnstrophy u :=
    W.gronwall u hu (hBalance u hu) hg1
  have hL3 : W.CriticalL3 u :=
    W.reconstructCritical u hu hE
  exact W.essEndpoint u hu hL3

def REAL_FRONTIER_COUNT : Nat := 1
def REAL_FRONTIER_NAME : String := "G5_NS: ActualNS -> FlexibleG1"
def K4_STATUS : String := "CANDIDATE_FACTORIZATION_INSIDE_G5"
def TERMINAL_STATUS : String := "CONDITIONAL_ON_G5_AND_EXACT_DOWNSTREAM_MATCHES"

#print axioms strictG1_to_decay
#print axioms flexibleG1_to_gronwall
#print axioms k4_factorization_closes_G5
#print axioms final_if_G5_exists

end G1Audit.MaximalFrontier
