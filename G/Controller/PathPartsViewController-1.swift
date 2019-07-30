import UIKit

class PathPartsViewControllerOne: UIViewController {
    
    @IBOutlet weak var rectView: PathPartsUIViewOne!
    @IBOutlet weak var rectCheckView: UIView!
    @IBOutlet weak var rectCorner0: UIImageView!
    @IBOutlet weak var rectCorner1: UIImageView!
    @IBOutlet weak var ovalView: PathPartsUIViewOne!
    @IBOutlet weak var ovalCheckView: UIView!
    @IBOutlet weak var ovalCorner0: UIImageView!
    @IBOutlet weak var ovalCorner1: UIImageView!
    @IBOutlet weak var roundedRectView: PathPartsUIViewOne!
    @IBOutlet weak var roundedRectCheckView: UIView!
    @IBOutlet weak var roundedRectCorner0: UIImageView!
    @IBOutlet weak var roundedRectCorner1: UIImageView!
    @IBOutlet weak var roundedRectRadiusCorner: UIImageView!
    
    @IBOutlet weak var rectEmptyCorner0: UIImageView!
    @IBOutlet weak var rectEmptyCorner1: UIImageView!
    @IBOutlet weak var ovalEmptyCorner0: UIImageView!
    @IBOutlet weak var ovalEmptyCorner1: UIImageView!
    @IBOutlet weak var roundedRectEmptyCorner0: UIImageView!
    @IBOutlet weak var roundedRectEmptyCorner1: UIImageView!
    
    var clickedRect: ViewTypeOne = .empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitials()
        
        rectView.delegate = self
        ovalView.delegate = self
        roundedRectView.delegate = self
    }
    
    func setInitials() {
        rectView.viewType = .rect
        ovalView.viewType = .oval
        roundedRectView.viewType = .roundedRect
        
        rectCheckView.center = rectView.center
        ovalCheckView.center = ovalView.center
        roundedRectCheckView.center = roundedRectView.center
        
        rectCorner0.center = rectView.points[0]
        rectCorner1.center = rectView.points[1]
        ovalCorner0.center = ovalView.points[0]
        ovalCorner1.center = ovalView.points[1]
        roundedRectCorner0.center = roundedRectView.points[0]
        roundedRectCorner1.center = roundedRectView.points[1]
        roundedRectRadiusCorner.center = roundedRectView.points[2]
        
        setEmptyCorners()
    }
    
    func setEmptyCorners() {
        rectEmptyCorner0.center = CGPoint(x: rectCorner1.center.x, y: rectCorner0.center.y)
        rectEmptyCorner1.center = CGPoint(x: rectCorner0.center.x, y: rectCorner1.center.y)
        ovalEmptyCorner0.center = CGPoint(x: ovalCorner1.center.x, y: ovalCorner0.center.y)
        ovalEmptyCorner1.center = CGPoint(x: ovalCorner0.center.x, y: ovalCorner1.center.y)
        roundedRectEmptyCorner0.center = CGPoint(x: roundedRectCorner1.center.x, y: roundedRectCorner0.center.y)
        roundedRectEmptyCorner1.center = CGPoint(x: roundedRectCorner0.center.x, y: roundedRectCorner1.center.y)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PathPartsViewControllerOne: PathPartsUIViewOneDelegate {
    
    func cornerNum(_ touch: UITouch) -> Int {
        let superLocation = touch.location(in: self.view)
        
        if rectCheckView.frame.contains(superLocation){
            let location = touch.location(in: rectView)
            clickedRect = .rect
            
            if rectCorner0.frame.contains(location) { return 0 }
            else if rectCorner1.frame.contains(location) { return 1 }
        }
        else if ovalCheckView.frame.contains(superLocation) {
            let location = touch.location(in: ovalView)
            clickedRect = .oval
            
            if ovalCorner0.frame.contains(location) { return 0 }
            else if ovalCorner1.frame.contains(location) { return 1 }
        }
        else if roundedRectCheckView.frame.contains(superLocation) {
            let location = touch.location(in: roundedRectView)
            clickedRect = .roundedRect
            
            if roundedRectCorner0.frame.contains(location) { return 0 }
            else if roundedRectCorner1.frame.contains(location) { return 1 }
            else if roundedRectRadiusCorner.frame.contains(location) { return 2 }
        }
        return .max
    }
    
    func changeCornerCenter(_ location: CGPoint) {
        let cornerNum = clickedRect == .rect ? rectView.cornerNum : (clickedRect == .oval ? ovalView.cornerNum : roundedRectView.cornerNum)
        
        switch clickedRect {
        case .empty:
            fatalError("type is incorrect!")
            
        case .rect:
            if cornerNum == 0 { rectCorner0.center = location }
            else { rectCorner1.center = location }
            
        case .oval:
            if cornerNum == 0 { ovalCorner0.center = location }
            else { ovalCorner1.center = location }
            
        case .roundedRect:
            if cornerNum == 0 { roundedRectCorner0.center = location }
            else if cornerNum == 1 { roundedRectCorner1.center = location }
            else { roundedRectRadiusCorner.center = location }
        }
        setEmptyCorners()
    }
}
