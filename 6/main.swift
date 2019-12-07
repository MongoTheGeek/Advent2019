//
//  main.swift
//  6
//
//  Created by Mark Lively on 12/6/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

var planets:Dictionary<String,String> = [:]

func parse(_ input:String)->Dictionary<String,String> {
    var out:Dictionary<String,String> = [:]
    for l in input.components(separatedBy:"\n"){
        let p1 = l.components(separatedBy:")")[0]
        let p2 = l.components(separatedBy:")")[1]
        out[p2] = p1
    }
    return out
}

func count(_ input:Dictionary<String,String>)->Int{
    var result = 0
    let keys = input.keys
    for k in keys {
        var t = k
        while keys.contains(input[t]!) {
            result += 1
            t = input[t]!
        }
        result += 1
    }
    return result
}

func upToRoot(_ k:String, input:Dictionary<String,String>) -> Array<String> {
    let keys = input.keys
    var t = k
    var out:Array<String> = []
    while keys.contains(input[t]!){
        t = input[t]!
        out.append(t)
    }
    return out
}


var result = count(parse(test1))
print("test \(result)")

planets = parse(input)
result = count(planets)

print("Part 1: \(result)") //278786 too high

planets = parse(test2)
var you = upToRoot("YOU", input: planets)
var santa = upToRoot("SAN", input: planets)
var common = ""
result = 0
for s in santa{
    if you.contains(s){common = s ; break}
    result += 1
}
result += you.firstIndex(of: common)!
print("Test 2:\(result)")

planets = parse(input)
you = upToRoot("YOU", input: planets)
santa = upToRoot("SAN", input: planets)
common = ""
result = 0
for s in santa{
    if you.contains(s){common = s ; break}
    result += 1
}
result += you.firstIndex(of: common)!
print("Part 2:\(result)")
