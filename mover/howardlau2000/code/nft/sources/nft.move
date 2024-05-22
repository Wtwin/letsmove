module nft::howardlau2000nft {
    use std::ascii::String;
    use std::string::utf8;
    use sui::display;
    use sui::object;
    use sui::object::{UID};
    use sui::package;
    use sui::transfer;
    use sui::transfer::public_transfer;
    use sui::tx_context;
    use sui::tx_context::{TxContext};

    public struct HOWARDLAU2000NFT has drop {}

    public struct NFT has key,store {
        id: UID,
        name: String,
    }
    
    fun init(otw: HOWARDLAU2000NFT, ctx: &mut sui::tx_context::TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"image_url"),
        ];

        let values = vector[
            utf8(b"{name}"),
            utf8(b"https://avatars.githubusercontent.com/u/167279232"),
        ];

        let publisher = package::claim(otw, ctx);
        let mut display = display::new_with_fields<NFT>(&publisher, keys, values,ctx);

        // update version to 1
        display::update_version(&mut display);

        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(display, tx_context::sender(ctx));
    }

    public entry fun mint_to(name: String, recipient: address,ctx: &mut TxContext) {
        let nft = NFT{
            id: object::new(ctx),
            name,
        };
        public_transfer(nft, recipient)
    }
}
