module real_estate_demo::registry {
    use std::signer;
    use std::error;
    use std::table;
    use std::string;

    // Error codes
    const ENOT_REGISTRAR: u64 = 1;
    const ENOT_OWNER: u64 = 2;

    // The hardcoded registrar address
    const REGISTRAR_ADDRESS: address = @0xA550C18;

    // Property structure with copy ability
    struct Property has store, drop, copy {
        id: u64,
        location: string::String,
        size_sqft: u64,
        owner: address,
    }

    // Registry structure
    struct Registry has key {
        properties: table::Table<u64, Property>,
        next_id: u64,
    }

    /// Initializes the property registry — only registrar can do this
    public entry fun initialize_registry(account: &signer) {
        let sender = signer::address_of(account);
        assert!(sender == REGISTRAR_ADDRESS, error::invalid_argument(ENOT_REGISTRAR));

        let props = table::new<u64, Property>();

        move_to(account, Registry {
            properties: props,
            next_id: 1,
        });
    }

    /// Creates a new property record — only registrar can do this
    public entry fun create_property(account: &signer, location: string::String, size_sqft: u64, owner: address) acquires Registry {
        let sender = signer::address_of(account);
        assert!(sender == REGISTRAR_ADDRESS, error::invalid_argument(ENOT_REGISTRAR));

        let registry = borrow_global_mut<Registry>(sender);
        let id = registry.next_id;
        registry.next_id = id + 1;

        let property = Property {
            id,
            location,
            size_sqft,
            owner,
        };

        table::add(&mut registry.properties, id, property);
    }

    /// Transfers a property to a new owner — only current owner can do this
    public entry fun transfer_property(account: &signer, registry_address: address, property_id: u64, new_owner: address) acquires Registry {
        let sender = signer::address_of(account);
        let registry = borrow_global_mut<Registry>(registry_address);
        let property = table::borrow_mut(&mut registry.properties, property_id);

        assert!(property.owner == sender, error::invalid_argument(ENOT_OWNER));
        property.owner = new_owner;
    }

    /// Returns full property information
    public fun get_property(registry_address: address, property_id: u64): Property acquires Registry {
        let registry = borrow_global<Registry>(registry_address);
        *table::borrow(&registry.properties, property_id)
    }

    /// Returns only the owner of a property
    public fun get_owner(registry_address: address, property_id: u64): address acquires Registry {
        let registry = borrow_global<Registry>(registry_address);
        table::borrow(&registry.properties, property_id).owner
    }

    #[test(account = @0xA550C18)]
    public entry fun test_create_property(account: &signer) acquires Registry {
        initialize_registry(account);
        create_property(account, string::utf8(b"123 Main St"), 1200, @0x1);
        let property = get_property(@0xA550C18, 1);
        assert!(property.size_sqft == 1200, 1);
        assert!(property.owner == @0x1, 2);
    }
}
