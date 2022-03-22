import NonFungibleToken from 0x631e88ae7f1d7c20
import Blockanime from 0x0b87d8c6bd786e7a
// This transaction is what an account would run
// to set itself up to receive NFTs

//ACC:0x05

transaction() {

    prepare(acct : AuthAccount){

        // Return early if the account already has a collection
        if acct.borrow<&Blockanime.Collection>(from: /storage/BlockanimeCollection) != nil {
            return
        }

        // Create a new empty collection
        let collection <- Blockanime.createEmptyCollection()

        // save it to the account
        acct.save(<-collection, to: /storage/BlockanimeCollection)

        // create a public capability for the collection
         acct.link<&Blockanime.Collection{NonFungibleToken.CollectionPublic, Blockanime.BlockanimeCollectionPublic}>(Blockanime.CollectionPublicPath, target: Blockanime.CollectionStoragePath)
        
        log("Account Set up")  
    }
}