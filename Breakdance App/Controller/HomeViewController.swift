
import UIKit
import Foundation

//
//MARK: - HomeViewController
//

class HomeViewController: UIViewController{
    //
    //MARK: - HomeViewController Properties
    //
    
    var timer: Timer?
    @IBOutlet var timerLabel: UILabel!
    
    var timeLeft = 300 {
        didSet {
            timerLabel.text = String(timeLeft)
        }
    }
    
    //
    //MARK: - HomeViewController View States
    //
    override func viewDidLoad() {
        timerLabel.text = String(timeLeft)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        print("Timer fired!")
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

    
    
}



