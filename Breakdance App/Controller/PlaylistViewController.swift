//
//  PlaylistViewController.swift
//  Breakdance App
//
//  Created by Lawrence Dizon on 2/19/21.
//  Copyright © 2021 Lawrence Dizon. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var playlistVideos: [String] = []
    var titleH: String?
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
               
        tableView.delegate = self
        tableView.dataSource = self
               
        view.addSubview(tableView)
        fetchInfo(url: Constants.API_URL)
        print("VIEWDIDLOAD \(self.playlistVideos.count)")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            print("HAHAAHHA \(self.playlistVideos.count)")
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    
    //Functions required for Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = playlistVideos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped")
    }
    
    func fetchInfo(url: String){
        guard let url = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: url)  { (data, _, error) in
            
            //error check
            guard error == nil else {
                print("An error occurred")
                print(error)
                return
            }
            
            //make sure we get data
            guard let data = data, error == nil else {
                return
            }
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                print("API CALL:  \(url)")
                DispatchQueue.main.async {
                    print("WE IN THERE DOG")
                    for item in jsonResult.items{
                        self.playlistVideos.append(item.snippet.title)
                    }
                    self.titleH = self.playlistVideos[0]
                    print("playlist count \(self.playlistVideos.count)")
                    
                }
            }catch{
                print("API CALL: \(url)")
                print("FUUUUCK")
                print(error)
            }
            
        }
        
        task.resume()
        print("playlist count after resume \(self.playlistVideos.count)")
    }

    

}
