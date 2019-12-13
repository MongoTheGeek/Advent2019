//
//  main.swift
//  11
//
//  Created by Mark Lively on 12/11/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

struct Point:Equatable,Hashable,CustomStringConvertible {
    let x:Int
    let y:Int
    var description:String { return "(\(x),\(y))"}
    func theta(i:Int, j:Int) -> Double {
        if x >= i {
            return  Double.pi / 2.0 - atan(Double(j-y)/Double(x-i))
        } else {
            return 3.0 * Double.pi / 2.0 - atan(Double(j-y)/Double(x-i))
        }
    }
}

extension Dictionary where Value == Bool {
    mutating func getVal(_ input:Key) ->Bool{
        if self.keys.contains(input) {return self[input]!}
        self[input] = false
        return false
    }
}

var computer = Computer(program: input , input: [0])
var direction = 0
var x = 0
var y = 0
var output : Dictionary<Point,Bool> = [:]
var step = 0
var pointSet : Set<Point> = []


computer.output = {
    if step == 0 {
        step = 1
        output[Point(x:x,y:y)] = $0 == 1
        pointSet.insert(Point(x:x,y:y))
    } else {
        step = 0
        if $0 == 1 {
            direction = (direction + 1) % 4
        } else {
            direction = (direction + 3) % 4
        }
        switch direction {
            case 0:
                y -= 1
            case 1:
                x += 1
            case 2:
                y += 1
            case 3:
                x -= 1
            default:
                fatalError()
        }
        computer.input.append( output.getVal(Point(x:x,y:y)) ? 1 : 0)
        
    }
}

computer.final = {
    print($0)
    print("Part 1: \(pointSet.count)")
    
}

computer.doIt()

direction = 0
x = 0
y = 0
output = [:]
pointSet = []
computer = Computer(program: input , input: [1])
computer.output = {
    if step == 0 {
        step = 1
        output[Point(x:x,y:y)] = $0 == 1
        pointSet.insert(Point(x:x,y:y))
    } else {
        step = 0
        if $0 == 1 {
            direction = (direction + 1) % 4
        } else {
            direction = (direction + 3) % 4
        }
        switch direction {
            case 0:
                y -= 1
            case 1:
                x += 1
            case 2:
                y += 1
            case 3:
                x -= 1
            default:
                fatalError()
        }
        computer.input.append( output.getVal(Point(x:x,y:y)) ? 1 : 0)
        
    }
}
computer.final = {
    print($0)
    let minx = output.reduce(0, {$1.0.x<$0 ? $1.0.x : $0})
    let maxx = output.reduce(0, {$1.0.x>$0 ? $1.0.x : $0})
    let miny = output.reduce(0, {$1.0.y<$0 ? $1.0.x : $0})
    let maxy = output.reduce(0, {$1.0.y>$0 ? $1.0.x : $0})

    var outArray = Array(repeating:Array(repeating:" ", count:(maxx-minx)), count:(maxy-miny))
    for (p,b) in output {
        if b {outArray[p.y-miny][p.x-minx] = "X"}
    }
    var outString = ""
    for a in outArray {
        outString +=  "\n" + a.joined()
    }

    print("Part 2:\(outString)")
}


computer.doIt()


