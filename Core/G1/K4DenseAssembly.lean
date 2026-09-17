/-
K4 dense assembly: maximize mechanically provable information without changing
SignedCZLinearGainTarget or promoting the open signed-CZ bridge.

Scientific boundary:
  SignedCZLinearGainTarget remains OPEN_MATH.
  Shell estimates below are sufficient-condition infrastructure only.
-/
import G1.SignedFarField

noncomputable section
open scoped BigOperators
open MeasureTheory Metric
namespace G1Audit

/-- A dyadic shell datum.  This is deliberately independent of ActualNS: the
missing NS -> signed-CZ bridge is not hidden in this structure. -/
structure K4ShellData where
  shell : ℕ → ℝ
  hshell : ∀ n, 0 ≤ shell n
  energy : ℝ
  henergy : 0 ≤ energy
  squareSumBound : Summable (fun n => (shell n)^2)
  squareTsumBound : (∑' n, (shell n)^2) ≤ energy^2

/-- Dyadic weight starting at n=0. -/
def k4Weight (n : ℕ) : ℝ := (1 / 2 : ℝ)^n

theorem k4Weight_nonneg (n : ℕ) : 0 ≤ k4Weight n := by
  positivity

theorem k4Weight_summable : Summable (fun n : ℕ => (k4Weight n)^2) := by
  simpa [k4Weight, pow_two] using
    (summable_geometric_of_norm_lt_one (𝕜 := ℝ) (by norm_num : ‖(1 / 4 : ℝ)‖ < 1))

/-- The exact n=0 geometric-square sum is 4/3.  This prevents the historical
1/sqrt(3) versus 2/sqrt(3) indexing ambiguity from entering a certificate. -/
theorem k4Weight_square_tsum :
    (∑' n : ℕ, (k4Weight n)^2) = (4 / 3 : ℝ) := by
  rw [show (fun n : ℕ => (k4Weight n)^2) = fun n : ℕ => (1 / 4 : ℝ)^n by
    funext n
    simp [k4Weight, pow_two, ← mul_pow]]
  rw [tsum_geometric_of_norm_lt_one (by norm_num : ‖(1 / 4 : ℝ)‖ < 1)]
  norm_num

/-- Candidate shell gain.  This is NOT the repository's SignedCZLinearGainTarget.
It is a sufficient-condition object to be attacked/proved/refuted separately. -/
def K4ShellGain (osc : ℕ → ℝ) (d : K4ShellData) : Prop :=
  ∀ n, |osc n| ≤ d.shell n * k4Weight n

/-- Non-promotion firewall as a type-level fact: structural shell data contains
no field capable of manufacturing K4ShellGain.  The gain must be supplied. -/
structure K4ConditionalInput (osc : ℕ → ℝ) where
  data : K4ShellData
  gain : K4ShellGain osc data

/-- The actual K4 endpoint is kept as a separate explicit obligation. -/
structure K4EndpointInput where
  farFieldSqAvg : ℝ
  Cfar : ℝ
  omegaL2 : ℝ
  scale : SubcutoffScale
  target : SignedCZLinearGainTarget farFieldSqAvg Cfar omegaL2 scale

/-- No theorem below constructs `K4EndpointInput.target`; doing so is the open
mathematics.  This projection exists only to make assumption closure visible. -/
theorem endpoint_target_of_input (h : K4EndpointInput) :
    SignedCZLinearGainTarget h.farFieldSqAvg h.Cfar h.omegaL2 h.scale :=
  h.target

/-- Basic pointwise majorization exposed for downstream mechanical assembly. -/
theorem shell_gain_majorizes
    (osc : ℕ → ℝ) (h : K4ConditionalInput osc) (n : ℕ) :
    |osc n| ≤ h.data.shell n * k4Weight n :=
  h.gain n

/-- A deliberately weak but unconditional consequence of the dyadic weight:
weight <= 1, hence gain <= shell.  This is enough for regression/firewall
checks and requires no new mathematics. -/
theorem k4Weight_le_one (n : ℕ) : k4Weight n ≤ 1 := by
  exact pow_le_one₀ (by norm_num : 0 ≤ (1 / 2 : ℝ)) (by norm_num : (1 / 2 : ℝ) ≤ 1)

theorem shell_gain_le_shell
    (osc : ℕ → ℝ) (h : K4ConditionalInput osc) (n : ℕ) :
    |osc n| ≤ h.data.shell n := by
  calc
    |osc n| ≤ h.data.shell n * k4Weight n := h.gain n
    _ ≤ h.data.shell n * 1 := mul_le_mul_of_nonneg_left (k4Weight_le_one n) (h.data.hshell n)
    _ = h.data.shell n := by ring

/-- Status values are data, not proofs. -/
def K4_DENSE_ASSEMBLY_STATUS : String := "MECHANICAL_GREEN_IF_COMPILED"
def K4_ENDPOINT_STATUS : String := "OPEN_MATH"
def K4_NEW_MACRO_GATES : Nat := 0

end G1Audit
