//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

protocol Coffee {
    var cost: Int { get }
    var ingredients: [String] { get }
}

class SimpleCoffee: Coffee {
        
    var cost: Int {
        return 150
    }
    
    var ingredients: [String] {
        return ["Coffee"]
    }
}

protocol CoffeeDecorator: Coffee {
    var decoratedCoffee: Coffee { get }
    init(decoratedCoffee: Coffee)
}

class Milk: CoffeeDecorator {
    var decoratedCoffee: Coffee
    
    var cost: Int {
        return decoratedCoffee.cost + 30
    }
    
    var ingredients: [String] {
        return decoratedCoffee.ingredients + ["Milk"]
    }
    required init(decoratedCoffee: Coffee) {
        self.decoratedCoffee = decoratedCoffee
    }
}

class Whip: CoffeeDecorator {
    var decoratedCoffee: Coffee
    
    var cost: Int {
        return decoratedCoffee.cost + 50
    }
    
    var ingredients: [String] {
        return decoratedCoffee.ingredients + ["Whip"]
    }
    required init(decoratedCoffee: Coffee) {
        self.decoratedCoffee = decoratedCoffee
    }
}

class Sugar: CoffeeDecorator {
    var decoratedCoffee: Coffee
    
    var cost: Int {
        return decoratedCoffee.cost + 10
    }
    
    var ingredients: [String] {
        return decoratedCoffee.ingredients + ["Sugar"]
    }
    required init(decoratedCoffee: Coffee) {
        self.decoratedCoffee = decoratedCoffee
    }
}

let someCoffee = SimpleCoffee()
print("Cost: \(someCoffee.cost); Ingredients: \(someCoffee.ingredients)")
let milkCoffee = Milk(decoratedCoffee: someCoffee)
print("Cost: \(milkCoffee.cost); Ingredients: \(milkCoffee.ingredients)")
let whipCoffee = Whip(decoratedCoffee: milkCoffee)
print("Cost: \(whipCoffee.cost); Ingredients: \(whipCoffee.ingredients)")
let whipWithSugarCoffee = Sugar(decoratedCoffee: whipCoffee)
print("Cost: \(whipWithSugarCoffee.cost); Ingredients: \(whipWithSugarCoffee.ingredients)")
