//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var middleName: String?
var firstName = "Diego"
middleName = "Clara"

// IF you can GET a value out of middleName
if let middleNameVal = middleName {
    var fullName = firstName + " " + middleNameVal
    print(fullName)
}


var lotteryWinnings: Int? // "I may not have a value"

// ! means force value out
// Use if, if let to check if optional has a value
lotteryWinnings = 100

if let lotteryWinningsVal = lotteryWinnings {
    print(lotteryWinningsVal)
}

Int(23.0)