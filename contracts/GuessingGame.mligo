//this contracts plays the game 
//this also call our reward contract if some achievement has been unlocked ?
//the above cna be replaced with the reward contract is called evertime. And it decides 
//if accourding to the given stats, the user is eligible for reward or not 
//the reward contract is called everytime one game turn finishes

type game = {
  guess : nat;
  bet : tez;
  level: nat;
  playerId : address;
}

type storage = {
  game : game option; //None ,  value hold -> None --> No instance of game present
  oracle_id : address;
}

type return = operation list * (address, nat) map

//the user id and the bet amount for each user PER LEVEL
//for each level, we will maintain a map

[@inline] let error_BET_MUST_BE_GREATER_THAN_ZERO = 1n
[@inline] let error_BET_TOO_LARGE = 2n
[@inline] let error_GUESS_TOO_LARGE = 4n

type userStats = (address, nat) map //contains user and the bet
type userWins = (address, nat) map  //contains user and the wins
//need to store information in map
let my_users : userWins =
  Map.literal [
    (1, 0);
    (2, 0);
    (3, 0)
  ]

let play (user : game) : game =

    if Tezos.amount() = 0tz then failwith (error_BET_MUST_BE_GREATER_THAN_ZERO)

    else if (user.level = 1) then
        if (user.guess > 10n) then failwith (error_GUESS_TOO_LARGE)
        else if Tezos.amount() * 2 > Tezos.balance() then failwith (error_BET_TOO_LARGE)

    else if(user.level = 2) then
        if user.guess > 100n then failwith (error_GUESS_TOO_LARGE)
        else if Tezos.amount() * 3 > Tezos.balance() then failwith (error_BET_TOO_LARGE)
    
    else if(user.level = 3) then
        if user.guess > 1000n then failwith (error_GUESS_TOO_LARGE)
        else if Tezos.amount() * 4 > Tezos.balance() then failwith (error_BET_TOO_LARGE)
    
    let userBetUpdate (u : game) : game = 
        u.bet = Tezos.amount()

    let findUser (query, u : userStats * game) : bool = //bool or unit ?
        let predicate = fun (i,j : address * nat) -> assert (i <> u.playerId)
        in Map.iter predicate query

    let addUser (query, u : userStats * game) : userStats =
        Map.add (u.playerId) (u.bet) query 
    
    let updateUser (query, u : userStats * game) : userStats = 
        Map.update (u.playerId) (Some(u.bet)) query 

    let action (query, u : userStats * game) : userStats =
        if(findUser) then updateUser(query, u) else addUser(query, u)

    
[@inline] let error_ORACLE_COULD_NOT_BE_REACHED = 3n

let finish (user, randomNumber, userWin : game * nat * userWins) = 
    if Tezos.sender () <> storage.oracle_id then failwith (error_ORACLE_COULD_NOT_BE_REACHED)
    
    else if (randomNumber = user.guess) then 

        if(user.level = 1) then 
            Map.update(user.level, Some(Map.find_opt 1 userWin + 1)) userWin
        else if (user.level = 2) then 
            Map.update(user.level, Some(Map.find_opt 2 userWin + 1)) userWin
        else if (user.level = 3) then
            Map.update(user.level, Some(Map.find_opt 3 userWin + 1)) userWin

        let finalAmount : nat = user.level * user.bet + user.bet in 
        
        Tezos.transfer (user.playerId finalAmount)

let main (action, stor: game * storage) : return =
  (([] : operation list), userStats)