import UIKit
import PlaygroundSupport


class ViewController: UIViewController {
    
    private lazy var lineChart: LineChart = {
        let lineChart = LineChart()
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        return lineChart
    }()
    
    private lazy var curvedlineChart: LineChart = {
        let lineChart = LineChart()
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        return lineChart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0.3529411765, blue: 0.6156862745, alpha: 1)
        layoutUI()
        // Sample dataset
//        let dataEntries = [PointEntry(value: 0, title: ""), PointEntry(value: 100, title: ""), PointEntry(value: 100, title: ""), PointEntry(value: 100, title: ""), PointEntry(value: 20, title: ""), PointEntry(value: 30, title: ""), PointEntry(value: 120, title: "")]
        
        let dataEntries = generateRandomEntries()
        
        lineChart.dataEntries = dataEntries
        lineChart.isCurved = false
        
        curvedlineChart.dataEntries = dataEntries
        curvedlineChart.animateDots = true
        curvedlineChart.isCurved = true
    }
    
    private func layoutUI() {
        view.addSubview(curvedlineChart)
        view.addSubview(lineChart)

        NSLayoutConstraint.activate([
            curvedlineChart.topAnchor.constraint(equalTo: view.topAnchor),
            curvedlineChart.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            curvedlineChart.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            curvedlineChart.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            lineChart.topAnchor.constraint(equalTo: curvedlineChart.bottomAnchor, constant: 8),
            lineChart.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineChart.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineChart.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func generateRandomEntries() -> [PointEntry] {
        var result: [PointEntry] = []
        for i in 0..<100 {
            let value = Int(arc4random() % 500)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            
            result.append(PointEntry(value: value, label: formatter.string(from: date)))
        }
        return result
    }
}

let vc = ViewController()


PlaygroundPage.current.setLiveView(vc)
