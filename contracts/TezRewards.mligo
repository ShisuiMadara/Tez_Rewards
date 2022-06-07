//the other apps will call this contract to update their rewards

//when they call this contract, we would have the address where the contract is located

// => Tezos.sender() is the game conract address
//user
type user = {
    gameContractAddress : address;
    userWalletAddress : address;
    userLevel : nat;
    userWinningCount : nat;
}

let setUser (u : user) : user = 
    {u with gameContractAddress = ("ADDRESS" : address)}

//this function must 
// (1) update the storage
// (2) send transaction to the game user 

let reward (u: user) : user =
    if u.userWinningCount = 5n then Tezos.transaction ("TezRewardsAddress", ("userWalletAddress", 5))
    else if u.userWinningCount = 10n then Tezos.transaction ("TezRewardsAddress", ("userWalletAddress", 10))
    

