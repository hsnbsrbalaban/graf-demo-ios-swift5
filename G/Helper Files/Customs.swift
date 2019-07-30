import UIKit

class CustomButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 15
    }
}

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "ic_check_box")! as UIImage
    let uncheckedImage = UIImage(named: "ic_check_box_outline_blank")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}

class CustomScrollView: UIScrollView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if let view = uiControlSubview(at: point), view is UIControl {
            return view
        }
        
        return self
        
    }
}

extension UIView {
    
    var currentContext: CGContext {
        let context = UIGraphicsGetCurrentContext()
        return context!
    }
    
//    ****************************************************************************
    
    func uiControlSubview(at point: CGPoint) -> UIView? {
        var testView: UIView?
        for view in subviews {
            
            if view.frame.contains(point) {
                testView = view
            }
        }
        
        if testView != nil {
            
            if testView is UIControl {
                return testView
            }
            
            if testView?.subviews.isEmpty ?? false {
                return testView
            }
            
            let convertedPoint = convert(point, to: testView)
            
            return testView?.uiControlSubview(at: convertedPoint)
        } else {
            return self
        }
    }
}

extension CGContext {
    func protectState(_ drawStuff: () -> Void) {
        saveGState()
        drawStuff()
        restoreGState()
    }
}
