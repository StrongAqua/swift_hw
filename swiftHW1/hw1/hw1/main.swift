//
//  main.swift
//  hw1
//
//  Created by aprirez on 6/27/20.
//  Copyright © 2020 alla. All rights reserved.
//

import Foundation

//---------------Task 1------------
let equation: String = "(2(x^2))-4x+2=0"
print("Решаем квадратное уравнение: ", equation)
let a: Double = 2
let b: Double = -4
let c: Double = 2
let discr: Double = (b*b)-(4*a*c)
if discr < 0 {
    print("Уравнение не имеет корней.")
}
else if discr == 0 {
    let x: Double = -b/(2*a)
    print("Корень уравнения равен ", x)
}
else {
    let x1: Double = (-b + sqrt(discr))/2*a
    let x2: Double = (-b - sqrt(discr))/2*a
    print("Уравнение имеет два корня ", x1, x2)
}

//----------------Task 2-----------
let сathet1: Double = 5
let сathet2: Double = 7
let hypotenuse: Double = sqrt(сathet1*сathet1 + сathet2*сathet2)
let perimeter: Double = сathet1 + сathet2 + hypotenuse
let square: Double = (сathet1*сathet2)/2

print("Гипотенуза равна ", String(format: "%.2f", hypotenuse),
      "\nПериметр равен ", String(format: "%.2f", perimeter),
      "\nПлощадь равна ", String(format: "%.2f", square))

//----------------Task 3-------------
print("\n\n")

var summ: Double = 0
var perc: Double = 0

repeat {
    print("Введите сумму вклада\n")
    summ = Double(readLine() ?? "0") ?? 0
} while summ <= 0


repeat {
    print("Введите процент вклада\n")
    perc = Double(readLine() ?? "0") ?? 0
} while perc <= 0

for i in 1...5 {
    summ += summ * perc/100
    print( "Год: ", i, ", текущая сумма вклада ", String(format: "%.2f", summ), "\n")
}
