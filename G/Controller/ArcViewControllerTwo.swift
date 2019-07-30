import UIKit

class ArcViewControllerTwo: UIViewController {
    
    @IBOutlet weak var relativeArcView: ArcsUIView!
    @IBOutlet weak var corner0: UIImageView!
    @IBOutlet weak var corner1: UIImageView!
    @IBOutlet weak var centerPoint: UIImageView!
    @IBOutlet weak var radiusPoint: UIImageView!
    @IBOutlet weak var corner2: UIImageView!
    @IBOutlet weak var corner3: UIImageView!
    
    @IBOutlet weak var startAngleLabel: UILabel!
    @IBOutlet weak var deltaLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setInitials()
        
        relativeArcView.delegate = self
    }
    
    func setInitials() {
        relativeArcView.viewType = .relativeArc
        relativeArcView.appendPoints()
        
        corner0.center = relativeArcView.points[0]
        corner1.center = relativeArcView.points[1]
        centerPoint.center = relativeArcView.points[2]
        radiusPoint.center = relativeArcView.points[3]
        corner2.center = relativeArcView.points[4]
        corner3.center = relativeArcView.points[5]
    }
    
    @IBAction func startAngleSlider(_ sender: UISlider) {
        let trueVal = sender.value - 6.28
        startAngleLabel.text = String(format: "%.2f", trueVal)
        
        relativeArcView.startAngle = CGFloat(trueVal)
        relativeArcView.setNeedsDisplay()
    }
    
    @IBAction func deltaSlider(_ sender: UISlider) {
        let trueVal = sender.value - 6.28
        deltaLabel.text = String(format: "%.2f", trueVal)
        
        relativeArcView.delta = CGFloat(trueVal)
        relativeArcView.setNeedsDisplay()
    }
    
    @IBAction func leftArrowButtonPressed(_ sender: CustomButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToMenuButtonPressed(_ sender: CustomButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension ArcViewControllerTwo: ArcsUIViewDelegate {
    func cornerNum(_ touch: UITouch) -> Int {
        let location = touch.location(in: relativeArcView)
        
        if corner0.frame.contains(location) { return 0 }
        else if corner1.frame.contains(location) { return 1 }
        else if centerPoint.frame.contains(location) { return 2 }
        else if radiusPoint.frame.contains(location) { return 3 }
        else if corner2.frame.contains(location) { return 4 }
        else if corner3.frame.contains(location) { return 5 }
        
        return .max
    }
    
    func changeCornerCenter(_ location: CGPoint) {
        let cornerNum = relativeArcView.cornerNum
        
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
