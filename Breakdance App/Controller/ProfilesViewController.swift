//
//  ViewController.swift
//  Breakdance App
//
//  Created by Lawrence Dizon on 8/11/20.
//  Copyright © 2020 Lawrence Dizon. All rights reserved.
//

import UIKit

class ProfilesViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var profiles = [Profile]()

    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
    }
    
    //MARK:- Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Profiles.profiles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return "Breakdancers"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           
           let profile = Profiles.profiles[indexPath.row]
           
           //configure cell
           cell.textLabel?.text = profile.name
           cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18 )
           cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17 )
           return cell
       }
    
}

