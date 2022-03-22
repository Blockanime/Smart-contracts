import Blockanime from 0x0b87d8c6bd786e7a

// This transaction transfers a number of moments to a recipient

// Parameters
//
// recipientAddress: the Flow address who will receive the NFTs
// momentIDs: an array of moment IDs of NFTs that recipient will receive

transaction(recipientAddress: Address, nftIDs: [UInt64]) {

    let transferRef: &Blockanime.Collection
    
    prepare(acct: AuthAccount) {
        self.transferRef = acct.borrow<&Blockanime.Collection>(from: Blockanime.CollectionStoragePath)!
    }

    execute {

        let transferTokens <- self.transferRef.batchWithdraw(ids: nftIDs)
        
        // get the recipient's public account object
        let recipient = getAccount(recipientAddress)

        // get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(/public/BlockanimeCollection).borrow<&{Blockanime.BlockanimeCollectionPublic}>()
            ?? panic("Could not borrow a reference to the recipients moment receiver")

        // deposit the NFT in the receivers collection
        receiverRef.batchDeposit(tokens: <-transferTokens)
        log("transfer done")
    }
}
