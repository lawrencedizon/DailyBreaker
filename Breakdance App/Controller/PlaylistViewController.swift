//
//  PlaylistViewController.swift
//  Breakdance App
//
//  Created by Lawrence Dizon on 2/19/21.
//  Copyright © 2021 Lawrence Dizon. All rights reserved.
//

import UIKit

class PlaylistViewController: UITableViewController {
    var playlistVideos: [String] = []
    var API_URL: String?
    var videoIds: [String] = []
    var thumbNails: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = API_URL {
            fetchInfo(url: url)
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistVideos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "playlistcell", for: indexPath) as! PlaylistTableViewCell
        
        cell.playlistItemLabel?.text = playlistVideos[indexPath.row]
        cell.playlistImage?.image = thumbNails[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    func fetchInfo(url: String){
        guard let url = URL(string: url) else { return }
        print("API CALL:  \(url)")
        let task = URLSession.shared.dataTask(with: url)  { (data, _, error) in
            
            //error check
            guard error == nil else {
                print("Failed to fetch Youtube playlist info")
                return
            }
            
            //make sure we get data
            guard let data = data, error == nil else {
                return
            }
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)

                for item in jsonResult.items{
                    self.playlistVideos.append(item.snippet.title)
                    self.videoIds.append(item.snippet.resourceId.videoId)
                    
                    if let url = URL(string: item.snippet.thumbnails.high.url){
                        let image = try? Data(contentsOf: url)
                        
                        if let imageData = image {
                            self.thumbNails.append(UIImage(data: imageData)!)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
               
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewController = storyboard?.instantiateViewController(identifier: "Video") as? VideoPlayerViewController {
            viewController.videoId = videoIds[indexPath.row]
            navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
}
