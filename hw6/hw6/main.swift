//
//  main.swift
//  hw6
//
//  Created by aprirez on 7/15/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation


protocol Weight {
    var weight: Double { get set }
}

protocol ConsolePrintable: CustomStringConvertible {
    func printDescription()
}
extension ConsolePrintable{
    func printDescription() {
        print(description)
    }
}

class BottleOFCola: Weight, ConsolePrintable {
    var taste: String
    var weight: Double
    
    init(taste: String, weight: Double) {
        self.taste = taste
        self.weight = weight
    }
    
    var description: String {
        return "Taste: \(taste) Weight: \(weight)"
    }
    
}

class Snack: Weight, ConsolePrintable {
    var taste: String
    var weight: Double
    
    init(taste: String, weight: Double) {
        self.taste = taste
        self.weight = weight
    }
    
    var description: String {
        return "\nTaste: \(taste), Weight: \(weight)"
    }
    
}

struct Queue<T: Weight> {
    
    private var list: [T] = []
    
    public var count: Int {
        return list.count
    }
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return list.removeFirst()
        }
    }
    
    var totalWeight : Double {
        var weight = 0.0
        for element in list {
            weight += element.weight
        }
        return weight
    }
    
    func printQueue() {
        print(list)
    }
    
    subscript(index: Int) -> T? {
        get {
            if index < 0 || index >= count {
                return nil
            }
            return list[index]
        }
    }
    
}

extension Queue {
    func filter(predicate:(T) -> Bool) -> [T] {
        var result = [T]()
        for i in list {
            if predicate(i) {
                result.append(i)
            }
        }
        return result
    }
    func sorted() -> [T] {
        return list.sorted(by: { $0.weight > $1.weight})
    }
}

var food = Queue<Snack>()
food.enqueue(Snack(taste: "onion", weight: 100))
food.enqueue(Snack(taste: "cheese", weight: 50))
food.enqueue(Snack(taste: "pepper", weight: 150))
food.enqueue(Snack(taste: "onion", weight: 200))
food.printQueue()

let onion = food.filter(predicate: {$0.taste == "onion"})
print(onion)
print("\n")
print("Find index = 20: ", food[20] ?? "nil")

print("\nDequeue one element:")
_ = food.dequeue()
food.printQueue()

print("\nSorted by weight:")
let sortedFood = food.sorted()
print(sortedFood)


