//
//  main.swift
//  swift_hw4
//
//  Created by aprirez on 7/8/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import SwiftUI


enum Transmission {
    case manual, auto
}

enum EngineState {
    case on, off
}

enum WindowsState {
    case opened, closed
}

enum GasEquipment {
    case attached, detached
}

class Car {
    let brand: String
    let model: String
    let year: Int
    let color: Color
    let transmission: Transmission
    let luggageEmpty: Double
    
    var cargo: Double
    var engineState: EngineState
    var windowsState: WindowsState
    var gasEquipment: GasEquipment

    var luggageFree: Double {
        get {
            return luggageEmpty - cargo
        }
    }
    
    func addCargo(_ number: Double) -> Bool {
        if cargo + number > luggageEmpty {
            return false
        }
        cargo = cargo + number
        return true
    }
    
    func engageEngine() -> EngineState {
        engineState = .on
        return engineState
    }
    
    func disengageEngine() -> EngineState {
        self.engineState = .off
        return self.engineState
    }
        
    func openWindows() -> WindowsState {
        self.windowsState = .opened
        return self.windowsState
    }

    func closeWindows() -> WindowsState {
        self.windowsState = .closed
        return self.windowsState
    }
    
    // описываем пустой метод действия по заданию №1
    func attachGasEquipment() -> Bool { return false }
    func detachGasEquipment() -> Bool { return false }

    init(brand: String, model: String, year: Int, color: Color,
         transmission: Transmission, luggageEmpty: Double) {
        self.brand = brand
        self.model = model
        self.year = year
        self.color = color
        self.transmission = transmission
        self.luggageEmpty = luggageEmpty

        self.cargo = 0
        self.engineState = .off
        self.windowsState = .closed
        self.gasEquipment = .detached
    }
    func printInfo() {
        print("Brand:", brand)
        print("Model:", model)
        print("Year:", year)
        print("Color:", color)
        print("Transmission:", transmission)
        print("Luggage:", luggageEmpty)
        print("Cargo:", cargo)
        print("Luggage free:", luggageFree)
        print("EngineState:", engineState)
        print("WindowsState:", windowsState)
        print("GasEquipment:", gasEquipment)
    }
}
    
enum VanState {
    case attached, detached
}

class TrunkCar: Car {
    var vanState: VanState
    
    override init(brand: String, model: String, year: Int, color: Color,
         transmission: Transmission, luggageEmpty: Double) {
        self.vanState = .detached
        super.init(brand: brand, model: model, year: year, color: color, transmission:  transmission, luggageEmpty: luggageEmpty)
    }
    
    func attachVan() {
        vanState = .attached
    }
    func detachVan() {
        vanState = .detached
    }

    override func addCargo(_ number: Double) -> Bool {
        if (vanState == .attached) {
            return super.addCargo(number) //не разрешаем грузить без прицепа
        }
        print("Attach the van, please")
        return false
    }
    
    override func attachGasEquipment() -> Bool {
        if self.gasEquipment == .attached {
            return false
        }
        self.gasEquipment = .attached
        return true
    }
    override func detachGasEquipment() -> Bool {
        if self.gasEquipment == .detached {
            return false
        }
        self.gasEquipment = .detached
        return true
    }
    override func printInfo() {
        super.printInfo()
        print("Van:", vanState)
    }
}
    
var truckCar1 = TrunkCar(brand: "liaf", model: "lf-8", year: 2015, color: .white, transmission: .manual, luggageEmpty: 20000)

print("[Truck Car #1]")
truckCar1.printInfo()

truckCar1.attachVan()
_ = truckCar1.attachGasEquipment()
_ = truckCar1.addCargo(1000)

print("\n\n")
print("[Truck Car #1] - after modifications")
truckCar1.printInfo()


enum NeonLight {
    case attached, detached
}
enum NOS {
    case attached, detached
}

class SportCar: Car {
    var neonLight: NeonLight //неоновая подсветка
    var nos: NOS //система впрыска закиси азота
    
    init(brand: String, model: String, year: Int, color: Color,
         transmission: Transmission, luggageEmpty: Double, neonLight: NeonLight,
         nos: NOS) {
        self.neonLight = neonLight
        self.nos = nos
        super.init(brand: brand, model: model, year: year, color: color, transmission:  transmission, luggageEmpty: luggageEmpty)
    }

    func attachNeonLight() {
        neonLight = .attached
    }
    func detachNeonLight() {
        neonLight = .detached
    }
    
    
    func attachNOS() {
        nos = .attached
    }
    func detachNOS() {
        nos = .detached
    }
    
    override func addCargo(_ number: Double) -> Bool {
        print("Don't add cargo! Handsome men don't carry goods.")
        return false
    }
    
    override func attachGasEquipment() -> Bool {
        return false
    }
    
    override func printInfo() {
        super.printInfo()
        print("Neon:", neonLight)
        print("Nitrous Oxide System:", nos)
        
    }
}
    
var sportCar1 = SportCar(brand: "Maserati", model: "Granturismo", year: 2020, color: .red, transmission: .manual, luggageEmpty: 0, neonLight: .detached, nos: .detached)

print("\n\n")
print("[Sport Car #1]")
sportCar1.printInfo()

sportCar1.attachNeonLight()
sportCar1.attachNOS()

print("\n\nTrying add cargo to sport car...")
_ = sportCar1.addCargo(1000)

print("\n\n")
print("[Sport Car #1] - after modifications")
sportCar1.printInfo()
