import Mnga from 0x7ef193bff7bb7b44
import FungibleToken from 0xf233dcee88fe0abe

// This script returns an account's Mnga balance.

pub fun main(address: Address): UFix64 {
    let account = getAccount(address)
    
    let vaultRef = account.getCapability(Mnga.BalancePublicPath)!.borrow<&Mnga.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}