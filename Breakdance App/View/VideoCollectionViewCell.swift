//
//  VideoCollectionViewCell.swift
//  Breakdance App
//
//  Created by Lawrence Dizon on 8/15/20.
//  Copyright © 2020 Lawrence Dizon. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var video: Video? {
        didSet {
            thumbnailView.image = video?.thumbnail
            thumbnailView.layer.cornerRadius = 10
            thumbnailView.clipsToBounds = true
            titleLabel.text = video?.title
            subtitleLabel.text = "\(video?.lessonCount ?? 0) lessons"
        }
    }
}
