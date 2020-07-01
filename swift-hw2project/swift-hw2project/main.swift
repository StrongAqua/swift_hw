//
//  main.swift
//  swift-hw2project
//
//  Created by aprirez on 7/1/20.
//  Copyright © 2020 alla. All rights reserved.
//

import Foundation

// ----------------------------------------------------------------------------------
print("1. Написать функцию, которая определяет, четное число или нет.")
print("2. Написать функцию, которая определяет, делится ли число без остатка на 3.")

func isEven(number: Int) {
    if number % 2 == 0 {
        print("Число '", number, "' - четное")
    } else {
        print("Число '", number, "' - нечетное")
    }
}

func isDivideByThree(number: Int) {
    if number % 3 == 0 {
        print("Число '", number, "' делится на 3 без остатка")
    } else{
        print("Число '", number, "' не делится на 3 без остатка")
    }
}
print("Введите число:\n")
var number: Int = Int(readLine() ?? "0") ?? 0

isEven(number: number)
isDivideByThree(number: number)

// ----------------------------------------------------------------------------------
print("\n3. Создать возрастающий массив из 100 чисел.")

var increasingArray: [Int] = []
increasingArray.reserveCapacity(100)
for i in 1...100 {
    increasingArray.append(i)
}
print(increasingArray)

// ----------------------------------------------------------------------------------
print("\n4. Удалить из этого массива все четные числа и все числа, которые не делятся на 3.")

var filteredArray = increasingArray.filter{ $0 % 2 != 0 && $0 % 3 == 0 }
print(filteredArray)

// ----------------------------------------------------------------------------------
print("\n5. * Написать функцию, которая добавляет в массив новое число Фибоначчи.")
print("Добавить при помощи нее 100 элементов.")

func fibonacci(_ fibonacciArray: inout [Double]) {
    let l = fibonacciArray.count;
    if l == 0 {
        fibonacciArray.append(0)
    }
    else if l == 1 {
        fibonacciArray.append(1)
    }
    else {
        let last = fibonacciArray[l - 1]
        let previous = fibonacciArray[l - 2]
        fibonacciArray.append(last + previous)
    }
}

// Ни Int, ни UInt не вмещают числа начиная с 94-го числа Фибоначчи.
// Double теряет в точности, но, по крайней мере, не падает и сохраняется порядок числа
// [ 093 ]      7540113804746346496
// [ 094 ]     12200160415121876992
// Должно быть 19740274219868223488, а видим:
// [ 095 ]     19740274219868225536, и т.д.
// ...
// Для точного оперирования бОльшими числами надо создавать свой тип данных.
var fibonacciArray: [Double] = []
for i in 1...100 {
    fibonacci(&fibonacciArray)
    print("[", String(format: "%3d", i), "] -", String(format: "%21.0f", fibonacciArray.last ?? 0.0))
}

// ----------------------------------------------------------------------------------
print("\n6. * Заполнить массив из 100 элементов различными простыми числами.")

var p = 2
let maxNumber: Int = 523 // информация из будущего - сотое простое число :)

// создаём массив:
var array: [Int] = []
for i in 0...maxNumber {
    array.append(i)
}

// просеиваем:
var count = 1 // учли 1-цу
repeat {

    var multi_p = p * 2
    while (multi_p <= maxNumber) {
        array[multi_p] = 0
        multi_p += p
    }

    repeat {
        p += 1
    } while (p <= maxNumber && array[p] == 0)

    count += 1

} while(count < 100 && p <= maxNumber)

// печатаем:
count = 1
for i in 0..<array.count {
    if (array[i] != 0) {
        print("[", String(format: "%3d", count), "] -", String(format: "%3d", array[i]))
        count += 1
    }
}
