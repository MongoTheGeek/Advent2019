//
//  main.swift
//  10
//
//  Created by Mark Lively on 12/10/19.
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

func buildGrid(input:String)->Array<Array<Bool>> {
    return input.components(separatedBy: "\n").map{Array($0).map{c in  c=="#"}}
}

func check(grid:Array<Array<Bool>>, i:Int, j:Int) -> Bool{
    if i<0 || j<0 || i >= grid[0].count || j >= grid.count {return false}
    return grid[j][i]
}

func blockout(i:Int,j:Int,x:Int,y:Int,rMax:Int) -> Array<Point>{
    var out:Array<Point> = []
    var dx = x - i
    var dy = y - j
    for k in (2..<rMax).reversed() {
        if dx % k == 0 && dy % k == 0 {
            dx = dx / k
            dy = dy / k
        }
    }
    var a = x
    var b = y
    while a >= 0 && b >= 0 && a < rMax && b < rMax {
        a += dx
        b += dy
        out.append(Point(x:a,y:b))
    }
    return out
}

func visible(grid:Array<Array<Bool>>, i:Int, j:Int) -> Array<Point> {
    var blocked:Array<Point> = []
    var seen:Array<Point> = []
    var count = 0
    let rMax = max(grid.count, grid[0].count)
    for r in 1 ..< rMax {
        for n in -r ..< r {
            for (x,y) in [(i+r,j+n),(i-r,j-n),(i+n,j-r),(i-n,j+r)] {
                if !blocked.contains(Point(x:x,y:y)) && check(grid: grid, i: x, j: y) {
                    count += 1
                    seen.append(Point(x: x, y: y))
                    blocked += blockout(i: i, j: j, x: x, y: y, rMax: rMax)
                }
            }
        }
    }
    for p in seen {
        assert(!blocked.contains(p))
    }
    return seen
}

func findMax(grid:Array<Array<Bool>>) -> (Int, Int, Array<Point>){
    var a = 0
    var b = 0
    var max: Array<Point> = []
    var out = ""
    for j in 0 ..< grid.count {
        let r = grid[j]
        for i in 0..<r.count {
            if r[i] {
                let c = visible(grid: grid, i: i, j: j)
                out += " \(c)"
                if c.count > max.count {
                    a = i
                    b = j
                    max = c
                }
            } else {
                out += "  ."
            }
        }
        out += "\n"
    }
    return (a,b,max)
}

var grid = buildGrid(input:test1)
//print("\(findMax(grid:grid)) -- \(test1a)\n\n\n")
//
//grid = buildGrid(input:test2)
//print("\(findMax(grid:grid)) -- \(test2a)\n\n\n")
//
//grid = buildGrid(input:test3)
//print("\(findMax(grid:grid)) -- \(test3a)\n\n\n")
//
//grid = buildGrid(input:test4)
//print("\(findMax(grid:grid)) -- \(test4a)\n\n\n")

grid = buildGrid(input: input)
let (i, j, seen) = findMax(grid:grid)
print("Part 1:\(seen.count)\n\n\n")

print(i,j,seen)

var sorted = seen.sorted{$0.theta(i: i, j: j) < $1.theta(i: i, j: j)}

let twoHundred = sorted[199]

print("Part 2: \(twoHundred.x * 100 + twoHundred.y)") //1309
