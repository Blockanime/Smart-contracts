import BlockAnime from 0x95c64d0a6df03a68

//addr: 0x05 

transaction(bloctoAddr: Address,charName : String,genre : String,animeName : String,quantity : UInt64) { 
    let mintRef: &BlockAnime.NFTMinter

    prepare(acct: AuthAccount) {
        self.mintRef = acct.borrow<&BlockAnime.NFTMinter>(from: BlockAnime.MinterStoragePath)!
    }

    execute{ 
 
        // Mint all the new NFTs
        let collection <- self.mintRef.batchMint(charName: charName, genre: genre,animeName : animeName,quantity : quantity)

        // Get the account object for the recipient of the minted tokens
        let recipient = getAccount(bloctoAddr)

        // get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(/public/BlockAnimeCollection).borrow<&{BlockAnime.BlockAnimeCollectionPublic}>()
            ?? panic("Cannot borrow a reference to the recipient's collection")

        // deposit the NFT in the receivers collection
        receiverRef.batchDeposit(tokens : <-collection)

        log("nfts minted")

    }
}