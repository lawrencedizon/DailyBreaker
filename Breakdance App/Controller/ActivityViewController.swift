import UIKit
import CoreData
import Charts

/// - ActivityViewController provides the user some information about their overall workout data.
class ActivityViewController: UIViewController, ChartViewDelegate {
    
   //MARK:- UI Labels
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var thisWeekLabel: UILabel!
    @IBOutlet weak var thisYearLabel: UILabel!
    @IBOutlet weak var thisMonthLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    // MARK: - Properties
    var sessionArray: [Session] = []
    var sessionDict = [String:Int]()
    
    // MARK: - ViewController Lifecyle States
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Activity"
        calculateSessions()
        pieChartView.delegate = self
        pieChartView.centerText = "All Sessions"
        updatePieChartData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //calculateSessions()
        updatePieChartData()
    }
    
    //MARK:- PieChart Functions
    func updatePieChartData(){
        sessionDict = countSessions()
        var entries = [PieChartDataEntry]()
        for session in sessionDict{
            entries.append(PieChartDataEntry(value: Double(session.value), label: session.key))
        }
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.pastel()
        
        let data = PieChartData(dataSets: [set])
        pieChartView.data = data
    }
    
    func countSessions() -> Dictionary<String,Int>{
        fetchAllSessions()
        var someDict = [String: Int]()
        for session in sessionArray{
            guard let sessionName = session.type else { return someDict }
            if someDict.keys.contains(sessionName){
                someDict[sessionName]! += 1
            }else{
                someDict[sessionName] = 1
            }
        }
        print(someDict)
        return someDict
    }
    
    //MARK:- Core Data Stuff
    /// Deletes all Session records
    func deleteAllRecords() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
           print ("There was an error")
        }
    }
    
    /// Fetches all sessions from Core Data and puts them into sessionArray
    func fetchAllSessions(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Session")
        
        do {
            sessionArray = try managedContext.fetch(fetchRequest) as! [Session]
        }catch let error as NSError {
            print("Could not fetch sessions. \(error), \(error.userInfo)")
        }
    }
    
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
    
    /// Fetches all Session counts for Today, This Week, This Month, and This Year
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
            try thisMonthLabel?.text = String(managedContext.count(for: fetchRequest))
            try thisWeekLabel?.text = String(managedContext.count(for: fetchRequest))
            try todayLabel?.text = String(managedContext.count(for: fetchRequest))
            //Update Month label
            
            //Update Week label
            
            //Update today's label
        }catch let error as NSError{
            print("Could not fetch \(error)")
        }
    }
    
}



