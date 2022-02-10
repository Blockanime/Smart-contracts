import Mnga from 0x95c64d0a6df03a68

// This script returns the total amount of Mnga currently in existence.

pub fun main(): UFix64 {

    let supply = Mnga.totalSupply

    log(supply)

    return supply
}