# 验证范围、规范与验收合同

## 基线与状态

基线提交为 `5d22dd74c2a14fb9f3d3b85ae2c39d0c669ddd99`，crate 0.9.0，edition 2024，仓库工具链 1.85.0。baseline.json 固定 src 下所有 Rust 文件、Cargo.toml、Cargo.lock、rust-toolchain.toml 及 README.md 的散列。源码基线建立时工作区干净。

第一阶段完成范围定义和初始函数登记。后续已执行核心配置提取、Lean 编译检查及 Rust 回归测试，具体范围见 [EXTRACTION.md](EXTRACTION.md)；尚未证明 Rust 功能正确性。coverage.json 保留第一阶段的词法清单，proof_status 全为 not_started，不能计算为已验证覆盖率；提取状态和外部接口另见 external-functions.json。

初始函数清单以 `文件:行号:名称` 区分同名 trait 方法，记录源码签名起始行和合同引用。扫描每个实现文件首个测试区域之前的函数声明，包含私有、嵌套、trait 声明及宏模板中的函数；保留模板而不伪装成展开实例。测试区域起点写在清单内。此规则是针对当前文件布局的词法登记，不是 Rust 解析器，也不证明可达性完备。第二步必须以 Charon 结果补齐 derive、宏实例、默认 trait 方法和外部依赖，并审计 cfg。

## 功能配置

| 配置 ID | Cargo 功能选择 | 目标 |
| --- | --- | --- |
| scalar | --no-default-features | util、Scalar 及依赖闭包 |
| groups | --no-default-features --features groups | 加入 Fp/Fp2/Fp6/Fp12、G1/G2 |
| pairings | --no-default-features --features pairings | 加入无 alloc 的配对 |
| default | 默认 groups,pairings,alloc,bits | 首个完整产品验证目标，含 G2Prepared/multi_miller_loop |
| experimental | 默认 + experimental | 消息扩展及 hash-to-curve |
| zeroize | 默认 + zeroize | 擦除 API 的抽象状态语义 |
| nightly | 默认 + nightly | 单独提取审计 subtle/nightly 差异 |

已选定 x86_64-unknown-linux-gnu 作为首次提取平台；bits 的非 64 位分支单列义务，不能用 64 位证明覆盖。组合功能中改变实现的 cfg 分支均须补入矩阵。已提取 groups,pairings,alloc 核心组合并检查其 Lean 模型；此表所列完整配置尚未取得功能正确性证明。

## 数学解释和共享不变量

令 B=2^64，L(a)=Σ a[i] B^i，p 为 Fp 模数，r 为 Scalar 模数。p/r 的数值以源码常数为输入，并与 README 的曲线参数独立核对；素性和常数关系是待证明义务。

- FIELD：Scalar 的 R=B^4，Fp 的 R=B^6；规范表示满足 0≤L(a)<m，decode(a)=L(a)·R⁻¹ mod m，m 分别为 r/p。所有有效构造路径建立此不变量。
- EXTENSION：Fp2=Fp[u]/(u²+1)，Fp6=Fp2[v]/(v³−(u+1))，Fp12=Fp6[w]/(w²−v)。每个系数满足 FIELD，关系和常数须与源码核对并证明不可约性。
- CURVE：G1 对应 y²=x³+4；G2 对应 y²=x³+4(u+1)。射影坐标按实现的齐次解释连接仿射坐标（Z≠0 时 x=X/Z、y=Y/Z），另定义无穷远点。曲线上合法与阶 r 子群合法是不同谓词。
- TARGET：Gt 是 Fp12 非零元素中满足 x^r=1 的子群，API 的加法对应域乘法，取负对应求逆，标量乘对应幂。
- CHOICE：有效 Choice 表示 0/1；CtOption 的存在标志和有效载荷分开建模。失败分支不凭空要求载荷满足成功分支的数学规范。

## 函数合同

coverage.json 每条函数记录引用以下合同 ID。合同是待证明目标，不是已建立事实。函数专有的参数界、算法不变量在证明阶段细化，并列入定理前提；不能为绕开反例任意收紧公开 API 的文档契约。

| ID | 函数或类别 | 前置条件 | 数学规范 / 后置条件 |
| --- | --- | --- | --- |
| WORD | adc/mac/sbb | 任意 u64 输入 | adc: lo+B·hi=a+b+carry；mac: lo+B·hi=a+b·c+carry；sbb: 令 d=a−b−floor(borrow/2^63)，lo=d mod B，hi 在 d<0 时为 B−1，否则为 0。证明 u128 中间计算符合语义 |
| FIELD | 域算术、构造、转换 | 域输入满足规范表示；原始整数构造按各自语义 | decode 与对应模运算一致且输出规范；0/1、默认值、常数及比较正确；Scalar::from_raw 是普通整数到 Montgomery 的转换，不同于 Fp::from_raw_unchecked |
| RAW | Fp::from_raw_unchecked | 位复制本身可接受任意数组；后续域运算需要 L(v)<p | 返回 v 的原始 Montgomery 表示；不能从此构造无条件推出规范表示 |
| REDUCE | montgomery_reduce/subtract_p | 来自调用者的精确整数上界，待逐调用证明 | reduction 与乘 R⁻¹ 模 m 一致且结果规范；subtract_p 需证明一次减法足够，不对任意多 limb 输入宣称规范化 |
| PRODUCTS | Fp::sum_of_products | 元素规范；T 的允许界待推导 | decode(result)=Σ decode(a[i])·decode(b[i])，且无丢失有效高位。审计所有 T 实例；未建立界前不宣称泛型任意 T 正确 |
| FIELD_CODEC | from_bytes/to_bytes/from_repr/to_repr 等 | 解码接受任意定长字节；编码输入有效 | Scalar 小端，Fp 大端；规范解码当且仅当整数<m；往返一致；wide/OKM 输入走模约减而非拒绝非规范整数 |
| POWER | pow/pow_vartime/chain | 底数有效，指数切片有限 | 指数按源码 limb 顺序解释；返回数学幂。固定 addition chain 指数须独立核验 |
| ROOT | invert/sqrt/sqrt_ratio | 域元素有效 | inverse 存在当且仅当非零；sqrt 存在当且仅当有平方根（包含零）；sqrt_ratio 按锁定 ff 版本契约细化零分母等分支，不能直接套用 sqrt 规范 |
| EXTENSION | 扩域算术及辅助运算 | EXTENSION 不变量 | 与商域运算一致；Frobenius 为 p 次幂，共轭与稀疏乘法对应其域表达式 |
| CURVE | 点构造、点运算、endomorphism | 曲线上合法；需要子群时显式加强；Scalar 有效 | 对应数学群运算；输出在曲线上，子群输入保持子群；覆盖无穷远、同点、互逆点；证明内部辅助函数实际公式 |
| SUBGROUP | is_on_curve/is_torsion_free/clear_cofactor/clear_h | torsion 判定及清余因子至少要求曲线上合法 | 判定的充要性；清余因子符合实际有效余因子公式并进入阶 r 子群；不能假定它等于任意选取的完整余因子 |
| BATCH | batch_normalize | p.len()==q.len()，输入点合法 | 输出逐项代表相同点；空数组和无穷远点正确；长度不等时是文档规定的 panic |
| POINT_CODEC | checked 编解码和 GroupEncoding 包装 | 解码接受所有定长字节；编码输入合法 | 与 notes/serialization.rs 对应的独立字节规范一致；成功 iff 规范编码且曲线/子群条件成立；合法输入往返 |
| UNCHECKED_CODEC | unchecked 解码 | 解析本身接受任意定长字节 | uncompressed 不保证在曲线上或子群；compressed 验证恢复曲线点但不验证子群；下游使用须补齐缺少的条件。仍验证规范域编码、标志与无穷远编码 |
| PAIRING | Miller loop、行函数、Gt 和 pairing | 合法子群输入；内部递推状态满足不变量；MillerLoopResult 非零 | 循环对应数学 Miller 递推；最终幂为 (p^12−1)/r；输出满足 TARGET；pairing 与固定数学配对一致，最终证明双线性及非退化性 |
| PREPARED | G2Prepared/multi_miller_loop | 预处理对象由有效构造产生；terms 有限 | 系数顺序、长度 68 及索引合法；多配对最终幂结果等于单配对乘积；空输入和无穷远项对应单位元 |
| HASH | hash_to_field/hash_to_curve/map/iso/expand | 域/曲线输入有效；消息有限；hash/XOF 满足登记的接口模型 | 对应选定版本的独立规范；DST、符号、模约减、SWU、同源映射和清余因子正确；输出属于目标子群 |
| EXPAND | 消息扩展初始化和读取 | len≤65535；XMD digest 长度>0 且 ceil(len/digest_len)≤255；其他泛型长度满足实现约束 | 输出字节流、read_into 的返回长度与 remain 一致；超界按实现 panic；零长度、长 DST 单独证明；不能默认为任意 digest 类型均满足约束 |
| RANDOM | try_random | 外部 RNG 调用按接口返回或失败 | 成功时返回有效元素，失败按实现传播；分布是实际采样/约减分布，不无条件声称均匀；终止性依赖外部 RNG 及可能的拒绝采样 |
| ADAPTER | trait 包装、选择、相等、迭代 sum/product、bits、clone/default | 底层类型有效；迭代器有限且回调契约成立 | 对应底层已证函数、数学折叠、位表示或值复制；包装层必须纳入最终调用闭包 |
| FORMAT | fmt | 有效值及 formatter 接口契约 | 暂不纳入密码学功能证明；明确排除 Debug/Display 格式正确性，不计入已证明覆盖率 |

## 特殊义务和外部依赖

- util 的宏生成多种运算符/赋值包装；derive 生成的 Copy/Eq 等及 ff/group/pairing 默认方法需在第二步审计。函数表中 trait 声明不是可执行实现。
- subtle：Choice、CtOption、选择和比较先登记语义接口，检查其 unsafe/编译器屏障部分；仅替换为理想 bool 模型必须列为条件性证明，不能声称验证了该依赖。
- ff：Scalar::sqrt 和 sqrt_ratio 调用外部 helpers，属于必须追踪的核心依赖，不可直接假定正确。
- digest、rand_core、generic_array、alloc、core 运算/迭代器：记录模型与实现连接。有限输入/外部调用终止条件及分配成功模型需显式说明。
- G2Prepared 的 68 项断言、MillerLoopResult::final_exponentiation 的 invert().unwrap()、批量归一化的逆元和切片转换 unwrap 都需证明其可达安全条件。
- hash-to-curve：README 标注 draft-v16；在规范版本核对前不能声称符合最终 RFC。ROOT/sqrt_ratio、REDUCE 的精确参数域和 EXPAND 泛型约束仍需依据锁定依赖细化。
- zeroize 的派生/trait 实现不一定包含源码函数声明，作为独立模块义务登记。只验证抽象值复位，不证明编译后内存物理擦除。

## 信任边界

最终报告列出 Lean 内核及所用标准逻辑公理、rustc/MIR、Charon、Aeneas 翻译、Aeneas 运行语义模型与手写外部模型。提取链没有在本项目内证明正确，不等同于机器码端到端证明。

暂不覆盖：侧信道/常数时间、编译器后端及硬件、密码学困难性、随机源安全、OOM/进程资源耗尽、Debug/Display 文本格式、测试/bench 本身。Rust 安全类型系统不替代功能证明，也不能代表外部依赖没有 unsafe。

## 验收和状态规则

状态依次为 not_started → extracted → specified → proved；blocked 单列原因。仅在定理通过内核检查、生成定义可追溯至基线、所有前置条件由调用者建立、依赖已证且无未披露假设时标记 proved。依赖外部未证明模型的结论只能标记 conditional。

每个证明须包含：终止/返回成功（契约允许错误时说明错误分支）、无越界及非预期溢出、输出不变量、数学等式和成功标志。不得使用 sorry、admit 或自定义公理绕过证明；检查定理的传递公理依赖，而非只 grep 源码。禁止通过矛盾前提使正确性命题空泛成立。

每个配置验收要求公开 API、内部调用和关键依赖闭包全部登记；宏/默认方法漏项补齐前不能声称全库覆盖。当前清单只有源码候选函数，故不报告百分比。

第一步的本地检查：`python3 verification/scripts/check_scope.py`。它只检查基线散列和词法函数登记一致性，不运行 Rust 或 Lean，也不构成正确性证明。
