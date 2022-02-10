import BlockAnime from 0x95c64d0a6df03a68

// This script returns  collection ids



pub fun main(account: Address): [UInt64] {

    let collectionRef = getAccount(account).getCapability(/public/BlockAnimeCollection)
        .borrow<&{BlockAnime.BlockAnimeCollectionPublic}>()
        ?? panic("Could not get public  collection reference")

    return collectionRef.getIDs()
}