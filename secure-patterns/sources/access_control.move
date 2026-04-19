module dxd_audit::access_control {
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use std::vector;
    use sui::transfer;

    /// Error codes
    const E_NO_PERMISSION: u64 = 0;

    /// Access token representing specific permissions
    struct AccessToken has key { 
        id: UID, 
        permissions: vector<u8> 
    }

    /// Admin capability to manage access tokens
    struct AdminCap has key, store { id: UID }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(AdminCap { id: object::new(ctx) }, tx_context::sender(ctx));
    }

    /// Issue a new access token
    public fun issue_token(_: &AdminCap, permissions: vector<u8>, ctx: &mut TxContext) {
        let token = AccessToken {
            id: object::new(ctx),
            permissions
        };
        transfer::transfer(token, tx_context::sender(ctx));
    }

    /// Check if the token has the required permission for an action
    public fun check_access(token: &AccessToken, action: u8) {
        assert!(vector::contains(&token.permissions, &action), E_NO_PERMISSION);
    }

    /// Revoke a token (destroy it)
    public fun revoke_token(token: AccessToken) {
        let AccessToken { id, permissions: _ } = token;
        object::delete(id);
    }

    spec module {
        pragma verify = true;
        pragma aborts_if_is_partial = false;
    }

    /// Spec for issuing tokens: proves it never aborts if a valid AdminCap is provided
    spec issue_token {
        aborts_if false; // Prove that issue_token never aborts unexpectedly
    }

    /// Spec for access checking: proves it ONLY succeeds if the permission exists
    spec check_access {
        aborts_if !vector::contains(token.permissions, action);
        ensures vector::contains(token.permissions, action);
    }

    /// Spec for revocation: proves the token is effectively consumed
    spec revoke_token {
        aborts_if false;
    }
}
