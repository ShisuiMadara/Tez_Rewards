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
  game : game ; //None ,  value hold -> None --> No instance of game present
  oracle_id : address;
}

type return = operation list * storage

//the user id and the bet amount for each user PER LEVEL
//for each level, we will maintain a map

[@inline] let error_BET_MUST_BE_GREATER_THAN_ZERO = 1n
[@inline] let error_BET_TOO_LARGE = 2n
[@inline] let error_GUESS_TOO_LARGE = 4n

type userStats = (address, tez) map //contains user and the bet
type userWins = (nat, int) map  //contains level and the wins
//need to store information in map
let my_users : userWins =
  Map.literal [
    (1n, 0);
    (2n, 0);
    (3n, 0)
  ]

let play (user : game) : unit =

    if Tezos.amount = 0tz then failwith (error_BET_MUST_BE_GREATER_THAN_ZERO)

    else if (user.level = 1n) then
        if (user.guess > 10n) then failwith (error_GUESS_TOO_LARGE)
        else if Tezos.amount * 2n > Tezos.balance then failwith (error_BET_TOO_LARGE)

    else if(user.level = 2n) then
        if user.guess > 100n then failwith (error_GUESS_TOO_LARGE)
        else if Tezos.amount * 3n > Tezos.balance then failwith (error_BET_TOO_LARGE)
    
    else if(user.level = 3n) then
        if user.guess > 1000n then failwith (error_GUESS_TOO_LARGE)
        else if Tezos.amount * 4n > Tezos.balance then failwith (error_BET_TOO_LARGE)
    
    let userBetUpdate (u : game) : game =
        {u with bet = Tezos.amount}
         

    let findUser (query, u : userStats * game) : unit = //bool or unit ?
        let predicate = fun (i,j : address * tez) -> assert (i <> u.playerId)
        in Map.iter predicate query

    let addUser (query, u : userStats * game) : userStats =
        Map.add (u.playerId) (u.bet) query 
    
    let updateUser (query, u : userStats * game) : userStats = 
        Map.update (u.playerId) (Some(u.bet)) query 

    // let action (query, u : userStats * game) : userStats =
    //     if(findUser = unit) then updateUser(query, u) else addUser(query, u)

    
[@inline] let error_ORACLE_COULD_NOT_BE_REACHED = 3n

let finish (user, randomNumber, userWin, stor: game * nat * userWins * storage) : userWins = 
    if Tezos.sender <> stor.oracle_id then failwith (error_ORACLE_COULD_NOT_BE_REACHED)
    
    else if (randomNumber = user.guess) then 

        if(user.level = 1n) then 
            let here : int = Map.find 1n userWin in
            let here = here + 1 in
            Map.update(user.level)  (Some(here)) userWin
        else if (user.level = 2n) then
            let here : int = Map.find 2n userWin in
            let here = here + 1 in 
            Map.update (user.level) (Some(here)) userWin
        else 
            let here : int = Map.find 3n userWin in
            let here = here + 1 in
            Map.update(user.level) (Some(here)) userWin
    
    else 
        userWin

// let make_transaction(usr : game) =
//     let finalAmount : tez = usr.level * usr.bet + usr.bet in 
//     Tezos.transaction unit finalAmount usr.playerId

let main (action, stor: game * storage) : return =
  (([] : operation list), stor)