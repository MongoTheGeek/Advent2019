//
//  main.swift
//  8
//
//  Created by Mark Lively on 12/8/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

let x = 25
let y = 6
let area = x * y
let layerCount = input.count / area
var mapped:Array<String> = []
for i in 0..<layerCount {
    mapped.append(String(input.dropFirst(i*area).dropLast((layerCount - i - 1)*area)))
}
let zCount = mapped.map{$0.components(separatedBy: "0").count}
let zLayer = zCount.firstIndex(of: zCount.min()!)!
let oneCount = mapped[zLayer].components(separatedBy: "1").count - 1
let twoCount = mapped[zLayer].components(separatedBy: "2").count - 1
print(input.count, area, zCount, oneCount, twoCount)
print("Part 1: \(oneCount * twoCount)")

let a = Array(input)

var outString = ""
for i in 0..<area{
    if i % x == 0 {outString.append("\n")}
    for j in 0..<mapped.count {
        if a[i+area*j] != "2" {
            outString.append(a[i+area*j])
            break
        }
    }
}

print ("Part 2:\(outString)")
