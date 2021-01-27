
import UIKit
import Foundation
import MediaPlayer

class TimerViewController: UIViewController, MPMediaPickerControllerDelegate{
    var exercises : [Exercise] = []
    
    //
    //MARK: - Properties
    //
    
    // MusicPlayer
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    //NowPlaying Bar
    @IBOutlet var nowPlayingBar: UIStackView!
    @IBOutlet var miniPauseButton: UIButton!
    @IBOutlet var songImage: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var songTitle: UILabel!
    
    //Timer
    var timer: Timer?
    let timerShapeLayer = CAShapeLayer()
    @IBOutlet var timerStartStopButton: UIButton!
    @IBOutlet var timerResetButton: UIButton!
    
    var initialTimeLeft = 60 * 5
    
    var timeLeft = 60 * 5 {
        didSet {
            timerLabel.text = timeString(time: TimeInterval(timeLeft)).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        }
    }
    
    
    //Exercise Labels
    @IBOutlet var currentExerciseDuration: UILabel!
    @IBOutlet var currentExerciseLabel: UILabel!
    @IBOutlet var upNextExerciseLabel: UILabel!
    
    var currentExerciseCounter = 0
    var numberOfExercises = 0
    
    //
    //MARK: - View States
    //
    
    override func viewDidLoad() {
        numberOfExercises = exercises.count
        
        timerLabel.text = timeString(time: TimeInterval(timeLeft)).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "doc.plaintext"),style: .plain, target: self, action: #selector(showSettings))
        
        createProgressBar()
        currentExerciseLabel.text = exercises[0].name
        currentExerciseDuration.text = String(exercises[0].duration)
        upNextExerciseLabel.text = exercises[1].name
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateSongInfo()
    }
    
    //
    //MARK: - Timer
    //
    
    @objc func timerAction(){
        
        
        if timeLeft != 0 {
            timeLeft -= 1
            timerLabel.text = timeString(time: TimeInterval(timeLeft))
            if(currentExerciseCounter > numberOfExercises){
                //Stop
                timerLabel.text = "Done!"
                print("Timer Stopped!")
                timer?.invalidate()
                
            }
                
            else{
            //We have more exercises to count
            exercises[currentExerciseCounter].duration -= 1
            currentExerciseDuration.text = String(exercises[currentExerciseCounter].duration)
                currentExerciseLabel.text = exercises[currentExerciseCounter].name
                if (exercises[currentExerciseCounter].duration == 0){
                    currentExerciseCounter += 1
                    if(currentExerciseCounter + 1  >= numberOfExercises){
                        upNextExerciseLabel.text = ""
                        
                    }else{
                        upNextExerciseLabel.text = String(exercises[currentExerciseCounter + 1].name)
                    }
                    
                }
            }
        }else{
            timerLabel.text = "Done!"
            currentExerciseDuration.text = "Done!"
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
    
    @IBAction func onPressStartOrStop(_ sender: UIButton) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(exercises[currentExerciseCounter].duration)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        timerShapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
        //Timer doesn't exist yet
        if timer == nil {
            //Start timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            print("Timer fired!")
            timerStartStopButton.setImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
            
            
        //Timer is already running
        }else if timer!.isValid {
            timerStartStopButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
            timer?.invalidate()
            
        }
        //Timer is currently paused
        else {
            timerStartStopButton.setImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
            //Start timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
   
    }
    @IBAction func onPressReset(_ sender: AnyObject? = nil) {
        if timer == nil {
            //Start timer
            timeLeft = initialTimeLeft
            timerStartStopButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
            
        }else if timer!.isValid{
            timer?.invalidate()
            timeLeft = initialTimeLeft
            timerStartStopButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
        }else{
            timeLeft = initialTimeLeft
            timerStartStopButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
        }
    }
    
    //
    //MARK: - ProgressBar
    //
    
    func createProgressBar(){
        
        //create circular path
        let center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 3 + 50)
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 120, startAngle: -(.pi/2), endAngle: .pi * 2, clockwise: true)
        
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
    
    //
    //MARK: - Music Playlist
    //
    
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
    
    //
    // MARK: - NowPlaying Bar
    //
    func updateSongInfo(){
    
        if let title = musicPlayer.nowPlayingItem?.title {
            songTitle.text = title
        }
        
        if let image = musicPlayer.nowPlayingItem?.artwork?.image(at: CGSize(width: 50, height: 50)) {
            songImage.image = image
        }
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
    
    //
    // MARK: - Navigation Bar
    //
    
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
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                present(ac, animated: true)
    }
}



