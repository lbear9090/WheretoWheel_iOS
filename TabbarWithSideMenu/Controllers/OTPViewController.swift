
import UIKit
import Alamofire

class OTPViewController: UIViewController {
    
    
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var txtOTP: UITextField!
    
    var emailStr:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAllMethods()
    }
    
    func loadAllMethods(){
           
           txtOTP.layer.borderColor = UIColor.blue.cgColor
           txtOTP.layer.borderWidth = 1.0
           btnSubmit.layer.cornerRadius = btnSubmit.frame.size.height/2
           setPadding(textfied: txtOTP)
        setToolBar()
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
           txtOTP.inputAccessoryView = numberToolbar
         
           
       }
       
       @objc func doneWithNumberPad() {
           
           
           self.view.endEditing(true)
           
       }
    
       
    
    func otpveryfyApiCall(){
        
        let url = "https://wheretowheel.us/api/user/otp_verify"
        let parameters: Parameters = ["email": self.emailStr,"otp": String(describing: self.txtOTP!.text!)]
        //print(parameters)
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            if response.value != nil {
                
                let responseData = response.value as! NSDictionary
                let status = responseData.value(forKey: "status") as! Int
                
                if(status == 1){
                    
                    
                    /*let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                    self.navigationController?.pushViewController(vc!, animated: true)*/
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangePassViewController") as? ChangePassViewController
                    vc?.emailStr = self.emailStr
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                    
                }
            }
            
        }
        
        
    }
    
    
    @IBAction func onClickBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        
        
        otpveryfyApiCall()
        
    }
    
    

}
