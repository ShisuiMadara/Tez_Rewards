//the other apps will call this contract to update their rewards

//when they call this contract, we would have the address where the contract is located

// => Tezos.sender() is the game conract address
//user
type user = {
    gameContractAddress : address;
    userWalletAddress : address;
    userBet : nat;
    userLevel : nat;
    userWon : bool;
    userWinningCount : nat;
}

let set (u : user) : user = 
    user.gameContractAddress = Tezos.sender()

//this function must 
// (1) update the storage
// (2) send transaction to the game user 

let reward (u: user) : user =
    if u.userWinningCount = 5 then Tezos.transaction ("TezRewardsAddress", ("userWalletAddress", 5))
    if u.userWinningCount = 10 then Tezos.transaction ("TezRewardsAddress", ("userWalletAddress", 10))


