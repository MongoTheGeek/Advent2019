//
//  main.swift
//  7
//
//  Created by Mark Lively on 12/7/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

func factorial(n:Int)->Int {
    switch n {
    case 0:
        return 1
    case 1:
        return 1
    case 2:
        return 2
    case 3:
        return 6
    case 4:
        return 24
    case 5:
        return 120
    case 6:
        return 720
    default:
        return n * factorial(n: n-1)
    }
}
func nthSequence(inSeq:Array<Int>,n:Int)->Array<Int>{
    if inSeq.count == 1 {return inSeq}
    var out: Array<Int> = []
    let j = factorial(n: inSeq.count - 1)
    out.append(inSeq[n/j])
    var temp = inSeq
    temp.remove(at: n/j)
    out +=  nthSequence(inSeq: temp, n: n%j)
    return out
}

func doIt(inArray: inout Array<Int>, input: Array<Int>) -> Int{
    var i = 0
    var j = 0
    var output = -1
    while inArray[i] != 99 {
        let command = inArray[i] % 100
        var immediate:Array<Bool> = []
        var c = inArray[i]/100
        while c > 0 {
            immediate.append(c%10 == 1)
            c /= 10
        }
        switch command {
        case 1:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
            let reg2 = immediate.count < 2 || !immediate[1] ? inArray[inArray[i+2]] : inArray[i+2]
            let reg3 = inArray[i+3] // never immediate
            inArray[reg3] = reg1 + reg2
            i += 4
        case 2:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
            let reg2 = immediate.count < 2 || !immediate[1] ? inArray[inArray[i+2]] : inArray[i+2]
            let reg3 = inArray[i+3] // never immediate
            inArray[reg3] = reg1 * reg2
            i += 4
        case 3:
            inArray[inArray[i+1]] = input[j]
            j += 1
            i += 2
        case 4:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
//            print(reg1)
            output = reg1
            i += 2
        case 5:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
            let reg2 = immediate.count < 2 || !immediate[1] ? inArray[inArray[i+2]] : inArray[i+2]
            if reg1 != 0 {
                i = reg2
            } else {
                i += 3
            }
        case 6:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
            let reg2 = immediate.count < 2 || !immediate[1] ? inArray[inArray[i+2]] : inArray[i+2]
            if reg1 == 0 {
                i = reg2
            } else {
                i += 3
            }
        case 7:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
            let reg2 = immediate.count < 2 || !immediate[1] ? inArray[inArray[i+2]] : inArray[i+2]
            let reg3 = inArray[i+3]
            inArray[reg3] = reg1 < reg2 ? 1 : 0
            i += 4
        case 8:
            let reg1 = immediate.count < 1 || !immediate[0] ? inArray[inArray[i+1]] : inArray[i+1]
            let reg2 = immediate.count < 2 || !immediate[1] ? inArray[inArray[i+2]] : inArray[i+2]
            let reg3 = inArray[i+3]
            inArray[reg3] = reg1 == reg2 ? 1 : 0
            i += 4

        default:
            print("error")
            print(inArray)
            fatalError()
        }
    }
    return output
}

func runSeq(input:Array<Int>, seq:Array<Int>) -> Int {
    var power = 0
    for s in seq {
        var running = input
        power = doIt(inArray: &running, input: [s,power])
    }
    return power
}


func maxSeq(input:Array<Int>, seq:Array<Int>) -> (Int,Array<Int>){
    var max = 0
    var outSeq:Array<Int> = []
    for i in 0..<factorial(n: seq.count){
        let pow = runSeq(input: input, seq: nthSequence(inSeq: seq, n: i))
        if pow > max {
            max = pow
            outSeq = nthSequence(inSeq: seq, n: i)
        }
    }
    return (max,outSeq)
}

print("Test 1:\(runSeq(input:test1,seq:test1s)), 43210, \(maxSeq(input: test1, seq: masterSequence))")
print("Test 2:\(runSeq(input:test2,seq:test2s)), 54321, \(maxSeq(input: test2, seq: masterSequence))")
print("Test 3:\(runSeq(input:test3,seq:test3s)), 65210, \(maxSeq(input: test3, seq: masterSequence))")

print("Part 1: \(maxSeq(input: input, seq: masterSequence))")


//
// Rewrite!
//

class Computer {
    enum Status {
        case initialized,running,paused,finished
    }
    let queue: OperationQueue
    var program: Array<Int>
    var status: Status
    var input: Array<Int> = []
    var finalValue: Int = -1
    var output: ((Int) -> ())?
    var final: ((Int) -> ())?
    var i: Int = 0
    init(program:Array<Int>, input:Array<Int>){
        self.program = program
        self.queue = OperationQueue()
        self.status = .initialized
        self.input = input
        self.queue.maxConcurrentOperationCount = 1
    }
    
    func addInput(n:Int) -> () {
        if self.status != .finished {
            queue.addOperation {
                self.input.append(n)
                if self.status == .paused {
                    self.start()
                }
            }
        }
    }
    func start() -> () {
        self.status = .running
        self.queue.addOperation {
            self.doIt()
        }
    }
    
    func doIt(){
        while program[i] != 99 {
            let command = program[i] % 100
            var immediate:Array<Bool> = []
            var c = program[i]/100
            while c > 0 {
                immediate.append(c%10 == 1)
                c /= 10
            }
            switch command {
            case 1:
                let reg1 = immediate.count < 1 || !immediate[0] ? program[program[i+1]] : program[i+1]
                let reg2 = immediate.count < 2 || !immediate[1] ? program[program[i+2]] : program[i+2]
                let reg3 = program[i+3] // never immediate
                program[reg3] = reg1 + reg2
                i += 4
            case 2:
                let reg1 = immediate.count < 1 || !immediate[0] ? program[program[i+1]] : program[i+1]
                let reg2 = immediate.count < 2 || !immediate[1] ? program[program[i+2]] : program[i+2]
                let reg3 = program[i+3] // never immediate
                program[reg3] = reg1 * reg2
                i += 4
            case 3:
                if input.count == 0 {
                    status = .paused
                    return
                }
                program[program[i+1]] = input[0]
                input = Array(input.dropFirst())
                i += 2
            case 4:
                let reg1 = immediate.count < 1 || !immediate[0] ? program[program[i+1]] : program[i+1]
//                print(reg1)
                if let output = output {output(reg1)}
                finalValue = reg1
                i += 2
            case 5:
                let reg1 = immediate.count < 1 || !immediate[0] ? program[program[i+1]] : program[i+1]
                let reg2 = immediate.count < 2 || !immediate[1] ? program[program[i+2]] : program[i+2]
                if reg1 != 0 {
                    i = reg2
                } else {
                    i += 3
                }
            case 6:
                let reg1 = immediate.count < 1 || !immediate[0] ? program[program[i+1]] : program[i+1]
                let reg2 = immediate.count < 2 || !immediate[1] ? program[program[i+2]] : program[i+2]
                if reg1 == 0 {
                    i = reg2
                } else {
                    i += 3
                }
            case 7:
                let reg1 = immediate.count < 1 || !immediate[0] ? program[program[i+1]] : program[i+1]
                let reg2 = immediate.count < 2 || !immediate[1] ? program[program[i+2]] : program[i+2]
                let reg3 = program[i+3]
                program[reg3] = reg1 < reg2 ? 1 : 0
                i += 4
            case 8:
                let reg1 = immediate.count < 1 || !immediate[0] ? program[program[i+1]] : program[i+1]
                let reg2 = immediate.count < 2 || !immediate[1] ? program[program[i+2]] : program[i+2]
                let reg3 = program[i+3]
                program[reg3] = reg1 == reg2 ? 1 : 0
                i += 4

            default:
                print("error")
                print(program)
                fatalError()
            }
        }
        status = .finished
        if let final = final {final(finalValue)}
    }
}

func findBest(program:Array<Int>, masterSeq:Array<Int>, circular:Bool = false) -> (Int,Array<Int>){
    var max = 0
    var seq:Array<Int> = []
    for i in 0 ..< factorial(n: masterSeq.count){
        var compArray:Array<Computer> = []
        for s in nthSequence(inSeq: masterSeq, n: i){
            compArray.append(Computer(program: program, input: [s]))
        }

        for j in 0..<(compArray.count - 1){
            compArray[j].output = {compArray[j+1].addInput(n: $0)}
        }
        if circular {
            compArray[compArray.count - 1].output = {compArray[0].addInput(n: $0)}
        }
        
        let l = NSLock()
        l.lock()
        
        if circular {
            for c in compArray {
                c.final = {
                        if $0 > max {
                            max = $0
                            seq = nthSequence(inSeq: masterSeq, n: i)
                        }
                        l.unlock()
                    }
            }
        } else {
            compArray[compArray.count-1].final = {
                let _ = $0
                l.unlock()
            }
        }
        for c in compArray{c.start()}
        compArray[0].addInput(n: 0)
        l.lock()
        l.unlock()
        for c in compArray{
            if c.finalValue > max && c.status == .finished {
                max = c.finalValue
                seq = nthSequence(inSeq: masterSeq, n: i)
            }
        }
    }
    return (max, seq)
}

print("Rewrite")
print(findBest(program: test1, masterSeq: masterSequence))
print(findBest(program: test2, masterSeq: masterSequence))
print(findBest(program: test3, masterSeq: masterSequence))
print(findBest(program: input, masterSeq: masterSequence))

print(findBest(program: test4, masterSeq: masterSequence2, circular: true))
print(findBest(program: test5, masterSeq: masterSequence2, circular: true))

print("Part 2:\(findBest(program: input, masterSeq: masterSequence2, circular: true))")
