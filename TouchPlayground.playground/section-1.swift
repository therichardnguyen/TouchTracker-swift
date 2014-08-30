// Playground - noun: a place where people can play

import Cocoa

class Line : NSObject {
    var begin : CGFloat
    var end : CGFloat
    override init() {
        begin = 1.0
        end = 2.0
    }
    
    func description() -> String {
        return "(\(begin), \(end))"
    }
}

var str = "Hello, playground"
var a = [Line]()




a.append(<#newElement: T#>)
for line:Line in a {
    print(line)
}