//
//  main.swift
//  3
//
//  Created by Mark Lively on 12/3/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

struct Point:Equatable,Hashable {
    let i:Int
    let j:Int
    
    func dist() -> Int {
        return abs(i) + abs(j)
    }
}

func lines(_ input:String) ->Set<Point> {
    return Set(line(input))
}

func line(_ input:String) -> Array<Point> {
    var out:Array<Point> = []
    var i = 0
    var j = 0
    for command in  input.components(separatedBy: ","){
        let c = command.first!
        let n = Int(String(command.dropFirst()))!
        switch c {
        case "U":
            for _ in 0 ..< n {
                j += 1
                out.append(Point(i: i, j: j))
            }
        case "D":
            for _ in 0 ..< n {
                j -= 1
                out.append(Point(i: i, j: j))
            }
        case "L":
            for _ in 0 ..< n {
                i -= 1
                out.append(Point(i: i, j: j))
            }
        case "R":
            for _ in 0 ..< n {
                i += 1
                out.append(Point(i: i, j: j))
            }
        default:
            fatalError()
        }
    }
    return out
}

var s1 = lines(test1a)
var s2 = lines(test1b)
var s = s1.intersection(s2)
var o = Array(s1.intersection(s2)).map{$0.dist()}.min()!
print (o,testans1a)

var a1 = line(test1a)
var a2 = line(test1a)
var time = a1.count+a2.count + 2
for p in s {
    print(p)
    let t = a1.firstIndex(of: p)! + a2.firstIndex(of: p)! + 2
    time = min(t,time)
}
print ("\(testans1b) \(time)")



s1 = lines(test2a)
s2 = lines(test2b)
s = s1.intersection(s2)
o = Array(s1.intersection(s2)).map{$0.dist()}.min()!
print (o,testans2a)

a1 = line(test2a)
a2 = line(test2a)
time = a1.count+a2.count + 2
for p in s {
    let t = a1.firstIndex(of: p)! + a2.firstIndex(of: p)! + 2
    time = min(t,time)
}
print ("\(testans2b) \(time)")


s1 = lines(test3a)
s2 = lines(test3b)
s = s1.intersection(s2)
o = Array(s1.intersection(s2)).map{$0.dist()}.min()!
print (o,testans3a)

a1 = line(test3a)
a2 = line(test3b)
time = a1.count+a2.count + 2
for p in s {
    let t = a1.firstIndex(of: p)! + a2.firstIndex(of: p)! + 2
    time = min(t,time)
}
print ("\(testans3b) \(time)")


s1 = lines(input1a)
s2 = lines(input1b)
s = s1.intersection(s2)
o = Array(s).map{$0.dist()}.min()!
print ("Part 1: \(o)")

a1 = line(input1a)
a2 = line(input1b)
time = a1.count+a2.count + 2
for p in s {
    let t = a1.firstIndex(of: p)! + a2.firstIndex(of: p)! + 2
    time = min(t,time)
}
print ("Part 2: \(time)")
