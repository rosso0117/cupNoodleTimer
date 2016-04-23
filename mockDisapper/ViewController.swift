//
//  ViewController.swift
//  mockDisapper
//
//  Created by Tomohiro Yoshida on 2016/03/02.
//  Copyright © 2016年 Tomohiro Yoshida. All rights reserved.
//

import UIKit
import AVFoundation



class ViewController: UIViewController,AVAudioPlayerDelegate {

    @IBOutlet weak var timerSelect: UISegmentedControl!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var mock: UIImageView!
    @IBOutlet weak var dageki: UIImageView!
    @IBOutlet weak var coverView: UIImageView!
    
    var myAlert:UIAlertController!
    var myTapGesture:UITapGestureRecognizer!
    var myAudioPlayer:AVAudioPlayer!
    var punchAudio:AVAudioPlayer!
    
    var dagekiImages:[UIImage]! = []
//    var dagekiGreen:UIImage!
//    var dagekiYellow:UIImage!
//    var dagekiRed:UIImage!

    var timer:NSTimer!
    var timerValue = 180
    var min:Int = 0
    var sec:Int = 0
   // var colorplusOneSec:CGFloat = (1.0 / 180)
    var colorplusTotal:CGFloat = 0
    var alphaMinusPerAttack:CGFloat = 1/30
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        ボタンに動作を設定
        startButton.addTarget(self, action: #selector(start(_:)),forControlEvents: UIControlEvents.TouchUpInside)
        stopButton.addTarget(self, action: #selector(start(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        stopButton.enabled = false
//        読み込み時の画像設定
        timerSelect.tintColor = UIColor.greenColor()
        timeLabel.text = "03:00"
        dageki.alpha = 0.0
        
        // Audioの設定
        let soundFilePath:NSString = NSBundle.mainBundle().pathForResource("mv", ofType: "mp3")!
        let fileURL:NSURL = NSURL(fileURLWithPath: soundFilePath as String)
        
        do {
            try myAudioPlayer = AVAudioPlayer(contentsOfURL: fileURL)
        } catch let error as NSError {
            print(error)
        }
        myAudioPlayer.delegate = self
        
        //打撃音
        let punchFilePath:NSString = NSBundle.mainBundle().pathForResource("punch", ofType: "mp3")!
        let punchURL:NSURL = NSURL(fileURLWithPath: punchFilePath as String)
        
        do {
            try punchAudio = AVAudioPlayer(contentsOfURL: punchURL)
        } catch let error as NSError {
            print(error)
        }
        punchAudio.delegate = self
        
//        アラートの設定
        myAlert = UIAlertController(title: "The Time Has Come!", message: "カップ麺(3分)", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Default)
            { action in print("ok")
        }
        myAlert.addAction(alertAction)
        
//        Gestureを画像に設定
        myTapGesture = UITapGestureRecognizer(target: self, action: #selector(playVoice))
        mock.addGestureRecognizer(myTapGesture)
        myTapGesture.enabled = false
        
        var dagekiGreen = UIImage(named: "greenattack")!
        var dagekiYellow = UIImage(named: "yellowattack")!
        var dagekiRed = UIImage(named: "pinkattack")!
        
        dagekiImages = [dagekiGreen,dagekiYellow,dagekiRed]
        dageki.image = dagekiImages[timerSelect.selectedSegmentIndex]


    }
    
    
    func start(sender: UIButton) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        startButton.enabled = false
        timerSelect.enabled = false
        stopButton.enabled = true
        myTapGesture.enabled = true
        myAudioPlayer!.play()
        
        
    }
    
    
    func stop(sender: UIButton) {
        stopButton.enabled = false
        
        timer.invalidate()
        startButton.enabled = true
        timerSelect.enabled = true
        myTapGesture.enabled = false
    }
    
//    タイマーのカウントダウン関数
    func countDown(timer:NSTimer) {
        if timerValue > 0{
            timerValue -= 1
            min = timerValue / 60
            sec = timerValue - min * 60
            //            colorplusTotal += colorplusOneSec
            // coverView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0 + colorplusTotal)
            
//            桁数を合わせる
            if sec < 10 {
                timeLabel.text = "0\(min):0\(sec)"
            }else{
                timeLabel.text = "0\(min):\(sec)"
            }
            
            
        }else{
//            ０秒時の処理
            timer.invalidate()
            presentViewController(myAlert, animated: true, completion: nil)
            
            
            self.timerSet(timerSelect)
//            初期化処理
            //        coverView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            //   colorplusTotal = 0
            mock.alpha = 1.0
            mock.image = UIImage(named: "mockLightBokashi")
            myAudioPlayer.play()
            startButton.enabled = true
            timerSelect.enabled = true
            stopButton.enabled = false
            myTapGesture.enabled = false
            
        }
        
    }
    
    @IBAction func timerSet(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            timerValue = 180
            //            colorplusOneSec = (1.0 / 180)
            alphaMinusPerAttack = 1/15
            self.timerSelect.tintColor = UIColor.greenColor()
            
        case 1:
            timerValue = 240
            //            colorplusOneSec = (1.0 / 240)
            alphaMinusPerAttack = 1/20
            self.timerSelect.tintColor = UIColor.yellowColor()
            
        case 2:
            timerValue = 300
            //            colorplusOneSec = (1.0 / 300)
            alphaMinusPerAttack = 1/30
            self.timerSelect.tintColor = UIColor.redColor()
            
        default:
            timerValue = 0
        }
        timeLabel.text = String("0\(timerValue / 60):00")
        mock.alpha = 1.0
        mock.image = UIImage(named: "mockLightBokashi")
        dageki.image = dagekiImages[timerSelect.selectedSegmentIndex]

        //        colorplusTotal = 0
        //  coverView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
    }
    

//    画像を押した時のファンクション
    func playVoice(sender: UITapGestureRecognizer) {
//        画像を小さくする
        let scaleTransform = CGAffineTransformMakeScale(0.8, 0.8)
        mock.transform = scaleTransform
        
//        透明度が高くなると元に戻る、別の音声を出す
        if mock.alpha > 0.08 {
            if punchAudio.playing{
                punchAudio.stop()
            } else {
                punchAudio.play()
            }
            mock.alpha -= alphaMinusPerAttack
            dageki.alpha = 0.6
        } else {
            mock.alpha = 1.0
            mock.image = UIImage(named: "mockGoldBokashi")
            myAudioPlayer.play()
            dageki.alpha = 0.6
            
        }
        
        UIView.animateWithDuration(0.7,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.mock.transform = CGAffineTransformIdentity
                self.dageki.alpha = 0.0
            },
            completion: nil)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

