//
//  Computer.swift
//  9
//
//  Created by Mark Lively on 12/9/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation


class Computer {
    enum Status {
        case initialized,running,paused,finished
    }
    enum Mode: Int {
        case position, immediate, relative
    }

    func read(i:Int, mode:Mode) -> Int64{
        if mode == .immediate {return Int64(program[i])}
        while i >= program.count {
            program.append(0)
        }
        let n = (mode == .position ? Int(program[i]) : relative + Int(program[i]))
        while n >= program.count {
            program.append(0)
        }
        return program[n]
    }

    func outputLocation(i:Int, mode:Mode) -> Int{
        if mode == .immediate {fatalError()}
        while i >= program.count {
            program.append(0)
        }
        let n = (mode == .position ? Int(program[i]) : relative + Int(program[i]))
        return n
    }

    func write(i:Int, data:Int64){
        while i >= program.count {
            program.append(0)
        }
        program[i] = data
    }

    let queue: OperationQueue
    var program: Array<Int64>
    var status: Status
    var input: Array<Int64> = []
    var finalValue: Int64 = -1
    var output: ((Int64) -> ())?
    var final: ((Int64) -> ())?
    var relative = 0
    var i: Int = 0
    var debug = false

    init(program:Array<Int64>, input:Array<Int64>){
        self.program = program
        self.queue = OperationQueue()
        self.status = .initialized
        self.input = input
        self.queue.maxConcurrentOperationCount = 1
    }
    
    func addInput(n:Int64) -> () {
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
            var immediate:Array<Mode> = []
            var c = Int(program[i]/100)
            for _ in 0..<3 {
                immediate.append(Mode(rawValue:(c%10))!)
                c /= 10
            }
            var reg1:Int64 = 0
            var reg2:Int64 = 0
            var reg3i = 0
            var reg1i = 0
            reg1 = read(i: i+1, mode: immediate[0])
            if [3].contains(command) {reg1i = outputLocation(i: i+1, mode: immediate[0])}
            if [1,2,5,6,7,8].contains(command) {reg2 = read(i: i+2, mode: immediate[1])}
            if [1,2,7,8].contains(command) {reg3i = outputLocation(i: i+3, mode: immediate[2])}
            switch command {
            case 1:
                write(i: reg3i, data: reg1+reg2)
                if debug {print(i , program[i], "Write \(reg1) + \(reg2) to \(reg3i)")}
                i += 4
            case 2:
                write(i: reg3i, data: reg1*reg2)
                if debug {print(i , program[i], "Write \(reg1) * \(reg2) to \(reg3i)")}
                i += 4
            case 3:
                if input.count == 0 {
                    status = .paused
                    return
                }
                write(i: reg1i, data: input[0])
                if debug {print(i , program[i], "Input \(input[0]) to \(reg1i)")}
                input = Array(input.dropFirst())
                i += 2
            case 4:
//                print(reg1)
                if let output = output {output(reg1)}
                if debug {print(i , program[i], "Output \(reg1)")}
                finalValue = reg1
                i += 2
            case 5:
                if debug {print(i , program[i], "if \(reg1) goto \(reg2)")}
                if reg1 != 0 {
                    i = Int(reg2)
                } else {
                    i += 3
                }
            case 6:
                if debug {print(i , program[i], "if not \(reg1) goto \(reg2)")}
                if reg1 == 0 {
                    i = Int(reg2)
                } else {
                    i += 3
                }
            case 7:
                if debug {print(i , program[i], "Write \(reg1) < \(reg2) to \(reg3i)")}
                write(i: reg3i, data: (reg1 < reg2 ? 1 : 0))
                i += 4
            case 8:
                if debug {print(i , "Write \(reg1) == \(reg2) to \(reg3i)")}
                write(i: reg3i, data: (reg1 == reg2 ? 1 : 0))
                i += 4
            case 9:
                relative += Int(reg1)
                if debug {print(i , "Increment Relative by \(reg1) currently \(relative)")}
//                print(reg1,relative,i)
                i += 2
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
