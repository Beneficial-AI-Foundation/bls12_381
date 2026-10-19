/-
External interfaces from the pinned Aeneas extraction, with manual models below.
Remaining `axiom` declarations are UNPROVED interfaces, not correctness theorems.
See ../../EXTRACTION.md and ../../external-functions.json for the boundary inventory.
Do not overwrite this file when regenerating FunsExternal_Template.lean.
-/
import Aeneas
import Bls12381.Types
open Aeneas Aeneas.Std Result ControlFlow Error
set_option linter.dupNamespace false
set_option linter.hashCommand false
set_option linter.unusedVariables false

/- You can set the `maxHeartbeats` value with the `-max-heartbeats` CLI option -/
set_option maxHeartbeats 1000000

/- You can set the `maxRecDepth` value with the `-max-recdepth` CLI option -/
set_option maxRecDepth 2048
open Bls12381
noncomputable section

private def choiceOfBool (b : Bool) : subtle.Choice :=
  if b then ⟨1#u8, Or.inr rfl⟩ else ⟨0#u8, Or.inl rfl⟩

@[trait_default]
def assert_fields_are_eq_trait_default {Self : Type} (_ : core.cmp.Eq Self) :
    Self → Result Unit := fun _ => ok ()

/-- [core::borrow::{impl core::borrow::Borrow<T> for T}::borrow]:
    Source: '/rustc/library/core/src/borrow.rs', lines 214:4-214:26
    Name pattern: [core::borrow::{core::borrow::Borrow<@T, @T>}::borrow]
    Visibility: public -/
@[rust_fun "core::borrow::{core::borrow::Borrow<@T, @T>}::borrow"]
def core.borrow.Borrow.Blanket.borrow {T : Type} : T → Result T :=
  fun x => ok x


/-- [core::borrow::{impl core::borrow::Borrow<T> for &'_0 T}::borrow]:
    Source: '/rustc/library/core/src/borrow.rs', lines 230:4-230:26
    Name pattern: [core::borrow::{core::borrow::Borrow<&'0 @T, @T>}::borrow]
    Visibility: public -/
@[rust_fun "core::borrow::{core::borrow::Borrow<&'0 @T, @T>}::borrow"]
def Shared0T.Insts.CoreBorrowBorrow.borrow {T : Type} : T → Result T :=
  fun x => ok x


/-- [core::fmt::{impl core::fmt::Debug for (V, U, T)}::fmt]:
    Source: '/rustc/library/core/src/fmt/mod.rs', lines 3089:16-3089:62
    Name pattern: [core::fmt::{core::fmt::Debug<(@V, @U, @T)>}::fmt]
    Visibility: public -/
@[rust_fun "core::fmt::{core::fmt::Debug<(@V, @U, @T)>}::fmt"]
axiom TupleVUT.Insts.CoreFmtDebug.fmt
  {V : Type} {U : Type} {T : Type} (DebugInst : core.fmt.Debug V) (DebugInst1 :
  core.fmt.Debug U) (DebugInst2 : core.fmt.Debug T) :
  (V × U × T) → core.fmt.Formatter → Result ((core.result.Result Unit
    core.fmt.Error) × core.fmt.Formatter)

/-- [core::fmt::{impl core::fmt::Debug for [T]}::fmt]:
    Source: '/rustc/library/core/src/fmt/mod.rs', lines 3122:4-3122:50
    Name pattern: [core::fmt::{core::fmt::Debug<[@T]>}::fmt]
    Visibility: public -/
@[rust_fun "core::fmt::{core::fmt::Debug<[@T]>}::fmt"]
axiom Slice.Insts.CoreFmtDebug.fmt
  {T : Type} (DebugInst : core.fmt.Debug T) :
  Slice T → core.fmt.Formatter → Result ((core.result.Result Unit
    core.fmt.Error) × core.fmt.Formatter)

/-- [core::fmt::num::{impl core::fmt::LowerHex for u8}::fmt]:
    Source: '/rustc/library/core/src/fmt/num.rs', lines 14:12-14:68
    Name pattern: [core::fmt::num::{core::fmt::LowerHex<u8>}::fmt]
    Visibility: public -/
@[rust_fun "core::fmt::num::{core::fmt::LowerHex<u8>}::fmt"]
axiom U8.Insts.CoreFmtLowerHex.fmt
  :
  Std.U8 → core.fmt.Formatter → Result ((core.result.Result Unit
    core.fmt.Error) × core.fmt.Formatter)

/-- [core::iter::traits::iterator::Iterator::map]:
    Source: '/rustc/library/core/src/iter/traits/iterator.rs', lines 831:4-834:34
    Name pattern: [core::iter::traits::iterator::Iterator::map]
    Visibility: public -/
@[trait_default, rust_fun "core::iter::traits::iterator::Iterator::map"]
axiom core.iter.traits.iterator.Iterator.map.default
  {Self : Type} {B : Type} {F : Type} {Clause0_Item : Type} (IteratorInst :
  core.iter.traits.iterator.Iterator Self Clause0_Item)
  (opsfunctionFnMutFTupleClause0_ItemBInst : core.ops.function.FnMut F
  Clause0_Item B) :
  Self → F → Result (core.iter.adapters.map.Map Self F)

/-- [core::iter::adapters::map::{impl core::iter::traits::iterator::Iterator<B> for core::iter::adapters::map::Map<I, F>}::next]:
    Source: '/rustc/library/core/src/iter/adapters/map.rs', lines 106:4-106:35
    Name pattern: [core::iter::adapters::map::{core::iter::traits::iterator::Iterator<core::iter::adapters::map::Map<@I, @F>, @B>}::next]
    Visibility: public -/
@[rust_fun
  "core::iter::adapters::map::{core::iter::traits::iterator::Iterator<core::iter::adapters::map::Map<@I, @F>, @B>}::next"]
axiom core.iter.adapters.map.Map.Insts.CoreIterTraitsIteratorIterator.next
  {B : Type} {I : Type} {F : Type} {Clause0_Item : Type}
  (traitsiteratorIteratorInst : core.iter.traits.iterator.Iterator I
  Clause0_Item) (opsfunctionFnMutFTupleClause0_ItemBInst :
  core.ops.function.FnMut F Clause0_Item B) :
  core.iter.adapters.map.Map I F → Result ((Option B) ×
    (core.iter.adapters.map.Map I F))

/-- [core::iter::adapters::rev::{impl core::iter::traits::iterator::Iterator<Clause0_Clause0_Item> for core::iter::adapters::rev::Rev<I>}::fold]:
    Source: '/rustc/library/core/src/iter/adapters/rev.rs', lines 79:4-81:41
    Name pattern: [core::iter::adapters::rev::{core::iter::traits::iterator::Iterator<core::iter::adapters::rev::Rev<@I>, @Clause0_Clause0_Item>}::fold]
    Visibility: public -/
@[rust_fun
  "core::iter::adapters::rev::{core::iter::traits::iterator::Iterator<core::iter::adapters::rev::Rev<@I>, @Clause0_Clause0_Item>}::fold"]
axiom core.iter.adapters.rev.Rev.Insts.CoreIterTraitsIteratorIterator.fold
  {I : Type} {Acc : Type} {F : Type} {Clause0_Clause0_Item : Type}
  (traitsdouble_endedDoubleEndedIteratorInst :
  core.iter.traits.double_ended.DoubleEndedIterator I Clause0_Clause0_Item)
  (opsfunctionFnMutFPairAccInst : core.ops.function.FnMut F (Acc ×
  Clause0_Clause0_Item) Acc) :
  core.iter.adapters.rev.Rev I → Acc → F → Result Acc

/-- [core::iter::traits::iterator::Iterator::fold]:
    Source: '/rustc/library/core/src/iter/traits/iterator.rs', lines 2664:4-2667:64
    Name pattern: [core::iter::traits::iterator::Iterator::fold]
    Visibility: public -/
@[trait_default, rust_fun "core::iter::traits::iterator::Iterator::fold"]
axiom core.iter.traits.iterator.Iterator.fold.default
  {Self : Type} {B : Type} {F : Type} {Clause0_Item : Type} (IteratorInst :
  core.iter.traits.iterator.Iterator Self Clause0_Item)
  (opsfunctionFnMutFPairBInst : core.ops.function.FnMut F (B × Clause0_Item)
  B) :
  Self → B → F → Result B

/-- [core::slice::index::{impl core::slice::index::SliceIndex<[T], [T]> for core::ops::range::RangeFull}::index_mut]:
    Source: '/rustc/library/core/src/slice/index.rs', lines 660:4-660:51
    Name pattern: [core::slice::index::{core::slice::index::SliceIndex<core::ops::range::RangeFull, [@T], [@T]>}::index_mut]
    Visibility: public -/
@[rust_fun
  "core::slice::index::{core::slice::index::SliceIndex<core::ops::range::RangeFull, [@T], [@T]>}::index_mut"]
def core.ops.range.RangeFull.Insts.CoreSliceIndexSliceIndexSliceSlice.index_mut
  {T : Type} :
  core.ops.range.RangeFull → Slice T → Result ((Slice T) × (Slice T →
    Slice T)) :=
  fun _ s => ok (s, id)


/-- [core::slice::index::{impl core::slice::index::SliceIndex<[T], [T]> for core::ops::range::RangeFull}::index]:
    Source: '/rustc/library/core/src/slice/index.rs', lines 655:4-655:39
    Name pattern: [core::slice::index::{core::slice::index::SliceIndex<core::ops::range::RangeFull, [@T], [@T]>}::index]
    Visibility: public -/
@[rust_fun
  "core::slice::index::{core::slice::index::SliceIndex<core::ops::range::RangeFull, [@T], [@T]>}::index"]
def core.ops.range.RangeFull.Insts.CoreSliceIndexSliceIndexSliceSlice.index
  {T : Type} : core.ops.range.RangeFull → Slice T → Result (Slice T) :=
  fun _ s => ok s


/-- [core::slice::index::{impl core::slice::index::SliceIndex<[T], [T]> for core::ops::range::RangeFull}::get_unchecked_mut]:
    Source: '/rustc/library/core/src/slice/index.rs', lines 650:4-650:66
    Name pattern: [core::slice::index::{core::slice::index::SliceIndex<core::ops::range::RangeFull, [@T], [@T]>}::get_unchecked_mut]
    Visibility: public -/
@[rust_fun
  "core::slice::index::{core::slice::index::SliceIndex<core::ops::range::RangeFull, [@T], [@T]>}::get_unchecked_mut"]
axiom
  core.ops.range.RangeFull.Insts.CoreSliceIndexSliceIndexSliceSlice.get_unchecked_mut
  {T : Type} :
  core.ops.range.RangeFull → MutRawPtr (Slice T) → Result (MutRawPtr (Slice
    T))

/-- [core::slice::index::{impl core::slice::index::SliceIndex<[T], [T]> for core::ops::range::RangeFull}::get_unchecked]:
    Source: '/rustc/library/core/src/slice/index.rs', lines 645:4-645:66
    Name pattern: [core::slice::index::{core::slice::index::SliceIndex<core::ops::range::RangeFull, [@T], [@T]>}::get_unchecked]
    Visibility: public -/
@[rust_fun
  "core::slice::index::{core::slice::index::SliceIndex<core::ops::range::RangeFull, [@T], [@T]>}::get_unchecked"]
axiom
  core.ops.range.RangeFull.Insts.CoreSliceIndexSliceIndexSliceSlice.get_unchecked
  {T : Type} :
  core.ops.range.RangeFull → ConstRawPtr (Slice T) → Result (ConstRawPtr
    (Slice T))

/-- [core::slice::index::{impl core::slice::index::SliceIndex<[T], [T]> for core::ops::range::RangeFull}::get_mut]:
    Source: '/rustc/library/core/src/slice/index.rs', lines 640:4-640:57
    Name pattern: [core::slice::index::{core::slice::index::SliceIndex<core::ops::range::RangeFull, [@T], [@T]>}::get_mut]
    Visibility: public -/
@[rust_fun
  "core::slice::index::{core::slice::index::SliceIndex<core::ops::range::RangeFull, [@T], [@T]>}::get_mut"]
def core.ops.range.RangeFull.Insts.CoreSliceIndexSliceIndexSliceSlice.get_mut
  {T : Type} :
  core.ops.range.RangeFull → Slice T → Result ((Option (Slice T)) ×
    (Option (Slice T) → Slice T)) :=
  fun _ s => ok (some s, fun x => x.getD s)


/-- [core::slice::index::{impl core::slice::index::SliceIndex<[T], [T]> for core::ops::range::RangeFull}::get]:
    Source: '/rustc/library/core/src/slice/index.rs', lines 635:4-635:45
    Name pattern: [core::slice::index::{core::slice::index::SliceIndex<core::ops::range::RangeFull, [@T], [@T]>}::get]
    Visibility: public -/
@[rust_fun
  "core::slice::index::{core::slice::index::SliceIndex<core::ops::range::RangeFull, [@T], [@T]>}::get"]
def core.ops.range.RangeFull.Insts.CoreSliceIndexSliceIndexSliceSlice.get
  {T : Type} :
  core.ops.range.RangeFull → Slice T → Result (Option (Slice T)) :=
  fun _ s => ok (some s)


/-- [core::slice::iter::{impl core::iter::traits::iterator::Iterator<&'a T> for core::slice::iter::Iter<'a, T>}::fold]:
    Source: '/rustc/library/core/src/slice/iter/macros.rs', lines 259:12-261:49
    Name pattern: [core::slice::iter::{core::iter::traits::iterator::Iterator<core::slice::iter::Iter<'a, @T>, &'a @T>}::fold]
    Visibility: public -/
@[rust_fun
  "core::slice::iter::{core::iter::traits::iterator::Iterator<core::slice::iter::Iter<'a, @T>, &'a @T>}::fold"]
axiom core.slice.iter.Iter.Insts.CoreIterTraitsIteratorIteratorSharedAT.fold
  {T : Type} {B : Type} {F : Type} (opsfunctionFnMutFPairBSharedATBInst :
  core.ops.function.FnMut F (B × T) B) :
  core.slice.iter.Iter T → B → F → Result B

/-- [core::slice::iter::{impl core::iter::traits::double_ended::DoubleEndedIterator<&'_ T> for core::slice::iter::Iter<'a, T>}::next_back]:
    Source: '/rustc/library/core/src/slice/iter/macros.rs', lines 438:12-438:52
    Name pattern: [core::slice::iter::{core::iter::traits::double_ended::DoubleEndedIterator<core::slice::iter::Iter<'a, @T>, &'_ @T>}::next_back]
    Visibility: public -/
@[rust_fun
  "core::slice::iter::{core::iter::traits::double_ended::DoubleEndedIterator<core::slice::iter::Iter<'a, @T>, &'_ @T>}::next_back"]
axiom
  core.slice.iter.Iter.Insts.CoreIterTraitsDouble_endedDoubleEndedIteratorSharedT.next_back
  {T : Type} :
  core.slice.iter.Iter T → Result ((Option T) × (core.slice.iter.Iter T))

/-- [ff::Field::is_zero_vartime]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/ff-0.14.0/src/lib.rs', lines 105:4-105:37
    Name pattern: [ff::Field::is_zero_vartime]
    Visibility: public -/
@[trait_default, rust_fun "ff::Field::is_zero_vartime"]
axiom ff.Field.is_zero_vartime.default
  {Self : Type} (FieldInst : ff.Field Self) : Self → Result Bool

/-- [ff::Field::sqrt]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/ff-0.14.0/src/lib.rs', lines 158:4-158:36
    Name pattern: [ff::Field::sqrt]
    Visibility: public -/
@[trait_default, rust_fun "ff::Field::sqrt"]
axiom ff.Field.sqrt.default
  {Self : Type} (FieldInst : ff.Field Self) :
  Self → Result (subtle.CtOption Self)

/-- [subtle::{impl core::clone::Clone for subtle::Choice}::clone]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 119:15-119:20
    Name pattern: [subtle::{core::clone::Clone<subtle::Choice>}::clone]
    Visibility: public -/
@[rust_fun "subtle::{core::clone::Clone<subtle::Choice>}::clone"]
def subtle.Choice.Insts.CoreCloneClone.clone
  : subtle.Choice → Result subtle.Choice :=
  fun x => ok x


/-- [subtle::{impl core::fmt::Debug for subtle::Choice}::fmt]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 119:22-119:27
    Name pattern: [subtle::{core::fmt::Debug<subtle::Choice>}::fmt]
    Visibility: public -/
@[rust_fun "subtle::{core::fmt::Debug<subtle::Choice>}::fmt"]
axiom subtle.Choice.Insts.CoreFmtDebug.fmt
  :
  subtle.Choice → core.fmt.Formatter → Result ((core.result.Result Unit
    core.fmt.Error) × core.fmt.Formatter)

/-- [subtle::{impl core::convert::From<subtle::Choice> for bool}::from]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 153:4-153:35
    Name pattern: [subtle::{core::convert::From<bool, subtle::Choice>}::from]
    Visibility: public -/
@[rust_fun "subtle::{core::convert::From<bool, subtle::Choice>}::from"]
def Bool.Insts.CoreConvertFromChoice.from : subtle.Choice → Result Bool :=
  fun x => ok (x.val == 1#u8)


/-- [subtle::{impl core::ops::bit::BitAnd<subtle::Choice, subtle::Choice> for subtle::Choice}::bitand]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 162:4-162:42
    Name pattern: [subtle::{core::ops::bit::BitAnd<subtle::Choice, subtle::Choice, subtle::Choice>}::bitand]
    Visibility: public -/
@[rust_fun
  "subtle::{core::ops::bit::BitAnd<subtle::Choice, subtle::Choice, subtle::Choice>}::bitand"]
def subtle.Choice.Insts.CoreOpsBitBitAndChoiceChoice.bitand
  : subtle.Choice → subtle.Choice → Result subtle.Choice :=
  fun a b => ok (choiceOfBool (a.val == 1#u8 && b.val == 1#u8))


/-- [subtle::{impl core::ops::bit::BitOr<subtle::Choice, subtle::Choice> for subtle::Choice}::bitor]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 177:4-177:41
    Name pattern: [subtle::{core::ops::bit::BitOr<subtle::Choice, subtle::Choice, subtle::Choice>}::bitor]
    Visibility: public -/
@[rust_fun
  "subtle::{core::ops::bit::BitOr<subtle::Choice, subtle::Choice, subtle::Choice>}::bitor"]
def subtle.Choice.Insts.CoreOpsBitBitOrChoiceChoice.bitor
  : subtle.Choice → subtle.Choice → Result subtle.Choice :=
  fun a b => ok (choiceOfBool (a.val == 1#u8 || b.val == 1#u8))


/-- [subtle::{impl core::ops::bit::BitXor<subtle::Choice, subtle::Choice> for subtle::Choice}::bitxor]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 192:4-192:42
    Name pattern: [subtle::{core::ops::bit::BitXor<subtle::Choice, subtle::Choice, subtle::Choice>}::bitxor]
    Visibility: public -/
@[rust_fun
  "subtle::{core::ops::bit::BitXor<subtle::Choice, subtle::Choice, subtle::Choice>}::bitxor"]
def subtle.Choice.Insts.CoreOpsBitBitXorChoiceChoice.bitxor
  : subtle.Choice → subtle.Choice → Result subtle.Choice :=
  fun a b => ok (choiceOfBool (a.val != b.val))


/-- [subtle::{impl core::ops::bit::Not<subtle::Choice> for subtle::Choice}::not]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 207:4-207:26
    Name pattern: [subtle::{core::ops::bit::Not<subtle::Choice, subtle::Choice>}::not]
    Visibility: public -/
@[rust_fun
  "subtle::{core::ops::bit::Not<subtle::Choice, subtle::Choice>}::not"]
def subtle.Choice.Insts.CoreOpsBitNotChoice.not
  : subtle.Choice → Result subtle.Choice :=
  fun a => ok (choiceOfBool (a.val == 0#u8))


/-- [subtle::{impl core::convert::From<u8> for subtle::Choice}::from]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 238:4-238:32
    Name pattern: [subtle::{core::convert::From<subtle::Choice, u8>}::from]
    Visibility: public -/
@[rust_fun "subtle::{core::convert::From<subtle::Choice, u8>}::from"]
def subtle.Choice.Insts.CoreConvertFromU8.from
  : Std.U8 → Result subtle.Choice :=
  fun x => if h : x = 0#u8 ∨ x = 1#u8 then ok ⟨x, h⟩ else fail .panic


/-- [subtle::{impl subtle::ConstantTimeEq for [T]}::ct_eq]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 313:4-313:41
    Name pattern: [subtle::{subtle::ConstantTimeEq<[@T]>}::ct_eq]
    Visibility: public -/
@[rust_fun "subtle::{subtle::ConstantTimeEq<[@T]>}::ct_eq"]
axiom Slice.Insts.SubtleConstantTimeEq.ct_eq
  {T : Type} (ConstantTimeEqInst : subtle.ConstantTimeEq T) :
  Slice T → Slice T → Result subtle.Choice

/-- [subtle::{impl subtle::ConstantTimeEq for u8}::ct_eq]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 348:12-348:51
    Name pattern: [subtle::{subtle::ConstantTimeEq<u8>}::ct_eq]
    Visibility: public -/
@[rust_fun "subtle::{subtle::ConstantTimeEq<u8>}::ct_eq"]
def U8.Insts.SubtleConstantTimeEq.ct_eq
  : Std.U8 → Std.U8 → Result subtle.Choice :=
  fun a b => ok (choiceOfBool (a == b))


/-- [subtle::{impl subtle::ConstantTimeEq for u64}::ct_eq]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 348:12-348:51
    Name pattern: [subtle::{subtle::ConstantTimeEq<u64>}::ct_eq]
    Visibility: public -/
@[rust_fun "subtle::{subtle::ConstantTimeEq<u64>}::ct_eq"]
def U64.Insts.SubtleConstantTimeEq.ct_eq
  : Std.U64 → Std.U64 → Result subtle.Choice :=
  fun a b => ok (choiceOfBool (a == b))


/-- [subtle::ConditionallySelectable::conditional_assign]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 442:4-442:66
    Name pattern: [subtle::ConditionallySelectable::conditional_assign]
    Visibility: public -/
@[trait_default, rust_fun
  "subtle::ConditionallySelectable::conditional_assign"]
def subtle.ConditionallySelectable.conditional_assign.default
  {Self : Type} (ConditionallySelectableInst : subtle.ConditionallySelectable
  Self) :
  Self → Self → subtle.Choice → Result Self :=
  fun a b c => ConditionallySelectableInst.conditional_select a b c


/-- [subtle::{impl subtle::ConditionallySelectable for u64}::conditional_select]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 513:12-513:77
    Name pattern: [subtle::{subtle::ConditionallySelectable<u64>}::conditional_select]
    Visibility: public -/
@[rust_fun
  "subtle::{subtle::ConditionallySelectable<u64>}::conditional_select"]
def U64.Insts.SubtleConditionallySelectable.conditional_select
  : Std.U64 → Std.U64 → subtle.Choice → Result Std.U64 :=
  fun a b c => ok (if c.val = 1#u8 then b else a)


/-- [subtle::{impl subtle::ConditionallySelectable for u8}::conditional_select]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 513:12-513:77
    Name pattern: [subtle::{subtle::ConditionallySelectable<u8>}::conditional_select]
    Visibility: public -/
@[rust_fun "subtle::{subtle::ConditionallySelectable<u8>}::conditional_select"]
def U8.Insts.SubtleConditionallySelectable.conditional_select
  : Std.U8 → Std.U8 → subtle.Choice → Result Std.U8 :=
  fun a b c => ok (if c.val = 1#u8 then b else a)


/-- [subtle::{impl subtle::ConditionallySelectable for subtle::Choice}::conditional_select]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 570:4-570:69
    Name pattern: [subtle::{subtle::ConditionallySelectable<subtle::Choice>}::conditional_select]
    Visibility: public -/
@[rust_fun
  "subtle::{subtle::ConditionallySelectable<subtle::Choice>}::conditional_select"]
def subtle.Choice.Insts.SubtleConditionallySelectable.conditional_select
  : subtle.Choice → subtle.Choice → subtle.Choice → Result subtle.Choice :=
  fun a b c => ok (if c.val = 1#u8 then b else a)


/-- [subtle::{subtle::CtOption<T>}::new]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 678:4-678:56
    Name pattern: [subtle::{subtle::CtOption<@T>}::new]
    Visibility: public -/
@[rust_fun "subtle::{subtle::CtOption<@T>}::new"]
def subtle.CtOption.new
  {T : Type} : T → subtle.Choice → Result (subtle.CtOption T) :=
  fun value is_some => ok ⟨value, is_some⟩


/-- [subtle::{subtle::CtOption<T>}::unwrap]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 700:4-700:28
    Name pattern: [subtle::{subtle::CtOption<@T>}::unwrap]
    Visibility: public -/
@[rust_fun "subtle::{subtle::CtOption<@T>}::unwrap"]
def subtle.CtOption.unwrap {T : Type} : subtle.CtOption T → Result T :=
  fun x => if x.is_some.val = 1#u8 then ok x.value else fail .panic


/-- [subtle::{subtle::CtOption<T>}::unwrap_or]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 709:4-711:35
    Name pattern: [subtle::{subtle::CtOption<@T>}::unwrap_or]
    Visibility: public -/
@[rust_fun "subtle::{subtle::CtOption<@T>}::unwrap_or"]
def subtle.CtOption.unwrap_or
  {T : Type} (ConditionallySelectableInst : subtle.ConditionallySelectable T) :
  subtle.CtOption T → T → Result T :=
  fun x other => ConditionallySelectableInst.conditional_select other x.value x.is_some


/-- [subtle::{subtle::CtOption<T>}::map]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 751:4-754:26
    Name pattern: [subtle::{subtle::CtOption<@T>}::map]
    Visibility: public -/
@[rust_fun "subtle::{subtle::CtOption<@T>}::map"]
def subtle.CtOption.map
  {T : Type} {U : Type} {F : Type} (coredefaultDefaultInst :
  core.default.Default T) (ConditionallySelectableInst :
  subtle.ConditionallySelectable T) (coreopsfunctionFnOnceFTupleTUInst :
  core.ops.function.FnOnce F T U) :
  subtle.CtOption T → F → Result (subtle.CtOption U) :=
  fun x f => do
    let d ← coredefaultDefaultInst.default
    let v ← ConditionallySelectableInst.conditional_select d x.value x.is_some
    let y ← coreopsfunctionFnOnceFTupleTUInst.call_once f v
    ok ⟨y, x.is_some⟩


/-- [subtle::{subtle::CtOption<T>}::and_then]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 774:4-777:36
    Name pattern: [subtle::{subtle::CtOption<@T>}::and_then]
    Visibility: public -/
@[rust_fun "subtle::{subtle::CtOption<@T>}::and_then"]
def subtle.CtOption.and_then
  {T : Type} {U : Type} {F : Type} (coredefaultDefaultInst :
  core.default.Default T) (ConditionallySelectableInst :
  subtle.ConditionallySelectable T) (coreopsfunctionFnOnceFTupleTCtOptionInst :
  core.ops.function.FnOnce F T (subtle.CtOption U)) :
  subtle.CtOption T → F → Result (subtle.CtOption U) :=
  fun x f => do
    let d ← coredefaultDefaultInst.default
    let v ← ConditionallySelectableInst.conditional_select d x.value x.is_some
    let y ← coreopsfunctionFnOnceFTupleTCtOptionInst.call_once f v
    let flag ← subtle.Choice.Insts.CoreOpsBitBitAndChoiceChoice.bitand y.is_some x.is_some
    ok ⟨y.value, flag⟩


/-- [subtle::{subtle::CtOption<T>}::or_else]:
    Source: '/cargo/registry/src/index.crates.io-1949cf8c6b5b557f/subtle-2.6.1/src/lib.rs', lines 792:4-795:35
    Name pattern: [subtle::{subtle::CtOption<@T>}::or_else]
    Visibility: public -/
@[rust_fun "subtle::{subtle::CtOption<@T>}::or_else"]
def subtle.CtOption.or_else
  {T : Type} {F : Type} (ConditionallySelectableInst :
  subtle.ConditionallySelectable T) (coreopsfunctionFnOnceFTupleCtOptionInst :
  core.ops.function.FnOnce F Unit (subtle.CtOption T)) :
  subtle.CtOption T → F → Result (subtle.CtOption T) :=
  fun x f => do
    let y ← coreopsfunctionFnOnceFTupleCtOptionInst.call_once f ()
    let flag ← subtle.Choice.Insts.CoreOpsBitNotChoice.not x.is_some
    let v ← ConditionallySelectableInst.conditional_select x.value y.value flag
    let present := if flag.val = 1#u8 then y.is_some else x.is_some
    ok ⟨v, present⟩


/-- [bls12_381::g1::{bls12_381::g1::G1Projective}::multiply]:
    Source: 'src/g1.rs', lines 754:4-774:5 -/
axiom g1.G1Projective.multiply
  : g1.G1Projective → Array Std.U8 32#usize → Result g1.G1Projective

/-- [bls12_381::g1::{bls12_381::g1::G1Projective}::batch_normalize]:
    Source: 'src/g1.rs', lines 806:4-839:5
    Visibility: public -/
axiom g1.G1Projective.batch_normalize
  : Slice g1.G1Projective → Slice g1.G1Affine → Result (Slice g1.G1Affine)

/-- [bls12_381::scalar::{impl ff::Field for bls12_381::scalar::Scalar}::sqrt]:
    Source: 'src/scalar.rs', lines 670:4-681:5
    Visibility: public -/
axiom scalar.Scalar.Insts.FfField.sqrt
  : scalar.Scalar → Result (subtle.CtOption scalar.Scalar)

/-- [bls12_381::scalar::{impl ff::Field for bls12_381::scalar::Scalar}::sqrt_ratio]:
    Source: 'src/scalar.rs', lines 666:4-668:5
    Visibility: public -/
axiom scalar.Scalar.Insts.FfField.sqrt_ratio
  : scalar.Scalar → scalar.Scalar → Result (subtle.Choice × scalar.Scalar)

/-- [bls12_381::g1::{impl group::Group<bls12_381::scalar::Scalar, [u8; 32usize]> for bls12_381::g1::G1Projective}::try_random]:
    Source: 'src/g1.rs', lines 948:4-968:5
    Visibility: public -/
axiom g1.G1Projective.Insts.GroupGroupScalarArrayU832.try_random
  {R : Type} {Clause0_Error : Type} (rand_coreTryRngInst : rand_core.TryRng R
  Clause0_Error) :
  R → Result ((core.result.Result g1.G1Projective Clause0_Error) × R)

/-- [bls12_381::g1::{impl group::wnaf::WnafGroup<bls12_381::scalar::Scalar, [u8; 32usize]> for bls12_381::g1::G1Projective}::recommended_wnaf_for_num_scalars]:
    Source: 'src/g1.rs', lines 990:4-1004:5
    Visibility: public -/
def g1.G1Projective.Insts.GroupWnafWnafGroupScalarArrayU832.recommended_wnaf_for_num_scalars
  : Std.Usize → Result Std.Usize :=
  fun n =>
    if n.val ≤ 1 then ok 4#usize else
    if n.val ≤ 3 then ok 5#usize else
    if n.val ≤ 7 then ok 6#usize else
    if n.val ≤ 20 then ok 7#usize else
    if n.val ≤ 43 then ok 8#usize else
    if n.val ≤ 120 then ok 9#usize else
    if n.val ≤ 273 then ok 10#usize else
    if n.val ≤ 563 then ok 11#usize else
    if n.val ≤ 1630 then ok 12#usize else
    if n.val ≤ 3128 then ok 13#usize else
    if n.val ≤ 7933 then ok 14#usize else
    if n.val ≤ 62569 then ok 15#usize else
    ok 16#usize


/-- [bls12_381::g2::{bls12_381::g2::G2Projective}::multiply]:
    Source: 'src/g2.rs', lines 825:4-845:5 -/
axiom g2.G2Projective.multiply
  : g2.G2Projective → Slice Std.U8 → Result g2.G2Projective

/-- [bls12_381::g2::{bls12_381::g2::G2Projective}::batch_normalize]:
    Source: 'src/g2.rs', lines 951:4-984:5
    Visibility: public -/
axiom g2.G2Projective.batch_normalize
  : Slice g2.G2Projective → Slice g2.G2Affine → Result (Slice g2.G2Affine)

/-- [bls12_381::g2::{impl group::Group<bls12_381::scalar::Scalar, [u8; 32usize]> for bls12_381::g2::G2Projective}::try_random]:
    Source: 'src/g2.rs', lines 1093:4-1113:5
    Visibility: public -/
axiom g2.G2Projective.Insts.GroupGroupScalarArrayU832.try_random
  {R : Type} {Clause0_Error : Type} (rand_coreTryRngInst : rand_core.TryRng R
  Clause0_Error) :
  R → Result ((core.result.Result g2.G2Projective Clause0_Error) × R)

/-- [bls12_381::g2::{impl group::wnaf::WnafGroup<bls12_381::scalar::Scalar, [u8; 32usize]> for bls12_381::g2::G2Projective}::recommended_wnaf_for_num_scalars]:
    Source: 'src/g2.rs', lines 1135:4-1148:5
    Visibility: public -/
def g2.G2Projective.Insts.GroupWnafWnafGroupScalarArrayU832.recommended_wnaf_for_num_scalars
  : Std.Usize → Result Std.Usize :=
  fun n =>
    if n.val ≤ 1 then ok 4#usize else
    if n.val ≤ 3 then ok 5#usize else
    if n.val ≤ 8 then ok 6#usize else
    if n.val ≤ 20 then ok 7#usize else
    if n.val ≤ 47 then ok 8#usize else
    if n.val ≤ 126 then ok 9#usize else
    if n.val ≤ 260 then ok 10#usize else
    if n.val ≤ 826 then ok 11#usize else
    if n.val ≤ 1501 then ok 12#usize else
    if n.val ≤ 4555 then ok 13#usize else
    if n.val ≤ 84071 then ok 14#usize else
    ok 15#usize


/-- [bls12_381::pairings::{impl core::ops::arith::Mul<&'b bls12_381::scalar::Scalar, bls12_381::pairings::Gt> for &'_1 bls12_381::pairings::Gt}::mul]:
    Source: 'src/pairings.rs', lines 298:4-319:5
    Visibility: public -/
axiom Shared0Gt.Insts.CoreOpsArithMulSharedBScalarGt.mul
  : pairings.Gt → scalar.Scalar → Result pairings.Gt

/-- [bls12_381::pairings::{impl core::ops::arith::Mul<bls12_381::scalar::Scalar, bls12_381::pairings::Gt> for bls12_381::pairings::Gt}::mul]:
    Source: 'src/util.rs', lines 115:12-117:13
    Visibility: public -/
def pairings.Gt.Insts.CoreOpsArithMulScalarGt.mul
  : pairings.Gt → scalar.Scalar → Result pairings.Gt :=
  Shared0Gt.Insts.CoreOpsArithMulSharedBScalarGt.mul


/-- [bls12_381::pairings::{impl core::ops::arith::Mul<&'b bls12_381::scalar::Scalar, bls12_381::pairings::Gt> for bls12_381::pairings::Gt}::mul]:
    Source: 'src/util.rs', lines 97:12-99:13
    Visibility: public -/
def pairings.Gt.Insts.CoreOpsArithMulSharedBScalarGt.mul
  : pairings.Gt → scalar.Scalar → Result pairings.Gt :=
  Shared0Gt.Insts.CoreOpsArithMulSharedBScalarGt.mul


/-- [bls12_381::pairings::multi_miller_loop]:
    Source: 'src/pairings.rs', lines 552:0-601:1
    Visibility: public -/
axiom pairings.multi_miller_loop
  :
  Slice (g1.G1Affine × pairings.G2Prepared) → Result
    pairings.MillerLoopResult

/-- [bls12_381::pairings::{impl core::ops::arith::Mul<bls12_381::scalar::Scalar, bls12_381::pairings::Gt> for &'a bls12_381::pairings::Gt}::mul]:
    Source: 'src/util.rs', lines 106:12-108:13
    Visibility: public -/
def SharedAGt.Insts.CoreOpsArithMulScalarGt.mul
  : pairings.Gt → scalar.Scalar → Result pairings.Gt :=
  Shared0Gt.Insts.CoreOpsArithMulSharedBScalarGt.mul

