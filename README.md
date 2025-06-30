
Business Rules

1. Only the government (represented by a designated address) can register or initialize a property on the blockchain.

2. Only the current owner of a property can transfer ownership to another address.

3. Anyone can view property details (e.g., location, size, and current owner).

# Real Estate Registry (Move Language)

A smart contract module for managing real estate properties on-chain.

## Module Summary

```move
module real_estate_demo::registry {
    struct Property { ... }
    struct Registry { ... }

    public entry fun initialize_registry(...)
    public entry fun create_property(...)
    public entry fun transfer_property(...)

    #[view] public fun get_property(...)
    #[view] public fun get_owner(...)

    #[test] public entry fun test_create_property(...) { ... }
}
```
