import UIKit

class HomeViewController: UIViewController {
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
//MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

//MARK:- HomeViewController Functions

extension HomeViewController {
    //Setup TableView and add constraints
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
        ])
    }
    
}

