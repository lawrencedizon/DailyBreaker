import Foundation
import UIKit


/// - TrainingViewController manages the list of exercises the user can choose from.

class TrainingViewController: UITableViewController {
    // MARK: - Properties
    private var skillArray: [String] = ["Warm Up","Battle", "Toprock","Footwork","Freezes","Powermoves","Stamina"]
    
    // MARK: - Lifecycle States
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Training"
    }
    
    // MARK: - TableView Properties
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skillArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainingTableViewCell
        cell.cellLabel?.text = skillArray[indexPath.row]
        cell.cellImage?.image = UIImage(named: skillArray[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(identifier: "TimerView") as? TimerViewController {
            
            navigationController?.pushViewController(viewController, animated: true)
            viewController.navigationItem.title = skillArray[indexPath.row]
            
            switch skillArray[indexPath.row]{
            case "Warm Up":
                viewController.exercises = TrainingExercises.WarmUp
            case "Battle":
                viewController.exercises = TrainingExercises.Battle
            case "Toprock":
                viewController.exercises = TrainingExercises.Toprock
            case "Footwork":
                viewController.exercises = TrainingExercises.Footwork
            case "Freezes":
                viewController.exercises = TrainingExercises.Freezes
            case "Powermoves":
                viewController.exercises = TrainingExercises.Powermoves
            case "Stamina":
                viewController.exercises = TrainingExercises.Stamina
            default:
                // We should never go here
                viewController.exercises = []
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
