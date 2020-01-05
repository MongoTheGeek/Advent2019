//
//  main.swift
//  25
//
//  Created by Mark Lively on 1/4/20.
//  Copyright © 2020 xxx. All rights reserved.
//

import Foundation

var temp:Array<Int> = []
let c = Computer(program: input, input: [])
c.output = {
    if $0 == 10 {
        print(String(bytes:temp.map{UInt8($0)}, encoding:.ascii )!)
        temp = []
    } else {
        temp.append($0)
    }
}
c.final = {print($0)}
c.doIt()
//Start in hull breach

c.inputString(s: "west\n") //warp drive maintenance
//c.inputString(s: "take giant electromagnet\n") //Lol Nope
c.inputString(s: "west\n") //corridor
c.inputString(s: "take loom\n")
c.inputString(s: "east\n") //warp drive maintenance
c.inputString(s: "east\n") //breach
c.inputString(s: "north\n") //Stables
//c.inputString(s: "take inifinite loop\n") //LOL nope
//Thread.sleep(forTimeInterval: 1)
c.inputString(s: "west\n") //HoloDeck
//Thread.sleep(forTimeInterval: 1)
c.inputString(s: "take antenna\n")
c.inputString(s: "south\n") //sick bay
//Thread.sleep(forTimeInterval: 1)
c.inputString(s: "take hologram\n")
c.inputString(s: "south\n") //Navigation
//Thread.sleep(forTimeInterval: 1)
c.inputString(s: "take mug\n")
c.inputString(s: "north\n") //Sick Bay
c.inputString(s: "west\n") //Gift Wrapping station
//Thread.sleep(forTimeInterval: 1)
c.inputString(s: "take astronaut ice cream\n")
c.inputString(s: "east\n") //Sick bay
c.inputString(s: "north\n") //Holodeck
c.inputString(s: "north\n") //Aracade
//Thread.sleep(forTimeInterval: 1)
c.inputString(s: "east\n") // Storage
//Thread.sleep(forTimeInterval: 1)
//c.inputString(s: "take escape pod\n") //LOL  nope again
c.inputString(s: "west\n") //arcade
c.inputString(s: "north\n") //Engineering
//Thread.sleep(forTimeInterval: 1)
c.inputString(s: "north\n") // Hot chocolate fountain
//Thread.sleep(forTimeInterval: 1)
c.inputString(s: "take space heater\n")
c.inputString(s: "north\n") //crew quarters
c.inputString(s: "east\n") //security
c.inputString(s: "inv\n") //
var stuff = ["loom",
    "hologram",
    "space heater",
    "antenna",
    "astronaut ice cream",
    "mug"]
stuff.forEach({
    c.inputString(s: "drop \($0)\n")
})
c.inputString(s: "east\n") //verify

//try each one individually
stuff.forEach({
    c.inputString(s: "take \($0)\n")
    c.inputString(s: "east\n") //verify
    c.inputString(s: "drop \($0)\n")
})
//loom is too heavy


print("=================================================")
let stuff2 = ["hologram",
"space heater",
"antenna",
"astronaut ice cream",
"mug"]
//add one at a time
stuff2.forEach({
    c.inputString(s: "take \($0)\n")
    c.inputString(s: "east\n") //verify
})



Thread.sleep(forTimeInterval: 10)
