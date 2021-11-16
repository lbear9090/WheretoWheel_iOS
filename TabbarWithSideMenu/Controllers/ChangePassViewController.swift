
import UIKit
import Alamofire

class ChangePassViewController: UIViewController {
    
    @IBOutlet weak var btnChangePass: UIButton!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    
    var emailStr:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        loadAllMethod()
        
    }
    
    func loadAllMethod(){
        
        btnChangePass.layer.cornerRadius = btnChangePass.frame.size.height/2
        txtPass.layer.cornerRadius = txtPass.frame.size.height/2
        txtConfirmPass.layer.cornerRadius = txtConfirmPass.frame.size.height/2
        
        txtConfirmPass.layer.borderColor = UIColor.blue.cgColor
        txtConfirmPass.layer.borderWidth = 1.0
        
        txtPass.layer.borderColor = UIColor.blue.cgColor
        txtPass.layer.borderWidth = 1.0
        
        setToolBar()
        setPadding(textfied: txtConfirmPass)
        setPadding(textfied: txtPass)
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
        txtConfirmPass.inputAccessoryView = numberToolbar
        txtPass.inputAccessoryView = numberToolbar

    }
    
    @objc func doneWithNumberPad() {

        self.view.endEditing(true)
        
    }
    
    func changeMainViewController(to viewController: UIViewController) {
       
        let navigationViewController = UINavigationController(rootViewController: viewController)
        slideMenuController()?.changeMainViewController(navigationViewController, close: true)
    }
    
    func changePassAPI(){
  
        let url = "https://wheretowheel.us/api/user/change_password"
        let parameters: Parameters = ["new_password": self.txtPass!.text!, "email": self.emailStr]
        print(parameters)
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            
            
            if response.value != nil {
                
                let responseData = response.value as! NSDictionary
                
                let status = responseData.value(forKey: "status") as! Int
                
                if(status == 1){
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            
            }
        }
        
    }
    
    @IBAction func onClickChangePass(_ sender: Any) {
        
        changePassAPI()
        
    }
    @IBAction func onClickBack(_ sender: Any) {
        
        
        guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "UserPRofileViewController") as? UserPRofileViewController else {
            return
        }
        changeMainViewController(to: tabViewController)
        
    }
}
