import UIKit

protocol PathPartsUIViewOneDelegate {
    func cornerNum(_ touch: UITouch) -> Int
    func changeCornerCenter(_ location: CGPoint)
}

enum ViewTypeOne {
    case empty
    case rect
    case oval
    case roundedRect
}

class PathPartsUIViewOne: UIView {
    
    var context: CGContext!
    var points: [CGPoint] = []
    
    var viewType: ViewTypeOne = .empty
    
    var cornerNum: Int = .max
    var delegate: PathPartsUIViewOneDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func customInit() {
        self.layer.cornerRadius  = 15
        
        let width = bounds.width
        let height = bounds.height
        
        points.append(CGPoint(x: width * 0.2, y: height * 0.2))
        points.append(CGPoint(x: width * 0.8, y: height * 0.8))
        points.append(CGPoint(x: points[0].x + 20, y: points[0].y + 20))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        context = self.currentContext
        
        drawLine()
    }
    
    var controlDistance: CGFloat {
        
        let topLeft = points[0]
        let radiusPoint = points[2]
        
        let xdist = topLeft.x - radiusPoint.x
        let ydist = topLeft.y - radiusPoint.y
        var controlDistance = sqrt(xdist * xdist + ydist * ydist)
        
        let width = points[1].x - points[0].x
        let height = points[1].y - points[0].y
        let rect = CGRect(x: points[0].x, y: points[0].y, width: width, height: height)
        
        controlDistance = min(controlDistance, rect.height * 0.5)
        controlDistance = min(controlDistance, rect.width * 0.5)
        
        return controlDistance
    }
    
    func drawLine() {
        let path = CGMutablePath()
        
        let width = points[1].x - points[0].x
        let height = points[1].y - points[0].y
        let rect = CGRect(x: points[0].x, y: points[0].y, width: width, height: height)
        
        switch viewType {
        case .empty:
            path.addRect(.zero)
            
        case .rect:
            path.addRect(rect)
            
        case .oval:
            path.addEllipse(in: rect)
            
        case .roundedRect:
            path.addRoundedRect(in: rect, cornerWidth: controlDistance, cornerHeight: controlDistance)
        }
        
        context.addPath(path)
        context.strokePath()
        
        if viewType == .oval || viewType == .roundedRect {
            context.protectState {
                let dashPath = CGMutablePath()
                dashPath.addRect(rect)
                
                if viewType == .roundedRect {
                    let radiusLine = CGMutablePath()
                    radiusLine.move(to: points[0])
                    radiusLine.addLine(to: points[2])
                    context.addPath(radiusLine)
                }
                
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

