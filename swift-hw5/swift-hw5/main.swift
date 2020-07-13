//
//  main.swift
//  swift-hw5
//
//  Created by aprirez on 7/13/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation


enum EngineState {
    case on, off
}

enum WindowsState {
    case opened, closed
}
// Создала базовый класс машин, чтобы не описывать их каждый раз
class BasicCar {
    let brand: String
    let model: String
    
    var engineState: EngineState
    var windowsState: WindowsState

    init(brand: String, model: String) {
        self.brand = brand
        self.model = model

        self.engineState = .off
        self.windowsState = .closed
    }
}

protocol ProtocolCar {
    var engineState: EngineState { get set }
    var windowsState: WindowsState { get set }

    mutating func engageEngine() -> EngineState
    mutating func disengageEngine() -> EngineState
    mutating func openWindows() -> WindowsState
    mutating func closeWindows() -> WindowsState
}

extension ProtocolCar {

    mutating func engageEngine() -> EngineState {
        engineState = .on
        return engineState
    }
    
    mutating func disengageEngine() -> EngineState {
        engineState = .off
        return engineState
    }
    mutating func openWindows() -> WindowsState {
        windowsState = .opened
        return windowsState
    }

    mutating func closeWindows() -> WindowsState {
        windowsState = .closed
        return windowsState
    }
    
}

protocol ConsolePrintable: CustomStringConvertible {
    func printDescription()
}
extension ConsolePrintable{
    func printDescription() {
        print(description)
    }
}


enum VanState {
    case attached, detached
}
// Создаем класс цистерн
class TrunkCar: BasicCar, ProtocolCar,  ConsolePrintable {
    var vanState: VanState

    init(brand: String, model: String, vanState: VanState) {
        self.vanState = vanState
        super.init(brand: brand, model: model)
    }
    
    func attachVan() {
        vanState = .attached
    }
    
    func detachVan() {
        vanState = .detached
    }
    
    var description: String {
        return "Brand: \(brand),\nModel: \(model),\nVan State: \(vanState),\nWindows State: \(windowsState),\nEngine: \(engineState)"
    }
    
}

var trunkCar = TrunkCar(brand: "Volvo", model: "Experimental", vanState: .detached)

_ = trunkCar.engageEngine()
_ = trunkCar.attachVan()
trunkCar.printDescription()

enum NeonLight {
    case attached, detached
}

//Создаем класс спортивных машин
class SportCar: BasicCar, ProtocolCar,  ConsolePrintable {
    var neonLight: NeonLight
    
    init(brand: String, model: String, neonLight: NeonLight) {
        self.neonLight = neonLight
        super.init(brand: brand, model: model)
    }
    
    func attachNeonLight() {
        neonLight = .attached
    }
    
    func detachNeonLight() {
        neonLight = .detached
    }
    
    var description: String {
        return "Brand: \(brand),\nModel: \(model),\nNeon Light: \(neonLight),\nWindows State: \(windowsState),\nEngine: \(engineState)"
    }
    
}

var sportCar = SportCar(brand: "Maserati", model: "Experimental", neonLight: .detached)

print("\n")
_ = sportCar.closeWindows()
_ = sportCar.attachNeonLight()
sportCar.printDescription()
