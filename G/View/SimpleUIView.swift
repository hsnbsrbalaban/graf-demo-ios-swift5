import UIKit

class SimpleUIView: UIView {
    
    var bound: CGRect!
    var context: CGContext!
    var isSloppy: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func customInit() {
        bound = self.bounds
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        context = self.currentContext
        
        if isSloppy {
            drawSloppily()
        } else {
            drawNicely()
        }
    }
    
    func drawSloppily() {
        context.setStrokeColor(UIColor.black.cgColor)
        context.setFillColor(UIColor.white.cgColor)
        context.setLineWidth(3.0)
        
        drawBackground()
        drawContent()
        drawBorder()
    }
    
    func drawNicely() {
        context.setStrokeColor(UIColor.black.cgColor)
        context.setFillColor(UIColor.white.cgColor)
        context.setLineWidth(3.0)
        
        drawBackground()
        drawNiceContent()
        drawBorder()
    }
    
    func drawBackground() {
        context.fill(bound)
    }
    
    func drawBorder() {
        context.stroke(bound)
    }
    
    func drawContent() {
        let innerRect = bound.inset(by: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40))
        
        context.setFillColor(UIColor.green.cgColor)
        context.fillEllipse(in: innerRect)
        
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(6.0)
        context.strokeEllipse(in: innerRect)
    }
    
    func drawNiceContent() {
        let innerRect = bound.inset(by: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40))
        
        context.protectState {
            context.setFillColor(UIColor.green.cgColor)
            context.fillEllipse(in: innerRect)
            
            context.setStrokeColor(UIColor.blue.cgColor)
            context.setLineWidth(6.0)
            context.strokeEllipse(in: innerRect)
        }
    }
}
