import NonFungibleToken from 0x631e88ae7f1d7c20
import BlockAnime from 0x95c64d0a6df03a68
// This transaction is what an account would run
// to set itself up to receive NFTs

//ACC:0x05

transaction() {

    prepare(acct : AuthAccount){

        // Return early if the account already has a collection
        if acct.borrow<&BlockAnime.Collection>(from: /storage/BlockAnimeCollection) != nil {
            return
        }

        // Create a new empty collection
        let collection <- BlockAnime.createEmptyCollection()

        // save it to the account
        acct.save(<-collection, to: /storage/BlockAnimeCollection)

        // create a public capability for the collection
         acct.link<&BlockAnime.Collection{NonFungibleToken.CollectionPublic, BlockAnime.BlockAnimeCollectionPublic}>(BlockAnime.CollectionPublicPath, target: BlockAnime.CollectionStoragePath)

        log("Account Set up")  
    }
}