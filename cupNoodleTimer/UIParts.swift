//
//  PartsViewController.swift
//  cupNoodleTimer
//
//  Created by Tomohiro Yoshida on 2016/04/30.
//  Copyright © 2016年 Tomohiro Yoshida. All rights reserved.
//

import UIKit
let width = UIScreen.mainScreen().bounds.size.width
let height = UIScreen.mainScreen().bounds.size.height
let btnsFrame = CGRect(x: 0, y: 0, width: width / 6, height: height / 30)

class mockImageView: UIImageView {
    let mockImageViewFrame = CGRect(x: 0, y: 0, width: width / 2, height: height / 2)
    let mockImage = UIImage(named: "mockLightBokashi")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = mockImageViewFrame
        self.image = mockImage!
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.layer.position = CGPoint(x: width / 2,
                                      y: height / 12 + self.frame.midY)
    }
    init(){
        super.init(frame: mockImageViewFrame)
        self.image = mockImage!
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.layer.position = CGPoint(x: width / 2,
                                      y: height / 12 + self.frame.midY)
    }
}

class DagekiImageView: UIImageView {
    let dagekiImageViewFrame = CGRect(x: 0, y: 0, width: width * 3 / 10, height: height / 5)
    let dagekiImage = UIImage(named: "greenAttack")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = dagekiImageViewFrame
        self.image = dagekiImage
        self.backgroundColor = UIColor.clearColor()
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.alpha = 0.0
    }
    init(){
        super.init(frame: dagekiImageViewFrame)
        self.image = dagekiImage
        self.backgroundColor = UIColor.clearColor()
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.alpha = 0.0
    }
}

class BackGroundImageView: UIImageView {
    let BackGroundImageViewFrame = UIScreen.mainScreen().bounds
    let BGImage = UIImage(named: "battleField2")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = BackGroundImageViewFrame
        self.image = BGImage
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.alpha = 0.6
    }
    init(){
        super.init(frame: BackGroundImageViewFrame)
        self.image = BGImage
        self.backgroundColor = UIColor.clearColor()
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.alpha = 0.6
    }
}
//class PartsViewController: UIViewController {
//    
//   
class TimerLabel: UILabel {
    let timerLabelFrame = CGRect(x: 0, y: 0, width: width / 6, height: height / 20)
    let position = CGPoint(x: width / 2, y: height * 7 / 10)
    let labelText = "03:00"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = timerLabelFrame
        self.layer.position = position
        self.textColor = UIColor.whiteColor()
        self.text = labelText
        self.adjustsFontSizeToFitWidth = true
    }
    
    init () {
        super.init(frame: timerLabelFrame)
        self.layer.position = CGPoint(x: width / 2, y: height * 7 / 10)
        self.textColor = UIColor.whiteColor()
        self.text = labelText
        self.adjustsFontSizeToFitWidth = true
    }
}

class TimerSegmentedControl: UISegmentedControl {
    let TimerSegmentedControlFrame = CGRect(x: 0, y: 0,
                                            width: width * 3 / 5,
                                            height: height / 20)
    let position = CGPoint(x: width / 2, y: height * 8 / 10)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = self.TimerSegmentedControlFrame
        self.selectedSegmentIndex = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.position = position
        self.selectedSegmentIndex = 0
    }
    
    override init(items: [AnyObject]?) {
        super.init(items: items)
        self.frame = TimerSegmentedControlFrame
        self.layer.position = position
    }
}

class StartButton: UIButton {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = btnsFrame
        self.setTitle("Start", forState: .Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.titleLabel?.font = UIFont(name: "GillSans-Bold", size: 14)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    init() {
        super.init(frame: btnsFrame)
        self.setTitle("START", forState: .Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.setTitleColor(UIColor.redColor(), forState: .Disabled)
        self.titleLabel?.font = UIFont(name: "GillSans-Bold", size: 14)
        self.titleLabel?.adjustsFontSizeToFitWidth = true

    }
}

class StopButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = btnsFrame
        self.setTitle("STOP", forState: .Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.titleLabel?.font = UIFont(name: "GillSans-Bold", size: 14)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    init() {
        super.init(frame: btnsFrame)
        self.setTitle("STOP", forState: .Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.titleLabel?.font = UIFont(name: "GillSans-Bold", size: 14)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }

}

