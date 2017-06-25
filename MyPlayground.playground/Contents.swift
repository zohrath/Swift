//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

str.startIndex

str.endIndex


struct Car {
    var make: String
    var year: Int
    var color: String
    var topSpeed: Int
     
    func startEngine() {...}
     
    func drive() {}
     
    func park() {}
     
    func steer(direction: Direction) {}
}
 
let firstCar = Car(make: "Honda", year: 2010, color: .blue,
                   topSpeed: 120)
let secondCar = Car(make: "Ford", year: 2013, color: .black,
                    topSpeed: 125)
 
firstCar.startEngine()
firstCar.drive()