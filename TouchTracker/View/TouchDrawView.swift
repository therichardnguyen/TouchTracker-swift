//
//  TouchDrawView.swift
//  TouchTracker
//
//  Created by Richard Nguyen on 8/29/14.
//  Copyright (c) 2014 Richard Nguyen. All rights reserved.
//

import UIKit
import CoreGraphics


class TouchDrawView: UIView {
    var linesInProgress: [NSValue:Line]
    var completeLines: [Line]
    
    // constants
    let kLineWidth: CGFloat = 10.0

    override init(frame: CGRect) {
        linesInProgress = [NSValue:Line]()
        completeLines = [Line]()
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.multipleTouchEnabled = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, kLineWidth)
        CGContextSetLineCap(context, kCGLineCapRound)
        
        // Draw complete lines in black
        UIColor.blackColor().set()
        
        for line in completeLines {
            CGContextMoveToPoint(context, line.begin.x, line.begin.y)
            CGContextAddLineToPoint(context, line.end.x, line.end.y)
            CGContextStrokePath(context)
            
        }
        
        // Draw in progress lines in red
        
        UIColor.redColor().set()
        
        for (key, line) in linesInProgress {
            CGContextMoveToPoint(context, line.begin.x, line.begin.y)
            CGContextAddLineToPoint(context, line.end.x, line.end.y)
            CGContextStrokePath(context)
        }
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        for touch in touches {
            if touch.tapCount > 1 {
                clearAll()
                return
            }
            
            var key:NSValue = NSValue(nonretainedObject: touch)
            
            // Create a line for the value
            var loc = touch.locationInView(self)
            var newLine = Line(begin: loc, end: loc)
            
            linesInProgress[key] = newLine
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        for touch in touches {
            var key = NSValue(nonretainedObject: touch)
            
            if let line = linesInProgress[key] {
                line.end = touch.locationInView(self)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        endTouch(touches)
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        endTouch(touches)
    }
    
    func endTouch(touches: NSSet!) {
        for touch in touches {
            var key = NSValue(nonretainedObject: touch)
            
            if let line = linesInProgress[key] {
                completeLines.append(line)
                linesInProgress.removeValueForKey(key)
            }
        }
        setNeedsDisplay()
    }
    
    func clearAll() {
        linesInProgress.removeAll(keepCapacity: true)
        completeLines.removeAll(keepCapacity: true)
        setNeedsDisplay()
    }
    
    
}
