//
//  main.swift
//  19
//
//  Created by Mark Lively on 12/25/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation


var count:Int = 0
var temp = ""

for j:Int in 0..<50 {
    for i:Int in 0..<50 {
        let c = Computer(program: input, input: [i,j])
        c.output = {
            count += $0
            temp += $0 == 0 ? "." : "#"
       }
        c.doIt()
    }
    print(temp,count)
    temp = ""
}

print("Part 1:\(count)")

func solve(_ i:Int,_ j:Int) ->Bool{
    var temp:Bool = false
    let c = Computer(program: input, input: [Int(i),Int(j)])
    c.output = {temp = $0 == 1}
    c.doIt()
    return temp
}

var found = false
var j = 1330
var i = 0
repeat{
    var i = j * 5 / 4
    if solve(i, j){
        repeat {i+=1} while solve(i,j)
        i -= 1
    } else {
        repeat {i-=1} while !solve(i,j)
    }
    var i2 = i-99
    var j2 = j+99
    if solve(i2,j2) {
        repeat {i2-=1}while solve(i2,j2)
        i2 += 1
        print("Part2: \(i2)\(j)")
        found = true
    } else {
        j+=1
    }
} while !found
