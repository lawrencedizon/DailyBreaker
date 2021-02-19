import UIKit


struct APIResponse: Codable {
    var videoId: String
}

class Video {
    var id = UUID()
    var title: String
    var thumbnail: UIImage?
    var link: URL?
    
    init(title: String, thumbnail: UIImage? = nil, link: URL?){
        self.title = title
        self.thumbnail = thumbnail
        self.link = link
    }
}
//
// MARK: - Video Data
//

extension Video {
    static let allVideos = [
        Video(
                title: "Toprock",
                thumbnail: UIImage(named: "toprock"),
                link: URL(string: "https://www.youtube.com/watch?v=7R9SLdD3eOU&list=PL57E01028C82367BD")
              ),
        Video(
            title: "Footwork",
            thumbnail: UIImage(named: "footwork"),
            link: URL(string: "https://www.youtube.com/watch?v=9OOzN7QNE_Y&list=PLC03D627286ADDD94")
        ),
        Video(
            title: "Freezes",
            thumbnail: UIImage(named: "freezes"),
            link: URL(string: "https://www.youtube.com/watch?v=FGiG47yG2KE&list=PL667C395494400FC0")
        ),
        Video(
            title: "Powermoves",
            thumbnail: UIImage(named: "powermoves"),
            link: URL(string: "https://www.youtube.com/watch?v=itAjT2Uuww8&list=PL0498871864379CC0")
        ),
    ]
}

