//
//  main.swift
//  2
//
//  Created by Mark Lively on 12/2/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation



func doIt(inArray: inout Array<Int>) {
    var i = 0
    while inArray[i] != 99 {
        let command = inArray[i]
        let reg1 = inArray[i+1]
        let reg2 = inArray[i+2]
        let reg3 = inArray[i+3]
        switch command {
        case 1:
            inArray[reg3] = inArray[reg1] + inArray[reg2]
        case 2:
            inArray[reg3] = inArray[reg1] * inArray[reg2]
        default:
            print("error")
            print(inArray)
            fatalError()
        }
        i += 4
    }
//    print(inArray)
}
var inArray = test2.components(separatedBy:",").compactMap{Int($0)}
doIt(inArray: &inArray)
inArray = test3.components(separatedBy:",").compactMap{Int($0)}
doIt(inArray: &inArray)
inArray = test4.components(separatedBy:",").compactMap{Int($0)}
doIt(inArray: &inArray)
inArray = test4.components(separatedBy:",").compactMap{Int($0)}
doIt(inArray: &inArray)

inArray = input.components(separatedBy:",").compactMap{Int($0)}
inArray[1]=12
inArray[2]=2
doIt(inArray: &inArray)
print("Part 1: \(inArray[0])")

for i in 0..<100 {
    for j in 0..<100 {
        inArray = input.components(separatedBy:",").compactMap{Int($0)}
        inArray[1]=i
        inArray[2]=j
        doIt(inArray: &inArray)
        if inArray[0] == target {
            print ("Part 2: \(i*100 + j)")
            exit(0)
        }
    }
}
