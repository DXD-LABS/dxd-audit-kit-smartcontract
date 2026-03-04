module prover_examples::agent_shared_object_consistency {

    struct SharedVault has drop {
        balance: u64,
        expected_version: u64,
        version: u64,
    }

    const E_VERSION_CONFLICT: u64 = 1;

    public fun withdraw(vault: &mut SharedVault, amount: u64) {
        assert!(vault.version == vault.expected_version, E_VERSION_CONFLICT);
        vault.balance = vault.balance - amount;
        vault.version = vault.version + 1;
        vault.expected_version = vault.expected_version + 1;
    }

    spec withdraw {
        pragma aborts_if_is_partial;
        aborts_if vault.version != vault.expected_version with E_VERSION_CONFLICT;
        aborts_if vault.balance < amount; // Add implicit abort if balance drops below 0 implicitly via math
        ensures vault.balance == old(vault.balance) - amount;
        modifies vault.balance, vault.version, vault.expected_version;
    }

    spec SharedVault {
        invariant balance >= 0;
    }
}
