import Mnga from 0x95c64d0a6df03a68
import FungibleToken from 0x9a0766d93b6608b7

// This script returns an account's Mnga balance.

pub fun main(address: Address): UFix64 {
    let account = getAccount(address)
    
    let vaultRef = account.getCapability(Mnga.BalancePublicPath)!.borrow<&Mnga.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}