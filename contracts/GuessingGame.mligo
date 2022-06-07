type game = {
  guess : nat;
  bet : tez;
  level: nat;
  playerId : address;
}

type storage = {
  game : game option;
  oracle_id : address;
}

//the user id and the bet amount for each user PER LEVEL
//for each level, we will maintain a map

[@inline] let error_BET_MUST_BE_GREATER_THAN_ZERO = 1n
[@inline] let error_BET_TOO_LARGE = 2n

type userStats = (address, nat) map

//need to store information in map

let play (user : game) : game =

    if Tezos.amount() = 0tz then failwith (error_BET_MUST_BE_GREATER_THAN_ZERO)

    if (user.level = 1) =
        if user.guess > 10 then failwith ("Guess cannot be greater than 10")
        if Tezos.amount() * 2 > Tezos.balance() then failwith (error_BET_TOO_LARGE)

    if(user.level = 2) = 
        if user.guess > 100 then failwith ("Guess cannot be greater than 100")
        if Tezos.amount() * 4 > Tezos.balance() then failwith (error_BET_TOO_LARGE)
    
    if(user.level = 3) =
        if user.guess > 1000 then failwith ("Guess cannot be greater than 1000")
        if Tezos.amount() * 8 > Tezos.balance() then failwith (error_BET_TOO_LARGE)
    
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

let finish (user, randomNumber : game * nat) : storage = 
    if Tezos.sender () <> storage.oracle_id then failwith (error_ORACLE_COULD_NOT_BE_REACHED)
    
    let operation =
        if (randomNumber = user.guess) then 
            let finalAmount : nat = user.bet

            if(user.level = 1) then let finalAmount = 2 * user.bet
            if(user.level = 2) then let finalAmount = 4 * user.bet 
            if(user.level = 3) then let finalAmount = 8 * user.bet

            [Tezos.transfer user.playerId finalAmount] 

    let storage = storage.game <- (None : game option) in
    (ops, storage)


let entry fund _ storage =
  ([] : operation list), storage