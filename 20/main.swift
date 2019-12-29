//
//  main.swift
//  20
//
//  Created by Mark Lively on 12/26/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

enum direction:Int {
    case up,down,left,right
}
struct Point:Hashable,Equatable {
    let x:Int
    let y:Int
    let d:Int
    func adjacents()->Array<Point>{
        return [Point(x: x+1, y: y, d:d),Point(x: x-1, y: y, d:d),Point(x: x, y: y+1, d:d),Point(x: x, y: y-1, d:d)]
    }
    static func == (lhs:Point, rhs:Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    init (x:Int, y:Int, d:Int = 0){
        self.x = x
        self.y = y
        self.d = d
    }
}

struct Portal:Equatable,Hashable {
    let name:String
    var connections:Array<Point>
}

func parseInput(input:String) -> (Array<Array<Int>>,Dictionary<String,Portal>){
    var map:Array<Array<Int>> = []
    var portalArray:Dictionary<String,Portal> = [:]
    let lines = input.components(separatedBy: "\n")
    var tempMap:Array<Array<String>> = []
    for l in lines{
        var temp:Array<String> = []
        for c in l {
            temp.append(String(c))
        }
        tempMap.append(temp)
    }
    
    let letters = "A"..."Z"
    
    for j in 0..<tempMap.count {
        var temp:Array<Int> = []
        for i in 0..<tempMap[j].count {
            switch tempMap[j][i] {
            case letters:
                if i==0 || i == tempMap[j].count - 2 {
                    let key = tempMap[j][i] + tempMap[j][i+1]
                    tempMap[j][i+1] = " "
                    var portal = portalArray[key] ?? Portal(name:key, connections: [])
                    if i == 0 {portal.connections.append(Point(x:i, y:j-2))}
                    else {portal.connections.append(Point(x:i-3, y:j-2))}
                    portalArray[key]=portal
                } else if j == 0 || j == tempMap.count - 2{
                    let key = tempMap[j][i] + tempMap[j+1][i]
                    tempMap[j+1][i] = " "
                    var portal = portalArray[key] ?? Portal(name:key, connections: [])
                    if j == 0 {portal.connections.append(Point(x:i-2, y:j))}
                    else {portal.connections.append(Point(x:i-2, y:j-3))}
                    portalArray[key]=portal
                } else {
                    temp.append(-99)
                    if letters.contains(tempMap[j][i+1]){
                        let key = tempMap[j][i]+tempMap[j][i+1]
                        tempMap[j][i+1] = " "
                        var portal = portalArray[key] ?? Portal(name:key, connections: [])
                        if tempMap[j][i-1] == "." {portal.connections.append(Point(x:i-3, y:j-2))}
                        else {portal.connections.append(Point(x:i, y:j-2))}
                        portalArray[key]=portal
                    } else {
                        let key = tempMap[j][i]+tempMap[j+1][i]
                        tempMap[j+1][i] = " "
                        var portal = portalArray[key] ?? Portal(name:key, connections: [])
                        if tempMap[j-1][i] == "." {portal.connections.append(Point(x:i-2, y:j-3))}
                        else {portal.connections.append(Point(x:i-2, y:j))}
                        portalArray[key]=portal

                    }
                }
            case ".":
                temp.append(0)
            case " ":
                if i>1 && i < tempMap[j].count-2 && j>1 && j<tempMap.count-2{temp.append(-99)}
            case "#":
                temp.append(-99)
            default:
                break
            }
        }
        if j>1 && j<tempMap.count-2{map.append(temp)}
    }
//    var map2 = map
//    for p in portalArray.keys {
//        for c in portalArray[p]!.connections {
//            map2[c.y][c.x] = 10000
//        }
//    }
//    printMap(map: map2)
//    printMap(map: map)
//    print(portalArray)
    return (map,portalArray)
}

func printMap(map:Array<Array<Array<Int>>>){
    for d in map {
        print("------------------------------------")
        for l in d{
            var temp = ""
            for c in l {
                switch c {
                case 0: temp.append(".")
                case -99: temp.append("#")
                case 10000: temp.append("+")
                default: temp.append(String(abs(c%10)))
                }
            }
            print(temp)
        }
    }
}

func solve(map:Array<Array<Int>>, portals:Dictionary<String,Portal>) -> Int {
    var distance = 1
    var found = false
    var tempMap = [map]
    let start = portals["AA"]!.connections.first!
    var pointList = start.adjacents()
    tempMap[0][start.y][start.x] = -99
    repeat {
        var temp:Array<Point> = []
        for p in pointList {
            if p.x >= 0 && p.y >= 0 && p.y<tempMap[p.d].count  && p.x < tempMap[p.d][p.y].count && p.y<tempMap[p.d].count && tempMap[p.d][p.y][p.x] == 0 {
                tempMap[p.d][p.y][p.x] = distance
                for k in portals.keys {
                    if portals[k]!.connections.contains(p) {
//                        print(k,distance)
                        for c in portals[k]!.connections{
                            if c != p {
                                if (p.x == 0 || p.y == 0 || p.x == tempMap[p.d][p.y].count - 1 || p.y == tempMap[p.d].count - 1)
                                {
                                    if p.d > 0 {
                                        temp.append(Point(x: c.x, y: c.y, d:p.d-1))
                                    } else {
                                        print("attempt to exit above")
                                    }
                                } else  {
                                    temp.append(Point(x: c.x, y: c.y, d:p.d+1))
                                    if p.d == tempMap.count - 1 {tempMap.append(map)}
                                }
                            }
                        }
                        if k == "ZZ" && p.d == 0{
                            found = true
//
                            return distance
                        }
                    }
                }
                temp.append(contentsOf:p.adjacents())
            }
        }
        pointList = temp
        distance += 1
//        printMap(map: tempMap)
    } while !found && pointList.count > 0
    print ("**** NO SOLUTION ***")
    return distance
}

var (map,portals) = parseInput(input: test1)
var result = solve(map: map, portals: portals)
print(result)

//(map,portals) = parseInput(input: test2)
//print(solve(map: map, portals: portals))

(map,portals) = parseInput(input: test4)
result = solve(map: map, portals: portals)
print(396,result)

(map,portals) = parseInput(input: input)
result = solve(map: map, portals: portals)
print("Part2: ", result)
