# Vuln DB Tests (Move)

This package contains Move proof-of-concept modules and unit tests for the vuln database.

## Run unit tests (local)

```bash
cd tests
sui move test
```

## Run unit + testnet integration

```bash
cd tests
./run_tests.sh
```

## Notes

- Sui CLI pinned to `mainnet-v1.64.2` for consistency.
- Integration tests publish the package to Sui testnet and run entry functions.
- Move package layout uses `sources/` for modules and `tests/` for test-only modules.
