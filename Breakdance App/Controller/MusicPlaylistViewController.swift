import UIKit
import SafariServices

class MusicPlaylistViewController: UIViewController, SFSafariViewControllerDelegate{
    
//MARK:- View Life Cycles
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let link = URL(string: "https://www.youtube.com/c/BboyMusic4life/playlists") else{
            return
        }
        let safariViewController = SFSafariViewController(url: link)
        
        present(safariViewController, animated: true, completion: {self.selectFirstTab()})
    }
    
//MARK:- Helper Functions
    
    //Sets the tabBar to the first tab (Home)
    func selectFirstTab(){
        self.tabBarController?.selectedIndex = 0
    }
}



