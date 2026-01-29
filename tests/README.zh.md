# Vuln DB Tests (Move)

该包包含 vuln-db 的 Move PoC 模块与单元测试。

## 运行单元测试 (本地)

```bash
cd tests
sui move test
```

## 运行单元 + testnet 集成测试

```bash
cd tests
./run_tests.sh
```

## 说明

- Sui CLI 固定为 `mainnet-v1.64.2` 以保持结果稳定。
- 集成测试会发布到 Sui testnet 并调用 entry functions。
- Move 包使用 `sources/` 存放模块，`tests/` 存放测试模块。