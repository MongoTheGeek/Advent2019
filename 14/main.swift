//
//  main.swift
//  14
//
//  Created by Mark Lively on 12/14/19.
//  Copyright © 2019 xxx. All rights reserved.
//

import Foundation

struct Recipe {
    var input: Array<(String,Int)>
    var output: Int
    var depth: Int?
}

func parse(input:String) -> Dictionary<String,Recipe> {
    var out:Dictionary<String,Recipe> = [:]
    for l in input.components(separatedBy:"\n"){
        let parts = l.components(separatedBy: " => ")
        let inputParts:Array<(String,Int)> = parts[0].components(separatedBy: ", ").map{
            let words:Array<String> = $0.components(separatedBy:" ")
            return (words[1],Int(words[0])!)
        }
        let temp = parts[1].components(separatedBy: " ")
        let outputParts = Int(temp[0])!
        let r = Recipe(input: inputParts, output: outputParts)
        out[temp[1]] = r
    }
    return out
}

func calcDepth(book: inout Dictionary<String,Recipe>){
    repeat {
        for k in book.keys {
            if book[k]!.depth == nil {
                var m = 0
                for (s,_) in book[k]!.input{
                    if s != "ORE" && m != -1 {
                        if let t = book[s]!.depth {
                            m = max(m, t)
                        } else {
                            m = -1
                        }
                    }
                }
                if m != -1 {book[k]!.depth = m + 1}
            }
        }
    } while book.reduce(false, {$0 || $1.1.depth == nil})
}

func findOre(book: Dictionary<String,Recipe>, required:String, amount:Int)->Int {
    var temp: Dictionary<String,Int> = [:]
    temp[required] = amount
    repeat {
        let m = temp.reduce(0, {max($0, book[$1.key]?.depth ?? 0 )})
        for k in temp.keys {
            if k != "ORE" && book[k]?.depth == m {
                let req = temp[k]!
                temp.removeValue(forKey: k)
                let replacement = book[k]!.input
                let mult = req % book[k]!.output == 0 ? req / book[k]!.output : req / book[k]!.output + 1
                for (s,i) in replacement {
                    let current = temp[s] ?? 0
                    temp[s] = i * mult + current
                }
            }
        }
    } while temp.keys.count != 1
    return temp["ORE"]!
}

var book = parse(input: test1)
calcDepth(book: &book)
print(findOre(book: book, required: "FUEL", amount: 1), test1a)

book = parse(input: test2)
calcDepth(book: &book)
print(findOre(book: book, required: "FUEL", amount: 1), test2a)

book = parse(input: test3)
calcDepth(book: &book)
print(findOre(book: book, required: "FUEL", amount: 1), test3a)

book = parse(input: test4)
calcDepth(book: &book)
print(findOre(book: book, required: "FUEL", amount: 1), test4a)

book = parse(input: input)
calcDepth(book: &book)
let p1 = findOre(book: book, required: "FUEL", amount: 1)
print("Part 1:\(p1)")

var p2 = input2 / p1
print(p2)
repeat {
    let used = findOre(book: book, required: "FUEL", amount: p2)
    let increment = max( (input2 - used) / p1, 2)
    p2 += increment
} while findOre(book: book, required: "FUEL", amount: p2) < input2

repeat {
    p2 -= 1
} while findOre(book: book, required: "FUEL", amount: p2) > input2


print("Part 2:\(p2)")
