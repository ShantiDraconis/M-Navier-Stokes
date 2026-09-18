import IMath.Certificates.Core
import G1.MaximalFrontier

noncomputable section

namespace G1Audit.ClosedOpenClosed

open IMath
open G1Audit.MaximalFrontier

/-!
# Closed -> open frontier -> closed conditional endpoint

The independent I-core is imported from the frozen source SHA
b8b1da782366a581fccd1118c389a2e191b67f0b.

The point of this file is epistemic as well as logical:
* I-G1..I-G4 are reconstructed from kernel-checked certificates.
* G5_NS is NOT derived from those certificates.
* adding the already-proved I-core to the left of G5 does not weaken G5:
  the two bridge propositions are proved equivalent.
* the terminal endpoint is closed only as conditional composition once G5 and
  the exact downstream theorem matches are supplied.
-/

/-- I-G1: carrier/state/embedding foundation certificates. -/
def I_G1_FoundationClosed : Prop :=
  Phi3.state (Phi3.I (α := ℂ)) = .indeterminate ∧
  Phi3.I (α := ℂ) ≠ (.infinity : Phi3 ℂ) ∧
  (∀ z : ℂ, Phi3.I (α := ℂ) ≠ (.finite z : Phi3 ℂ)) ∧
  Function.Injective ofReal ∧
  Function.Injective ofComplex

theorem I_G1_foundation_closed : I_G1_FoundationClosed := by
  constructor
  · exact IMath.Certificates.C01_I_is_indeterminate
  constructor
  · exact IMath.Certificates.C02_I_is_not_infinity
  constructor
  · intro z
    exact IMath.Certificates.C03_I_is_not_finite z
  constructor
  · exact IMath.Certificates.C04_real_embedding_injective
  · exact IMath.Certificates.C05_complex_embedding_injective

/-- I-G2: division/provenance/collapse/algebraic counterexample certificates. -/
def I_G2_ArithmeticAlgebraClosed : Prop :=
  Phi3.idiv (.finite (0 : ℂ)) (.finite 0) = Phi3.I ∧
  Phi3.idiv (.infinity : Phi3 ℂ) .infinity =
    .indeterminate (.div .infinity .infinity) ∧
  (∀ x : Phi3 ℂ, Phi3.collapse (Phi3.collapse x) = Phi3.collapse x) ∧
  (∃ a b : Phi3 ℂ,
    a ≠ b ∧
    Phi3.absorbingAdd a Phi3.I = Phi3.absorbingAdd b Phi3.I)

theorem I_G2_arithmetic_algebra_closed : I_G2_ArithmeticAlgebraClosed := by
  constructor
  · exact IMath.Certificates.C06_zero_over_zero_is_I
  constructor
  · exact IMath.Certificates.C07_infinity_over_infinity_retains_provenance
  constructor
  · intro x
    exact IMath.Certificates.C08_collapse_is_idempotent x
  · exact IMath.Certificates.C09_absorbing_addition_refutes_right_cancellation

/-- I-G3: refinement plus context-sensitive zero-over-zero germs. -/
def I_G3_InformationAnalysisClosed : Prop :=
  (∀ A B C : Realization ℂ,
    refines A B → refines B C → refines A C) ∧
  xOverX ≠ xSqOverX ∧
  ResolvesTo xOverX 1 ∧
  ResolvesTo xSqOverX 0 ∧
  (ResolvesTo xOverX 1 ∧ ResolvesTo xSqOverX 0)

theorem I_G3_information_analysis_closed : I_G3_InformationAnalysisClosed := by
  constructor
  · intro A B C hAB hBC
    exact IMath.Certificates.C10_refinement_transitive hAB hBC
  constructor
  · exact IMath.Certificates.C11_contextual_zero_over_zero_germs_differ
  constructor
  · exact IMath.Certificates.C12_x_over_x_resolves_to_one
  constructor
  · exact IMath.Certificates.C13_x_squared_over_x_resolves_to_zero
  · exact IMath.Certificates.C14_same_substitution_form_different_resolutions

/-- I-G4: dimension-generic determined geometry embeds injectively. -/
def I_G4_GeometryClosed : Prop :=
  ∀ n : ℕ, Function.Injective (@determinedPoint ℂ n)

theorem I_G4_geometry_closed : I_G4_GeometryClosed := by
  intro n
  exact IMath.Certificates.C15_determined_geometry_embedding_injective

/-- The reusable I-core is closed exactly when its four internal gates hold. -/
def ICoreClosed : Prop :=
  I_G1_FoundationClosed ∧
  I_G2_ArithmeticAlgebraClosed ∧
  I_G3_InformationAnalysisClosed ∧
  I_G4_GeometryClosed

theorem I_core_closed : ICoreClosed := by
  exact ⟨
    I_G1_foundation_closed,
    I_G2_arithmetic_algebra_closed,
    I_G3_information_analysis_closed,
    I_G4_geometry_closed
  ⟩

/--
External G5 written with the closed I-core visible at the left edge.
This does not assert the bridge; it merely states the research obligation.
-/
def G5FromClosedI {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData) : Prop :=
  ICoreClosed → G5NSBridge ActualNS T trajectory

/--
Crucial anti-laundering theorem:
because ICoreClosed is already proved, "closed I -> G5" is logically equivalent
to G5 itself.  The closed start cannot erase or weaken the open PDE frontier.
-/
theorem G5FromClosedI_iff_G5
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData) :
    G5FromClosedI ActualNS T trajectory ↔
      G5NSBridge ActualNS T trajectory := by
  constructor
  · intro h
    exact h I_core_closed
  · intro h _
    exact h

/-- TEST 00: the beginning of the chain is closed. -/
theorem test_00_I_start_closed : ICoreClosed :=
  I_core_closed

/-- TEST 10: the unique external frontier remains exactly G5_NS. -/
theorem test_10_frontier_exact
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData) :
    G5FromClosedI ActualNS T trajectory ↔
      G5NSBridge ActualNS T trajectory :=
  G5FromClosedI_iff_G5 ActualNS T trajectory

/-- TEST 20: the explicit K4 two-arrow factorization is sufficient for G5. -/
theorem test_20_K4_factorization
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData)
    (farFieldSqAvg Cfar omegaL2 : State → ℝ)
    (scale : State → SubcutoffScale)
    (hNSK4 : ActualNSToK4Target ActualNS farFieldSqAvg Cfar omegaL2 scale)
    (hK4G1 : K4TargetToTerminalFlexibleG1
      T trajectory farFieldSqAvg Cfar omegaL2 scale) :
    G5FromClosedI ActualNS T trajectory := by
  intro _
  exact k4_factorization_closes_G5
    ActualNS T trajectory farFieldSqAvg Cfar omegaL2 scale hNSK4 hK4G1

/-- TEST 30: terminal G1 plus exact enstrophy balance reaches the differential gate. -/
theorem test_30_terminal_G1_to_gronwall
    (T : ℝ) (d : TrajectoryData)
    (hBalance : EnstrophyBalance d)
    (hG1 : TerminalFlexibleG1 T d) :
    ∃ (t0 theta : ℝ) (a : ℝ → ℝ),
      0 ≤ t0 ∧
      t0 < T ∧
      0 ≤ theta ∧
      theta < 1 ∧
      IntervalIntegrable a MeasureTheory.volume t0 T ∧
      TerminalGronwallDifferential t0 T theta a d :=
  terminalFlexibleG1_to_gronwall T d hBalance hG1

/-- TEST 40: the explicit downstream Gronwall theorem match yields enstrophy. -/
theorem test_40_G5_to_uniform_enstrophy
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData)
    (hBalance : ∀ u, ActualNS u → EnstrophyBalance (trajectory u))
    (hG5I : G5FromClosedI ActualNS T trajectory)
    (W : DownstreamWiring ActualNS T trajectory)
    (u : State) (hu : ActualNS u) :
    W.UniformEnstrophy u := by
  have hG5 : G5NSBridge ActualNS T trajectory :=
    (G5FromClosedI_iff_G5 ActualNS T trajectory).mp hG5I
  exact W.gronwall u hu (hBalance u hu) (hG5 u hu)

/-- TEST 50: enstrophy reaches the critical L3 endpoint through the explicit match. -/
theorem test_50_enstrophy_to_critical_L3
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData)
    (W : DownstreamWiring ActualNS T trajectory)
    (u : State) (hu : ActualNS u)
    (hE : W.UniformEnstrophy u) :
    W.CriticalL3 u :=
  W.reconstructCritical u hu hE

/-- TEST 60: critical L3 reaches the regularity endpoint through the ESS match. -/
theorem test_60_critical_L3_to_final
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData)
    (W : DownstreamWiring ActualNS T trajectory)
    (u : State) (hu : ActualNS u)
    (hL3 : W.CriticalL3 u) :
    W.GlobalRegularity u :=
  W.essEndpoint u hu hL3

/--
The final edge is a closed theorem of conditional composition.
It explicitly quantifies over the one open G5 bridge and over the exact
downstream theorem-match object.
-/
def FinalClosedConditional {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData) : Prop :=
  G5FromClosedI ActualNS T trajectory →
  (∀ u, ActualNS u → EnstrophyBalance (trajectory u)) →
  ∀ W : DownstreamWiring ActualNS T trajectory,
    FINAL_STATEMENT ActualNS W.GlobalRegularity

theorem test_70_final_closed_conditional
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData) :
    FinalClosedConditional ActualNS T trajectory := by
  intro hG5I hBalance W
  have hG5 : G5NSBridge ActualNS T trajectory :=
    (G5FromClosedI_iff_G5 ActualNS T trajectory).mp hG5I
  exact EndpointCompression ActualNS T trajectory hBalance hG5 W

/--
Whole chain certificate:
  CLOSED I-core
  -> OPEN G5_NS (supplied explicitly)
  -> CLOSED conditional endpoint wiring.
-/
theorem ClosedOpenClosedChain
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData)
    (hG5I : G5FromClosedI ActualNS T trajectory)
    (hBalance : ∀ u, ActualNS u → EnstrophyBalance (trajectory u))
    (W : DownstreamWiring ActualNS T trajectory) :
    ICoreClosed ∧ FINAL_STATEMENT ActualNS W.GlobalRegularity := by
  refine ⟨I_core_closed, ?_⟩
  exact test_70_final_closed_conditional ActualNS T trajectory hG5I hBalance W

def START_STATUS : String := "GREEN_FROZEN_I_G1_G4"
def MIDDLE_STATUS : String := "OPEN_G5_NS"
def END_STATUS : String := "PROVED_WIRING_CONDITIONAL"
def UNCONDITIONAL_NS_STATUS : String := "NOT_ESTABLISHED"

#print axioms I_G1_foundation_closed
#print axioms I_G2_arithmetic_algebra_closed
#print axioms I_G3_information_analysis_closed
#print axioms I_G4_geometry_closed
#print axioms I_core_closed
#print axioms G5FromClosedI_iff_G5
#print axioms test_20_K4_factorization
#print axioms test_30_terminal_G1_to_gronwall
#print axioms test_70_final_closed_conditional
#print axioms ClosedOpenClosedChain

end G1Audit.ClosedOpenClosed
