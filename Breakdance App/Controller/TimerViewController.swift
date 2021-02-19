import UIKit
import Foundation
import MediaPlayer
import AVFoundation



//
// TimerViewController manages the application's exercise timer.
// It also controls the mediaplayer functionality.
//
//TODO: THIS CLASS NEEDS MAJOR REFACTORING
class TimerViewController: UIViewController, MPMediaPickerControllerDelegate{
    //
    //MARK: - Properties
    //
    
    var beepSoundEffect: AVAudioPlayer?
    
    var exercises : [Exercise] = []
    
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
    var timerShapeLayer = CAShapeLayer()
    @IBOutlet var timerStartStopButton: UIButton!
    @IBOutlet var timerResetButton: UIButton!
    
    var initialTimeLeft: Int {
        var time = 0
        for exercise in exercises{
            time += exercise.duration
        }
        return time
    }
    
    var timeLeft = 0 {
        didSet {
            timerLabel.text = timeString(time: TimeInterval(timeLeft)).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        }
    }
    
    //Exercise Labels
    @IBOutlet var currentExerciseDuration: UILabel!
    @IBOutlet var currentExerciseLabel: UILabel!
    @IBOutlet var nextLabel: UILabel!
    @IBOutlet var upNextExerciseLabel: UILabel!
    
    var currentExerciseCounter = 0
    var currentExerciseTimeLeft = 0
    var numberOfExercises = 0
    
    //
    //MARK: - View States
    //
    
    override func viewDidLoad() {
        numberOfExercises = exercises.count
        timeLeft = initialTimeLeft
        currentExerciseTimeLeft = exercises[currentExerciseCounter].duration
        
        timerLabel.text = timeString(time: TimeInterval(timeLeft)).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        
        drawProgressBar()
        
        //Initialize labels
        updateCurrentExerciseLabels()
        updateNextExerciseLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateSongInfo()
    }
    
    //
    //MARK: - UI Updates
    //
 
    func updateCurrentExerciseLabels(){
        currentExerciseLabel.text = exercises[currentExerciseCounter].name
        currentExerciseDuration.text = timeString(time: TimeInterval(currentExerciseTimeLeft)).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
    }
    
    func updateNextExerciseLabel(){
        upNextExerciseLabel.text = exercises[currentExerciseCounter + 1].name
    }
    
 
    
    //
    //MARK: - Beep sound effect
    //
    
    func playBeep(){
        print("Beep sound made!")
        let path = Bundle.main.path(forResource: "beep", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        if musicPlayer.playbackState == MPMusicPlaybackState.playing{
            musicPlayer.pause()
            do {
                beepSoundEffect = try AVAudioPlayer(contentsOf: url)
                beepSoundEffect?.play()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {  self.musicPlayer.play()
                }
            } catch {
            // couldn't load file :(
            }
        }else{
            do {
                beepSoundEffect = try AVAudioPlayer(contentsOf: url)
                beepSoundEffect?.play()
            } catch {
                // couldn't load file :(
            }
        }
        
        
       
        
        
    }
    //
    //MARK: - Timer
    //
    
    @objc func timerAction(){
        if timeLeft != 0 {
            timeLeft -= 1
            if(currentExerciseCounter > numberOfExercises){
                //Stop
                timerLabel.text = "Done!"
                
                print("Timer Stopped!")
                timer?.invalidate()
            }else{
            //We have more exercises to count
            currentExerciseTimeLeft -= 1
            currentExerciseDuration.text = timeString(time: TimeInterval(currentExerciseTimeLeft)).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
                currentExerciseLabel.text = exercises[currentExerciseCounter].name
                
                // Current Exercise is finished
                if (currentExerciseTimeLeft == 0){
                    playBeep() // Play beep sound when exercise is done
                    currentExerciseCounter += 1
                    
                    // There are no more exercises after the current one, don't update the next exercise label
                    
                    if (currentExerciseCounter + 1 == numberOfExercises){
                        upNextExerciseLabel.isHidden = true
                        nextLabel.isHidden = true
                        currentExerciseTimeLeft = exercises[currentExerciseCounter].duration
                        animateProgressBar() //Restart progress bar animation
                    }
                    else if(currentExerciseCounter + 1  > numberOfExercises){
                        
                        upNextExerciseLabel.isHidden = true
                        nextLabel.isHidden = true
                        
                    // We still have an exercise after the current one, update the next exercise label
                    }else{
                        upNextExerciseLabel.text = String(exercises[currentExerciseCounter + 1].name)
                        currentExerciseTimeLeft = exercises[currentExerciseCounter].duration
                        animateProgressBar() //Restart progress bar animation
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
    
    
    @IBAction func onPressTimerStartOrStop(_ sender: UIButton) {
        //Timer doesn't exist yet
        if timer == nil {
            
            //Start timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            print("Timer fired!")
            
            timerStartStopButton.setImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
            animateProgressBar()
            
        //Timer is already running
        }else if timer!.isValid {
            
            timerStartStopButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
            timer?.invalidate()
            pauseProgressBar()
        }
        //Timer is currently paused
        else {
           
            timerStartStopButton.setImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
            //Start timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            resumeProgressBar(layer: timerShapeLayer)
            
        }
    }
    
    @IBAction func onPressReset(_ sender: AnyObject? = nil) {
        //TODO: - Fix reset progressbar
        
        // Reset exercise to first
        currentExerciseCounter = 0
        
        // Reset current exercise duration time to first one.
        currentExerciseTimeLeft = exercises[currentExerciseCounter].duration
        timeLeft = initialTimeLeft
        updateCurrentExerciseLabels()
        timerShapeLayer.removeAllAnimations()
        if timer == nil {
            timerStartStopButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
        }else if timer!.isValid{
            timer?.invalidate()
            timer = nil
            timerStartStopButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
        }else{
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
            timerShapeLayer.speed = 0.8 //Resume animation incase they paused the timer before reset
            timerStartStopButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
        }
    }
    
    //
    //MARK: - ProgressBar
    //
    
    func drawTrackLayer(){
        //create circular path
        let center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 3 + 50)
        let circularPath = UIBezierPath(arcCenter: center, radius: 120, startAngle: -(.pi/2), endAngle: .pi * 2, clockwise: true)
        
        //Progressbar track layer
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.black.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
    }
    
    func drawProgressLayer(){
        let center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 3 + 50)
        let circularPath = UIBezierPath(arcCenter: center, radius: 120, startAngle: -(.pi/2), endAngle: .pi * 2, clockwise: true)
        
        //Progressbar layer
        timerShapeLayer.path = circularPath.cgPath
        timerShapeLayer.strokeColor = UIColor.red.cgColor
        timerShapeLayer.lineWidth = 10
        timerShapeLayer.fillColor = UIColor.clear.cgColor
        timerShapeLayer.lineCap = CAShapeLayerLineCap.round
        timerShapeLayer.strokeEnd = 0
        view.layer.addSublayer(timerShapeLayer)
    }
    func drawProgressBar(){
        drawTrackLayer()
        drawProgressLayer()
    }
    
    func animateProgressBar(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        //Interpolation values
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 1
        
        //Animation properties
        basicAnimation.duration = CFTimeInterval(exercises[currentExerciseCounter].duration)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        basicAnimation.speed = 0.8
        timerShapeLayer.add(basicAnimation, forKey: "progressBarAnimation")
    }
    
    func pauseProgressBar(){
        let pausedTime : CFTimeInterval = timerShapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        timerShapeLayer.speed = 0.0
        timerShapeLayer.timeOffset = pausedTime
        
        
    }
    
    func resumeProgressBar(layer : CALayer){
        let pausedTime = layer.timeOffset
        layer.speed = 1
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
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
    
    @IBAction func onPressPauseButton(_ sender: UIButton? = nil) {
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
}



