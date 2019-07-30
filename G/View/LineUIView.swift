import UIKit

protocol LineUIViewDelegate {
    func cornerNum(_ location: CGPoint) -> Int
    func changeCornerCenter(_ location: CGPoint)
}

enum DrawingOption {
    case singlePathConstructed
    case singlePathAddLines
    case multiplePaths
    case segments
}

class LineUIView: UIView {
    
    var context: CGContext!
    var points: [CGPoint] = []
    
    var drawingState: DrawingOption = .singlePathConstructed
    var lineWidth: CGFloat = 5
    var miterLimit: CGFloat = 5
    var contextAlpha: CGFloat = 1
    var lineJoin: Int = 0 //0: miter, 1: round, 2: bevel
    var lineCap: Int = 0 //0: butt, 1: round, 2: square
    var pattern: [CGFloat] = [12, 8, 6, 14, 16, 7]
    var phase: CGFloat = 0
    var lineDashAvailable: Bool = false
    
    var cornerNum: Int = .max
    var delegate: LineUIViewDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func customInit() {
        let bound = self.bounds
        points.append(CGPoint(x: 30, y: bound.height / 6 * 5))
        points.append(CGPoint(x: bound.width / 2 + 15, y: 15))
        points.append(CGPoint(x: bound.width / 5 * 4 + 15, y: bound.height / 5 * 3))
        points.append(CGPoint(x: bound.width / 3 * 1 + 15, y: bound.height / 5 * 4))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        context = self.currentContext
        setContextParameters()
        
        drawLines()
    }
    
    func setContextParameters() {
        context.setLineWidth(lineWidth)
        context.setMiterLimit(miterLimit)
        context.setAlpha(contextAlpha)
        
        if lineDashAvailable {
            context.setLineDash(phase: phase, lengths: pattern)
        }
        
        switch lineJoin {
        case 0:
            context.setLineJoin(.miter)
        case 1:
            context.setLineJoin(.round)
        case 2:
            context.setLineJoin(.bevel)
        default:
            print("invalid lineJoin value!")
        }
        
        switch lineCap {
        case 0:
            context.setLineCap(.butt)
        case 1:
            context.setLineCap(.round)
        case 2:
            context.setLineCap(.square)
        default:
            print("invalid lineCap value!")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        cornerNum = delegate.cornerNum(location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if cornerNum == .max { return }
        
        points[cornerNum] = location
        delegate.changeCornerCenter(location)
        
        setNeedsDisplay()
    }
    
    func drawLines() {
        switch drawingState {
        case .singlePathConstructed:
            let path = CGMutablePath()
            path.move(to: points[0])
            for i in 1 ..< points.count {
                path.addLine(to: points[i])
            }
            context.addPath(path)
            context.strokePath()
            
        case .singlePathAddLines:
            let path = CGMutablePath()
            path.addLines(between: points)
            context.addPath(path)
            context.strokePath()
            
        case .multiplePaths:
            for i in 0 ..< points.count - 1 {
                let path = CGMutablePath()
                path.move(to: points[i])
                path.addLine(to: points[i+1])
                context.addPath(path)
                context.strokePath()
            }
            
        case .segments:
            var newPoints: [CGPoint] = []
            for i in points {
                newPoints.append(i)
            }
            newPoints.insert(newPoints[1], at: 1)
            newPoints.insert(newPoints[3], at: 3)
            context.strokeLineSegments(between: newPoints)
        }
    }

}
