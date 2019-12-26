//
//  18pt2.swift
//  18
//
//  Created by Mark Lively on 12/24/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation


struct P2_Cluster:Equatable,Hashable{
    var paths:Array<P2_Path>
}
struct P2_Path:Equatable,Hashable{
    var actual:Array<P2_Point>
    var distance:Int
    
    static func == (lhs:P2_Path, rhs:P2_Path) -> Bool {
        return lhs.actual.last == rhs.actual.last && Set(lhs.actual) == Set(rhs.actual)
    }
}

struct P2_Point:Equatable,Hashable {
    let name:String
    let start:Bool
    let x:Int
    let y:Int
    var distances:Dictionary<String,Int> = [:]
//    var blocked:Array<P2_Point> = [] //Blocking is only cross region
}

func P2_parseArray(input:String) -> Dictionary<String,P2_Point> {
    var out:Dictionary<String,P2_Point> = [:]
    var map:Array<Array<Int>> = []
    var startx = 0
    var starty = 0
    var j = 0
    for l in input.split(separator: "\n") {
        var i = 0
        var temp:Array<Int> = []
        for c in l {
            switch c {
            case "#":
                temp.append(-99)
            case ".":
                temp.append(0)
            case "@":
                out["Start1"] = P2_Point(name:"Start1",start:true,x:i-1,y:j-1)
                out["Start2"] = P2_Point(name:"Start2",start:true,x:i-1,y:j+1)
                out["Start3"] = P2_Point(name:"Start3",start:true,x:i+1,y:j-1)
                out["Start4"] = P2_Point(name:"Start4",start:true,x:i+1,y:j+1)
                temp.append(-99)
                startx = i
                starty = j
            case "a"..."z":
                out[String(c)] = (P2_Point(name:String(c),start:false,x:i,y:j))
                let n = Int(c.asciiValue! - 96)
                temp.append(-n)
            case "A"..."Z":
                temp.append(0)
            default:
                fatalError()
            }
            i += 1
        }
        map.append(temp)
        j += 1
    }
    map[starty+1][startx] = -99
    map[starty-1][startx] = -99
    map[starty][startx+1] = -99
    map[starty][startx-1] = -99
    let staticMap = map
    var outTemp:Dictionary<String,P2_Point> = [:]
    for k in out.values {
        var t = k
        map = staticMap
        map[k.y][k.x] = -99
        var pointList:Array<(Int,Int,UInt32)> = adjacents(x:k.x,y:k.y,blocked:UInt32(0))
        var distance = 1
        repeat {
            var temp:Array<(Int,Int,UInt32)> = []
            for (x,y,blocked) in pointList{
                switch map[y][x] {
                case 0:
                    temp += adjacents(x: x, y: y, blocked: blocked)
                    map[y][x]=distance
                case -26 ... -1:
                    let n = -map[y][x]
                    map[y][x]=distance
                    let c = String(bytes:[UInt8(96 + n)], encoding:.ascii)!
                    t.distances[c]=distance
                    temp += adjacents(x: x, y: y, blocked: 0 )
                default:
                    break
                }
            }
            distance += 1
            pointList = temp
            outTemp[t.name] = t
        } while pointList.count > 0
    }
    out = outTemp
    return out
}

func P2_Solve(input:P2_Point, map:Dictionary<String,P2_Point>) -> Int {
    var pathList:Array<P2_Path> = [P2_Path(actual: [input], distance: 0)]
    let finalCount = input.distances.count + 1
    var depth = 1
    repeat {
        var temp:Array<P2_Path> = []
        for p in pathList {
            let nodes = p.actual.last!.distances.keys
            for node in nodes {
                if !p.actual.map({$0.name}).contains(node){temp.append(P2_Path(actual: p.actual + [map[node]!], distance: p.distance + p.actual.last!.distances[node]!))}
            }
        }
        pathList = temp.sorted(by: {$0.distance < $1.distance})
        var i = 0
        if pathList.count > 0 {
            repeat {
                var j = i + 1
                repeat {
                    if pathList[j] == pathList[i] {
                        pathList.remove(at: j)
                    } else {
                        j += 1
                    }
                } while j < pathList.count
                i += 1
            } while i < pathList.count - 1
        }
        depth += 1
    } while depth < finalCount
    return pathList[0].distance
}
