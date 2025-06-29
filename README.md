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
