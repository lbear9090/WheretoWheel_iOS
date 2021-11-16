import UIKit

class TermsConditionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

          self.navigationController?.navigationBar.isHidden = true
        
    }
    
    @IBAction func onCLickBack(_ sender: Any) {
        
     
        
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.makeRootViewController()
        
    }

}
