//
//  main.swift
//  1
//
//  Created by Mark Lively on 12/1/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

var fuel = 0
var fuel_2 = 0

for l in input1.components(separatedBy: "\n") {
    if var more = Int(l){
        var first = 1
        more = more / 3 - 2
        while more > 0 {
            fuel += first * more
            fuel_2 += more
            first = 0
            more = more / 3 - 2
        }
    }
}

print("Part 1: \(fuel)")
print("Part 2: \(fuel_2)")
