//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

let offensive = ["Genji", "McCree", "Pharah", "Reaper", "Soldier", "Sombra"]
let defensive = ["Bastion", "Hanzo", "Junkrat", "Mei", "Torbjörn", "Widowmaker"]
let tank = ["Dva", "Orisa", "Reinhardt", "Roadhog", "Winston", "Zarya"]
let support = ["Ana", "Lucio", "Mercy", "Symmetra", "Zenyatta"]

struct genericProfile {
    let score =
        ["Genji" : 0, "McCree" : 0, "Pharah" : 0, "Reaper" : 0, "Soldier" : 0, "Sombra" : 0, "Tracer" : 0,  //Offensive
        "Bastion" : 0, "Hanzo" : 0, "Junkrat" : 0, "Mei" : 0, "Torbjörn" : 0, "widowmaker" : 0,             //Defensive
        "Dva" : 0, "Orisa" : 0, "Reinhardt" : 0, "Roadhog" : 0, "Winston" : 0, "Zarya" : 0,                 //Tank
        "Ana" : 0, "Lucio" : 0, "Mercy" : 0, "Symmetra" : 0, "Zenyatta" : 0]                                //Support
}

struct Genji {
    let score =
        ["Genji" : 0, "McCree" : 0, "Pharah" : 0, "Reaper" : 0, "Soldier" : 0, "Sombra" : 0, "Tracer" : 0,  //Offensive
         "Bastion" : 2, "Hanzo" : 1, "Junkrat" : 0, "Mei" : -2, "Torbjörn" : 0, "widowmaker" : 1,           //Defensive
         "Dva" : 0, "Orisa" : 0, "Reinhardt" : 0, "Roadhog" : -1, "Winston" : -2, "Zarya" : -2,             //Tank
         "Ana" : 0, "Lucio" : 0, "Mercy" : 2, "Symmetra" : -1, "Zenyatta" : 2]                              //Support
    
}

struct McCree {
    let score =
        ["Genji" : -1, "McCree" : 0, "Pharah" : 0, "Reaper" : 1, "Soldier" : 0, "Sombra" : 0, "Tracer" : 1,      //Offensive
            "Bastion" : -1, "Hanzo" : 0, "Junkrat" : 0, "Mei" : 0, "Torbjörn" : 0, "widowmaker" : -1,             //Defensive
            "Dva" : 0, "Orisa" : 0, "Reinhardt" : 0, "Roadhog" : -2, "Winston" : 0, "Zarya" : -1,                 //Tank
            "Ana" : 0, "Lucio" : 1, "Mercy" : 2, "Symmetra" : 0, "Zenyatta" : 2]                                //Support
}

struct Pharah {
    let score =
        ["Genji" : 0, "McCree" : 0, "Pharah" : 0, "Reaper" : 0, "Soldier" : 0, "Sombra" : 0, "Tracer" : 0,  //Offensive
            "Bastion" : 0, "Hanzo" : 0, "Junkrat" : 0, "Mei" : 0, "Torbjörn" : 0, "widowmaker" : 0,             //Defensive
            "Dva" : 0, "Orisa" : 0, "Reinhardt" : 0, "Roadhog" : 0, "Winston" : 0, "Zarya" : 0,                 //Tank
            "Ana" : 0, "Lucio" : 0, "Mercy" : 0, "Symmetra" : 0, "Zenyatta" : 0]                                //Support
    
    func checkScore() {
        
    }
}



let g = McCree()
var ack = 0
for (name, value) in g.score {
    ack += value
}
print(ack)








