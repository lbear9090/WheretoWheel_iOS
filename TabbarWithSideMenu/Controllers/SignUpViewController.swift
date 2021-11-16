
import UIKit
import Alamofire

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblWhereToWheel: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblPleaseWait: UILabel!
    @IBOutlet weak var viewPleaseWait: UIView!
    @IBOutlet weak var viewSpinner: UIView!
    
    var spinner = JTMaterialSpinner()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadAllMethods()
        
    }
    
    func loadAllMethods(){
        txtEmail.layer.borderColor = UIColor.blue.cgColor
        txtEmail.layer.borderWidth = 1.0
        txtName.layer.borderColor = UIColor.blue.cgColor
        txtName.layer.borderWidth = 1.0
        txtPassword.layer.borderColor = UIColor.blue.cgColor
        txtPassword.layer.borderWidth = 1.0
        btnSignUp.layer.cornerRadius = btnSignUp.frame.size.height/2
        setPadding(textfied: txtEmail)
        setToolBar()
        setPadding(textfied: txtName)
        setPadding(textfied: txtPassword)
    }
    
    func loadLoader(){
        viewSpinner.isHidden = false
        spinner = JTMaterialSpinner()
        
        viewPleaseWait.layer.cornerRadius = 5.0
        viewPleaseWait.addSubview(spinner)
        
        spinner.frame = CGRect(x: 25, y: 45, width: 40, height: 40)
        
        spinner.circleLayer.lineWidth = 3.0;
        spinner.circleLayer.strokeColor = UIColor.blue.cgColor;
        spinner.beginRefreshing()
        
        
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
           txtPassword.inputAccessoryView = numberToolbar
           txtName.inputAccessoryView = numberToolbar
         
           
       }
       
       @objc func doneWithNumberPad() {
           
           
           self.view.endEditing(true)
           
       }
    
    
    func createNewAccountApiCall(){
        
        loadLoader()
        
        let url = "https://wheretowheel.us/api/user/registration"
        let parameters: Parameters = ["username": txtName.text!, "email": txtEmail.text!, "password": txtPassword.text!]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            
            if response.value != nil {
                
                let responseData = response.value as! NSDictionary
                let res = responseData.value(forKey: "response") as! NSDictionary
                let status = res.value(forKey: "status") as! Int
                
               // DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    
                     self.spinner.endRefreshing()
                     self.viewSpinner.isHidden = true
                    
                //}
                
                if(status == 1){
                    
                     self.showAlertWith1(title: "Success", message: "Create Account Successfully...")
                    

                     DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                     
                        self.dismiss(animated: true, completion: nil)
                        
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                }
            }
        }
        
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
        
        if(txtName.text == ""){
            
            showAlertWith(title: "Name", message: "Please Enter Name")
            
        }else if(txtEmail.text == ""){
            
            showAlertWith(title: "Email", message: "Please Enter Email")
            
        }else if(txtPassword.text == ""){
            
            showAlertWith(title: "Password", message: "Please Enter Password")
            
        }else if (!isValidEmail(txtEmail.text!)){
            
            showAlertWith(title: "Email", message: "Please Enter Valid Email address")
            
        }else{
              createNewAccountApiCall()
        }
        
      
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
          
          let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
          let action = UIAlertAction(title: "Ok", style: .default) { (action) in
              self.dismiss(animated: true, completion: nil)
          }
          alertController.addAction(action)
          self.present(alertController, animated: true, completion: nil)
      }
    
    func showAlertWith1(title: String, message: String, style: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        /*let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)*/
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
