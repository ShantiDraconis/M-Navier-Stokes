import G1.MaximalFrontier

noncomputable section
open MeasureTheory

namespace G1Audit.MaximalFrontier

/--
Raw terminal decomposition data for the direct G5 route.

This structure intentionally does NOT contain the two hard conclusions
`theta < 1` and `IntervalIntegrable a volume t0 T`.
Those remain explicit propositions below.
-/
structure G5RawDecomposition (T : ℝ) (d : TrajectoryData) where
  t0 : ℝ
  theta : ℝ
  a : ℝ → ℝ
  ht00 : 0 ≤ t0
  ht0T : t0 < T
  htheta0 : 0 ≤ theta
  hstretch :
    ∀ t, t ∈ Set.Ioo t0 T →
      d.stretch t ≤ theta * d.nu * d.z t + a t * d.y t

/-- Hard sub-obligation G5-1. -/
def ThetaSubcritical {T : ℝ} {d : TrajectoryData}
    (r : G5RawDecomposition T d) : Prop :=
  r.theta < 1

/-- Hard sub-obligation G5-2, in the exact terminal interval needed by G5. -/
def DefectIntervalL1 {T : ℝ} {d : TrajectoryData}
    (r : G5RawDecomposition T d) : Prop :=
  IntervalIntegrable r.a volume r.t0 T

/--
A complete direct-G5 witness.  This is a result object, not a theorem that
ActualNS produces such a witness.
-/
structure G5DirectWitness (T : ℝ) (d : TrajectoryData)
    extends G5RawDecomposition T d where
  htheta1 : theta < 1
  ha : IntervalIntegrable a volume t0 T

/-- Raw decomposition + the two explicit hard obligations packages G5. -/
def G5DirectWitness.ofRaw
    {T : ℝ} {d : TrajectoryData}
    (r : G5RawDecomposition T d)
    (hθ : ThetaSubcritical r)
    (ha : DefectIntervalL1 r) :
    G5DirectWitness T d where
  t0 := r.t0
  theta := r.theta
  a := r.a
  ht00 := r.ht00
  ht0T := r.ht0T
  htheta0 := r.htheta0
  hstretch := r.hstretch
  htheta1 := hθ
  ha := ha

/-- A direct witness is exactly sufficient for the existing terminal G1 target. -/
theorem directWitness_to_terminalFlexibleG1
    {T : ℝ} {d : TrajectoryData}
    (w : G5DirectWitness T d) :
    TerminalFlexibleG1 T d := by
  exact ⟨
    w.t0, w.theta, w.a,
    w.ht00, w.ht0T, w.htheta0, w.htheta1, w.ha, w.hstretch
  ⟩

/-- The existing terminal G1 target can be unpacked into the same witness. -/
theorem terminalFlexibleG1_to_directWitness
    {T : ℝ} {d : TrajectoryData}
    (h : TerminalFlexibleG1 T d) :
    Nonempty (G5DirectWitness T d) := by
  rcases h with ⟨t0, theta, a, ht00, ht0T, htheta0, htheta1, ha, hstretch⟩
  exact ⟨{
    t0 := t0
    theta := theta
    a := a
    ht00 := ht00
    ht0T := ht0T
    htheta0 := htheta0
    hstretch := hstretch
    htheta1 := htheta1
    ha := ha
  }⟩

/--
The direct attack producer.  This proposition is deliberately left unproved:
it is the exact scientific delta `ActualNS -> direct G5 witness`.
-/
def G5DirectProducer {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData) : Prop :=
  ∀ u, ActualNS u → Nonempty (G5DirectWitness (T u) (trajectory u))

/-- No semantic weakening: the direct producer is equivalent to G5_NS. -/
theorem g5DirectProducer_iff_G5NSBridge
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData) :
    G5DirectProducer ActualNS T trajectory ↔
      G5NSBridge ActualNS T trajectory := by
  constructor
  · intro h u hu
    rcases h u hu with ⟨w⟩
    exact directWitness_to_terminalFlexibleG1 w
  · intro h u hu
    exact terminalFlexibleG1_to_directWitness (h u hu)

/--
G5-3 is already algebraic/reusable:
balance + a complete direct witness yields the exact terminal Gronwall
differential inequality.  No derivative of z is introduced.
-/
theorem directWitness_to_terminalGronwall
    {T : ℝ} {d : TrajectoryData}
    (hbal : EnstrophyBalance d)
    (w : G5DirectWitness T d) :
    ∃ (t0 theta : ℝ) (a : ℝ → ℝ),
      0 ≤ t0 ∧
      t0 < T ∧
      0 ≤ theta ∧
      theta < 1 ∧
      IntervalIntegrable a volume t0 T ∧
      TerminalGronwallDifferential t0 T theta a d := by
  exact terminalFlexibleG1_to_gronwall
    T d hbal (directWitness_to_terminalFlexibleG1 w)

/--
Exact decomposition of the open producer into:
  (1) produce raw signed-stretch data from ActualNS,
  (2) prove theta < 1,
  (3) prove the defect coefficient is L1 on the terminal interval.

This theorem is composition only; it manufactures none of the three inputs.
-/
theorem raw_plus_two_hard_obligations_closes_G5
    {State : Type}
    (ActualNS : State → Prop)
    (T : State → ℝ)
    (trajectory : State → TrajectoryData)
    (raw :
      ∀ u, ActualNS u →
        Nonempty (G5RawDecomposition (T u) (trajectory u)))
    (thetaHard :
      ∀ u, ActualNS u →
        ∀ r : G5RawDecomposition (T u) (trajectory u),
          ThetaSubcritical r)
    (l1Hard :
      ∀ u, ActualNS u →
        ∀ r : G5RawDecomposition (T u) (trajectory u),
          DefectIntervalL1 r) :
    G5NSBridge ActualNS T trajectory := by
  intro u hu
  rcases raw u hu with ⟨r⟩
  exact directWitness_to_terminalFlexibleG1
    (G5DirectWitness.ofRaw r (thetaHard u hu r) (l1Hard u hu r))

/--
Fail-closed status markers.  These are documentation values only and carry no
proof of the open producer.
-/
def G5_DIRECT_STATUS : String := "OPEN_MATH"
def G5_1_THETA_STATUS : String := "OPEN_MATH"
def G5_2_L1_STATUS : String := "OPEN_MATH"
def G5_3_BALANCE_STATUS : String := "PROVED_REUSE"
def K4_TO_THETA_PROMOTION_STATUS : String := "FORBIDDEN_WITHOUT_NEW_THEOREM"
def FINAL_NS_PROOF_STATUS : String := "0"

#print axioms directWitness_to_terminalFlexibleG1
#print axioms terminalFlexibleG1_to_directWitness
#print axioms g5DirectProducer_iff_G5NSBridge
#print axioms directWitness_to_terminalGronwall
#print axioms raw_plus_two_hard_obligations_closes_G5

end G1Audit.MaximalFrontier
