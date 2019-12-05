//
//  main.swift
//  5
//
//  Created by Mark Lively on 12/5/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

func doIt(inArray: inout Array<Int>, input: Int) -> Int{
    var i = 0
    var output = -1
    while inArray[i] != 99 {
        let command = inArray[i] % 100
        var immediate:Array<Bool> = []
        var c = inArray[i]/100
        while c > 0 {
            immediate.append(c%10 == 1)
            c /= 10
        }
        switch command {
        case 1:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
            let reg2 = immediate.count < 2 || !immediate[1] ? inArray[inArray[i+2]] : inArray[i+2]
            let reg3 = inArray[i+3] // never immediate
            inArray[reg3] = reg1 + reg2
            i += 4
        case 2:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
            let reg2 = immediate.count < 2 || !immediate[1] ? inArray[inArray[i+2]] : inArray[i+2]
            let reg3 = inArray[i+3] // never immediate
            inArray[reg3] = reg1 * reg2
            i += 4
        case 3:
            inArray[inArray[i+1]] = input
            i += 2
        case 4:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
            print(reg1)
            output = reg1
            i += 2
        case 5:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
            let reg2 = immediate.count < 2 || !immediate[1] ? inArray[inArray[i+2]] : inArray[i+2]
            if reg1 != 0 {
                i = reg2
            } else {
                i += 3
            }
        case 6:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
            let reg2 = immediate.count < 2 || !immediate[1] ? inArray[inArray[i+2]] : inArray[i+2]
            if reg1 == 0 {
                i = reg2
            } else {
                i += 3
            }
        case 7:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
            let reg2 = immediate.count < 2 || !immediate[1] ? inArray[inArray[i+2]] : inArray[i+2]
            let reg3 = inArray[i+3]
            inArray[reg3] = reg1 < reg2 ? 1 : 0
            i += 4
        case 8:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
            let reg2 = immediate.count < 2 || !immediate[1] ? inArray[inArray[i+2]] : inArray[i+2]
            let reg3 = inArray[i+3]
            inArray[reg3] = reg1 == reg2 ? 1 : 0
            i += 4

        default:
            print("error")
            print(inArray)
            fatalError()
        }
    }
    return output
}

var inArray = test1
assert(3 == doIt(inArray: &inArray, input: 3))

inArray = test2
let _ = doIt(inArray: &inArray, input: 1)
assert(inArray[4] == 99)

inArray = day2
assert (-1 == doIt(inArray: &inArray, input: 0))
assert(inArray[0] == 2890696)

inArray = program
let result = doIt(inArray: &inArray, input: 1)
print("Part 1:\(result)")

//
// PART 2
//

inArray = test3
assert (1 == doIt(inArray: &inArray, input: 8))
inArray = test3
assert (0 == doIt(inArray: &inArray, input: 1))
inArray = test4
assert (1 == doIt(inArray: &inArray, input: 7))
inArray = test4
assert (0 == doIt(inArray: &inArray, input: 10))
inArray = test5
assert (1 == doIt(inArray: &inArray, input: 8))
inArray = test5
assert (0 == doIt(inArray: &inArray, input: 5))
inArray = test6
assert (1 == doIt(inArray: &inArray, input: 7))
inArray = test6
assert (0 == doIt(inArray: &inArray, input: 9))

inArray = test7
assert (1 == doIt(inArray: &inArray, input: 8))
inArray = test7
assert (0 == doIt(inArray: &inArray, input: 0))
inArray = test8
assert (1 == doIt(inArray: &inArray, input: 8))
inArray = test8
assert (0 == doIt(inArray: &inArray, input: 0))

inArray = program
let result2 = doIt(inArray: &inArray, input: 5)
print("Part 2:\(result2)")
