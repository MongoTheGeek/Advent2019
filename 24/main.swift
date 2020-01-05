//
//  main.swift
//  24
//
//  Created by Mark Lively on 1/4/20.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation

typealias Grid = Array<Array<Int>>
let baseGrid:Grid = Array(repeating:Array(repeating:0, count:7), count:7)
var history:Array<Int> = []

var grid = baseGrid
var j = 1
for l in input.components(separatedBy: "\n"){
    var i = 1
    for c in l {
        if c == "#" {grid[j][i] = 1}
        i += 1
    }
    j += 1
}

func value(_ grid:Grid) -> Int {
    var l = 1
    var out = 0
    for j in 1...5 {
        for i in 1...5{
            out += l*grid[j][i]
            l *= 2
        }
    }
    return out
}

var k = 0
var next = value(grid)
print(next)
repeat{
    history.append(next)
    var newGrid = baseGrid
    for j in 1...5 {
        for i in 1...5 {
            if grid[j][i] == 1 {
                if (grid[j+1][i]+grid[j-1][i]+grid[j][i+1]+grid[j][i-1]) == 1 {newGrid[j][i] = 1}
            } else {
                if [1,2].contains(grid[j+1][i]+grid[j-1][i]+grid[j][i+1]+grid[j][i-1])  {newGrid[j][i] = 1}
            }
        }
    }
    grid = newGrid
    next = value(grid)
//    grid.forEach{print($0)}
//    print(next)
    k += 1
} while !history.contains(next)
print(history)

print ("Part 1:\(next)")

typealias HGrid = Array<Grid>

var hGrid:HGrid = Array(repeating:baseGrid, count:5)

j = 1
for l in input.components(separatedBy: "\n"){
    var i = 1
    for c in l {
        if c == "#" {hGrid[2][j][i] = 1}
        i += 1
    }
    j += 1
}

for _ in 0..<200 {
    var newHGrid:HGrid = Array(repeating: baseGrid, count: hGrid.count + 2)
//    hGrid.forEach({
//        print("---------------")
//        $0.forEach({print($0)})
//    })
//    print("====================")
    print(hGrid.count, hGrid.joined().joined().reduce(0,+))
    for k in 1...hGrid.count-2 {
        for j in 1...5 {
            for i in 1...5{
                var count = hGrid[k][j+1][i] + hGrid[k][j-1][i] + hGrid[k][j][i+1] + hGrid[k][j][i-1]
                if i == 1 {count += hGrid[k+1][3][2]}
                else if i == 5 {count += hGrid[k+1][3][4]}
                if j == 1 {count += hGrid[k+1][2][3]}
                else if j == 5 {count += hGrid[k+1][4][3]}
                if j == 2 && i == 3 {count += hGrid[k-1][1].reduce(0, +) }
                if j == 4 && i == 3 {count += hGrid[k-1][5].reduce(0, +) }
                if j == 3 && i == 2 {count += hGrid[k-1].reduce(0, {$0+$1[1]}) }
                if j == 3 && i == 4 {count += hGrid[k-1].reduce(0, {$0+$1[5]}) }
                if hGrid[k][j][i] == 1 && count == 1{
                    newHGrid[k+1][j][i] = 1
                } else if  hGrid[k][j][i] == 0 && (count == 1 || count == 2) {
                    newHGrid[k+1][j][i] = 1
                }
            }
        }
        newHGrid[k][3][3] = 0
    }
    hGrid = newHGrid
}
//hGrid.forEach({
//    print("---------------")
//    $0.forEach({print($0)})
//})
let out:Int = hGrid.joined().joined().reduce(0,+)
print(out)
