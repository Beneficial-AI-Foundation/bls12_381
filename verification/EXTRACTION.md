# Aeneas 提取结果

2026-10-19，基线 `5d22dd74c2a14fb9f3d3b85ae2c39d0c669ddd99`。

已实际运行 Charon 和 Aeneas，并用 Lean 检查生成文件及外部接口。原始 `src/`、Cargo.toml、Cargo.lock 和 Rust 工具链配置没有修改；第一阶段的基线检查仍通过。

## 发布前复核（2026-10-19）

- `cargo test --locked --release --features experimental,zeroize`：Rust 1.85.0 下 115 个单元测试和 11 个集成测试全部通过，doc-tests 为 0。
- `cargo fmt -- --check`：通过。
- `python3 verification/scripts/check_scope.py`：23 个基线文件、19 个 Rust 模块、442 个词法函数条目一致；已证明数仍为 0。
- `python3 verification/scripts/check_lean.py` 及 `ModelChecks`：全部模块和模型回归检查通过。
- `python3 verification/scripts/extract.py`：Charon/Aeneas 均成功；重提取后的全部 7 个 Lean 源文件与重提取前 SHA-256 完全一致。
- 外部接口清单：55 个接口，包括 30 个未证明等价性的手写模型和 25 个未证明公理。

新增 GitHub Actions 工作流检查冻结基线及外部接口清单同步；Lean 检查和重提取仍需上述固定工具及缓存，未宣称已在 CI 中运行。此次本地测试不覆盖完整功能矩阵或跨平台构建，也不构成密码学审计或功能正确性证明。

## 当前可运行配置

| 项目 | 固定值 |
| --- | --- |
| Aeneas | `5d08da45a405913bbee6fd544e01debf8154ac9d` |
| Charon | `f5208b1c4ce287898a1fc015d41a20da3baf0974`（对应 charon-pin） |
| 提取 Rust | `nightly-2026-06-01`，rustc `14210df0e27ccd7d9e6a05b8085cbd438e4bbc65` |
| 目标 | `x86_64-unknown-linux-gnu` |
| Lean | `leanprover/lean4:v4.31.0` |
| Cargo | `--locked --no-default-features --features groups,pairings,alloc` |

复用了本机 `auto_verify_dalek/curve25519-dalek-u32` 已编译的匹配工具及 Lean 缓存，未修改该项目。用户指定的 `curve25519-dalek-lean-verify` 用作工程组织和外部接口处理的参考；其配置中的 Aeneas `6e167c9b` 与本次实际使用的版本不同，不能混用。

初次默认配置提取在 bits/bitvec 的 trait 签名处失败，故当前可用配置未启用 bits。experimental、zeroize、nightly 也未尝试；这不是默认全部 API 或全特性的转换成功报告。

## 文件与重现

- [lean/Bls12381/Types.lean](lean/Bls12381/Types.lean)：生成的 Rust 类型和 trait。
- [lean/Bls12381/Funs.lean](lean/Bls12381/Funs.lean)：生成的 1086 个 def/impl_def，计数含包装、闭包、常数及实例，不等于源码函数覆盖率。
- [lean/Bls12381/TypesExternal.lean](lean/Bls12381/TypesExternal.lean)：具体的 Choice/CtOption 表示。
- [lean/Bls12381/FunsExternal.lean](lean/Bls12381/FunsExternal.lean)：55 个外部函数接口；30 个有手写模型，25 个暂为未证明 axiom。另有一个 Eq 默认方法兼容定义。
- `*_Template.lean`：Aeneas 自动输出的原始接口模板，重提取不会覆盖手写文件。
- [external-functions.json](external-functions.json)：逐接口的 Rust 名称、源码位置、外部化原因和模型/公理状态。
- [config/extraction.json](config/extraction.json)：精确的 opaque/exclude 配置。

在本机仓库根目录运行：

```sh
python3 verification/scripts/check_scope.py
python3 verification/scripts/extract.py
python3 verification/scripts/check_lean.py
python3 verification/scripts/check_lean.py ModelChecks
```

`extract.py` 检查工具仓库 commit、执行 Charon/Aeneas、应用显式兼容补丁并核对外部接口清单。默认 offline，因为依赖已在首次联网提取时下载。新的机器需要先准备 Cargo.lock 对应的依赖缓存（或移除配置中的 `--offline` 进行首次下载），安装固定 Rust 工具链，构建固定 Aeneas 和对应 Charon，并设置 `AENEAS_ROOT`。

`check_lean.py` 用已有的只读 Aeneas/mathlib 编译缓存直接调用固定 Lean，所有本项目 `.olean` 均写入本目录。可用 `AENEAS_LEAN_CACHE` 指定另一份相同版本的缓存。独立构建可使用固定依赖的 Lake 工程：

```sh
cd verification/lean
lake build
lake env lean ModelChecks.lean
```

本次实际验证的是 `check_lean.py` 路径；未额外执行会下载整套依赖的独立 Lake 构建。源码等价性与数学正确性尚未证明。

## 本库外部化的函数

| Rust 函数 | 实测障碍 | FunsExternal 中当前处理 |
| --- | --- | --- |
| Scalar 的 `ff::Field::sqrt`、`sqrt_ratio` | 函数与 Field/PrimeField 实例形成混合互递归 | 2 个未证明接口 |
| G1/G2 `Group::try_random` | 随机点构造中的闭包/控制流触发内部错误 | 2 个未证明接口 |
| G1/G2 `multiply` | flat_map/map 返回捕获引用的闭包，转换失败 | 2 个未证明接口 |
| G1/G2 `batch_normalize` | mutable iterator 调用触发 Unreachable | 2 个未证明接口 |
| G1/G2 `recommended_wnaf_for_num_scalars` | 遍历静态数组时报告 nested borrows | 2 个具体阈值模型；分别使用原始 G1/G2 表 |
| `&Gt * &Scalar` | 同类嵌套迭代器闭包失败 | 1 个未证明接口 |
| Gt 的另外 3 个乘法包装 | 与主乘法共享 opaque 匹配范围 | 3 个转发到主乘法接口的定义，不声称这些包装本身不能转换 |
| `multi_miller_loop` | 内部 Adder 的 doubling/addition 方法含 nested borrows | 1 个未证明接口 |

共 15 个本库接口，其中 10 个是 axiom、5 个有手写定义。其余 40 个接口来自 core、subtle 和 ff 等依赖，其中 15 个仍为 axiom。

Charon 的当前 name matcher 尚未实现 inherent impl 类型匹配，所以 batch_normalize/multiply 使用模块级 `_` 路径；对已排除的 Curve::batch_normalize 另加精确排除，避免更精确的 opaque 规则重新引入孤立方法。

## 无法仅靠函数外部化解决的签名

`group::CurveAffine` 和 `group::Curve` 的关联类型约束让 Aeneas 在签名阶段报内部错误。当前排除了这些 trait 及对应 G1/G2 实例，并排除依赖它们的 PrimeCurve、PairingCurveAffine、Engine、MultiMillerLoop 包装实例。完整模式见配置文件。

这些排除项没有生成可直接填写的完整 Lean trait 接口，因此没有伪造为成功转换的 FunsExternal 函数。底层 G1/G2 固有运算、`pairings::pairing`、Miller loop、最终幂及 G2Prepared 构造仍参与提取；独立 `multi_miller_loop` 作为上述外部接口保留。被排除的 trait API 和 bits API 仍是明确缺口。

## 手写模型和信任边界

Choice 用带 0/1 证明的 U8 表示，CtOption 保留 value/is_some 两个字段。实现了布尔运算、相等比较、条件选择、构造、unwrap、unwrap_or、map、and_then、or_else，以及 Borrow 和部分 RangeFull 操作。

CtOption 的 map/and_then 在失败标志下仍调用回调，并传入默认 dummy 值；or_else 在已有值时仍调用备用回调。ModelChecks 对这些容易误写成 Option 短路语义的分支进行了检查，另外检查非法 Choice、unwrap 失败和 G1/G2 不同的 WNAF 阈值。Choice::from 的非法值在模型中失败，对应有效 0/1 输入的契约，不覆盖关闭 debug assertion 时非法 Rust 输入的行为。

所有手写模型目前都没有到原 Rust 的等价性证明。剩余 axiom 保留原始函数类型，不添加“该函数正确”的公理，也不以固定零值、`sorry` 或返回失败伪造实现。对这些接口的下游功能证明必须后续提供实现/规范及证明，或明确报告为条件性结论。

## 生成代码的兼容补丁

参考 dalek 工程的显式后处理方式，所有修改位于 [scripts/postprocess.py](scripts/postprocess.py)，精确匹配数量，变化时停止而非静默继续：

1. 转义参数名 `by` 为 `«by»`（4 处）。
2. 为 Eq 的默认空方法使用可展开定义，解决实例展开的循环字段（11 处）。
3. 删除 Rev Iterator 实例中 Aeneas 标准库没有的 map/fold/rev 字段；泛型 fold 调用改用显式外部接口（5 处）。这部分接口语义仍待验证。
4. 为 G2Prepared 内部 driver 的两处 Unit 返回值补回 `((), updated_state)`，匹配 trait 签名。

补丁不是数学正确性证明。原始诊断保存在 logs/aeneas-initial.log、aeneas-core.log、aeneas-body-failures.log；最终命令、退出码及兼容改动保存在 logs/run.json 和 postprocess.json。Lean 检查日志分别对应各模块。
