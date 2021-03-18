import UIKit
import SafariServices

// Personal notes: When a user clicks on the category, it should lead to PlaylistViewController TableView of

/// - LearnViewController manages the different learning topics. Each topic leads to a video playlist pertaining to that topic.
class LearnViewController: UICollectionViewController {
    
    // MARK: - Properties
    private var videoList = Video.allVideos
    
    // MARK: - View Controller LifeCycle States
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
}

// MARK: - Functions
extension LearnViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count
    }
    
    // MARK: - CollectionView DataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let video = videoList[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "VideoCollectionViewCell",
            for: indexPath) as? VideoCollectionViewCell else { fatalError() }
        cell.video = video
        return cell
    }
}

// MARK: - CollectionView Delegate
extension LearnViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let viewController = storyboard?.instantiateViewController(identifier: "PlaylistView") as? PlaylistViewController {
            switch indexPath.row{
                case 0:
                //Toprock
                    viewController.API_URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=PL57E01028C82367BD&key=\(Constants.API_KEY)&maxResults=50"
                //Footwork
                case 1:
                    viewController.API_URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=PLC03D627286ADDD94&key=\(Constants.API_KEY)&maxResults=50"
                //Freezes
                case 2:
                    viewController.API_URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=PL667C395494400FC0&key=\(Constants.API_KEY)&maxResults=50"
                //Powermoves
                case 3:
                    viewController.API_URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=PL0498871864379CC0&key=\(Constants.API_KEY)&maxResults=50"
                default:
                    print("This should never happen")
                    return
            }
            
            navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
}
    
// MARK: - Layout Handling
extension LearnViewController {
    private func configureLayout(){
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            let size = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250))
            let itemCount = isPhone ? 1 : 3
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            return section
        })
    }
}

    
    
    
    

