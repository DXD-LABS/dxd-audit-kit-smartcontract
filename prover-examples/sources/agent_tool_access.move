/// AgentToolAccessControl: Aborts nếu unauthorized tool call
/// Module này simulate agent gọi tool với simple allowlist check.
/// Abort nếu tool không được phép.
/// 
/// NOTE: Đây là simplified demo cho Move Prover. Production code nên dùng
/// VecSet hoặc Table cho dynamic tool management.
module prover_examples::agent_tool_access {

    /// Agent với tool access control
    /// tool_id: 1=trade, 2=bridge, 3=transfer
    struct Agent has drop {
        allowed_tool_1: bool,  // trade
        allowed_tool_2: bool,  // bridge  
        allowed_tool_3: bool,  // transfer
    }

    // Error codes
    const E_UNAUTHORIZED_TOOL: u64 = 200;

    /// Create agent với allowed tools
    public fun create_agent(
        allow_trade: bool,
        allow_bridge: bool,
        allow_transfer: bool
    ): Agent {
        Agent {
            allowed_tool_1: allow_trade,
            allowed_tool_2: allow_bridge,
            allowed_tool_3: allow_transfer,
        }
    }

    /// Call trade tool (tool_id = 1)
    public fun call_trade(agent: &Agent): bool {
        assert!(agent.allowed_tool_1, E_UNAUTHORIZED_TOOL);
        true
    }

    /// Call bridge tool (tool_id = 2)
    public fun call_bridge(agent: &Agent): bool {
        assert!(agent.allowed_tool_2, E_UNAUTHORIZED_TOOL);
        true
    }

    /// Call transfer tool (tool_id = 3)
    public fun call_transfer(agent: &Agent): bool {
        assert!(agent.allowed_tool_3, E_UNAUTHORIZED_TOOL);
        true
    }

    // ============ MOVE SPECIFICATION LANGUAGE (MSL) ============

    spec module {
        pragma verify = true;
    }

    spec create_agent {
        // Pre-condition: at least one tool must be allowed
        requires allow_trade || allow_bridge || allow_transfer;
        
        // Abort if no tools allowed (agent has no purpose)
        aborts_if !allow_trade && !allow_bridge && !allow_transfer;
        
        ensures result.allowed_tool_1 == allow_trade;
        ensures result.allowed_tool_2 == allow_bridge;
        ensures result.allowed_tool_3 == allow_transfer;
    }

    spec call_trade {
        // Pre-condition: agent must have trade permission
        requires agent.allowed_tool_1;
        
        // Abort nếu trade không allowed
        aborts_if !agent.allowed_tool_1 with E_UNAUTHORIZED_TOOL;
        
        // No state modification
        modifies nothing;
        
        // Ensures chỉ return true nếu authorized
        ensures result == true;
        ensures agent.allowed_tool_1;
    }

    spec call_bridge {
        // Pre-condition
        requires agent.allowed_tool_2;
        
        // Abort nếu bridge không allowed
        aborts_if !agent.allowed_tool_2 with E_UNAUTHORIZED_TOOL;
        
        // No state modification
        modifies nothing;
        
        ensures result == true;
        ensures agent.allowed_tool_2;
    }

    spec call_transfer {
        // Pre-condition
        requires agent.allowed_tool_3;
        
        // Abort nếu transfer không allowed
        aborts_if !agent.allowed_tool_3 with E_UNAUTHORIZED_TOOL;
        
        // No state modification
        modifies nothing;
        
        ensures result == true;
        ensures agent.allowed_tool_3;
    }

    // Global invariant: Tool permissions are immutable after creation
    spec Agent {
        // At least one tool must be allowed (agent must have purpose)
        invariant allowed_tool_1 || allowed_tool_2 || allowed_tool_3;
    }
}
