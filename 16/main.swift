//
//  main.swift
//  16
//
//  Created by Mark Lively on 12/16/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

func stringToIntArray(_ input:String) ->Array<Int> {
    var out:Array<Int> = []
    for c in input.unicodeScalars {
        out.append(Int(String(c))!)
    }
    return out
}

func FFT(_ input: Array<Int>)->Array<Int>{
    var out:Array<Int> = []
    let nums = [0,1,0,-1]
    for i in 0..<input.count {
        var sum = 0
        for j in 0..<input.count {
            let k = ((j+1)/(i+1) ) % 4
            sum += nums[k]*input[j]
        }
        out.append(abs(sum%10))
    }
    return out
}

func firstEight(s:String, i:Int) -> String {
    var array:Array<Int> = stringToIntArray(s)
    for _ in 0..<i {
        array = FFT(array)
    }
    let out = array[0...7].map{"\($0)"}.joined()
    return out
}

func bulkupInput(s:String, i:Int) -> String{
    var temp = s
    repeat {
        temp += s
    } while temp.count < i
    let cut = temp.count - i
    return String(temp.dropFirst(cut))
}

func aggroFirstEight(s:String, i:Int) -> String{
    var input = stringToIntArray(s)
    var output = input
    let count = input.count - 1 //Last digit never changes.
    for _ in 0..<i {
        for n in (0..<count).reversed(){
            output [n] = (output[n+1]+input[n])%10
        }
        input = output
    }
    let out = output[0...7].map{"\($0)"}.joined()
    return out
}

print("Tests")
var (s,i) = test1
print(test1a, firstEight(s: s, i: i))
(s,i) = test2
print(test2a, firstEight(s: s, i: i))
(s,i) = test3
print(test3a, firstEight(s: s, i: i))
(s,i) = test4
print(test4a, firstEight(s: s, i: i))

print("")
(s,i) = input
var t = Date()
print("Part 1:\(firstEight(s: s, i: i))")
print("\(-t.timeIntervalSinceNow) seconds or \(-t.timeIntervalSinceNow*100_000_000/31536000) years of grinding for part2\n")


print("The last n digits are only affected by the last n digits.  Trimming the fat...\n")
let offset = Int(s.prefix(7))!
let count = s.count * 10_000 - offset
print("Only have to worry about \(count) numbers which is \(count/s.count) times more.")
print("This is o2, meaning \(-t.timeIntervalSinceNow * Double((count/s.count)*(count/s.count)/86400)) days.  😢🐼")

print("time to get aggro!")
s = bulkupInput(s: s, i: count)
t = Date()
print("Part 2: \(aggroFirstEight(s: s, i: i))  ")
print("\(-t.timeIntervalSinceNow) seconds.  🤷‍♂️")
