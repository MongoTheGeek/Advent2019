//
//  main.swift
//  21
//
//  Created by Mark Lively on 12/29/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

let c = Computer(program: input, input: [])
c.final = {print($0)}
//let s = """
//OR C T
//AND D T
//OR T J
//NOT B T
//AND T J
//NOT A T
//AND D T
//OR T J
//WALK
//
//"""
let s = """
OR D J
NOT B T
AND T J
NOT A T
OR T J
OR D T
AND H T
NOT T T
OR C T
NOT T T
OR T J
RUN

"""

c.inputString(s: s)
var out = ""
c.output = {
    guard $0<255 else {return}
    if $0 != 10 {
        let i = UInt8($0)
        out.append(String(bytes:[i], encoding: .ascii)!)
    } else {
        print(out)
        out = ""
    }
}

c.doIt()
print(c.status)
