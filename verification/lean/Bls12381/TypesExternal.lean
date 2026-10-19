import Aeneas
open Aeneas Aeneas.Std

/-! External representation models. These definitions are not a proof of subtle's Rust
implementation or its constant-time behavior. Choice's valid-input invariant is explicit. -/
@[rust_type "subtle::Choice"]
structure subtle.Choice where
  val : U8
  valid : val = 0#u8 ∨ val = 1#u8

@[rust_type "subtle::CtOption"]
structure subtle.CtOption (T : Type) where
  value : T
  is_some : subtle.Choice
