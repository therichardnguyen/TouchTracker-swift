//
//  Line.swift
//  TouchTracker
//
//  Created by Richard Nguyen on 8/29/14.
//  Copyright (c) 2014 Richard Nguyen. All rights reserved.
//

import Foundation
import CoreGraphics

class Line: NSObject {
    var begin: CGPoint;
    var end: CGPoint;
    
    init(begin: CGPoint, end: CGPoint) {
        self.begin = begin;
        self.end = end;
    }
    
    func description() -> String {
        return "\(begin) -> \(end)"
    }
}