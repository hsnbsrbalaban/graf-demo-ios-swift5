import UIKit

class LineViewController: UIViewController {
    
    @IBOutlet weak var lineUIView: LineUIView!
    @IBOutlet weak var corner0: UIView!
    @IBOutlet weak var corner1: UIView!
    @IBOutlet weak var corner2: UIView!
    @IBOutlet weak var corner3: UIView!
    
    @IBOutlet weak var lineCapDropDown: DropDown!
    @IBOutlet weak var lineJoinDropDown: DropDown!
    @IBOutlet weak var lineCreationDropDown: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        corner0.center = lineUIView.points[0]
        corner1.center = lineUIView.points[1]
        corner2.center = lineUIView.points[2]
        corner3.center = lineUIView.points[3]
        
        initializeDropDowns()
        
        lineUIView.delegate = self
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lineWidthSlider(_ sender: UISlider) {
        lineUIView.lineWidth = CGFloat(sender.value)
        lineUIView.setNeedsDisplay()
    }
    
    @IBAction func miterLimitSlider(_ sender: UISlider) {
        lineUIView.miterLimit = CGFloat(sender.value)
        lineUIView.setNeedsDisplay()
    }
    
    @IBAction func alphaSlider(_ sender: UISlider) {
        lineUIView.contextAlpha = CGFloat(sender.value)
        lineUIView.setNeedsDisplay()
    }
    
    @IBAction func linePhaseCheckButton(_ sender: CheckBox) {
        lineUIView.lineDashAvailable = lineUIView.lineDashAvailable ? false : true
        lineUIView.setNeedsDisplay()
    }
    
    
    @IBAction func secondPageSliderHandler(_ sender: UISlider) {
        switch sender.tag {
        case 0:
            lineUIView.phase = CGFloat(sender.value)
        case 1:
            lineUIView.pattern[0] = CGFloat(sender.value)
        case 2:
            lineUIView.pattern[1] = CGFloat(sender.value)
        case 3:
            lineUIView.pattern[2] = CGFloat(sender.value)
        case 4:
            lineUIView.pattern[3] = CGFloat(sender.value)
        case 5:
            lineUIView.pattern[4] = CGFloat(sender.value)
        case 6:
            lineUIView.pattern[5] = CGFloat(sender.value)
        default:
            print("invalid sender tag in secondPageSliderHandler!")
        }
        lineUIView.setNeedsDisplay()
    }
    
    func initializeDropDowns() {
        lineCapDropDown.optionArray = ["Butt Cap", "Round Cap", "Square Cap"]
        lineJoinDropDown.optionArray = ["Miter Join", "Round Join", "Bevel Join"]
        lineCreationDropDown.optionArray = ["Single Path (Constructed)", "Single Path (Add lines)",
                                            "Multiple Paths", "Segments"]
        
        lineCapDropDown.selectedIndex = 0
        lineJoinDropDown.selectedIndex = 0
        lineCreationDropDown.selectedIndex = 0
        
        lineCapDropDown.didSelect { (text, index, id) in
            self.lineUIView.lineCap = index
            self.lineUIView.setNeedsDisplay()
        }
        
        lineJoinDropDown.didSelect { (text, index, id) in
            self.lineUIView.lineJoin = index
            self.lineUIView.setNeedsDisplay()
        }
        
        lineCreationDropDown.didSelect { (text, index, id) in
            switch index {
            case 0:
                self.lineUIView.drawingState = .singlePathConstructed
            case 1:
                self.lineUIView.drawingState = .singlePathAddLines
            case 2:
                self.lineUIView.drawingState = .multiplePaths
            case 3:
                self.lineUIView.drawingState = .segments
            default:
                print("invalid lineCreationDropDownSelect")
            }
            self.lineUIView.setNeedsDisplay()
        }
    }
    
}

extension LineViewController: LineUIViewDelegate {
    func cornerNum(_ location: CGPoint) -> Int {
        if corner0.frame.contains(location) { return 0}
        if corner1.frame.contains(location) { return 1}
        if corner2.frame.contains(location) { return 2}
        if corner3.frame.contains(location) { return 3}
        
        return .max
    }
    
    func changeCornerCenter(_ location: CGPoint) {
        let cornerNum = lineUIView.cornerNum
        switch cornerNum {
        case 0:
            corner0.center = location
        case 1:
            corner1.center = location
        case 2:
            corner2.center = location
        case 3:
            corner3.center = location
        default:
            print("invalid cornerNum!")
        }
    }
}
