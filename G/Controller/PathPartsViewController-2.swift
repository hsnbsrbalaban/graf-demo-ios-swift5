import UIKit

class PathPartsViewControllerTwo: UIViewController {
    
    @IBOutlet weak var lineToView: PathPartsUIViewTwo!
    @IBOutlet weak var lineToCheckView: UIView!
    @IBOutlet weak var lineToCorner0: UIImageView!
    @IBOutlet weak var lineToCorner1: UIImageView!
    @IBOutlet weak var lineToCorner2: UIImageView!
    @IBOutlet weak var quadCurveView: PathPartsUIViewTwo!
    @IBOutlet weak var quadCurveCheckView: UIView!
    @IBOutlet weak var quadCurveCorner0: UIImageView!
    @IBOutlet weak var quadCurveCorner1: UIImageView!
    @IBOutlet weak var quadCurveControlCorner: UIImageView!
    @IBOutlet weak var bezierCurveView: PathPartsUIViewTwo!
    @IBOutlet weak var bezierCurveCheckView: UIView!
    @IBOutlet weak var bezierCurveCorner0: UIImageView!
    @IBOutlet weak var bezierCurveCorner1: UIImageView!
    @IBOutlet weak var bezierCurveControlCorner0: UIImageView!
    @IBOutlet weak var bezierCurveControlCorner1: UIImageView!
    
    @IBOutlet weak var superView: UIView!
    
    var clickedRect: ViewTypeTwo = .empty

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitials()
        
        lineToView.delegate = self
        quadCurveView.delegate = self
        bezierCurveView.delegate = self
    }
    
    func setInitials() {
        lineToView.viewType = .lineTo
        lineToView.appendPoints()
        quadCurveView.viewType = .quadCurve
        quadCurveView.appendPoints()
        bezierCurveView.viewType = .bezierCurve
        bezierCurveView.appendPoints()
        
        lineToCheckView.center = lineToView.center
        quadCurveCheckView.center = quadCurveView.center
        bezierCurveCheckView.center = bezierCurveView.center
        
        lineToCorner0.center = lineToView.points[0]
        lineToCorner1.center = lineToView.points[1]
        lineToCorner2.center = lineToView.points[2]
        quadCurveCorner0.center = quadCurveView.points[0]
        quadCurveCorner1.center = quadCurveView.points[1]
        quadCurveControlCorner.center = quadCurveView.points[2]
        bezierCurveCorner0.center = bezierCurveView.points[0]
        bezierCurveCorner1.center = bezierCurveView.points[1]
        bezierCurveControlCorner0.center = bezierCurveView.points[2]
        bezierCurveControlCorner1.center = bezierCurveView.points[3]
    }
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func backToMenuButtonPressed(_ sender: CustomButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension PathPartsViewControllerTwo: PathPartsUIViewTwoDelegate {
    func cornerNum(_ touch: UITouch) -> Int {
        let superLocation = touch.location(in: superView)
        
        if lineToCheckView.frame.contains(superLocation) {
            let location = touch.location(in: lineToView)
            clickedRect = .lineTo
            
            if lineToCorner0.frame.contains(location) { return 0}
            else if lineToCorner1.frame.contains(location) { return 1 }
            else if lineToCorner2.frame.contains(location) { return 2 }
        }
        else if quadCurveCheckView.frame.contains(superLocation) {
            let location = touch.location(in: quadCurveView)
            clickedRect = .quadCurve
            
            if quadCurveCorner0.frame.contains(location) { return 0 }
            else if quadCurveCorner1.frame.contains(location) { return 1 }
            else if quadCurveControlCorner.frame.contains(location) { return 2 }
        }
        else if bezierCurveCheckView.frame.contains(superLocation) {
            let location = touch.location(in: bezierCurveView)
            clickedRect = .bezierCurve
            
            if bezierCurveCorner0.frame.contains(location) { return 0 }
            else if bezierCurveCorner1.frame.contains(location) { return 1 }
            else if bezierCurveControlCorner0.frame.contains(location) { return 2 }
            else if bezierCurveControlCorner1.frame.contains(location) { return 3 }
        }
        return .max
    }
    
    func changeCornerCenter(_ location: CGPoint) {
        let cornerNum = clickedRect == .lineTo ? lineToView.cornerNum : (clickedRect == .quadCurve ? quadCurveView.cornerNum : bezierCurveView.cornerNum)
        
        switch clickedRect {
        case .empty:
            fatalError("type is incorrect!")
            
        case .lineTo:
            if cornerNum == 0 { lineToCorner0.center = location }
            else if cornerNum == 1 { lineToCorner1.center = location }
            else { lineToCorner2.center = location }
            
        case .quadCurve:
            if cornerNum == 0 { quadCurveCorner0.center = location }
            else if cornerNum == 1 { quadCurveCorner1.center = location }
            else if cornerNum == 2 { quadCurveControlCorner.center = location }
            
        case .bezierCurve:
            if cornerNum == 0 { bezierCurveCorner0.center = location }
            else if cornerNum == 1 { bezierCurveCorner1.center = location }
            else if cornerNum == 2 { bezierCurveControlCorner0.center = location }
            else if cornerNum == 3 { bezierCurveControlCorner1.center = location }
        }
    }
}
