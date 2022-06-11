//the other apps will call this contract to update their rewards

//when they call this contract, we would have the address where the contract is located

// => Tezos.sender() is the game conract address
//user

type game = {
  guess : nat;
  bet : tez;
  level: nat;
  playerId : address;
}
type userWins = (address, nat) map
type win = nat 
//tz1MVXCWHbHpCJhxnktHGwuwFcDYMeAai6iM -> address of tez rewards wallet

//what do we need ?
//the game id (for there will be many other games)
//the user stats for that particular game
//what is the user stats that's needed ? in this case its the number of wins
//but it may differ for other games 
//hence a general thing must be imported 
//let say the general user stats which is a general key

let reward (g, wins : game * userWins)  : game =
    if (g.level = 1) then 
        let win = Map.find_opt 1 wins in 
        if(win = 5) then Tezos.transaction ()



