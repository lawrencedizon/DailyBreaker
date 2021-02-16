import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var video: Video? {
        didSet {
            thumbnailView.image = video?.thumbnail
            thumbnailView.clipsToBounds = true
            titleLabel.text = video?.title
        }
    }
}
