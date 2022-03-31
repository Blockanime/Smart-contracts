import Blockanime from 0x7ef193bff7bb7b44

// This script returns true if a moment with the specified ID
// exists in a user's collection

// Parameters:
//
// account: The Flow Address of the account whose moment data needs to be read
// id: The unique ID for the moment whose data needs to be read

// Returns: Bool
// Whether a moment with specified ID exists in user's collection

pub fun main(account: Address): [UInt64] {

    let collectionRef = getAccount(account).getCapability(/public/BlockanimeCollection)
        .borrow<&{BlockAnime.BlockanimeCollectionPublic}>()
        ?? panic("Could not get public  collection reference")

    return collectionRef.getIDs()
}