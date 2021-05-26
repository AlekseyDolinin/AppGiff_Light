import UIKit

class AppTrackingModalViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
    }

    @IBAction func continueAction(_ sender: UIButton) {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name("requestAppTracking"), object: nil)
        }
    }
}
