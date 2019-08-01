import UIKit

protocol PathPartsUIViewTwoDelegate {
    func cornerNum(_ touch: UITouch) -> Int
    func changeCornerCenter(_ location: CGPoint)
}

enum ViewTypeTwo {
    case empty
    case lineTo
    case quadCurve
    case bezierCurve
}

class PathPartsUIViewTwo: UIView {
    
    var context: CGContext!
    var points: [CGPoint] = []
    
    var viewType: ViewTypeTwo = .empty
    
    var cornerNum: Int = .max
    var delegate: PathPartsUIViewTwoDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius  = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius  = 15
    }
    
    func appendPoints() {
        let width = bounds.width
        let height = bounds.height
        
        switch viewType {
        case .lineTo:
            points.append(CGPoint(x: width * 0.2, y: height * 0.8)) // lower left point
            points.append(CGPoint(x: width * 0.5, y: height * 0.2)) // upper middle point
            points.append(CGPoint(x: width * 0.8, y: height * 0.8)) // lower right point
            
        case .quadCurve:
            points.append(CGPoint(x: width * 0.2, y: height * 0.2)) // upper left point
            points.append(CGPoint(x: width * 0.5, y: height * 0.8)) // lower middle point
            points.append(CGPoint(x: width * 0.8, y: height * 0.2)) // control point
            
        case .bezierCurve:
            points.append(CGPoint(x: width * 0.5, y: height * 0.2)) // upper middle point
            points.append(CGPoint(x: width * 0.5, y: height * 0.8)) // lower middle point
            points.append(CGPoint(x: width * 0.8, y: height * 0.5)) // right control point
            points.append(CGPoint(x: width * 0.2, y: height * 0.5)) // left control point
            
        default:
            fatalError("type is empty!")
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        context = self.currentContext
        
        drawLine()
    }
    
    func drawLine() {
        let path = CGMutablePath()
        
        switch viewType {
        case .empty:
            path.addRect(.zero)
            
        case .lineTo:
            path.addLines(between: points)
            
        case .quadCurve:
            path.move(to: points[0])
            path.addQuadCurve(to: points[1], control: points[2])
            
        case .bezierCurve:
            path.move(to: points[0])
            path.addCurve(to: points[1], control1: points[2], control2: points[3])
        }
        
        context.addPath(path)
        context.strokePath()
        
        if viewType == .quadCurve {
            context.protectState {
                let dashPath = CGMutablePath()
                dashPath.move(to: points[0])
                dashPath.addLine(to: points[2])
                dashPath.addLine(to: points[1])
                
                context.setLineDash(phase: 0, lengths: [1, 1])
                context.addPath(dashPath)
                context.strokePath()
            }
        }
        
        if viewType == .bezierCurve {
            context.protectState {
                let dashPath = CGMutablePath()
                dashPath.move(to: points[0])
                dashPath.addLine(to: points[2])
                dashPath.addLine(to: points[3])
                dashPath.addLine(to: points[1])
                
                context.setLineDash(phase: 0, lengths: [1, 1])
                context.addPath(dashPath)
                context.strokePath()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        cornerNum = delegate.cornerNum(touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if cornerNum == .max { return }
        
        points[cornerNum] = location
        delegate.changeCornerCenter(location)
        
        setNeedsDisplay()
    }

}
