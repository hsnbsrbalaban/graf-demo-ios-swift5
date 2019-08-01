import UIKit

class AllPartsViewController: UIViewController {
    
    @IBOutlet weak var allPartsView: AllPartsUIView!
    @IBOutlet weak var moveToPoint: UIImageView!
    @IBOutlet weak var lineToPointOne: UIImageView!
    @IBOutlet weak var relativeArcToCenterPoint: UIImageView!
    @IBOutlet weak var curveToEndPonint: UIImageView!
    @IBOutlet weak var curveToControlPointOne: UIImageView!
    @IBOutlet weak var curveToControlPointTwo: UIImageView!
    @IBOutlet weak var quadCurveToEndPoint: UIImageView!
    @IBOutlet weak var quadCurveToControlPoint: UIImageView!
    @IBOutlet weak var lineToPointTwo: UIImageView!
    @IBOutlet weak var arcToPointOne: UIImageView!
    @IBOutlet weak var arcToPointTwo: UIImageView!
    @IBOutlet weak var lineToPointThree: UIImageView!
    @IBOutlet weak var arcCenterPoint: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        allPartsView.delegate = self
        
        allPartsView.appendPoints()

        moveToPoint.center = allPartsView.points[0]
        lineToPointOne.center = allPartsView.points[1]
        relativeArcToCenterPoint.center = allPartsView.points[2]
        curveToEndPonint.center = allPartsView.points[3]
        curveToControlPointOne.center = allPartsView.points[4]
        curveToControlPointTwo.center = allPartsView.points[5]
        quadCurveToEndPoint.center = allPartsView.points[6]
        quadCurveToControlPoint.center = allPartsView.points[7]
        lineToPointTwo.center = allPartsView.points[8]
        arcToPointOne.center = allPartsView.points[9]
        arcToPointTwo.center = allPartsView.points[10]
        lineToPointThree.center = allPartsView.points[11]
        arcCenterPoint.center = allPartsView.points[12]
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AllPartsViewController: AllPartsUIViewDelegate {
    func cornerNum(_ touch: UITouch) -> Int {
        let location = touch.location(in: allPartsView)
        
        if moveToPoint.frame.contains(location) { return 0 }
        else if lineToPointOne.frame.contains(location) { return 1 }
        else if relativeArcToCenterPoint.frame.contains(location) { return 2 }
        else if curveToEndPonint.frame.contains(location) { return 3 }
        else if curveToControlPointOne.frame.contains(location) { return 4 }
        else if curveToControlPointTwo.frame.contains(location) { return 5 }
        else if quadCurveToEndPoint.frame.contains(location) { return 6 }
        else if quadCurveToControlPoint.frame.contains(location) { return 7 }
        else if lineToPointTwo.frame.contains(location) { return 8 }
        else if arcToPointOne.frame.contains(location) { return 9 }
        else if arcToPointTwo.frame.contains(location) { return 10 }
        else if lineToPointThree.frame.contains(location) { return 11 }
        else if arcCenterPoint.frame.contains(location) { return 12 }
        
        return .max
    }
    
    func changeCornerCenter(_ location: CGPoint) {
        let cornerNum = allPartsView.cornerNum
        
        switch cornerNum {
        case 0:
            moveToPoint.center = location
        case 1:
            lineToPointOne.center = location
        case 2:
            relativeArcToCenterPoint.center = location
        case 3:
            curveToEndPonint.center = location
        case 4:
            curveToControlPointOne.center = location
        case 5:
            curveToControlPointTwo.center = location
        case 6:
            quadCurveToEndPoint.center = location
        case 7:
            quadCurveToControlPoint.center = location
        case 8:
            lineToPointTwo.center = location
        case 9:
            arcToPointOne.center = location
        case 10:
            arcToPointTwo.center = location
        case 11:
            lineToPointThree.center = location
        case 12:
            arcCenterPoint.center = location
        default:
            fatalError("cornerNum is invalid!")
        }
    }
    
    
}
