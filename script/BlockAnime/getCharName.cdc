
import BlockAnime from 0x95c64d0a6df03a68

// This transaction returns character name

pub fun main(address: Address,animeID: UInt64): String{
   

    let owner = getAccount(address)

    let collectionBorrow = owner.getCapability(BlockAnime.CollectionPublicPath)
        .borrow<&{BlockAnime.BlockAnimeCollectionPublic}>()
        ?? panic("Could not borrow BlockAnimeCollectionPublic")

    // borrow a reference to a specific NFT in the collection
    let card = collectionBorrow.borrowAnimeCard(id: animeID)
        ?? panic("No such itemID in that collection")

    return card.charName
}