import NonFungibleToken from 0x1d7e57aa55817448
import Blockanime from 0x7ef193bff7bb7b44

// This transaction returns an array of all the nft ids in the collection

pub fun main(address: Address,animeID: UInt64): String {
   
    //let cardRef = SportsCard.fetch(from: from,itemID: itemID);

    let owner = getAccount(address)

    let collectionBorrow = owner.getCapability(Blockanime.CollectionPublicPath)!
        .borrow<&{Blockanime.BlockanimeCollectionPublic}>()
        ?? panic("Could not borrow BlockAnimeCollectionPublic")

    // borrow a reference to a specific NFT in the collection
    let card = collectionBorrow.borrowBlockanime(id: animeID)
        ?? panic("No such itemID in that collection")

    return card.animeName
}