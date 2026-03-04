module prover_examples::agent_unauthorized_tool_prevent {
    use std::vector;

    struct AgentPolicy has drop {
        allowed_tools: vector<u8>,
    }

    const E_UNAUTHORIZED_TOOL: u64 = 1;

    public fun execute_tool(policy: &AgentPolicy, tool_id: u8) {
        assert!(vector::contains(&policy.allowed_tools, &tool_id), E_UNAUTHORIZED_TOOL);
    }

    spec execute_tool {
        pragma aborts_if_is_partial;
        aborts_if !contains(policy.allowed_tools, tool_id) with E_UNAUTHORIZED_TOOL;
        ensures contains(policy.allowed_tools, tool_id);
    }

    // spec AgentPolicy {
    //     invariant forall t in allowed_tools: valid_tool_id(t);
    // }
}
