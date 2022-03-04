import Blockanime from 0x95c64d0a6df03a68

//addr: 0x05 

transaction(bloctoAddr: Address,charName : String,animeName : String,thumbnail : String,quantity : UInt64) { 
    let mintRef: &Blockanime.NFTMinter

    prepare(acct: AuthAccount) {
        self.mintRef = acct.borrow<&Blockanime.NFTMinter>(from: Blockanime.MinterStoragePath)!
    }

    execute{ 
 
        // Mint all the new NFTs
        let collection <- self.mintRef.batchMint(charName: charName,animeName : animeName,thumbnail : thumbnail,quantity : quantity)

        // Get the account object for the recipient of the minted tokens
        let recipient = getAccount(bloctoAddr)

        // get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(/public/BlockanimeCollection).borrow<&{Blockanime.BlockanimeCollectionPublic}>()
            ?? panic("Cannot borrow a reference to the recipient's collection")

        // deposit the NFT in the receivers collection
        receiverRef.batchDeposit(tokens : <-collection)

        log("nfts minted")

    }
}