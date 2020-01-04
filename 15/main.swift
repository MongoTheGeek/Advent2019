//
//  main.swift
//  15
//
//  Created by Mark Lively on 12/15/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

struct Point:Equatable,Hashable {
    let x:Int
    let y:Int
}

enum Direction:Int{
    case N=1,S,W,E
    var next:Direction {
        switch self {
        case .N:
            return .W
        case .S:
            return .E
        case .W:
            return .S
        case .E:
            return .N
        }
    }
    var prev:Direction {
        switch self {
        case .N:
            return .E
        case .S:
            return .W
        case .W:
            return .N
        case .E:
            return .S
        }
    }

}
var x = 0
var y = 0
var goalX = 0
var goalY = 0
var direction = Direction.N
var walls: Set<Point> = []
var stepCount = 0

let repairDrone = Computer(program: input, input: [1])


func printWalls() {
    let minx = min(x, walls.reduce(0, {min($0,$1.x)}))
    let maxx = max(x, walls.reduce(0, {max($0,$1.x)}))
    let miny = min(y, walls.reduce(0, {min($0,$1.y)}))
    let maxy = max(y, walls.reduce(0, {max($0,$1.y)}))
    var grid = Array(repeating:(Array(repeating:".",count:(maxx-minx+1))), count:maxy-miny+1)
    for w in walls {
        grid[w.y-miny][w.x-minx]="#"
    }
    grid[y-miny][x-minx] = "^"
    print(grid.map{$0.joined()}.joined(separator: "\n"))
}

repairDrone.output = {
    switch $0 {
    case 0:
        switch direction {
        case .N:
            walls.insert(Point(x:x, y: y - 1))
        case .S:
            walls.insert(Point(x:x, y: y + 1))
        case .W:
            walls.insert(Point(x:x - 1, y: y))
        case .E:
            walls.insert(Point(x:x + 1, y: y))
        }
        direction = direction.prev
        repairDrone.input.append(Int(direction.rawValue))
    case 1:
        stepCount += 1
        switch direction {
        case .N:
            y -= 1
        case .S:
            y += 1
        case .W:
            x -= 1
        case .E:
            x += 1
        }
        if walls.count != 0 {
            direction = direction.next
        }
        repairDrone.input.append(Int(direction.rawValue))
    case 2:
        stepCount += 1
        switch direction {
        case .N:
            y -= 1
        case .S:
            y += 1
        case .W:
            x -= 1
        case .E:
            x += 1
        }
        print(x,y)
        goalX = x
        goalY = y
        if walls.count != 0 {
            direction = direction.next
        }
    if stepCount<3000 {
            repairDrone.input.append(Int(direction.rawValue))
        }
    default:
        fatalError()
    }
}

repairDrone.final = {
    print($0,x,y)
    print(walls)
}
repairDrone.doIt()
print(repairDrone.status,x,y)
print(goalX, goalY)

printWalls()

let minx = min(x, walls.reduce(0, {min($0,$1.x)}))
let maxx = max(x, walls.reduce(0, {max($0,$1.x)}))
let miny = min(y, walls.reduce(0, {min($0,$1.y)}))
let maxy = max(y, walls.reduce(0, {max($0,$1.y)}))
var grid = Array(repeating: Array(repeating:0, count: maxx-minx+1), count: maxy-miny+1)
for w in walls {
    grid[w.y-miny][w.x-minx] = -1
}
var i = 1
var pArray:Array<Point> = [Point(x:0,y:0)]
repeat{
    var tempArray:Set<Point> = []
    for p in pArray {
        grid[p.y-miny][p.x-minx] = i
        if grid[p.y-miny+1][p.x-minx] == 0 {tempArray.insert(Point(x:p.x, y: p.y+1))}
        if grid[p.y-miny-1][p.x-minx] == 0 {tempArray.insert(Point(x:p.x, y: p.y-1))}
        if grid[p.y-miny][p.x-minx+1] == 0 {tempArray.insert(Point(x:p.x+1, y: p.y))}
        if grid[p.y-miny][p.x-minx-1] == 0 {tempArray.insert(Point(x:p.x-1, y: p.y))}
    }
    let tSet = Set(pArray)
    let reduce = tempArray.intersection(tSet)
    pArray = Array(tempArray.symmetricDifference(reduce))
    i += 1
} while pArray.count > 0

print("Part 1:\( grid[goalY-miny][goalX-minx]-1 )")

grid = Array(repeating: Array(repeating:0, count: maxx-minx+1), count: maxy-miny+1)
for w in walls {
    grid[w.y-miny][w.x-minx] = -1
}
i = 1
pArray = [Point(x:goalX,y:goalY)]
repeat{
    var tempArray:Set<Point> = []
    for p in pArray {
        grid[p.y-miny][p.x-minx] = i
        if grid[p.y-miny+1][p.x-minx] == 0 {tempArray.insert(Point(x:p.x, y: p.y+1))}
        if grid[p.y-miny-1][p.x-minx] == 0 {tempArray.insert(Point(x:p.x, y: p.y-1))}
        if grid[p.y-miny][p.x-minx+1] == 0 {tempArray.insert(Point(x:p.x+1, y: p.y))}
        if grid[p.y-miny][p.x-minx-1] == 0 {tempArray.insert(Point(x:p.x-1, y: p.y))}
    }
    let tSet = Set(pArray)
    let reduce = tempArray.intersection(tSet)
    pArray = Array(tempArray.symmetricDifference(reduce))
    i += 1
} while pArray.count > 0

print("Part 2:\( i-2 )")
