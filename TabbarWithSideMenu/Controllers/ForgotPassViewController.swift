
import UIKit
import Alamofire


class ForgotPassViewController: UIViewController {
    
    
    @IBOutlet weak var lblWelcome: UILabel!
    
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblWhereToWheel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAllMethods()
    }
    
    func loadAllMethods(){
        
        txtEmail.layer.borderColor = UIColor.blue.cgColor
        txtEmail.layer.borderWidth = 1.0
        btnForgot.layer.cornerRadius = btnForgot.frame.size.height/2
        setPadding(textfied: txtEmail)
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
           txtEmail.inputAccessoryView = numberToolbar
         
           
       }
       
       @objc func doneWithNumberPad() {
           
           
           self.view.endEditing(true)
           
       }
    
    
    func callForgotAPI(){
        
        
        let url = "https://wheretowheel.us/api/user/forgot_password"
        let parameters: Parameters = ["email": txtEmail.text!]

               AF.request(url, method: .post, parameters: parameters).responseJSON { response in
               print(response)
                if response.value != nil {
                    
                    let responseData = response.value as! NSDictionary
                    let status = responseData.value(forKey: "status") as! Int
                    
                    if(status == 1){
                        
                      self.showAlertWith(title: "Success", message: responseData.value(forKey: "message") as! String)
                        
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                            self.dismiss(animated: true, completion: nil)
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController
                        vc?.emailStr = String(describing: self.txtEmail!.text!)
                        self.navigationController?.pushViewController(vc!, animated: true)
                       }

                    }
                }
                
           }
        
        
    }

    @IBAction func onClickForgot(_ sender: Any) {
        
        if(txtEmail.text == ""){
            
            showAlertWith(title: "Email", message: "Please Enter Email")
        }else if !isValidEmail(txtEmail.text!){
            
            showAlertWith(title: "Email", message: "Please Enter Valid Email address")
        }else{
            
            callForgotAPI()
        }
    
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
      /*  let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }*/
       // alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func onClickback(_ sender: Any) {
           
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    

}
