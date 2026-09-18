import Lake
open Lake DSL

package «campanato-lean» where
  version := v!"0.1.0"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.32.1"

lean_lib IMath where
  srcDir := "Vendor"

lean_lib G1 where
  srcDir := "Core"
