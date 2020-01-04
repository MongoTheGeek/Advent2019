//
//  main.swift
//  23
//
//  Created by Mark Lively on 1/3/20.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation

class Nat{
    var done:Bool = false
    var lastSent =  (-1,-1)
    var current = (-1,-1)
    
    func send(){
        if lastSent == current {
            print("Part 2: \(current)")
            done = true
        } else {
            print("NAT SEND \(current)")
            lastSent = current
            cArray[0].c.addInput(n: current.0)
            cArray[0].c.addInput(n: current.1)
        }
    }
    
    func update(_ i :(Int,Int)){
        current = i
    }
}
class CachedComputer {
    let i:Int
    var c:Computer
    var output:Array<Int> = []
    var nat:Nat
    
    init (_ i:Int, n:Nat, q:OperationQueue? = nil){
        nat = n
        self.i = i
        c = Computer(program: input, input: [i], q:q)
        weak var s = self
        weak var n = self.nat
        c.output = {
            s?.output.append($0)
            if s?.output.count == 3{
                let a = s!.output[0]
                let b = s!.output[1]
                let c = s!.output[2]
                if a == 255 {
                    print ("Part 1:\(a), \(b), \(c)")
                    n?.update((b,c))
                }
                if a < cArray.count && a != s!.i {
                    cArray[a].c.addInput(n:b)
                    cArray[a].c.addInput(n:c)
                } else if a == s!.i {
                    s!.c.input.append(b)
                    s!.c.input.append(c)
                }
                s?.output = []
            }
        }
        c.final = {
            print($0)
        }
    }
}


var cArray:Array<CachedComputer> = []
var nat = Nat()
let q = OperationQueue()
for i in 0..<50 {
    let cc = CachedComputer(i, n:nat, q:q)
    cArray.append(cc)
}

for c in cArray{
    c.c.doIt()
}

var n = 0
repeat {
    if n > 2 && cArray.reduce(true, {$0 && $1.c.status == .paused}){
        n = 0
        nat.send()
        for i in 1..<cArray.count {
            cArray[i].c.addInput(n: -1)
        }
    } else {
        if cArray.reduce(true, {$0 && $1.c.status == .paused}) {
            n += 1
            for c in cArray{
                if c.c.status == .paused {
                    if c.c.input.count == 0 {
                        c.c.addInput(n: -1)
                    } else {
                        c.c.start()
                    }
                }
            }
        }
    }
} while !nat.done
