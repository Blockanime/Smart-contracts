import Mnga from 0x7ef193bff7bb7b44

// This script returns the total amount of Mnga currently in existence.

pub fun main(): UFix64 {

    let supply = Mnga.totalSupply

    log(supply)

    return supply
}