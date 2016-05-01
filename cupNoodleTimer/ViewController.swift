//
//  ViewController.swift
//  mockDisapper
//
//  Created by Tomohiro Yoshida on 2016/03/02.
//  Copyright © 2016年 Tomohiro Yoshida. All rights reserved.
//

import UIKit
import AVFoundation



class ViewController: UIViewController,AVAudioPlayerDelegate{
    enum Errors: ErrorType {
        case ImageDoesNotExist
    }
    var noodleTimer: NSTimer!
    var noodleTimerValue: Int = 0
    let noodleTimerValueArray = [180, 240, 300]
    
    var decreaseAlphaPerAttack: CGFloat =  0
    let decreaseAlphaPerAttackArray:[CGFloat] = [1 / 15, 1 / 20, 1 / 30]
    
    var startBtn: StartButton!
    var stopBtn: StopButton!
    
    var timerSegCon: TimerSegmentedControl!
    
    var mockView: mockImageView!
    var dagekiView: DagekiImageView!
    var dagekiImages = [UIImage]()
    var backGroundView: BackGroundImageView!
    
    var countDownLabel: TimerLabel!
    let items = ["03:00", "04:00", "05:00"]
    
    var voicePlayer: AVAudioPlayer!
    var punchSoundPlayer: AVAudioPlayer!
    var TimeOverAlert: UIAlertController!
    var dagekiTapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let voiceFilePath = NSBundle.mainBundle().pathForResource("mockVoice", ofType: "mp3")!
        let voiceFileURL = NSURL(fileURLWithPath: voiceFilePath)
        let punchFilePath = NSBundle.mainBundle().pathForResource("punch", ofType: "mp3")!
        let punchFileURL = NSURL(fileURLWithPath: punchFilePath)
        
        let dagekiGreen = UIImage(named: "greenattack")!
        let dagekiYellow = UIImage(named: "yellowattack")!
        let dagekiRed = UIImage(named: "pinkattack")!
        dagekiImages = [dagekiGreen, dagekiYellow, dagekiRed]
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)

        
//      
        backGroundView = BackGroundImageView()
        self.view.addSubview(backGroundView)
        
        dagekiTapGesture = UITapGestureRecognizer(target: self, action: #selector(mockTapped(_:)))
        dagekiTapGesture.enabled = false

        mockView = mockImageView()
        mockView.userInteractionEnabled = true
        mockView.addGestureRecognizer(dagekiTapGesture)
        self.view.addSubview(mockView)

        dagekiView = DagekiImageView()
        dagekiView.layer.position = CGPoint(x: mockView.frame.midX - dagekiView.frame.midX, y: mockView.frame.midX)
        dagekiView.userInteractionEnabled = false
        mockView.addSubview(dagekiView)
        
        countDownLabel = TimerLabel()
        self.view.addSubview(countDownLabel)
        
        timerSegCon = TimerSegmentedControl(items: self.items)
        timerSegCon.addTarget(self, action: #selector(timerSet(_:)), forControlEvents: .ValueChanged)
        timerSegCon.selectedSegmentIndex = 0
        self.view.addSubview(timerSegCon)
        timerSet(timerSegCon)
        
        startBtn = StartButton()
        startBtn.layer.position = CGPoint(x: timerSegCon.frame.minX + self.startBtn.frame.midX,
                                          y: self.view.frame.maxY * 53 / 60)
        startBtn.addTarget(self, action: #selector(start(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(startBtn)
        
        stopBtn = StopButton()
        stopBtn.layer.position = CGPoint(x: timerSegCon.frame.maxX - self.stopBtn.frame.midX,
                                         y: self.view.frame.maxY * 53 / 60)
        stopBtn.addTarget(self, action: #selector(stop(_:)), forControlEvents: .TouchUpInside)
        stopBtn.enabled = false
        self.view.addSubview(stopBtn)
        
        do {
            try voicePlayer = AVAudioPlayer(contentsOfURL: voiceFileURL)
            try punchSoundPlayer = AVAudioPlayer(contentsOfURL: punchFileURL)
            voicePlayer.delegate = self
            punchSoundPlayer.delegate = self
        } catch {
            print("Error(AudiPlayer contentsURL")
        }
        
        TimeOverAlert = UIAlertController(title: "The Time Has Come!", message: "カップ麺(3分)", preferredStyle: .Alert)
        TimeOverAlert.addAction(alertAction)
    }
    
    func timerSet(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            noodleTimerValue = noodleTimerValueArray[0]
            //            colorplusOneSec = (1.0 / 180)
            decreaseAlphaPerAttack = decreaseAlphaPerAttackArray[0]
            self.timerSegCon.tintColor = UIColor.greenColor()
            
        case 1:
            noodleTimerValue = noodleTimerValueArray[1]
            //            colorplusOneSec = (1.0 / 240)
            decreaseAlphaPerAttack = decreaseAlphaPerAttackArray[1]
            self.timerSegCon.tintColor = UIColor.yellowColor()
            
        case 2:
            noodleTimerValue = noodleTimerValueArray[2]
            //            colorplusOneSec = (1.0 / 300)
            decreaseAlphaPerAttack = decreaseAlphaPerAttackArray[2]
            self.timerSegCon.tintColor = UIColor.redColor()
            
        default:
            break
        }
        countDownLabel.text = String("0\(noodleTimerValue / 60):00")
        mockView.alpha = 1.0
        mockView.image = UIImage(named: "mockLightBokashi")
        dagekiView.image = dagekiImages[timerSegCon.selectedSegmentIndex]
        
        
    }
    
    func start(sender: UIButton) {
        noodleTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self,
                                                             selector: #selector(countDown(_:)),
                                                             userInfo: nil, repeats: true)
        startBtn.enabled = false
        timerSegCon.enabled = false
        stopBtn.enabled = true
        dagekiTapGesture.enabled = true
        voicePlayer.play()
    }
    
    func stop(sender: UIButton) {
        stopBtn.enabled = false
        
        noodleTimer.invalidate()
        startBtn.enabled = true
        timerSegCon.enabled = true
        dagekiTapGesture.enabled = false
    }
    
    func countDown(timer:NSTimer) {
        if noodleTimerValue > 0{
            noodleTimerValue -= 1
            let min = noodleTimerValue / 60
            let sec = noodleTimerValue - min * 60
            //            桁数を合わせる
            if sec < 10 {
                countDownLabel.text = "0\(min):0\(sec)"
            }else{
                countDownLabel.text = "0\(min):\(sec)"
            }
        }else{
            //            0秒時の処理
            noodleTimer.invalidate()
            presentViewController(TimeOverAlert, animated: true, completion: nil)
            
            timerSet(timerSegCon)
            //            初期化処理
            mockView.alpha = 1.0
            mockView.image = UIImage(named: "mockLightBokashi")
            voicePlayer.play()
            startBtn.enabled = true
            timerSegCon.enabled = true
            stopBtn.enabled = false
            dagekiTapGesture.enabled = false
            
        }
    }
    
    
    //    画像を押した時のファンクション
    func mockTapped(sender: UITapGestureRecognizer) {
        //        画像を小さくする
        let scaleTransform = CGAffineTransformMakeScale(0.8, 0.8)
        mockView.transform = scaleTransform
        
        //        透明度が高くなると元に戻る、別の音声を出す
        if mockView.alpha > 0.08 {
            if punchSoundPlayer.playing{
                punchSoundPlayer.stop()
            } else {
                punchSoundPlayer.play()
            }
            mockView.alpha -= decreaseAlphaPerAttackArray[timerSegCon.selectedSegmentIndex]
            dagekiView.alpha = 0.6
        } else {
            mockView.alpha = 1.0
            mockView.image = UIImage(named: "mockGoldBokashi")
            voicePlayer.play()
            dagekiView.alpha = 0.6
            
        }
        
        UIView.animateWithDuration(0.7,
                                   delay: 0,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    self.mockView.transform = CGAffineTransformIdentity
                                    self.dagekiView.alpha = 0.0
            },
                                   completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

