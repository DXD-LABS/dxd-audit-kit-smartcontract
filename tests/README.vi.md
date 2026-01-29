# Vuln DB Tests (Move)

Gói này chứa các module PoC Move và unit tests cho vuln-db.

## Chạy unit tests (local)

```bash
cd tests
sui move test
```

## Chạy unit + testnet integration

```bash
cd tests
./run_tests.sh
```

## Ghi chú

- Sui CLI được pin ở `mainnet-v1.64.2` để ổn định kết quả.
- Integration tests publish package lên Sui testnet và gọi các entry functions.
- Move package sử dụng `sources/` cho modules và `tests/` cho test-only modules.
