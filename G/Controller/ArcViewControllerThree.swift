import UIKit

class ArcViewControllerThree: UIViewController {

    @IBOutlet weak var arcToView: ArcsUIView!
    @IBOutlet weak var corner0: UIImageView!
    @IBOutlet weak var corner1: UIImageView!
    @IBOutlet weak var controlCorner0: UIImageView!
    @IBOutlet weak var radiusPoint: UIImageView!
    @IBOutlet weak var corner2: UIImageView!
    @IBOutlet weak var controlCorner1: UIImageView!
    @IBOutlet weak var corner3: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitials()

        arcToView.delegate = self
    }
    
    func setInitials() {
        arcToView.viewType = .arcToPoint
        arcToView.appendPoints()
        
        corner0.center = arcToView.points[0]
        corner1.center = arcToView.points[1]
        controlCorner0.center = arcToView.points[2]
        radiusPoint.center = arcToView.points[3]
        corner2.center = arcToView.points[4]
        controlCorner1.center = arcToView.points[5]
        corner3.center = arcToView.points[6]
    }
    
    @IBAction func leftArrowButtonPressed(_ sender: CustomButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backToMenuButtonPressed(_ sender: CustomButton) {
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension ArcViewControllerThree: ArcsUIViewDelegate {
    func cornerNum(_ touch: UITouch) -> Int {
        let location = touch.location(in: arcToView)
        
        if corner0.frame.contains(location) { return 0 }
        else if corner1.frame.contains(location) { return 1 }
        else if controlCorner0.frame.contains(location) { return 2 }
        else if radiusPoint.frame.contains(location) { return 3 }
        else if corner2.frame.contains(location) { return 4 }
        else if controlCorner1.frame.contains(location) { return 5 }
        else if corner3.frame.contains(location) { return 6 }
        
        return .max
    }
    
    func changeCornerCenter(_ location: CGPoint) {
        let cornerNum = arcToView.cornerNum
        
        switch cornerNum {
        case 0:
            corner0.center = location
        case 1:
            corner1.center = location
        case 2:
            controlCorner0.center = location
        case 3:
            radiusPoint.center = location
        case 4:
            corner2.center = location
        case 5:
            controlCorner1.center = location
        case 6:
            corner3.center = location
        default:
            fatalError("cornerNum is invalid!")
        }
    }
}
