//
//  Constants.swift
//  Breakdance App
//
//  Created by Lawrence Dizon on 2/19/21.
//  Copyright © 2021 Lawrence Dizon. All rights reserved.
//

import Foundation

struct Constants {
    static var API_KEY = ""
    static var PLAYLIST_ID = "DNqpXCGiMXk"
    
    static var API_URL = "https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&id=\(PLAYLIST_ID)&key=\(API_KEY)"
}
