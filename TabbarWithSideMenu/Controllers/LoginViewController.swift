import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import Alamofire
import Sentry
import AuthenticationServices
import CryptoKit

class LoginViewController: UIViewController,GIDSignInDelegate {
    

    fileprivate var currentNonce: String?
    
    @IBOutlet weak var viewApple: UIView!
    
    @IBOutlet weak var viewGoogle: UIView!
    @IBOutlet weak var lblWhereToWheel: UILabel!
    @IBOutlet weak var lblWelcomeTo: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblPleaseWait: UILabel!
    @IBOutlet weak var viewPleaseWait: UIView!
    @IBOutlet weak var viewSpinner: UIView!
    
    var spinner = JTMaterialSpinner()
   // var userDP = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        loadAllMethods()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnNavigateToMainTapped(_ sender: UIButton) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.SelectedIndex = 0
            appDelegate.makeRootViewController()
        }
    }
    
    func loadAllMethods(){
        
        setRadius()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        setPadding(textfied: txtEmail)
        setPadding(textfied: txtPass)
        setToolBar()
        setUpSignInAppleButton()
    }
    
    func setPadding(textfied : UITextField){
        
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textfied.frame.height))
        textfied.leftView = paddingView
        textfied.leftViewMode = UITextField.ViewMode.always
        
    }
    
    func setUpSignInAppleButton() {
      let authorizationButton = ASAuthorizationAppleIDButton()
      authorizationButton.addTarget(self, action: #selector(onClickAppleButton), for: .touchUpInside)
//      authorizationButton.cornerRadius = 10
      //Add button on some view or stack
        authorizationButton.frame = CGRect(x: 0, y: 0, width: viewApple.frame.size.width, height: viewApple.frame.size.height)
        viewApple.addSubview(authorizationButton)
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
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            
          //  spinner.endRefreshing()
//            self.viewSpinner.isHidden = true
            
        }
        
    }
    
    func setToolBar(){
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
//        UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtEmail.inputAccessoryView = numberToolbar
        txtPass.inputAccessoryView = numberToolbar
        
    }
    
    @objc func doneWithNumberPad() {
        self.view.endEditing(true)
    }
    
    func simpleLoginApi(){
        
        let url = "https://wheretowheel.us/api/user/user_login"
        let parameters: Parameters = ["email": txtEmail.text!, "password": txtPass.text!, "user_type": "1"]

            AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            
            if response.value != nil {
                
                let responseData = response.value as! NSDictionary
                
                let res = responseData.mutableCopy() as! NSMutableDictionary
                let resDic = self.removeNullFromDict(dict: res)
                
                let status = resDic.value(forKey: "status") as! Int
                
                if(status == 1){
                    
                    UserDefaults.standard.set(resDic.value(forKey: "username"), forKey: "username")
                    UserDefaults.standard.set(resDic.value(forKey: "user_id"), forKey: "userid")
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    self.spinner.endRefreshing()
                    self.viewSpinner.isHidden = true
                    self.showAlertWith(title: "Success", message: "Login Successfull...")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                           
                        self.dismiss(animated: true, completion: nil)
                        let appdelegate = UIApplication.shared.delegate as? AppDelegate
                        appdelegate?.makeRootViewController()
                    }
                     //self.showToast(message: "Loging Successfully")
                  //  let appdelegate = UIApplication.shared.delegate as? AppDelegate
                  //  appdelegate?.makeRootViewController()4
                }else{
                    
                    self.spinner.endRefreshing()
                    self.viewSpinner.isHidden = true
                    let alertController = UIAlertController(title: "Login Error", message: "Incorrect Email or Password", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
        
                }
            
            }
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
    
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Login Successful.")
                
                
                let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
                // let fullName = user.profile.name
                let email = user.profile.email
                let id = user.userID
                let name = user.profile.name
                if user.profile.hasImage {
                    
                    let thumbSize = CGSize(width: 500, height: 500)
                    let dimension = Int(round(Double(thumbSize.width * UIScreen.main.scale)))
                    let imageURL = user.profile.imageURL(withDimension: UInt(dimension))
                   

                    if let imageURL = imageURL {
                        
                        UserDefaults.standard.set("\(imageURL)", forKey: "loginuserimage")
                    }
               
                   
                } else {
                    // self.sampleImageView.image = UIImage(named: “default-profile”)
                }
                
                
                let url = "https://wheretowheel.us/api/user/user_login"
                let parameters: Parameters = ["email": email!, "google_id": id!, "user_type": 3, "user_name": name!]
                self.loadLoader()
                
                AF.request(url, method: .post, parameters: parameters).responseJSON { response in
                    
                    if response.value != nil {
                        
                        let responseData = response.value as! NSDictionary
                        
                        let res = responseData.mutableCopy() as! NSMutableDictionary
                        let resDic = self.removeNullFromDict(dict: res)
                        
                        let status = resDic.value(forKey: "status") as! Int
                        
                        if(status == 1){
                            
                            UserDefaults.standard.set(user.profile.name, forKey: "username")
                            UserDefaults.standard.set(resDic.value(forKey: "user_id"), forKey: "userid")
                            self.spinner.endRefreshing()
                            self.viewSpinner.isHidden = true
                            UserDefaults.standard.set(true, forKey: "isLogin")
                            let appdelegate = UIApplication.shared.delegate as? AppDelegate
                            appdelegate?.makeRootViewController()
        
                        }
                    }
                }
            }
            
        }
        
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func setRadius(){
        
        txtEmail.layer.borderColor = UIColor.blue.cgColor
        txtEmail.layer.borderWidth = 1.0
        
        txtPass.layer.borderColor = UIColor.blue.cgColor
        txtPass.layer.borderWidth = 1.0
        
        btnLogin.layer.cornerRadius = btnLogin.frame.size.height/2
        btnCreateAccount.layer.cornerRadius = btnCreateAccount.frame.size.height/2
        
        
//        viewApple.layer.cornerRadius = viewApple.frame.size.width/2
        viewGoogle.layer.cornerRadius = viewApple.frame.size.width/2
        
//        viewApple.layer.borderColor = UIColor.blue.cgColor
//        viewApple.layer.borderWidth = 1.0
        
        viewGoogle.layer.borderColor = UIColor.blue.cgColor
        viewGoogle.layer.borderWidth = 1.0
        
        
    }

    @IBAction func onClickCreateNewAccount(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
            self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func onClickLogin(_ sender: Any) {
        SentrySDK.capture(message: "My first test message")
        loadLoader()
        simpleLoginApi()
        
    }
    
    @objc func onClickAppleButton() {
        let nonce = randomNonceString()
          currentNonce = nonce
          let appleIDProvider = ASAuthorizationAppleIDProvider()
          let request = appleIDProvider.createRequest()
          request.requestedScopes = [.fullName, .email]
          request.nonce = sha256(nonce)

          let authorizationController = ASAuthorizationController(authorizationRequests: [request])
          authorizationController.delegate = self
          authorizationController.performRequests()
    }
    
    @IBAction func onClickFBButton(_ sender: Any) {
        
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
              
                if let currentUser = Auth.auth().currentUser {
                    
                    self.loadLoader()
                    let email = currentUser.email
                    let id = currentUser.uid
                    let name = currentUser.displayName
                    let url = "https://wheretowheel.us/api/user/user_login"
                    let parameters: Parameters = ["email": email!, "fb_id": id, "user_type": 2, "user_name": name!]

                        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
                        
                        if response.value != nil {
                            
                            let responseData = response.value as! NSDictionary
                            
                            let res = responseData.mutableCopy() as! NSMutableDictionary
                            let resDic = self.removeNullFromDict(dict: res)
                            
                            let status = resDic.value(forKey: "status") as! Int
                            let imageProfile : URL = currentUser.photoURL!
                            print(imageProfile as Any)
                            if(status == 1){
                                
                                UserDefaults.standard.set(currentUser.displayName, forKey: "username")
                                UserDefaults.standard.set(resDic.value(forKey: "user_id"), forKey: "userid")
                                UserDefaults.standard.set("\(imageProfile)", forKey: "loginuserimage")
                                self.spinner.endRefreshing()
                                self.viewSpinner.isHidden = true
                                UserDefaults.standard.set(true, forKey: "isLogin")
                                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                                appdelegate?.makeRootViewController()
                                
                            }
                        
                        }
                    }
                    
                }
            
            })
        }
    }
    
    func removeNullFromDict (dict : NSMutableDictionary) -> NSMutableDictionary
       {
           let dic = dict;

           for (key, value) in dict {

               let val : NSObject = value as! NSObject;
               if(val.isEqual(NSNull()))
               {
                   dic.setValue("", forKey: (key as? String)!)
               }
               else
               {
                   dic.setValue(value, forKey: key as! String)
               }

           }

           return dic;
       }
    
    
    @IBAction func onClickGoogleButton(_ sender: Any) {
        
        
         GIDSignIn.sharedInstance().signIn()
        
    }
    
    @IBAction func onClickForgot(_ sender: Any) {
           
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPassViewController") as? ForgotPassViewController
        self.navigationController?.pushViewController(vc!, animated: true)
           
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height/2-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
            
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
                              appdelegate?.makeRootViewController()
        })
    }
}


extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension LoginViewController : ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                // User is signed in to Firebase with Apple.
                
                if let currentUser = Auth.auth().currentUser {
                    
                    self.loadLoader()
                    let email = currentUser.email
                    let id = currentUser.uid
                    var name: String
                    if currentUser.displayName != nil{
                        name = currentUser.displayName!
                    }else{
                        name = currentUser.email!
                    }
                    
                    let url = "https://wheretowheel.us/api/user/user_login"
                    let parameters: Parameters = ["email": email!, "fb_id": id, "user_type": 2, "user_name": name]

                        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
                        
                        if response.value != nil {
                            
                            let responseData = response.value as! NSDictionary
                            
                            let res = responseData.mutableCopy() as! NSMutableDictionary
                            let resDic = self.removeNullFromDict(dict: res)
                            
                            let status = resDic.value(forKey: "status") as! Int
//                            let imageProfile : URL = currentUser.photoURL!
//                            print(imageProfile as Any)
                            if(status == 1){
                                
                                UserDefaults.standard.set(currentUser.displayName, forKey: "username")
                                UserDefaults.standard.set(resDic.value(forKey: "user_id"), forKey: "userid")
//                                UserDefaults.standard.set("\(imageProfile)", forKey: "loginuserimage")
                                self.spinner.endRefreshing()
                                self.viewSpinner.isHidden = true
                                UserDefaults.standard.set(true, forKey: "isLogin")
                                let appdelegate = UIApplication.shared.delegate as? AppDelegate
                                appdelegate?.makeRootViewController()
                                
                            }
                        
                        }
                    }
                    
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension LoginViewController {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

