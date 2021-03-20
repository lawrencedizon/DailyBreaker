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
    
    // MARK: - ViewController Lifecycle States
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Activity"
        pieChartView.legend.enabled = false
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
        fetchAllSessions()
        calculateSessions()
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
    
    /// Fetches all Session counts for Today, This Week, This Month, and This Year (BRUTE FORCE APPROACH)
    //FIXME: - Clean and Refacor this
    // Currently we have a fixed solution, but we can make this generalized.
    // We use DateComponents to construct the date, is there a better way?
    
    func calculateSessions(){
        // Get context from Core Data
        guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // We need 4 seperate fetch requests (Y,T,W,M)
        
        // YEAR
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Session")
        let calendar = Calendar.current
        let dateComponents = DateComponents(calendar: calendar, year: 2021, month: 1, day: 1)
        let dateComponents2 = DateComponents(calendar: calendar, year: 2021, month: 12,day: 31)
        let startYearDate = calendar.date(from: dateComponents)! // 1/1/2021
        let endYearDate = calendar.date(from: dateComponents2)
        let predicate = NSPredicate(format: "date > %@ AND date < %@", argumentArray: [startYearDate, endYearDate])
        fetchRequest.predicate = predicate
        
        // TODAY
        let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "Session")
        let dateComponents3 = DateComponents(calendar: calendar, year: 2021, month: 3, day: 19)
        let dateComponents4 = DateComponents(calendar: calendar, year: 2021, month: 3, day: 20)
        let startTodayDate = calendar.date(from: dateComponents3)
        let endTodayDate = calendar.date(from: dateComponents4)
        let predicate2 = NSPredicate(format: "date > %@ AND date < %@", argumentArray: [startTodayDate, endTodayDate])
        fetchRequest2.predicate = predicate2
        
        // WEEK
        let fetchRequest3 = NSFetchRequest<NSManagedObject>(entityName: "Session")
        let dateComponents5 = DateComponents(year: 2021, month: 3, day: 15)
        let dateComponents6 = DateComponents(year: 2021, month: 3, day: 21)
        let startWeekDate = calendar.date(from: dateComponents5)
        let endWeekDate = calendar.date(from: dateComponents6)
        let predicate3 = NSPredicate(format: "date > %@ AND date < %@", argumentArray: [startWeekDate, endWeekDate])
        fetchRequest3.predicate = predicate3
        
        // MONTH
        let fetchRequest4 = NSFetchRequest<NSManagedObject>(entityName: "Session")
        let dateComponents7 = DateComponents(year: 2021, month: 3, day: 1)
        let dateComponents8 = DateComponents(year: 2021, month: 4, day: 1)
        let startMonthDate = calendar.date(from: dateComponents7)
        let endMonthDate = calendar.date(from: dateComponents8)
        let predicate4 = NSPredicate(format: "date > %@ AND date < %@", argumentArray: [startMonthDate, endMonthDate])
        fetchRequest4.predicate = predicate4
        
        do {
            try thisYearLabel?.text = String(managedContext.count(for: fetchRequest))
            try todayLabel?.text = String(managedContext.count(for: fetchRequest2))
            try thisWeekLabel?.text = String(managedContext.count(for: fetchRequest3))
            try thisMonthLabel?.text = String(managedContext.count(for: fetchRequest4))
        }catch let error as NSError{
            print("Could not fetch \(error)")
        }
    }
}



