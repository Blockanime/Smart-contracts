import NonFungibleToken from 0x631e88ae7f1d7c20
import BlockAnime from 0x95c64d0a6df03a68

// This transaction transfers a number of moments to a recipient

// Parameters
//
// recipientAddress: the Flow address who will receive the NFTs
// momentIDs: an array of moment IDs of NFTs that recipient will receive

transaction(recipientAddress: Address, nftIDs: [UInt64]) {

    let transferRef: &BlockAnime.Collection
    
    prepare(acct: AuthAccount) {
        self.transferRef = acct.borrow<&BlockAnime.Collection>(from: BlockAnime.CollectionStoragePath)!
    }

    execute {

        let transferTokens <- self.transferRef.batchWithdraw(ids: nftIDs)
        
        // get the recipient's public account object
        let recipient = getAccount(recipientAddress)

        // get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(/public/BlockAnimeCollection).borrow<&{BlockAnime.BlockAnimeCollectionPublic}>()
            ?? panic("Could not borrow a reference to the recipients moment receiver")

        // deposit the NFT in the receivers collection
        receiverRef.batchDeposit(tokens: <-transferTokens)
        log("transfer done")
    }
}
