
import youtube_ios_player_helper
import UIKit

class VideoPlayerViewController: UIViewController, YTPlayerViewDelegate {
    var videoId: String?
    @IBOutlet var playerView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self
    
        if let id = videoId  {
            print("id: \(id)")
            playerView.load(withVideoId: id)
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}


