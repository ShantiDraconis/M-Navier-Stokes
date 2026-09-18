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
Strong signed depletion. This is sufficient for monotone enstrophy decay but
is stronger than the maximal flexible frontier.
-/
def StrictG1 (d : TrajectoryData) : Prop :=
  ∃ δ : ℝ,
    0 < δ ∧ δ ≤ 1 ∧
    ∀ t, d.stretch t ≤ (1 - δ) * d.nu * d.z t

/--
Full-interval flexible G1. Kept because it is a useful stronger theorem target.
The maximal/minimal sufficient gate below only asks for its terminal analogue.
-/
def FlexibleG1 (T : ℝ) (d : TrajectoryData) : Prop :=
  ∃ (theta : ℝ) (a : ℝ → ℝ),
    0 ≤ theta ∧
    theta < 1 ∧
    IntervalIntegrable a volume 0 T ∧
    ∀ t, t ∈ Set.Ioo 0 T →
      d.stretch t ≤ theta * d.nu * d.z t + a t * d.y t

/--
Terminal flexible G1: it is enough to obtain signed depletion on some
(t0,T), because a maximal smooth solution is already regular on every compact
subinterval strictly before T.
-/
def TerminalFlexibleG1 (T : ℝ) (d : TrajectoryData) : Prop :=
  ∃ (t0 theta : ℝ) (a : ℝ → ℝ),
    0 ≤ t0 ∧
    t0 < T ∧
    0 ≤ theta ∧
    theta < 1 ∧
    IntervalIntegrable a volume t0 T ∧
    ∀ t, t ∈ Set.Ioo t0 T →
      d.stretch t ≤ theta * d.nu * d.z t + a t * d.y t

/-- Differential inequality produced by strict G1. -/
def StrictDecayDifferential (d : TrajectoryData) : Prop :=
  ∃ δ : ℝ,
    0 < δ ∧ δ ≤ 1 ∧
    ∀ t, deriv d.y t + 2 * δ * d.nu * d.z t ≤ 0

/-- Full-interval Gronwall-ready differential inequality. -/
def GronwallDifferential
    (T theta : ℝ) (a : ℝ → ℝ) (d : TrajectoryData) : Prop :=
  ∀ t, t ∈ Set.Ioo 0 T →
    deriv d.y t + 2 * (1 - theta) * d.nu * d.z t
      ≤ 2 * a t * d.y t

/-- Terminal-interval Gronwall-ready differential inequality. -/
def TerminalGronwallDifferential
    (t0 T theta : ℝ) (a : ℝ → ℝ) (d : TrajectoryData) : Prop :=
  ∀ t, t ∈ Set.Ioo t0 T →
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

/-- Strong G1 is a special case of full flexible G1, with zero defect. -/
theorem strictG1_to_flexible
    (T : ℝ) (d : TrajectoryData)
    (hg1 : StrictG1 d) :
    FlexibleG1 T d := by
  rcases hg1 with ⟨δ, hδ, hδ1, hs⟩
  refine ⟨1 - δ, (fun _ : ℝ => 0), ?_, ?_, ?_, ?_⟩
  · linarith
  · linarith
  · simp
  · intro t ht
    simpa using hs t

/--
Full-interval flexible G1 implies terminal G1 whenever the target interval is
nonempty; choose t0=0.
-/
theorem flexible_to_terminal
    (T : ℝ) (d : TrajectoryData) (hT : 0 < T)
    (hg1 : FlexibleG1 T d) :
    TerminalFlexibleG1 T d := by
  rcases hg1 with ⟨theta, a, htheta0, htheta1, ha, hs⟩
  exact ⟨0, theta, a, le_rfl, hT, htheta0, htheta1, ha, hs⟩

/-- Strong G1 therefore also implies terminal flexible G1. -/
theorem strictG1_to_terminal
    (T : ℝ) (d : TrajectoryData) (hT : 0 < T)
    (hg1 : StrictG1 d) :
    TerminalFlexibleG1 T d :=
  flexible_to_terminal T d hT (strictG1_to_flexible T d hg1)

/--
Pure algebra: exact balance plus full flexible G1 gives the precise
Gronwall-ready differential inequality.
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
The same algebra on a terminal interval. This is the downstream input needed
by the maximal one-gate compression.
-/
theorem terminalFlexibleG1_to_gronwall
    (T : ℝ) (d : TrajectoryData)
    (hbal : EnstrophyBalance d)
    (hg1 : TerminalFlexibleG1 T d) :
    ∃ (t0 theta : ℝ) (a : ℝ → ℝ),
      0 ≤ t0 ∧
      t0 < T ∧
      0 ≤ theta ∧
      theta < 1 ∧
      IntervalIntegrable a volume t0 T ∧
      TerminalGronwallDifferential t0 T theta a d := by
  rcases hg1 with
    ⟨t0, theta, a, ht00, ht0T, htheta0, htheta1, ha, hs⟩
  refine ⟨t0, theta, a, ht00, ht0T, htheta0, htheta1, ha, ?_⟩
  intro t ht
  have hb := hbal t
  have hst := hs t ht
  linarith

/--
The single real Navier--Stokes research frontier after endpoint compression:
derive terminal flexible G1 from the actual equations, without importing a
critical regularity bound.
-/
def G5NSBridge {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData) : Prop :=
  ∀ u, ActualNS u → TerminalFlexibleG1 (T u) (trajectory u)

/--
K4/signed-CZ factorization surface. These are two attack obligations inside
the single G5_NS macro-gate, not additional macro-gates.
-/
def ActualNSToK4Target {State : Type}
    (ActualNS : State → Prop)
    (farFieldSqAvg Cfar omegaL2 : State → ℝ)
    (scale : State → SubcutoffScale) : Prop :=
  ∀ u, ActualNS u →
    SignedCZLinearGainTarget
      (farFieldSqAvg u) (Cfar u) (omegaL2 u) (scale u)

def K4TargetToTerminalFlexibleG1 {State : Type}
    (T : State → ℝ)
    (trajectory : State → TrajectoryData)
    (farFieldSqAvg Cfar omegaL2 : State → ℝ)
    (scale : State → SubcutoffScale) : Prop :=
  ∀ u,
    SignedCZLinearGainTarget
      (farFieldSqAvg u) (Cfar u) (omegaL2 u) (scale u) →
    TerminalFlexibleG1 (T u) (trajectory u)

/-- If both K4 sub-obligations are genuinely proved, they close G5_NS. -/
theorem k4_factorization_closes_G5
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData)
    (farFieldSqAvg Cfar omegaL2 : State → ℝ)
    (scale : State → SubcutoffScale)
    (hNSK4 : ActualNSToK4Target ActualNS farFieldSqAvg Cfar omegaL2 scale)
    (hK4G1 : K4TargetToTerminalFlexibleG1
      T trajectory farFieldSqAvg Cfar omegaL2 scale) :
    G5NSBridge ActualNS T trajectory := by
  intro u hu
  exact hK4G1 u (hNSK4 u hu)

/--
Downstream theorem interface. These fields remain visible theorem obligations.
They are not counted as new conjectural mechanisms.
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
      TerminalFlexibleG1 (T u) (trajectory u) →
      UniformEnstrophy u
  reconstructCritical :
    ∀ u, ActualNS u → UniformEnstrophy u → CriticalL3 u
  essEndpoint :
    ∀ u, ActualNS u → CriticalL3 u → GlobalRegularity u

/-- Non-circular final statement. -/
def FINAL_STATEMENT {State : Type}
    (ActualNS GlobalRegularity : State → Prop) : Prop :=
  ∀ u, ActualNS u → GlobalRegularity u

/--
Hypothetical terminal theorem: if the one real G5_NS bridge exists and all
downstream exact theorem matches are supplied, the final statement follows.
This theorem proves composition only and cannot manufacture G5_NS.
-/
theorem EndpointCompression
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData)
    (hBalance : ∀ u, ActualNS u → EnstrophyBalance (trajectory u))
    (hG5 : G5NSBridge ActualNS T trajectory)
    (W : DownstreamWiring ActualNS T trajectory) :
    FINAL_STATEMENT ActualNS W.GlobalRegularity := by
  intro u hu
  have hg1 : TerminalFlexibleG1 (T u) (trajectory u) := hG5 u hu
  have hE : W.UniformEnstrophy u :=
    W.gronwall u hu (hBalance u hu) hg1
  have hL3 : W.CriticalL3 u :=
    W.reconstructCritical u hu hE
  exact W.essEndpoint u hu hL3

/-- Compatibility name for the terminal composition theorem. -/
theorem final_if_G5_exists
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData)
    (hBalance : ∀ u, ActualNS u → EnstrophyBalance (trajectory u))
    (hG5 : G5NSBridge ActualNS T trajectory)
    (W : DownstreamWiring ActualNS T trajectory) :
    ∀ u, ActualNS u → W.GlobalRegularity u :=
  EndpointCompression ActualNS T trajectory hBalance hG5 W

def REAL_FRONTIER_COUNT : Nat := 1
def REAL_FRONTIER_NAME : String :=
  "G5_NS: ActualNS -> TerminalFlexibleG1"
def K4_STATUS : String :=
  "CANDIDATE_FACTORIZATION_INSIDE_G5"
def ACTUAL_NS_REPRESENTATION_STATUS : String :=
  "ABSTRACT_PREDICATE_PENDING_CONCRETE_CLAY_INSTANTIATION"
def TERMINAL_STATUS : String :=
  "CONDITIONAL_ON_G5_AND_EXACT_DOWNSTREAM_MATCHES"

#print axioms strictG1_to_decay
#print axioms strictG1_to_flexible
#print axioms flexible_to_terminal
#print axioms terminalFlexibleG1_to_gronwall
#print axioms k4_factorization_closes_G5
#print axioms EndpointCompression
#print axioms final_if_G5_exists

end G1Audit.MaximalFrontier
