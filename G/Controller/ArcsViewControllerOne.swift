import UIKit

class ArcsViewControllerOne: UIViewController {
    
    @IBOutlet weak var arcView: ArcsUIView!
    @IBOutlet weak var corner0: UIImageView!
    @IBOutlet weak var corner1: UIImageView!
    @IBOutlet weak var centerPoint: UIImageView!
    @IBOutlet weak var radiusPoint: UIImageView!
    @IBOutlet weak var corner2: UIImageView!
    @IBOutlet weak var corner3: UIImageView!
    
    @IBOutlet weak var startAngleLabel: UILabel!
    @IBOutlet weak var endAngleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitials()
        
        arcView.delegate = self
    }
    
    func setInitials() {
        arcView.viewType = .arc
        arcView.appendPoints()
        
        corner0.center = arcView.points[0]
        corner1.center = arcView.points[1]
        centerPoint.center = arcView.points[2]
        radiusPoint.center = arcView.points[3]
        corner2.center = arcView.points[4]
        corner3.center = arcView.points[5]
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startAngleSlider(_ sender: UISlider) {
        let trueVal = sender.value - 6.28
        startAngleLabel.text = String(format: "%.2f", trueVal)
        
        arcView.startAngle = CGFloat(trueVal)
        arcView.setNeedsDisplay()
    }
    
    @IBAction func endAngleSlider(_ sender: UISlider) {
        let trueVal = sender.value - 6.28
        endAngleLabel.text = String(format: "%.2f", trueVal)
        
        arcView.endAngle = CGFloat(trueVal)
        arcView.setNeedsDisplay()
    }
    
    @IBAction func clockwiseButtonPressed(_ sender: CheckBox) {
        arcView.clockwise = arcView.clockwise ? false : true
        arcView.setNeedsDisplay()
    }
}

extension ArcsViewControllerOne: ArcsUIViewDelegate {
    func cornerNum(_ touch: UITouch) -> Int {
        let location = touch.location(in: arcView)
        
        if corner0.frame.contains(location) { return 0 }
        else if corner1.frame.contains(location) { return 1 }
        else if centerPoint.frame.contains(location) { return 2 }
        else if radiusPoint.frame.contains(location) { return 3 }
        else if corner2.frame.contains(location) { return 4 }
        else if corner3.frame.contains(location) { return 5 }
        
        return .max
    }
    
    func changeCornerCenter(_ location: CGPoint) {
        let cornerNum = arcView.cornerNum
        
        switch cornerNum {
        case 0:
            corner0.center = location
        case 1:
            corner1.center = location
        case 2:
            centerPoint.center = location
        case 3:
            radiusPoint.center = location
        case 4:
            corner2.center = location
        case 5:
            corner3.center = location
        default:
            fatalError("cornerNum is invalid!")
        }
    }
}
