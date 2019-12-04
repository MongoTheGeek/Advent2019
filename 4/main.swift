//
//  main.swift
//  4
//
//  Created by Mark Lively on 12/4/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

func test(_ n:Int)->Bool{
    var digits = Array<Int>()
    var t = n
    while t > 0 {
        digits.append(t % 10)
        t /= 10
    }
    var double = false
    for i in 1..<digits.count{
        if digits[i]>digits[i-1] { return false }
        if digits[i] == digits[i-1] { double = true }
    }
    return double
}

func test2(_ n:Int)->Bool{
    var digits = Array<Int>()
    var t = n
    while t > 0 {
        digits.append(t % 10)
        t /= 10
    }
    var double = false
    var last = 99
    var count = 0
    for t in digits {
        if t > last {return false}
        if t == last {
            count += 1
        } else {
            last = t
            if count == 2 { double = true }
            count = 1
        }
    }
    if count == 2 {double = true}
    return double
}

var (n,a) = test1
assert( a == test(n))
(n,a) = test2
assert( a == test(n))
(n,a) = test3
assert( a == test(n))


(n,a) = test4
assert( a == test2(n))
(n,a) = test5
assert( a == test2(n))
(n,a) = test6
assert( a == test2(n))

var count = 0
var count2 = 0
for n in inputa...inputb {
    if test(n) {count += 1}
    if test2(n) {count2 += 1}
}

print("Part 1:\(count)")
print("Part 2:\(count2)")
