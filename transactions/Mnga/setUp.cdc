import FungibleToken from 0x9a0766d93b6608b7
import Mnga from 0x95c64d0a6df03a68

// This transaction is a template for a transaction
// to add a Vault resource to their account
// so that they can use the Kibble

transaction {

    prepare(signer: AuthAccount) {

        if signer.borrow<&Mnga.Vault>(from: Mnga.VaultStoragePath) == nil {
            // Create a new Kibble Vault and put it in storage
            signer.save(<-Mnga.createEmptyVault(), to: Mnga.VaultStoragePath)

            // Create a public capability to the Vault that only exposes
            // the deposit function through the Receiver interface
            signer.link<&Mnga.Vault{FungibleToken.Receiver}>(
                Mnga.ReceiverPublicPath,
                target: Mnga.VaultStoragePath
            )

            // Create a public capability to the Vault that only exposes
            // the balance field through the Balance interface
            signer.link<&Mnga.Vault{FungibleToken.Balance}>(
                Mnga.BalancePublicPath,
                target: Mnga.VaultStoragePath
            )
          log("account set up")
        }
    }
}