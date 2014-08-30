//
//  Line.swift
//  TouchTracker
//
//  Created by Richard Nguyen on 8/29/14.
//  Copyright (c) 2014 Richard Nguyen. All rights reserved.
//

import Foundation
import CoreGraphics

class Line: NSObject, NSCoding {
    var begin: CGPoint;
    var end: CGPoint;
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder .encodeCGPoint(begin, forKey: "begin")
        aCoder.encodeCGPoint(end, forKey: "end")
    }
    
    required init(coder aDecoder: NSCoder) {
        begin = aDecoder.decodeCGPointForKey("begin")
        end = aDecoder.decodeCGPointForKey("end")
    }

    init(begin: CGPoint, end: CGPoint) {
        self.begin = begin;
        self.end = end;
    }
    
    func description() -> String {
        return "\(begin) -> \(end)"
    }
}