import UIKit

protocol AllPartsUIViewDelegate {
    func cornerNum(_ touch: UITouch) -> Int
    func changeCornerCenter(_ location: CGPoint)
}

class AllPartsUIView: UIView {
    
    var context: CGContext!
    var points: [CGPoint] = []
    
    var cornerNum: Int = .max
    var delegate: AllPartsUIViewDelegate!
    
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
    }
    
    func appendPoints() {
        let width = self.bounds.width
        let height = self.bounds.height
        
        points.append(CGPoint(x: width * 0.5625, y: height * 0.1245)) //starting move to point          0
        points.append(CGPoint(x: width * 0.4375, y: height * 0.249)) //left line to point               1
        points.append(CGPoint(x: width * 0.1875, y: height * 0.332)) //relative arc to center           2
        points.append(CGPoint(x: width * 0.125, y: height * 0.747)) //curve to end point                3
        points.append(CGPoint(x: width * 0.1875, y: height * 0.498)) //curve to control point 1         4
        points.append(CGPoint(x: width * 0.0625, y: height * 0.664)) //curve to control point 2         5
        points.append(CGPoint(x: width * 0.625, y: height * 0.83)) //quad curve to end point            6
        points.append(CGPoint(x: width * 0.375, y: height * 0.7055)) //quad curve to control point      7
        points.append(CGPoint(x: width * 0.75, y: height * 0.664)) //right bottom line to point         8
        points.append(CGPoint(x: width * 0.875, y: height * 0.7055)) //arc to control point 1           9
        points.append(CGPoint(x: width * 0.625, y: height * 0.498)) //arc to control point 2            10
        points.append(CGPoint(x: width * 0.8125, y: height * 0.249)) //right top line to point          11
        points.append(CGPoint(x: width * 0.6875, y: height * 0.166)) //arc center point                 12
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        context = self.currentContext
        
        let path = CGMutablePath()
        
        path.move(to: points[0])
        path.addLine(to: points[1])
        path.addRelativeArc(center: points[2], radius: 30, startAngle: -1.57, delta: -3.14)
        path.addCurve(to: points[3], control1: points[4], control2: points[5])
        path.addQuadCurve(to: points[6], control: points[7])
        path.addLine(to: points[8])
        path.addArc(tangent1End: points[9], tangent2End: points[10], radius: 30)
        path.addLine(to: points[11])
        path.addArc(center: points[12], radius: 30, startAngle: 0, endAngle: -3.14, clockwise: true)
        path.closeSubpath()
        
        context.addPath(path)
        context.strokePath()
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
