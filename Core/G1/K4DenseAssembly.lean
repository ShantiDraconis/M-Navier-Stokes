/- 
K4 dense assembly: maximize mechanically provable information without changing
SignedCZLinearGainTarget or promoting the open signed-CZ bridge.

Scientific boundary:
  SignedCZLinearGainTarget remains OPEN_MATH.
  Shell estimates below are sufficient-condition infrastructure only.

Historical source:
  commit 76acf5b3be15ff1308024f416a8371c41e94e5f4
  blob   3b1c090bfc4bdf7c45a5ef87de5111313276c03d
This revision only updates Lean/Mathlib proof compatibility.
-/
import G1.SignedFarField

noncomputable section
open scoped BigOperators
open MeasureTheory Metric
namespace G1Audit

structure K4ShellData where
  shell : ℕ → ℝ
  hshell : ∀ n, 0 ≤ shell n
  energy : ℝ
  henergy : 0 ≤ energy
  squareSumBound : Summable (fun n => (shell n)^2)
  squareTsumBound : (∑' n, (shell n)^2) ≤ energy^2

def k4Weight (n : ℕ) : ℝ := (1 / 2 : ℝ)^n

theorem k4Weight_nonneg (n : ℕ) : 0 ≤ k4Weight n := by
  unfold k4Weight
  exact pow_nonneg (by norm_num) n

private theorem k4Weight_sq (n : ℕ) :
    (k4Weight n)^2 = (1 / 4 : ℝ)^n := by
  unfold k4Weight
  rw [pow_two, ← mul_pow]
  norm_num

theorem k4Weight_summable : Summable (fun n : ℕ => (k4Weight n)^2) := by
  have hgeom : Summable (fun n : ℕ => (1 / 4 : ℝ)^n) :=
    summable_geometric_of_norm_lt_one (by norm_num)
  simpa only [k4Weight_sq] using hgeom

theorem k4Weight_square_tsum :
    (∑' n : ℕ, (k4Weight n)^2) = (4 / 3 : ℝ) := by
  rw [show (fun n : ℕ => (k4Weight n)^2) =
      (fun n : ℕ => (1 / 4 : ℝ)^n) by
    funext n
    exact k4Weight_sq n]
  rw [tsum_geometric_of_norm_lt_one (by norm_num : ‖(1 / 4 : ℝ)‖ < 1)]
  norm_num

def K4ShellGain (osc : ℕ → ℝ) (d : K4ShellData) : Prop :=
  ∀ n, |osc n| ≤ d.shell n * k4Weight n

structure K4ConditionalInput (osc : ℕ → ℝ) where
  data : K4ShellData
  gain : K4ShellGain osc data

structure K4EndpointInput where
  farFieldSqAvg : ℝ
  Cfar : ℝ
  omegaL2 : ℝ
  scale : SubcutoffScale
  target : SignedCZLinearGainTarget farFieldSqAvg Cfar omegaL2 scale

theorem endpoint_target_of_input (h : K4EndpointInput) :
    SignedCZLinearGainTarget h.farFieldSqAvg h.Cfar h.omegaL2 h.scale :=
  h.target

theorem shell_gain_majorizes
    (osc : ℕ → ℝ) (h : K4ConditionalInput osc) (n : ℕ) :
    |osc n| ≤ h.data.shell n * k4Weight n :=
  h.gain n

theorem k4Weight_le_one (n : ℕ) : k4Weight n ≤ 1 := by
  exact pow_le_one₀ (by norm_num : 0 ≤ (1 / 2 : ℝ))
    (by norm_num : (1 / 2 : ℝ) ≤ 1)

theorem shell_gain_le_shell
    (osc : ℕ → ℝ) (h : K4ConditionalInput osc) (n : ℕ) :
    |osc n| ≤ h.data.shell n := by
  calc
    |osc n| ≤ h.data.shell n * k4Weight n := h.gain n
    _ ≤ h.data.shell n * 1 :=
      mul_le_mul_of_nonneg_left (k4Weight_le_one n) (h.data.hshell n)
    _ = h.data.shell n := by ring

def K4_DENSE_ASSEMBLY_STATUS : String := "MECHANICAL_GREEN_IF_COMPILED"
def K4_ENDPOINT_STATUS : String := "OPEN_MATH"
def K4_NEW_MACRO_GATES : Nat := 0

#print axioms k4Weight_nonneg
#print axioms k4Weight_summable
#print axioms k4Weight_square_tsum
#print axioms shell_gain_le_shell

end G1Audit
