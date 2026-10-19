# BLS12-381 的 Aeneas 验证计划

基线：`5d22dd74c2a14fb9f3d3b85ae2c39d0c669ddd99`。建立日期：2026-10-19。

采用 Rust → Charon LLBC → Aeneas → Lean 4，证明原始实现与独立数学规范一致。成功提取、编译、测试均不等于完成正确性证明。

## 1. 确定范围和验收标准（已完成初始建档）

- 固定提交、Cargo.lock、源码及编译配置的 SHA-256。
- 建立功能配置矩阵、数学解释、函数清单、前置条件和信任边界。
- 明确合法输入下的终止性、运行时安全、表示不变量及功能正确性义务。
- 区分 checked/unchecked API，列出外部依赖和待核实条件。
- 交付：[SCOPE.md](SCOPE.md)、[baseline.json](baseline.json)、[coverage.json](coverage.json)。函数清单是源码层面的初始清单，第二步用提取结果补齐宏展开和依赖实例。

## 2. 搭建可复现提取工程（已运行核心配置；完整范围仍有缺口）

2026-10-19：已实际运行 Charon/Aeneas，并完成生成代码和外部接口的 Lean 编译检查。精确功能范围、排除项、手写模型及未证明接口见 [EXTRACTION.md](EXTRACTION.md)。这不代表本阶段“目标配置无遗漏”的全部验收条件已满足。

固定 Aeneas commit、对应 charon-pin、提取用 Rust 编译器、Lean 和数学库版本。保留 Rust 1.85.0 原构建基线；提取编译器差异纳入信任报告。先提取 util/Scalar，再打开 groups、pairings、alloc。

验证 subtle、trait、迭代器、闭包、const generics 的实际兼容性。外部模型明确登记为假设；任何 Rust 改写必须保存补丁及等价性义务。生成代码禁止手工修改。

预计结构：toolchain/、scripts/、lean/Generated/、lean/Spec/、lean/Proofs/。验收：从固定源码可重复生成并编译 Lean，提取失败和外部定义无静默遗漏。

## 3. 验证整数基础（未开始）

证明 util::adc、sbb、mac 的整数等式、范围、截断、移位和 wrapping 语义。特别处理 sbb 的全零/全一借位掩码。建立 limb 数组解释函数。

验收：原始 Rust 自动提取，三个函数完整证明通过 Lean 内核检查，无 sorry 或新增未证明假设。

## 4. 验证 Scalar 和 Fp（未开始）

建立模数素性、Montgomery 常数、规范表示及 decode。依次证明条件减模、加减取负、Montgomery reduction、乘法、平方、字节编解码、幂、逆和平方根。

证明输出范围和 CtOption 成功条件；检查 sum_of_products 的实际 T 及累加器上界。外部 ff 平方根辅助函数必须纳入依赖闭包。

第一轮端到端目标为 util 三个函数加 Scalar::add；完成后再评估整个域阶段的工作量。

## 5. 验证扩域（未开始）

定义 Fp2、Fp6、Fp12 的商域模型并证明不可约性，验证运算、求逆、Frobenius、共轭和稀疏乘法。优化实现逐项对应普通域运算，上层复用底层定理。

## 6. 验证 G1/G2 和编码（未开始）

定义仿射/射影解释、无穷远点和子群。证明点加、倍点、混合加法、标量乘法、批量归一化；覆盖相同点、互逆点及无穷远点。证明生成元阶、子群判定、余因子清除。

编码证明包含往返性质、规范性、标志位、符号位及非法输入处理；checked 和 unchecked 分别立约。

## 7. 验证配对（未开始）

分层证明 Miller loop 递推、最终幂运算与数学配对的一致性，再证明双线性和非退化性。处理负 BLS 参数、无穷远点、非零中间值、G2Prepared 系数长度和 multi-pairing 乘积性质。

优先调查 Lean 配对理论缺口；仅完成指数链或循环证明不能算配对验证完成。

## 8. 可选功能和持续验证（未开始）

补齐 bits、alloc、experimental 和 zeroize 的功能规范，单独审计 nightly。Hash-to-curve 先确认实际规范版本（README 标注 draft-v16），再证明消息扩展、hash-to-field、SWU、同源映射及余因子清除；哈希和 RNG 的外部假设明确列出。

CI 重跑提取和 Lean 证明、检查生成文件同步和公理依赖，并按功能配置报告覆盖率。原有测试用于回归，不作为形式证明替代。

## 完成标准与限制

逐函数完成标准见 SCOPE.md。整体完成要求目标配置全部可达核心实现及依赖有证明，未完成项和外部假设均可审计。当前已运行核心配置的 Aeneas 提取，尚无 Rust 功能正确性证明。总工期在首个端到端证明完成后评估。

功能证明不自动推出常数时间、机器码正确性、内存擦除效果、RNG 质量或密码学安全性。

## 工具参考

- [Aeneas 官方说明与安装](https://github.com/AeneasVerif/aeneas)：工具关系、charon-pin 和 Lean 版本要求。
- [官方密码学验证指南](https://github.com/AeneasVerif/aeneas/blob/main/documentation/crypto-verification.md)：实现、算法和数学规范的分层证明。

以上链接是路线参考；第二步必须锁定具体版本，不能以浮动 main 作为可复现依赖。
