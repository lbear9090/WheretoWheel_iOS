
import UIKit
import Alamofire

class ContactUsViewController: UIViewController {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

          self.navigationController?.navigationBar.isHidden = true
          loadAllMethods()
    }
    
    func loadAllMethods(){
        
        btnSubmit.layer.cornerRadius = btnSubmit.frame.size.height/2
        setToolBar()
        setPadding(textfied: txtSubject)
        setPadding(textfied: txtName)
        setPadding(textfied: txtMessage)
        setPadding(textfied: txtEmail)
        
    }
    
    func setPadding(textfied : UITextField){
        
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textfied.frame.height))
        textfied.leftView = paddingView
        textfied.leftViewMode = UITextField.ViewMode.always
        
    }
    
    func setToolBar(){
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            // UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        
        numberToolbar.sizeToFit()
        txtName.inputAccessoryView = numberToolbar
        txtEmail.inputAccessoryView = numberToolbar
        txtMessage.inputAccessoryView = numberToolbar
        txtSubject.inputAccessoryView = numberToolbar

    }
    
    @objc func doneWithNumberPad() {

        self.view.endEditing(true)
        
    }
    
    func contactAPI(){
        
        let url = "https://wheretowheel.us/api/hotels/contact_us?name=\(txtName.text!)&email=\(txtEmail.text!)&contact_no=\(txtSubject.text!)&msg=\(txtMessage.text!)"
        
        
        AF.request(url, method: .post, parameters: [:]).responseJSON { response in
            
            
            if response.value != nil {
                
                let responseData = response.value as! NSDictionary
                let res = responseData.value(forKey: "response") as! NSDictionary
                let status = res.value(forKey: "status") as! Int
                
                if(status == 1){
                    
                    let appdelegate = UIApplication.shared.delegate as? AppDelegate
                    appdelegate?.makeRootViewController()
                    
                }
            
            }
        }
    }
    
    @IBAction func onCLickSubmit(_ sender: Any) {
        
        contactAPI()
        
    }
    
    @IBAction func onCLickBack(_ sender: Any) {
    
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.makeRootViewController()
        
    }
    
}
