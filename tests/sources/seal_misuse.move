#[allow(lint(public_entry))]
module vuln_db::seal_misuse {
    use std::vector;

    const E_MISMATCH: u64 = 6;

    public fun vuln_seal(data: vector<u8>, _key: u8): vector<u8> {
        // Returns plaintext without sealing.
        data
    }

    public fun fixed_seal(data: vector<u8>, key: u8): vector<u8> {
        mask(&data, key)
    }

    public fun fixed_open(sealed: vector<u8>, key: u8): vector<u8> {
        mask(&sealed, key)
    }

    fun mask(data: &vector<u8>, key: u8): vector<u8> {
        let out = vector::empty<u8>();
        let len = vector::length(data);
        let i = 0;
        while (i < len) {
            let b = *vector::borrow(data, i);
            vector::push_back(&mut out, b ^ key);
            i = i + 1;
        };
        out
    }

    fun clone_vec(data: &vector<u8>): vector<u8> {
        let out = vector::empty<u8>();
        let len = vector::length(data);
        let i = 0;
        while (i < len) {
            let b = *vector::borrow(data, i);
            vector::push_back(&mut out, b);
            i = i + 1;
        };
        out
    }

    fun vectors_equal(a: &vector<u8>, b: &vector<u8>): bool {
        let len_a = vector::length(a);
        let len_b = vector::length(b);
        if (len_a != len_b) return false;
        let i = 0;
        while (i < len_a) {
            if (*vector::borrow(a, i) != *vector::borrow(b, i)) return false;
            i = i + 1;
        };
        true
    }

    #[test]
    fun test_exploit() {
        let data = vector[1, 2, 3, 4];
        let sealed = vuln_seal(clone_vec(&data), 7);
        assert!(vectors_equal(&sealed, &data), 0);
    }

    #[test]
    fun test_fixed() {
        let data = vector[1, 2, 3, 4];
        let sealed = fixed_seal(clone_vec(&data), 7);
        assert!(!vectors_equal(&sealed, &data), E_MISMATCH);
        let opened = fixed_open(sealed, 7);
        assert!(vectors_equal(&opened, &data), E_MISMATCH);
    }

    public entry fun exploit() {
        let data = vector[1, 2, 3, 4];
        let sealed = vuln_seal(clone_vec(&data), 7);
        assert!(vectors_equal(&sealed, &data), 0);
    }
}
