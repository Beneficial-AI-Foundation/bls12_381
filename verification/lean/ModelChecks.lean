import Bls12381.FunsExternal

open Aeneas Aeneas.Std Result Bls12381

/-! Regression checks for handwritten models, not Rust equivalence proofs. -/
private def no : subtle.Choice := ⟨0#u8, Or.inl rfl⟩
private def yes : subtle.Choice := ⟨1#u8, Or.inr rfl⟩
private def byteDefault : core.default.Default U8 := ⟨ok 0#u8⟩
private def byteSelect : subtle.ConditionallySelectable U8 where
  coremarkerCopyInst := core.marker.CopyU8
  conditional_select := U8.Insts.SubtleConditionallySelectable.conditional_select
  conditional_assign := U8.Insts.SubtleConditionallySelectable.conditional_select

-- Invalid Choice inputs must not be silently treated as true.
example : subtle.Choice.Insts.CoreConvertFromU8.from 2#u8 = fail .panic := by rfl
example : subtle.CtOption.unwrap (⟨9#u8, no⟩ : subtle.CtOption U8) = fail .panic := by rfl

-- CtOption::map calls its callback on the default dummy value even when absent.
example : subtle.CtOption.map byteDefault byteSelect
    (⟨fun (_ : Unit) (x : U8) => ok x⟩ : core.ops.function.FnOnce Unit U8 U8)
    ⟨9#u8, no⟩ () = ok ⟨0#u8, no⟩ := by rfl
example : subtle.CtOption.map byteDefault byteSelect
    (⟨fun (_ : Unit) (_ : U8) => fail .panic⟩ : core.ops.function.FnOnce Unit U8 U8)
    ⟨9#u8, no⟩ () = fail .panic := by rfl

-- CtOption::or_else also calls its callback when the existing value is present.
example : subtle.CtOption.or_else byteSelect
    (⟨fun (_ : Unit) (_ : Unit) => fail .panic⟩ :
      core.ops.function.FnOnce Unit Unit (subtle.CtOption U8))
    ⟨9#u8, yes⟩ () = fail .panic := by rfl

-- The G1 and G2 recommendation tables have different thresholds.
example : g1.G1Projective.Insts.GroupWnafWnafGroupScalarArrayU832.recommended_wnaf_for_num_scalars
    8#usize = ok 7#usize := by rfl
example : g2.G2Projective.Insts.GroupWnafWnafGroupScalarArrayU832.recommended_wnaf_for_num_scalars
    8#usize = ok 6#usize := by rfl
