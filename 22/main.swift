//
//  main.swift
//  22
//
//  Created by Mark Lively on 12/29/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

extension Array {
    func cut(_ n:Int)->Array{
        let cut = (self.count + n) % self.count
        return Array(self[cut...]+self[0..<cut])
    
    }
    
    func deal(_ n:Int)->Array{
        var out = self
        for i in 0..<self.count{
            out[(i*n)%self.count] = self[i]
        }
        return out
    }
    
    func stack()->Array{
        return Array(self.reversed())
    }
}

var m = 1
var b = 0
func deal2(_ n:Int, p:Int)->Int{
    m = modMul(a: m, b: n, n: cardCount)
    if b < 0 {b = cardCount - b}
    b = modMul(a: b, b: n, n: cardCount)
    return (p * n) % cardCount
}

func cut2(_ n:Int, p:Int) -> Int {
    b = (b - n + cardCount) % cardCount
    return (p - n + cardCount) % cardCount
}

func stack2(p:Int) -> Int {
    m *= -1
    b = cardCount - b - 1
    return cardCount - p - 1
}


/// mod code adapted from https://github.com/vilya/AdventOfCode-2019/blob/master/day22/day22b.cpp

func modExp(base:Int, exp:Int, n:Int) -> Int {
    var bit = 1
    var p = base % n
    var out = 1
    while bit <= exp {
        if exp & bit != 0 {
            out = modMul(a:out, b:p, n:n)
        }
        p = modMul(a: p, b: p, n: n)
        bit <<= 1
    }
    return out
}

func gcdExtended(a: Int, b:Int, x: inout Int, y:inout Int) ->Int {
    if a == 0 {return b}
    var x1:Int = 0
    var y1:Int = 1
    let gcd = gcdExtended(a: b%a, b: a, x: &x1, y: &y1)
    x = y1 - (b/a) * x1
    y = x1
    return gcd
}

func modInv(b:Int, n:Int) -> Int {
    var y:Int = 1
    var x:Int = 0
    let g = gcdExtended(a: b, b: n, x: &x, y: &y)
    return g != 1 ? -1 : (x % n + n) % n
}

func modDiv(a:Int, b:Int, n:Int) -> Int {
    let b2 = modInv(b: b, n: n)
    return modMul(a: a, b: b2, n: n)
}

func modMul(a:Int, b:Int, n:Int) -> Int {
    var o = 0
    let s:Int = 32768
    let split = s * s
    let a1 = a / split
    let a2 = a % split
    let b1 = b / split
    let b2 = b % split
    let c1 = (a2 * b2) % n
    let c2 = (a1 * b2) % n * s % n * s % n
    let c3 = (a2 * b1) % n * s % n * s % n
    let c4 = (a1 * b1) % n * s % n * s % n * s % n * s % n
    o = (c1 + c2 + c3 + c4) % n
    return o
}


var cardCount:Int = 10
var deck = Array(0..<10)
print(deck.cut(-3))
print(cut2(-3,p:5))
print(deck.deal(3))
print(deal2(3,p:5))
print(deck.deal(7).reversed().reversed())
print(stack2(p:stack2(p:deal2(7,p:0))))

    
print(deck.cut(6).deal(7).stack())
print(stack2(p:deal2(7,p:cut2(6,p:5))))

var t:Int = 3
for _ in 0..<10 {
    t = deal2(3,p: t)
    deck = deck.deal(3)
}
print(t,deck)
print(stack2(p: 0))

print(deck.stack().cut(-2).deal(7).cut(8).cut(-4).deal(7).cut(3).deal(9).deal(3).cut(-1))

deck = Array(0...10006)
var output = input(deck)
print("Part 1: \(output.firstIndex(of: 2019)!)")

cardCount = 10007
print("Part 1(redo): \(input2(2019))")


// Part 2

var start:Int = 2020
cardCount = 119315717514047
var repition:Int = 101741582076661
var position:UInt = UInt(start)
b = 0
m = 1
_ = input2(220)


//let s:UInt = 65536
//let split = s * s
//let m1 = UInt(m % split)
//let m2 = UInt(m / split)
//for i in 0..<repition {
//    let p1 = UInt(position % split)
//    let p2 = UInt(position / split)
//    let a1 = p1 * m1 % cc
//    let a2 = p1 * m2 % cc * s % cc * s % cc
//    let a3 = p2 % cc * m1 % cc * s % cc * s % cc
//    let a4 = p2 % cc * m2 % cc * s % cc * s % cc * s % cc * s % cc
//    position = (a1 + a2 + a3 + a4 + b) % cc
//    if i%1000000 == 0 {print(i,position)}
//    if position == start {print (i);break}
//}

let fullA = modExp(base: m, exp: repition, n: cardCount)
let fullB = modMul(a:b ,b:modDiv(a: modExp(base: m, exp: repition, n: cardCount) - 1, b: m - 1, n: cardCount), n:cardCount)

let ans = (modDiv(a: ((start - fullB + cardCount) % cardCount), b: fullA, n: cardCount) + cardCount) % cardCount
print("Part 2:\(ans)")

