import UIKit

protocol ArcsUIViewDelegate {
    func cornerNum(_ touch: UITouch) -> Int
    func changeCornerCenter(_ location: CGPoint)
}

enum ArcsViewType {
    case empty
    case arc
    case relativeArc
    case arcToPoint
}

class ArcsUIView: UIView {
    
    var context: CGContext!
    var points: [CGPoint] = []

    var viewType: ArcsViewType = .empty
    
    var cornerNum: Int = .max
    var delegate: ArcsUIViewDelegate!
    
    var startAngle: CGFloat = 3.92
    var endAngle: CGFloat = 5.49
    var clockwise: Bool = false
    
    var delta: CGFloat = 1.57
    
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
        
        if viewType == .arc || viewType == .relativeArc {
            points.append(CGPoint(x: width * 0.1, y: height * 0.5)) //start point
            points.append(CGPoint(x: width * 0.375, y: height * 0.5)) //left-middle blue
            points.append(CGPoint(x: width * 0.5, y: height * 0.5)) //center point - red
            points.append(CGPoint(x: width * 0.5, y: height * 0.5 + width * 0.125)) //radius point
            points.append(CGPoint(x: width * 0.625, y: height * 0.5)) //right-middle blue
            points.append(CGPoint(x: width * 0.9, y: height * 0.5)) //end point
        }
        else if viewType == .arcToPoint {
            points.append(CGPoint(x: width * 0.1, y: height * 0.5)) //start point
            points.append(CGPoint(x: width * 0.375, y: height * 0.5)) //left-middle blue
            points.append(CGPoint(x: width * 0.375, y: height * 0.1)) //control point 0
            points.append(CGPoint(x: width * 0.5, y: height * 0.5 + width * 0.125)) //radius point
            points.append(CGPoint(x: width * 0.625, y: height * 0.5)) //right-middle blue
            points.append(CGPoint(x: width * 0.9, y: height * 0.7)) //control point 1
            points.append(CGPoint(x: width * 0.9, y: height * 0.5)) //end point
        } else {
            fatalError("type is empty!")
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        context = self.currentContext
    
        drawLine()
    }
    
    func drawLine() {
        let path = CGMutablePath ()
        
        if viewType == .arc || viewType == .relativeArc {
            path.move(to: points[0])
            path.addLine(to: points[1])
            
            if viewType == .arc {
                path.addArc(center: points[2], radius: CGFloat(distance(points[2], points[3])),
                            startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
            } else {
                path.addRelativeArc(center: points[2], radius: CGFloat(distance(points[2], points[3])),
                                    startAngle: startAngle, delta: delta)
            }
            
            path.addLine(to: points[4])
            path.addLine(to: points[5])
        }
        else if viewType == .arcToPoint {
            path.move(to: points[0])
            path.addLine(to: points[1])
            
            let center = CGPoint(x: bounds.width / 2 , y: bounds.height / 2)
            path.addArc(tangent1End: points[2], tangent2End: points[5], radius: CGFloat(distance(center, points[3])))
            path.addLine(to: points[4])
            path.addLine(to: points[6])
        } else {
            path.addRect(.zero)
        }
        
        context.addPath(path)
        context.strokePath()
        
        if viewType == .arc || viewType == .relativeArc{
            context.protectState {
                let dist = CGFloat(distance(points[2], points[3])) + 20
                let connectionP1 = CGPoint(x: points[2].x + dist * cos(startAngle),
                                           y: points[2].y + dist * sin(startAngle))
                var connectionP2: CGPoint{
                    if viewType == .arc {
                        return CGPoint(x: points[2].x + dist * cos(endAngle), y: points[2].y + dist * sin(endAngle))
                    } else {
                        return CGPoint(x: points[2].x + dist * cos(startAngle + delta),
                                       y: points[2].y + dist * sin(startAngle + delta))
                    }
                }
                
                let dashPath = CGMutablePath()
                dashPath.move(to: points[2])
                dashPath.addLine(to: connectionP1)
                dashPath.move(to: points[2])
                dashPath.addLine(to: connectionP2)
                
                context.setLineDash(phase: 0, lengths: [2, 2])
                context.addPath(dashPath)
                context.strokePath()}
        }
        
        if viewType == .arcToPoint {
            context.protectState {
                let dashPath = CGMutablePath()
                dashPath.move(to: points[1])
                dashPath.addLine(to: points[2])
                dashPath.addLine(to: points[5])
                dashPath.move(to: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5))
                dashPath.addLine(to: points[3])
                
                context.setLineDash(phase: 0, lengths: [2, 2])
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
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> Float {
        return hypotf(Float(a.x - b.x), Float(a.y - b.y))
    }
    
}
