//
//  ViewController.swift
//  TouchTracker
//
//  Created by Richard Nguyen on 8/29/14.
//  Copyright (c) 2014 Richard Nguyen. All rights reserved.
//

import UIKit

class TouchViewController: UIViewController {
    
    
    override func loadView() {
        self.view = TouchDrawView(frame: CGRectZero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

