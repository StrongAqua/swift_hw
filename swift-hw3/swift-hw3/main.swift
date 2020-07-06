//
//  main.swift
//  swift-hw3
//
//  Created by aprirez on 7/6/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

enum EngineState {
    case on, off
}

enum WindowsState {
    case open, close
}

// Passenger car
struct PassengerCar {
    let brand: String
    let model: String
    let year: Int
    let luggageEmpty: Double
    
    var cargo: Double
    var engineState: EngineState
    var windowsState: WindowsState

    var luggageFree: Double {
        get {
            return luggageEmpty - cargo
        }
    }
    
    mutating func addCargo(_ number: Double) -> Bool {
        if cargo + number > luggageEmpty {
            return false
        }
        cargo = cargo + number
        return true
    }
    
    mutating func engageEngine() -> EngineState {
        self.engineState = .on
        return self.engineState
    }
    
    mutating func disengageEngine() -> EngineState {
        self.engineState = .off
        return self.engineState
    }
        
    mutating func openWindows() -> WindowsState {
        self.windowsState = .open
        return self.windowsState
    }

    mutating func closeWindows() -> WindowsState {
        self.windowsState = .close
        return self.windowsState
    }
}

var passCar1 = PassengerCar(
    brand: "kia", model: "soul", year: 2018, luggageEmpty: 364, cargo: 0,
    engineState: .off, windowsState: .close)

print("Car#1 Brand:", passCar1.brand)
print("Car#1 Model:", passCar1.model)
print("Free space in luggage:", passCar1.luggageFree)

print("Current windows state:", passCar1.windowsState)
print("Current engine state:", passCar1.engineState)

print("Try open windows:", passCar1.openWindows())
print("Try engage the engine:", passCar1.engageEngine())

var passCar2 = PassengerCar(
    brand: "volkswagen", model: "polo", year: 2020, luggageEmpty: 530, cargo: 0,
    engineState: .on, windowsState: .open)

print("\n\n")
print("Car#2 Brand:", passCar2.brand)
print("Car#2 Model:", passCar2.model)

print("Try to add cargo, result =", passCar2.addCargo(200), ", capacity left =", passCar2.luggageFree)

print("Try to add much more cargo, result =", passCar2.addCargo(600), ", capacity left =", passCar2.luggageFree)

print("Try to remove some cargo, result =", passCar2.addCargo(-20), ", capacity left = ", passCar2.luggageFree)

// Тruck

struct TruckCar {
    let brand: String
    let model: String
    let year: Int
    let luggageEmpty: Double
    
    var cargo: Double
    var engineState: EngineState
    var windowsState: WindowsState

    var luggageFree: Double {
        get {
            return luggageEmpty - cargo
        }
    }

    mutating func addCargo(_ number: Double) -> Bool {
        if cargo + number > luggageEmpty {
            return false
        }
        cargo = cargo + number
        return true
    }

    mutating func engageEngine() -> EngineState {
        self.engineState = .on
        return self.engineState
    }
    mutating func disengageEngine() -> EngineState {
        self.engineState = .off
        return self.engineState
    }
    
    mutating func openWindow() -> WindowsState {
        self.windowsState = .open
        return self.windowsState
    }
    mutating func closeWindows() -> WindowsState {
        self.windowsState = .close
        return self.windowsState
    }
}

var truckCar1 = TruckCar(
    brand: "daf", model: "lf45", year: 2014, luggageEmpty: 10000, cargo: 0,
    engineState: .on, windowsState: .open)

print("\n\n")
print("Truck#1 Brand:", truckCar1.brand)
print("Truck#1 Model:", truckCar1.model)

print("Current windows state:", truckCar1.windowsState)

print("Try close windows:", truckCar1.closeWindows())
print("Try to add cargo, result =",truckCar1.addCargo(1000), ", cargo capacity:", truckCar1.cargo, ", capacity left =", truckCar1.luggageFree)
