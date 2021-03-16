import UIKit
import CoreData
import Charts

/// - ActivityViewController provides the user some information about their overall workout data.
class ActivityViewController: UIViewController, ChartViewDelegate {
   //MARK:- UI Labels
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var thisWeekLabel: UILabel!
    @IBOutlet weak var thisMonth: UIStackView!
    @IBOutlet weak var thisYearLabel: UILabel!
    
    // MARK: - Properties
    @IBOutlet weak var pieChartView: PieChartView!
    
    // MARK: - ViewController Lifecyle States
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Activity"
        calculateSessions()
        
        pieChartView.delegate = self
        pieChartView.centerText = "All Sessions"
        
            // PieChart test data
            var entries = [PieChartDataEntry]()
            entries.append(PieChartDataEntry(value: 5, label: "Toprock"))
            entries.append(PieChartDataEntry(value: 1, label: "Footwork"))
            entries.append(PieChartDataEntry(value: 2, label: "Freezes"))
            entries.append(PieChartDataEntry(value: 3, label: "Powermoves"))
            entries.append(PieChartDataEntry(value: 5, label: "Battle"))
            
            let set = PieChartDataSet(entries: entries)
            set.colors = ChartColorTemplates.pastel()
            
            let data = PieChartData(dataSets: [set])
            pieChartView.data = data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateSessions()
    }
    
    //MARK:- Core Data Functions
    /* Notes: Use NSPredicate to specify requests. I need to create Date ranges
    
     Year: 1/1/2021
     YearEnd: 12/31/2021
     
     Month: (Current Month first day)
     MonthEnd: (Current month last day)
     
     Week: (Get first day of current week)
     WeekEnd: (Get last day of current week)
     
     Today: (Get first time of day)
     Today: (Get last time of day)
     
     */
    
    func calculateSessions(){
        // Get context from Core Data
        guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        
        // We need 4 seperate fetch requests (Y,M,W,T)
        
        // YEAR
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Session")
        
        let startDate = Date()
        let predicate = NSPredicate(format: "date < %@", argumentArray: [startDate])
        fetchRequest.predicate = predicate
        
        // MONTH
        
        // WEEK
        
        // TODAY
        
        do {
            //Update Year label
            try thisYearLabel?.text = String(managedContext.count(for: fetchRequest))
            
            //Update Month label
            
            //Update Week label
            
            //Update today's label
        }catch let error as NSError{
            print("Could not fetch \(error)")
        }
        
        
        
        
    }
    
}



