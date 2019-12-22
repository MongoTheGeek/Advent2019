//
//  main.swift
//  18
//
//  Created by Mark Lively on 12/18/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

struct Point:Hashable,Equatable {
    let x:Int
    let y:Int
    var blocked:Set<Point> = []
    func adjacents() -> Array<Point> {
        return [Point(x:x+1, y: y, blocked: blocked), Point(x:x-1, y: y, blocked: blocked), Point(x:x, y: y+1, blocked: blocked), Point(x:x, y: y-1, blocked: blocked)]
    }
    func blockedAjacents() -> Array<Point> {
        var bPlus = blocked
        bPlus.insert(Point(x:x,y:y))
        return [Point(x:x+1, y: y, blocked: bPlus), Point(x:x-1, y: y, blocked: bPlus), Point(x:x, y: y+1, blocked: bPlus), Point(x:x, y: y-1, blocked: bPlus)]
    }

    static func == (lhs:Point,rhs:Point) -> Bool{
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

}

struct ShortCutKey:Equatable,Hashable {
    let start:Point
    let remaining:Array<Point>
}

struct P2P: Equatable, Hashable {
    let distance:Int
    let blocking: Set<Point>
}

typealias Map = Array<Array<Int>>
typealias ODict = Dictionary<Point,String>
typealias BlockList = Dictionary<Point,Dictionary<Point,P2P>>

typealias FReachable = (Map,ODict,ODict,Set<Point>,Point) -> Array<(Point,Int)>

var map: Map = []
var keys: ODict = [:]
var doors: ODict = [:]
var start: Point

///WARN this variable is treated as a global.  Best make it into a struct and the have it initialized and send it's reachable function
var blockList: BlockList = [:]

func buildBlockList(map:Map,keys:ODict,doors:ODict,start:Point) -> BlockList{
    var out:BlockList = [:]
    let gridlist = [start] + keys.keys
    for i in 0 ..< gridlist.count {
        var nextRow:Dictionary<Point,P2P> = [:]
        var mapCopy = map
        var distance = 1
        var pointlist = gridlist[i].adjacents()
        mapCopy[gridlist[i].y][gridlist[i].x] = -2
        repeat {
            var temp:Array<Point> = []
            for p in pointlist {
                if mapCopy[p.y][p.x] == 0 {
                    mapCopy[p.y][p.x] = distance
                    if keys[p] != nil {
                        nextRow[p] = P2P(distance: distance, blocking: p.blocked)
                        temp.append(contentsOf: p.blockedAjacents())
                    } else if doors[p] != nil {
                        temp.append(contentsOf: p.blockedAjacents())
                    } else {
                        temp.append(contentsOf: p.adjacents())
                    }
                }
            }
            distance += 1
            pointlist = temp
        } while pointlist.count > 0
        out[gridlist[i]]=nextRow
    }
    return out
}

func reachablePoints2(_ map:Map ,_ keys:ODict, _ doors:ODict, _ cleared: Set<Point>, _ start:Point) -> Array<(Point,Int)> {
    var outArray:Array<(Point,Int)> = []
    let row = blockList[start]!
    for k in row.keys {
        if !cleared.contains(k) && row[k]!.blocking.isSubset(of: cleared) {
            outArray.append((k,row[k]!.distance))
        }
    }
    return outArray
}

func parseInput(_ input:String)->(Map, ODict, ODict, Point){
    var keys: ODict = [:]
    var doors: ODict = [:]
    var map: Array<Array<Int>> = []
    var start: Point?
    var temp: Array<Int> = []
    var j = 0
    for l in input.split(separator: "\n"){
        var i = 0
        for c in l {
            switch c {
            case "#":
                temp.append(-1)
            case ".":
                temp.append(0)
            case "a"..."z":
                keys[Point(x:i,y:j)] = String(c)
                temp.append(0)
            case "A"..."Z":
                doors[Point(x:i,y:j)] = String(c)
                temp.append(0)
            case "@":
                temp.append(0)
                start = Point(x:i,y:j)
            default:
                fatalError()
            }
            i += 1
        }
        map.append(temp)
        temp = []
        j += 1
    }
    
    if let start = start {
        return(map,keys,doors,start)
    } else {
        fatalError()
    }
}



func reachableKeys(_ map:Map ,_ keys:ODict, _ doors:ODict, _ cleared: Set<Point>, _ start:Point) -> Array<(Point,Int)> {
    var reachable:Array<(Point,Int)> = []
    var mapCopy = map
    var pointList = start.adjacents()
    var distance = 1
    mapCopy[start.y][start.x] = -2
    repeat {
        var temp:Array<Point> = []
        for p in pointList {
            if mapCopy[p.y][p.x] == 0 {
                mapCopy[p.y][p.x] = distance
                if cleared.contains(p) || (doors[p] == nil && keys[p] == nil) {
                    temp.append(contentsOf:p.adjacents())
                }
                if keys[p] != nil && !cleared.contains(p) {
                    reachable.append((p,distance))
                }
            }
        }
        pointList = temp
        distance += 1
    } while pointList.count > 0
    return reachable
}

func findShortest(map:Map,keys:ODict,doors:ODict,start:Point, freachable:FReachable = reachableKeys) -> (Array<String>,Int) {
    var backDoors:Dictionary<String,Point> = [:]
    for k in doors.keys {
        backDoors[doors[k]!]=k
    }
    var foundKeys:Array<String> = Array(repeating: " ", count: keys.count)
    var bestKeys:Array<String> = Array(repeating: " ", count: keys.count)
    var minDistance = 999999999
    var cleared:Set<Point> = []
    var location = start
    var distance = 0
    var choice:Array<Int> = Array(repeating: 0, count: keys.count)
    var shortCuts:Dictionary<ShortCutKey,(Int,Array<Point>)> = [:]
    var reachables:Array<Array<(Point,Int)>> = Array(repeating: [], count: keys.count)
    var done = false
    var localBest: ShortCutKey?
    var d = 0
    var localD = 0
    repeat {
        var reachable:Array<(Point,Int)> = []
        if distance < minDistance {
            reachable = freachable(map, keys, doors, cleared, location).sorted{$0.1 < $1.1}
        }
        if localBest == nil && (reachable.count + d == keys.count) && reachable.count > 1 {
            localBest = ShortCutKey(start: location, remaining: reachable.map{$0.0})
            localD = d
            if let (shortCutDistance, shortCut) = shortCuts[localBest!] {
                reachable = []
                distance += shortCutDistance
                for i in d..<keys.count {
                    choice[i]=0
                    foundKeys[i]=keys[shortCut[i-d]]!
                }
                d = keys.count - 1
                var l = location
                for r in shortCut{
                    reachables.append([(r,blockList[l]![r]!.distance)])
                    l = r
                }
                print("found shortcut")
                localBest = nil
            }
        }
        if reachable.count == 0 || distance > minDistance {
            if let localBest = localBest {
                var distance = 0
                var points:Array<Point> = []
                for i in (choice.count-localBest.remaining.count)..<choice.count {
                    distance += reachables[i].last!.1
                    points.append(reachables[i].last!.0)
                }
                if distance < shortCuts[localBest]?.0 ?? distance + 1{
                    shortCuts[localBest] = (distance,points)
                }
            }
            if distance < minDistance {
                minDistance = distance
                bestKeys = foundKeys
                print(minDistance,bestKeys.joined())
            }
            repeat {
                d -= 1
                distance -= reachables[d][choice[d]].1
            } while d > 0 && choice[d] == reachables[d].count-1
            if d < localD {localBest = nil}
            if d == 0 {
                done = true
            } else {
                distance -= reachables[d][choice[d]].1
                choice[d] += 1
                location = reachables[d][choice[d]].0
                distance += reachables[d][choice[d]].1
                foundKeys[d] = keys[location]!
            }
        } else {
            choice[d] = 0
            reachables[d] = reachable
            distance += reachable[0].1
            location = reachable[0].0
            foundKeys[d] = keys[location]!
            d += 1
        }
        cleared = []
        for i in 0 ..< d {
            cleared.insert(reachables[i][choice[i]].0)
        }
        for k in foundKeys {
            if let p = backDoors[k.uppercased()] {
                cleared.insert(p)
            }
        }
    } while !done
    return (bestKeys,minDistance)
}

print(1)
(map,keys,doors,start) = parseInput(test1)
print(test1a,"---",findShortest(map: map, keys: keys, doors: doors, start: start))
blockList = buildBlockList(map: map, keys: keys, doors: doors, start: start)
print(test1a,"___",findShortest(map: map, keys: keys, doors: doors, start: start, freachable: reachablePoints2(_:_:_:_:_:)))

print(2)
(map,keys,doors,start) = parseInput(test2)
print(test2a,"---",findShortest(map: map, keys: keys, doors: doors, start: start))
blockList = buildBlockList(map: map, keys: keys, doors: doors, start: start)
print(test2a,"___",findShortest(map: map, keys: keys, doors: doors, start: start, freachable: reachablePoints2(_:_:_:_:_:)))

print(3)
(map,keys,doors,start) = parseInput(test3)
print(test3a,"---",findShortest(map: map, keys: keys, doors: doors, start: start))
blockList = buildBlockList(map: map, keys: keys, doors: doors, start: start)
print(test3a,"___",findShortest(map: map, keys: keys, doors: doors, start: start, freachable: reachablePoints2(_:_:_:_:_:)))

print(4)
(map,keys,doors,start) = parseInput(test4)
//print(test4a,"---",findShortest(map: map, keys: keys, doors: doors, start: start))
blockList = buildBlockList(map: map, keys: keys, doors: doors, start: start)
print(test4a,"___",findShortest(map: map, keys: keys, doors: doors, start: start, freachable: reachablePoints2))

print(5)
(map,keys,doors,start) = parseInput(test5)
print(test5a,"---",findShortest(map: map, keys: keys, doors: doors, start: start))
blockList = buildBlockList(map: map, keys: keys, doors: doors, start: start)
print(test5a,"___",findShortest(map: map, keys: keys, doors: doors, start: start, freachable: reachablePoints2))


(map,keys,doors,start) = parseInput(input)
blockList = buildBlockList(map: map, keys: keys, doors: doors, start: start)
print("Part 1:",findShortest(map: map, keys: keys, doors: doors, start: start, freachable: reachablePoints2))
