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
    var completeLines: [Line]?
    var selectedLine:Line?
    
    // constants
    let kLineWidth: CGFloat = 10.0

    override init(frame: CGRect) {
        linesInProgress = [NSValue:Line]()
        var archivePath = TouchDrawView.touchDrawArchivePath()
        completeLines = NSKeyedUnarchiver.unarchiveObjectWithFile(archivePath) as? [Line]
        if (completeLines == nil) {
            completeLines = [Line]()
        }
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.multipleTouchEnabled = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "save", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        addGestureRecognizer(tapRecognizer)
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
        
        for line in completeLines! {
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
        
        if selectedLine != nil {
            UIColor.greenColor().set()
            CGContextMoveToPoint(context, selectedLine!.begin.x, selectedLine!.begin.y)
            CGContextAddLineToPoint(context, selectedLine!.end.x, selectedLine!.end.y)
            CGContextStrokePath(context)
        }
    }
    
    
    func tap(gr:UIGestureRecognizer) {
        var point:CGPoint = gr .locationInView(self)
        selectedLine = lineAtPoint(point)
        linesInProgress.removeAll(keepCapacity: true)
        setNeedsDisplay()
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
                completeLines!.append(line)
                linesInProgress.removeValueForKey(key)
            }
        }
        setNeedsDisplay()
    }
    
    func clearAll() {
        linesInProgress.removeAll(keepCapacity: true)
        completeLines!.removeAll(keepCapacity: true)
        setNeedsDisplay()
    }
    
    func lineAtPoint(point : CGPoint) -> Line? {
        for line in completeLines! {
            var start = line.begin
            var end = line.end
            
            var t: CGFloat
            for t = 0.0; t <= 1.0; t += 0.5 {
                var x = start.x + t * (end.x - start.x)
                var y = start.y + t * (end.y - start.y)
                
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return line
                }
            }
        }
        return nil
    }
    
    class func touchDrawArchivePath() -> String {
        var documentDirectory : NSString! = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
        return documentDirectory.stringByAppendingPathComponent("currentDrawing.art")
    }
    
    func save() -> Bool{
        var imagePath = TouchDrawView.touchDrawArchivePath()
        return NSKeyedArchiver.archiveRootObject(completeLines!, toFile: imagePath)
    }
    
}