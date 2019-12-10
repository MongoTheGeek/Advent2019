//
//  main.swift
//  9
//
//  Created by Mark Lively on 12/9/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

let cTest1 = Computer(program: test1, input: [])
cTest1.output = {print($0)}
cTest1.final = {print($0)}
cTest1.doIt()
print(cTest1.program)

let cTest2 = Computer(program: test2, input: [])
cTest2.output = {print($0)}
cTest2.final = {print($0)}
cTest2.doIt()
print(cTest2.program)

let cTest3 = Computer(program: test3, input: [])
cTest3.output = {print($0)}
cTest3.final = {print($0)}
cTest3.doIt()
print(cTest3.program)

let computer = Computer(program: input, input: [1])
computer.output = {print($0)}
computer.final = {print("Part 1: \($0)")}
computer.doIt()

let computer2 = Computer(program: input, input: [2])
computer2.output = {print($0)}
computer2.final = {print("Part 2: \($0)")}
computer2.doIt()
