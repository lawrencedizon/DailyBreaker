
import UIKit
import Foundation
import MediaPlayer

class TimerViewController: UIViewController, MPMediaPickerControllerDelegate{
    //
    //MARK: - Properties
    //
    
    @IBOutlet var nowPlayingBar: UIStackView!
    
    @IBOutlet var miniPauseButton: UIButton!
    var timer: Timer?
    let timerShapeLayer = CAShapeLayer()
    
    @IBOutlet var timerStartStopButton: UIButton!
    @IBOutlet var timerResetButton: UIButton!
    // Get the system music player.
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    @IBOutlet var songImage: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var songTitle: UILabel!
    
    var timeLeft = 300 {
        didSet {
            timerLabel.text = String(timeLeft)
        }
    }
    
    //
    //MARK: - View States
    //
    
    override func viewDidLoad() {
        timerLabel.text = String(timeLeft)
        createProgressBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateSongInfo()
        
    }
    
    
    //
    //MARK: - Timer
    //
    
    @objc func timerAction(){
        
        if timeLeft != 0 {
            print(timeLeft)
            timeLeft -= 1
        }else{
            timerLabel.text = "Timer Stopped!"
            print("Timer Stopped!")
            timer?.invalidate()
        }
    }
    
    //
    //MARK: - ProgressBar
    //
    
    func createProgressBar(){
        
        //create circular path
        let center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 3)
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 2, clockwise: true)
        
        //create track layer
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.black.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        
        //progressbar layer
        timerShapeLayer.path = circularPath.cgPath
        timerShapeLayer.strokeColor = UIColor.red.cgColor
        timerShapeLayer.lineWidth = 10
        timerShapeLayer.fillColor = UIColor.clear.cgColor
        timerShapeLayer.lineCap = CAShapeLayerLineCap.round
        timerShapeLayer.strokeEnd = 0
        view.layer.addSublayer(timerShapeLayer)
    }
    
    func updateSongInfo(){
        if let title = musicPlayer.nowPlayingItem?.title {
            songTitle.text = title
        }
        
        if let image = musicPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 50, height: 50)) {
            songImage.image = image
        }
    }
    
    @IBAction func onPressMusicPlayer(_ sender: UIButton) {
        let controller = MPMediaPickerController(mediaTypes: .music)
        controller.allowsPickingMultipleItems = true
        controller.popoverPresentationController?.sourceView = sender
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController,
                     didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        
        musicPlayer.setQueue(with: mediaItemCollection)
        
        mediaPicker.dismiss(animated: true)
        
        musicPlayer.play()
        
        if let title = musicPlayer.nowPlayingItem?.title {
            songTitle.text = title
        }
        miniPauseButton.setImage(UIImage(systemName: "pause.fill"),for: UIControl.State.normal)
    }
    
    

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
    }
    
    @IBAction func onPressPauseButton(_ sender: UIButton) {
        updateSongInfo()
        
        if musicPlayer.playbackState == MPMusicPlaybackState.playing {
            miniPauseButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
            musicPlayer.pause()
        }else{
            miniPauseButton.setImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
            musicPlayer.play()
        }
    }
    
    @IBAction func onPressForwardButton(_ sender: UIButton) {
        musicPlayer.skipToNextItem()
        updateSongInfo()
    }
    @IBAction func onPressBackwardButton(_ sender: UIButton) {
        musicPlayer.skipToPreviousItem()
        updateSongInfo()
    }
    @IBAction func onPressStartOrStop(_ sender: UIButton) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(timeLeft)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        timerShapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
        //Timer doesn't exist yet
        if timer == nil {
            //Start timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            print("Timer fired!")
            timerStartStopButton.setTitle("Stop", for: .normal)
            
        //Timer is already running
        }else if timer!.isValid {
            timerStartStopButton.setTitle("Start", for: .normal)
            timer?.invalidate()
            
        }
        //Timer is currently paused
        else {
            timerStartStopButton.setTitle("Stop", for: .normal)
            //Start timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
   
    }
    @IBAction func onPressReset(_ sender: UIButton) {
        if timer == nil {
            //Start timer
            timeLeft = 300
            timerStartStopButton.setTitle("Start", for: .normal)
            
        }else if timer!.isValid{
            timer?.invalidate()
            timeLeft = 300
            timerStartStopButton.setTitle("Start", for: .normal)
        }else{
            timeLeft = 300
            timerStartStopButton.setTitle("Start", for: .normal)
        }
    }
}



