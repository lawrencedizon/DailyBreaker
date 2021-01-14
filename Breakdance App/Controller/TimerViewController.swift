
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
    
    var initialTimeLeft = 60 * 5
    
    var timeLeft = 60 * 5 {
        didSet {
            timerLabel.text = timeString(time: TimeInterval(timeLeft)).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        }
    }
    
    //
    //MARK: - View States
    //
    
    override func viewDidLoad() {
        timerLabel.text = timeString(time: TimeInterval(timeLeft)).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"),style: .plain, target: self, action: #selector(showSettings))
        
        createProgressBar()
        
        
    }
    
    
    
    @objc func showSettings(){
        let ac = UIAlertController(title: "Training length", message: "", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Short", style: .default, handler: { action in
                    self.navigationItem.title = "Short Warm Up"
                    self.initialTimeLeft = 60 * 5
                    self.timerLabel.text = self.timeString(time: TimeInterval(self.timeLeft)).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
                    self.onPressReset()
                }))
                ac.addAction(UIAlertAction(title: "Medium", style: .default, handler: { action in
                    self.navigationItem.title = "Medium Warm Up"
                    self.initialTimeLeft = 60 * 25
                    self.timerLabel.text = self.timeString(time: TimeInterval(self.timeLeft)).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
                    self.onPressReset()
                }))
                ac.addAction(UIAlertAction(title: "Long", style: .default, handler: { action in
                    self.navigationItem.title = "Long Warm Up"
                    self.initialTimeLeft = 60 * 60
                    self.timerLabel.text = self.timeString(time: TimeInterval(self.timeLeft)).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
                    
                    self.onPressReset()
                }))
                ac.addAction(UIAlertAction(title: "Continue", style: .cancel))
                
                present(ac, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateSongInfo()
        
    }
    
    
    //
    //MARK: - Timer
    //
    
    @objc func timerAction(){
        
        if timeLeft != 0 {
            timerLabel.text = timeString(time: TimeInterval(timeLeft))
            timeLeft -= 1
        }else{
            timerLabel.text = "Timer Stopped!"
            print("Timer Stopped!")
            timer?.invalidate()
        }
    }
    
    func timeString(time: TimeInterval) -> String {
            let hour = Int(time) / 3600
            let minute = Int(time) / 60 % 60
            let second = Int(time) % 60

            // return formated string
        
        if hour == 0 {
            return String(format: "%02i:%02i", minute, second).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        }else{
            return String(format: "%02i:%02i:%02i", hour, minute, second).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        }
    }
    
    //
    //MARK: - ProgressBar
    //
    
    func createProgressBar(){
        
        //create circular path
        let center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 3 + 50)
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
        
        updateSongInfo()
        
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
    @IBAction func onPressReset(_ sender: AnyObject? = nil) {
        if timer == nil {
            //Start timer
            timeLeft = initialTimeLeft
            timerStartStopButton.setTitle("Start", for: .normal)
            
        }else if timer!.isValid{
            timer?.invalidate()
            timeLeft = initialTimeLeft
            timerStartStopButton.setTitle("Start", for: .normal)
        }else{
            timeLeft = initialTimeLeft
            timerStartStopButton.setTitle("Start", for: .normal)
        }
    }
}



