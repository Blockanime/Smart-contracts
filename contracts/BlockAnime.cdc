import NonFungibleToken from 0x631e88ae7f1d7c20

//BlockAnime
// NFT items for Anime!
//
pub contract BlockAnime: NonFungibleToken {

    // Events
    //
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    pub event Minted(id: UInt64, charName: String, genre : String,animeName : String)
    pub event Destroyed(id: UInt64)

    // Named Paths
    //
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let CollectionPrivatePath: PrivatePath
    pub let MinterStoragePath: StoragePath
    pub let MinterPrivatePath : PrivatePath


    
    // totalSupply
    // The total number of Anime Characters that have been minted
    //
    pub var totalSupply: UInt64

    // NFT
    // A Card as an NFT
    //
    pub resource NFT: NonFungibleToken.INFT {
        // The token's ID
        pub let id: UInt64
    
        pub let charName : String

        pub let genre : String

        pub let animeName : String

        // initializer
        //
        init(initID: UInt64, initName: String, initGenre : String,initAnime : String) {
            self.id = initID
            self.charName = initName
            self.genre= initGenre
            self.animeName = initAnime
        }

        destroy (){
            emit Destroyed(id : self.id)
        }
    }

    // This is the interface that users can cast their Anime Collection as
    // to allow others to deposit Anime into their Collection. It also allows for reading
    // the details of Anime in the Collection.
    pub resource interface BlockAnimeCollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun batchDeposit(tokens: @NonFungibleToken.Collection)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowAnimeCard(id: UInt64): &BlockAnime.NFT? {
            // If the result isn't nil, the id of the returned reference
            // should be the same as the argument to the function
            post {
                (result == nil) || (result?.id == id):
                    "Cannot borrow BlockAnime reference: The ID of the returned reference is incorrect"
            }
        }
    }

    
    // Collection
    // A collection of Anime NFTs owned by an account
    //
    pub resource Collection: BlockAnimeCollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
        // dictionary of NFT conforming tokens
        // NFT is a resource type with an `UInt64` ID field
        //
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        // withdraw
        // Removes an NFT from the collection and moves it to the caller
        //
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")

            emit Withdraw(id: token.id, from: self.owner?.address)

            return <-token
        }


        // batchWithdraw withdraws multiple tokens and returns them as a Collection
        //
        // Parameters: ids: An array of IDs to withdraw
        //
        // Returns: @NonFungibleToken.Collection: A collection that contains
        //                                        the withdrawn moments
        //
        pub fun batchWithdraw(ids: [UInt64]): @NonFungibleToken.Collection {
            // Create a new empty Collection
            var batchCollection <- create Collection()
            
            // Iterate through the ids and withdraw them from the Collection
            for id in ids {
                batchCollection.deposit(token: <-self.withdraw(withdrawID: id))
            }
            
            // Return the withdrawn tokens
            return <-batchCollection
        }



        // deposit
        // Takes a NFT and adds it to the collections dictionary
        // and adds the ID to the id array
        //
        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @BlockAnime.NFT

            let id: UInt64 = token.id

            // add the new token to the dictionary which removes the old one
            let oldToken <- self.ownedNFTs[id] <- token

            emit Deposit(id: id, to: self.owner?.address)

            destroy oldToken
        }


         // batchDeposit takes a Collection object as an argument
        // and deposits each contained NFT into this Collection

        pub fun batchDeposit(tokens: @NonFungibleToken.Collection) {

            // Get an array of the IDs to be deposited
            let keys = tokens.getIDs()

            // Iterate through the keys in the collection and deposit each one
            for key in keys {
                self.deposit(token: <-tokens.withdraw(withdrawID: key))
            }

            // Destroy the empty Collection
            destroy tokens
        }

        // getIDs
        // Returns an array of the IDs that are in the collection
        //
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        

        // borrowNFT
        // Gets a reference to an NFT in the collection
        // so that the caller can read its metadata and call its methods
        //
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return &self.ownedNFTs[id] as &NonFungibleToken.NFT
        }

        // borrowAnimeCard
        // Gets a reference to an NFT in the collection as a BlockAnime,
        // exposing all of its fields (including the typeID).
        // This is safe as there are no functions that can be called on the BlockAnime.
        //
        pub fun borrowAnimeCard(id: UInt64): &BlockAnime.NFT? {
            if self.ownedNFTs[id] != nil {
                let ref = &self.ownedNFTs[id] as auth &NonFungibleToken.NFT
                return ref as! &BlockAnime.NFT
            } else {
                return nil
            }
        }

        // destructor
        destroy() {
            destroy self.ownedNFTs
        }

        // initializer
        //
        init () {
            self.ownedNFTs <- {}
        }
    }

    // createEmptyCollection
    // public function that anyone can call to create a new empty collection
    //
    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    // NFTMinter aka Admin
    // Resource that an admin or something similar would own to be
    // able to mint new NFTs
    //
	pub resource NFTMinter {

       // mintNFT
        // Mints a new NFT with a new ID
		// and deposit it in the recipients collection using their collection reference
        //
		pub fun mintNFT(charName : String, genre : String, animeName : String): @NFT{
            emit Minted(id: BlockAnime.totalSupply, charName : charName, genre : genre,animeName : animeName)

            let newNFT : @NFT <-create BlockAnime.NFT(initID: BlockAnime.totalSupply, initName: charName, initGenre : genre,initAnime : animeName)

			// deposit it in the recipient's account using their reference
			//recipient.deposit(token: <-create SportsCard.NFT(initID: SportsCard.totalSupply, initTypeID: typeID))

            BlockAnime.totalSupply = BlockAnime.totalSupply + (1 as UInt64)

            return <-newNFT
		}

        pub fun batchMint(charName : String,genre : String,animeName : String,quantity : UInt64): @Collection {
            let newCollection <- create Collection()

            var i: UInt64 = 0
            while i < quantity {
                newCollection.deposit(token: <-self.mintNFT(charName : charName,genre : genre,animeName : animeName))
                i = i + (1 as UInt64)
            }

            return <-newCollection
        }

	}




    // initializer
    //
	init() {
        // Set our named paths
        self.CollectionStoragePath = /storage/BlockAnimeCollection
        self.CollectionPublicPath = /public/BlockAnimeCollection
        self.CollectionPrivatePath = /private/BloackAnimeCollection
        
        self.MinterStoragePath = /storage/BlockAnimeMinter
        self.MinterPrivatePath = /private/BlockAnimeMinter

        
        // Initialize the total supply
        self.totalSupply = 0 as UInt64

        let collection <- BlockAnime.createEmptyCollection()

        // save it to the account
        self.account.save(<-collection, to: /storage/BlockAnimeCollection)

        // create a public capability for the collection
        self.account.link<&BlockAnime.Collection{NonFungibleToken.CollectionPublic, BlockAnime.BlockAnimeCollectionPublic}>(BlockAnime.CollectionPublicPath, target: BlockAnime.CollectionStoragePath)


        // Put the Minter in storage
        self.account.save<@NFTMinter>(<- create NFTMinter(), to: self.MinterStoragePath)
        self.account.link<&NFTMinter>(self.MinterPrivatePath,target : self.MinterStoragePath)


        emit ContractInitialized()
	}
}