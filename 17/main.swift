//
//  main.swift
//  17
//
//  Created by Mark Lively on 12/17/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

let c = Computer(program: input, input: [])
var grid:Array<Array<Int>> = []
var temp:Array<Int> = []

var out:Array<String> = []
c.output = {
    if $0 != 10 {
        temp.append(Int($0))
    } else {
        grid.append(temp)
        temp = []
    }
    let i = UInt8($0)
    out.append(String(bytes:[i], encoding: .ascii)!)
}

c.final = {print("Final: \($0)")}
c.doIt()
print(c.status)

print(out.joined())

var total = 0
for j in 1..<grid.count-2 {
    for i in 1..<grid[0].count-1 {
        if grid[j][i] != 46 {
            if grid[j+1][i] != 46 && grid[j-1][i] != 46 && grid[j][i+1] != 46 && grid[j][i-1] != 46 {
                total += j*i
            }
        }
    }
}

print("Part 1: \(total)")

var program = input
program[0]=2
var stringInput = "C,C,B,A,B,A,B,A,A,C\nR,10,R,4,R,4\nL,12,L,12,R,8,R,8\nR,8,L,4,R,4,R,10,R,8\nN\n"

let computer2 = Computer(program: program, input: stringInput.map{Int64($0.asciiValue!)})

computer2.output = {
    guard $0<255 else {return}
    if $0 != 10 {
        temp.append(Int($0))
        let i = UInt8($0)
        out.append(String(bytes:[i], encoding: .ascii)!)
    } else {
        grid.append(temp)
        temp = []
        print(out.joined())
        out = []
    }
}

computer2.final = {print("Part 2: \($0)")}

computer2.doIt()
print(computer2.status)

print(out.joined())
