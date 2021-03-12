import UIKit
import CoreData
import Charts

/// - ActivityViewController provides the user some information about their overall workout data.
class ActivityViewController: UIViewController, ChartViewDelegate {
   
    // MARK: - Properties
    @IBOutlet weak var pieChartView: PieChartView!
    
    // MARK: - ViewController Life States
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Activity"
        
        pieChartView.delegate = self
        pieChartView.centerText = "All Sessions"
        
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
    
}



