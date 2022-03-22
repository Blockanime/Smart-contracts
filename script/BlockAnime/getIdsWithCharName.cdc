import Blockanime from 0x0b87d8c6bd786e7a
//return anime ids with same character name
pub fun main(address: Address,charName : String): [UInt64]{
   
    let idWithName : [UInt64] = []
    
    let owner = getAccount(address)

    let collectionBorrow = owner.getCapability(Blockanime.CollectionPublicPath)
        .borrow<&{Blockanime.BlockanimeCollectionPublic}>()
        ?? panic("Could not borrow BlockAnimeCollectionPublic")

    
    let nftIds = collectionBorrow.getIDs()

    for id in nftIds {
         // borrow a reference to a specific NFT in the collection
        let card = collectionBorrow.borrowBlockanime(id: id)
        ?? panic("No such itemID in that collection")
        if(card.charName==charName){
            idWithName.append(id)
        }
    }

    return idWithName
}