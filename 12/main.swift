//
//  main.swift
//  12
//
//  Created by Mark Lively on 12/12/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

struct Planet:Equatable,CustomStringConvertible {
    var description: String {get {return "pos=<x=\(x), y= \(y), z= \(z)>, vel=<x= \(i), y= \(j), z= \(k)>"}}
    
    var x:Int
    var y:Int
    var z:Int
    var i:Int
    var j:Int
    var k:Int

    var energy: Int {
        get {return (abs(x) + abs(y) + abs(z)) * (abs(i) + abs(j) + abs(k))}
    }
    
    mutating func move(){
        x += i
        y += j
        z += k
    }
    
    mutating func accelerate(_ p:Planet){
        if p.x < x {i-=1} else if p.x > x {i+=1}
        if p.y < y {j-=1} else if p.y > y {j+=1}
        if p.z < z {k-=1} else if p.z > z {k+=1}
    }
    
    init (x:Int, y:Int, z:Int){
        self.x = x
        self.y = y
        self.z = z
        self.i = 0
        self.j = 0
        self.k = 0
    }
}

var planets:Array<Planet> = []
for (x,y,z) in test2 {
    planets.append( Planet(x: x, y: y, z: z))
}

func LCD(_ x:Int,_ y:Int) -> Int {
    var out:Int = 1
    var m = min(x,y)
    var x = max(x,y)
    if x%m == 0 {return x}
    var d:Int = 2
    repeat {
        if m%d == 0 && x%d == 0 {
            out *= d
            m /= d
            x /= d
        } else {
            d += 1
        }
    } while Double(d) < (sqrt(Double(m)) + 1.0)
    out *= m
    out *= x
    return out
}

for i in 0..<110 {
    if i%10 == 0 {
        print ("Time \(i)")
        for p in planets {print(p)}
        print ("Energy(): \(planets.reduce(0, {$0 + $1.energy}))")
    }
    var newPlanets: Array<Planet> = []
    for p in planets {
        var p = p
        for q in planets {
            p.accelerate(q)
        }
        p.move()
        newPlanets.append(p)
    }
    planets = newPlanets
}

planets = []
for (x,y,z) in input {
    planets.append( Planet(x: x, y: y, z: z))
}

for _ in 0..<1000 {
    var newPlanets: Array<Planet> = []
    for p in planets {
        var p = p
        for q in planets {
            p.accelerate(q)
        }
        p.move()
        newPlanets.append(p)
    }
    planets = newPlanets
}
print ("Part 1:")
for p in planets {print(p)}
print ("Energy: \(planets.reduce(0, {$0 + $1.energy}))")

planets = []
for (x,y,z) in input {
    planets.append( Planet(x: x, y: y, z: z))
}


var cycle:Int = 0
let inputPlanets = planets
var cycleLength = Array(repeating: Int(0), count: 3)

repeat {
    var foundx = true
    var foundy = true
    var foundz = true
    for n in 0..<planets.count {
        foundx = foundx && planets[n].i == 0 && planets[n].x == inputPlanets[n].x
        foundy = foundy && planets[n].j == 0 && planets[n].y == inputPlanets[n].y
        foundz = foundz && planets[n].k == 0 && planets[n].z == inputPlanets[n].z
    }
    if foundx && cycleLength[0] == 0 {cycleLength[0] = cycle }
    if foundy && cycleLength[1] == 0 {cycleLength[1] = cycle }
    if foundz && cycleLength[2] == 0 {cycleLength[2] = cycle }
    var newPlanets: Array<Planet> = []
    for p in planets {
        var p = p
        for q in planets {
            p.accelerate(q)
        }
        p.move()
        newPlanets.append(p)
    }
    planets = newPlanets
    cycle += 1
} while cycleLength.min() == 0
print(cycleLength,cycle)
print(cycleLength.reduce(1, *))
print("Part 2: \(LCD(LCD(cycleLength[0],cycleLength[1]),cycleLength[2]))")
