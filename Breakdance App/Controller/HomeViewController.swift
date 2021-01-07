
import UIKit
import Foundation

enum TimeEnum: Int {
    case hour = 3600, minute = 60, second = 1
}

class HomeViewController: UIViewController{
    //
    //MARK: - Properties
    //
    
    var timer: Timer?
    let timerShapeLayer = CAShapeLayer()
    
    @IBOutlet var timerLabel: UILabel!
    
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
        let center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 4)
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 2, clockwise: true)
        
        //create track layer
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
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
        
        //Start progressbar animation on tap
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        
        
    }
    
    @objc private func handleTap(){
        print("Attempting to animate stroke")
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        
        basicAnimation.duration = 300
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        timerShapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
        //Start timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        print("Timer fired!")
    }
    
}



