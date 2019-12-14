//
//  main.swift
//  13
//
//  Created by Mark Lively on 12/13/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

enum TileType:Int,Equatable,RawRepresentable,Hashable,CustomStringConvertible {
    var description: String {
        get {
            switch self {
            case .empty: return "."
            case .wall: return "#"
            case .block: return "%"
            case .paddle: return "_"
            case .ball: return "o"
            }
        }
    }
    
    case empty=0,wall,block,paddle,ball
}
struct Tile:Equatable, Hashable {
    var x:Int
    var y:Int
    var type:TileType
}
var output:Array<Tile> = []
var temp:Array<Int> = []
let c = Computer(program: input, input: [])

c.output = {
    temp.append(Int($0))
    if temp.count == 3 {
        output.append(Tile(x: temp[0], y: temp[1], type: TileType(rawValue:temp[2])!))
        temp = []
    }
}

c.final = {
    _ = $0
    print("Part 1: \(output.filter{$0.type == .block}.count)")
}

c.doIt()

var minx =  output.map{$0.x}.min()!
var miny =  output.map{$0.x}.min()!
var maxx =  output.map{$0.x}.max()!
var maxy =  output.map{$0.x}.max()!

var s = Array(repeating:Array(repeating: " ", count:maxx-minx+1),count:maxy-miny+1)
for t in output {
    switch t.type {
        case .empty: s[t.y-miny][t.x-minx] = "."
        case .wall: s[t.y-miny][t.x-minx] = "#"
        case .block: s[t.y-miny][t.x-minx] = "%"
        case .paddle: s[t.y-miny][t.x-minx] = "_"
        case .ball: s[t.y-miny][t.x-minx] = "o"
    }
}

let outString = s.map{$0.joined()}.joined(separator:"\n")
print(outString)
var score = 0
var program2 = input
program2[0] = 2
let c2 = Computer(program: program2, input: [0])

var grid = Array(repeating:Array(repeating:TileType.empty, count:maxx+1), count: 21)

c2.output = {
    temp.append(Int($0))
    if temp.count == 3 {
        if temp[0] == -1 {
            score = temp[2]
        } else {
            let type = TileType(rawValue:temp[2])!
            grid[temp[1]][temp[0]] = TileType(rawValue:temp[2])!
            if type == .ball {
                if let pr = (grid.filter{$0.contains(.paddle)}.first) {
                    let px = pr.firstIndex(of: .paddle)!
                    if px > temp[0] {
                        c2.addInput(n: -1)
                    } else if px < temp[0] {
                        c2.addInput(n: 1)
                    } else {
                        c2.addInput(n: 0)
                    }
//                    print("\u{1B}[3J\u{1B}[2J")
                    print("\u{1B}[2J\u{1B}[3J\u{1B}[1;1H")
                    print(score)
                    print(grid.map{$0.map{$0.description}.joined()}.joined(separator:"\n"))
                    Thread.sleep(forTimeInterval: 0.3/log2(Double(score)))
                }
            }
        }
        temp = []
    }
}

c2.final = {
    _ = $0
    print("Part 2: \(score)")
}

c2.doIt()
print(c2.status)
