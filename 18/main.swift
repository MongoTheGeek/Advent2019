//
//  main.swift
//  18
//
//  Created by Mark Lively on 12/18/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation


func adjacents(x:Int,y:Int,blocked:UInt32) -> Array<(Int,Int,UInt32)>{
    return [(x+1,y,blocked),(x-1,y,blocked),(x,y+1,blocked),(x,y-1,blocked)]
}

func parseArray(input:String) -> (Array<Array<Int>>,Array<UInt32>){
    var distances:Array<Array<Int>> = Array(repeating:Array(repeating: 0, count:27), count:27)
    var blocking:Array<UInt32> = Array(repeating:0, count:27)
    var keyX:Array<Int> = Array(repeating: 0, count: 27)
    var keyY:Array<Int> = Array(repeating: 0, count: 27)
    var doorX:Array<Int> = Array(repeating: 0, count: 27)
    var doorY:Array<Int> = Array(repeating: 0, count: 27)
    var map:Array<Array<Int>> = []
    var keyCount = 0
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
                keyX[0]=i
                keyY[0]=j
                temp.append(0)
            case "a"..."z":
                let n = Int(c.asciiValue! - 96)
                keyX[n]=i
                keyY[n]=j
                temp.append(-n)
                keyCount += 1
            case "A"..."Z":
                let n = Int(c.asciiValue! - 64)
                doorX[n]=i
                doorY[n]=j
                temp.append(-26 - n)
            default:
                fatalError()
            }
            i += 1
        }
        map.append(temp)
        j += 1
    }
    let staticMap = map
    for i in 0...keyCount {
        map = staticMap
        map[keyY[i]][keyX[i]] = -99
        var pointList:Array<(Int,Int,UInt32)> = adjacents(x:keyX[i],y:keyY[i],blocked:UInt32(0))
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
                    distances[i][n] = distance
                    if i == 0 {
                        blocking[n] = blocked
                    }
                    temp += adjacents(x: x, y: y, blocked: blocked | 1<<n )
                case -52 ... -27:
                    let n = -26 - map[y][x]
                    map[y][x]=distance
                    temp += adjacents(x: x, y: y, blocked: blocked | 1<<n )
                default:
                    break
                }
            }
            distance += 1
            pointList = temp
        } while pointList.count > 0
    }
    return (distances,blocking)
}

func getAvailable(blocking:Array<UInt32>, found:UInt32, max:Int)->Array<Int> {
    var out:Array<Int> = []
    for i in 1...max {
        if (found | ~blocking[i]) == UInt32.max && ((found >> i) % 2 == 0) {
            out.append(i)
        }
    }
    return out
}

func solve(distances:Array<Array<Int>>,blocking:Array<UInt32>) -> (Int,String){
    var keyCount = 0
    for i in (1...26).reversed(){
        if distances[0][i] != 0 {
            keyCount = i
            break
        }
    }
    var cache:Dictionary<UInt32,Int> = [:]
    var choices:Array<Int> = Array(repeating:0 , count:keyCount+1)
    var available:Array<Array<Int>> = Array(repeating:[] , count:keyCount+1)
    var depth = 0
    var minDistance = Int.max
    var bestPath = ""
    var found:UInt32 = 0
    var distance = 0
    var path:Array = Array(repeating: 0, count: keyCount+1)
    for maxDepth in 1...keyCount {
        print(maxDepth,cache.count)
        var done = false
        repeat {
            let localFound = UInt32(found) + UInt32(path[depth])<<27
            if depth == maxDepth || distance > minDistance || distance > cache[localFound] ?? .max {
                if depth == keyCount && distance < minDistance {
                    minDistance = distance
                    bestPath = String(bytes: path[1...maxDepth].map{UInt8($0+64)}, encoding: .ascii)!
                    print(minDistance,bestPath)
                }
                if depth == maxDepth {
                    var localFound:UInt32 = UInt32(path[maxDepth])<<27
                    var dist = 0
                    var last = 0
                    for i in 0...keyCount{
                        dist += distances[last][path[i]]
                        localFound |= 1<<path[i]
                        last = path[i]
                        if cache[localFound] ?? .max > dist {cache[localFound] = dist}
                    }
                }
                repeat {
                    distance -= distances[path[depth-1]][path[depth]]
                    found &= ~(1<<path[depth])
    //                path[depth]=0
                    depth -= 1
                } while  depth > 0 && choices[depth] == available[depth].count - 1
                if depth == 0 && choices[depth] == available[depth].count - 1 {
                    done = true
                } else {
                    choices[depth] += 1
                    path[depth+1] = available[depth][choices[depth]]
                    depth += 1
                    found |= 1<<path[depth]
                    distance += distances[Int(path[depth-1])][Int(path[depth])]
                }
            } else {
                available[depth] = getAvailable(blocking:blocking, found:found, max:keyCount)
                choices[depth] = 0
                path[depth+1] = available[depth][choices[depth]]
                depth += 1
                found |= 1<<path[depth]
                distance += distances[Int(path[depth-1])][Int(path[depth])]
            }
        } while !done
    }
    return (minDistance,bestPath)
}
extension Array where Element == Int{
    var key:UInt32 {
        get {
            return found + UInt32(self.last!) << 27
        }
    }
    var found:UInt32 {
        get {
            var temp:UInt32 = 0
            for i in 0..<self.count {
                temp |= UInt32(1<<self[i])
            }
            return temp
        }
    }
}
struct Path:Hashable,Equatable {
    let actual:Array<Int>
    let distance:Int
    let found:UInt32
    let key:UInt32
    init(actual a:Array<Int>,distance d:Int) {
        actual = a
        distance = d
        var temp:UInt32 = 0
        for i in 0..<a.count {
            temp |= UInt32(1<<actual[i])
        }
        found = temp
        key = temp + UInt32(a.last!) << 27
    }
}

func solve2(distances:Array<Array<Int>>,blocking:Array<UInt32>) -> (Int,String){
    var keyCount = 0
    for i in (1...26).reversed(){
        if distances[0][i] != 0 {
            keyCount = i
            break
        }
    }
    var depth = 0
    var paths:Array<Path> = [Path(actual: [0], distance: 0)]
    repeat {
        var temp:Array<Path> = []
        for path in paths {
            var p = path
            let avail = getAvailable(blocking: blocking, found: path.found, max: keyCount)
            for a in avail {
                temp.append(Path(actual: path.actual+[a],distance: path.distance+distances[path.actual.last!][a]))
            }
        }
        if temp.count > 1 {
            temp.sort{$0.distance < $1.distance}
            var i = 0
            var j = 1
            repeat {
                j = i + 1
                repeat {
                    if temp[i].key == temp[j].key {temp.remove(at: j)}
                    j += 1
                } while j < temp.count
                i += 1
            } while i < temp.count - 1
        }
        depth += 1
        paths = temp
        print(depth,paths.count)
    } while depth < keyCount
    let (best,path) = (paths[0].distance, paths[0].actual)
    return (best, String(bytes: path[1...keyCount].map{UInt8($0+64)}, encoding: .ascii)!)
}

var (distances,blocking) = parseArray(input: test1)
print(test1a,solve(distances: distances, blocking: blocking))
print(test1a,solve2(distances: distances, blocking: blocking))

(distances,blocking) = parseArray(input: test2)
print(test2a,solve(distances: distances, blocking: blocking))
print(test2a,solve2(distances: distances, blocking: blocking))

(distances,blocking) = parseArray(input: test3)
print(test3a,solve2(distances: distances, blocking: blocking))

(distances,blocking) = parseArray(input: test4)
print(test4a,solve2(distances: distances, blocking: blocking))

(distances,blocking) = parseArray(input: test5)
print(test5a,solve2(distances: distances, blocking: blocking))

(distances,blocking) = parseArray(input: input)
print(solve2(distances: distances, blocking: blocking))

//(distances,blocking) = parseArray(input: input2a)
//print(solve2(distances: distances, blocking: blocking))
