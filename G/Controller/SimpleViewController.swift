import UIKit

class SimpleViewController: UIViewController {
    
    
    @IBOutlet weak var simpleUIView: SimpleUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        simpleUIView.center = self.view.center
        
        simpleUIView.setNeedsDisplay()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stateSwitch(_ sender: UISwitch) {
        if simpleUIView.isSloppy {
            simpleUIView.isSloppy = false
        } else {
            simpleUIView.isSloppy = true
        }
        
        simpleUIView.setNeedsDisplay()
    }
}
