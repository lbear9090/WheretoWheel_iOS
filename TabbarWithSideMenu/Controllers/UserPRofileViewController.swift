import UIKit
import Alamofire
import SDWebImage

class UserPRofileViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    @IBOutlet weak var imgProfile: SDAnimatedImageView!
    
    @IBOutlet weak var btnChangePass: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtNAme: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    var dictData = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        getUserProfileDta()
        loadAllMethods()
       
        
    }
    
    func loadAllMethods(){
        
        btnSave.layer.cornerRadius = btnSave.frame.size.height/2
        btnChangePass.layer.cornerRadius = btnChangePass.frame.size.height/2
        txtNAme.layer.cornerRadius = txtNAme.frame.size.height/2
        txtEmail.layer.cornerRadius = txtEmail.frame.size.height/2
        txtUserName.layer.cornerRadius = txtUserName.frame.size.height/2
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width/2
        setPadding(textfied: txtUserName)
        setPadding(textfied: txtNAme)
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
        txtUserName.inputAccessoryView = numberToolbar
        txtEmail.inputAccessoryView = numberToolbar
        txtNAme.inputAccessoryView = numberToolbar
        
    }
    
    @objc func doneWithNumberPad() {
        
        
        self.view.endEditing(true)
        
    }
    
    func getUserProfileDta(){
        
        let userid = UserDefaults.standard.value(forKey: "userid") as! String
        let url = "https://wheretowheel.us/api/user/user_account?user_id=\(userid)"
        
        AF.request(url, method: .post, parameters: [:]).responseJSON { response in
            
            
            if response.value != nil {
                
                let responseData = response.value as! NSDictionary
                
              
                
                let rsDic = responseData.mutableCopy() as! NSMutableDictionary
                let resDic = self.removeNullFromDict(dict: rsDic)
                
                
                self.dictData = resDic.value(forKey: "response") as! NSDictionary
                self.setUserProfileData()
                
            }
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
    
    func setUserProfileData(){
    
        let name = UserDefaults.standard.value(forKey: "username") as! String
        
        if(dictData.value(forKey: "username") as! String == ""){
            
            
            txtUserName.text = name
            txtNAme.text = name
            txtEmail.text = (dictData.value(forKey: "email") as! String)
            
        }else{
            
            
            txtUserName.text = (dictData.value(forKey: "username") as! String)
            txtNAme.text = (dictData.value(forKey: "name") as! String)
            txtEmail.text = (dictData.value(forKey: "email") as! String)
            
        }
        
        
           var placeholderImage: UIImage? = nil
            if placeholderImage == nil {
                placeholderImage = UIImage(named: "placeholder")
            }
            
           
            
        let imgurl = UserDefaults.standard.object(forKey: "loginuserimage") as? String ?? ""
        
        let url : NSString = imgurl as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        
        weak var imageView = imgProfile
        
        imageView?.sd_setImage(with: searchURL as URL, placeholderImage: placeholderImage, options:  0 == 0 ? SDWebImageOptions(rawValue: SDWebImageOptions.RawValue(Int(1 << 3))) : [], context: [
            SDWebImageContextOption.imageThumbnailPixelSize: CGSize(width: 280, height: 240)
            ], progress: nil, completed: { image, error, cacheType, imageURL in
                
                let operation = imageView?.sd_imageLoadOperation(forKey: imageView?.sd_latestOperationKey) as? SDWebImageCombinedOperation
                let token = operation?.loaderOperation as? SDWebImageDownloadToken
                if #available(iOS 10.0, *) {
                    let metrics = token?.metrics
                    if metrics != nil {
                        if let c = (imageURL!.absoluteString as NSString).cString(using: String.Encoding.utf8.rawValue), let duration = metrics?.taskInterval.duration {
                            print("Metrics: \(c) download in (\(duration)) seconds\n")
                        }
                    }
                }
        })
        
    
    }
    
    func changeMainViewController(to viewController: UIViewController) {
       
        let navigationViewController = UINavigationController(rootViewController: viewController)
        slideMenuController()?.changeMainViewController(navigationViewController, close: true)
    }
    
    
    func updateProfileAPI(){
        
        let userid = UserDefaults.standard.value(forKey: "userid") as! String
        let url = "https://wheretowheel.us/api/user/user_update"
        let parameters: Parameters = ["username": txtUserName.text!, "email": txtEmail.text!, "name": txtNAme.text!, "user_id": userid]
               
               AF.request(url, method: .post, parameters: parameters).responseJSON { response in
                   
                   
                   if response.value != nil {
                       
                       let responseData = response.value as! NSDictionary
                       let dictTemp = responseData.value(forKey: "response") as! NSDictionary
                      
                       let status = dictTemp.value(forKey: "status") as! Int
                       
                    if(status == 1){
                        
                        
                        
                        let appdelegate = UIApplication.shared.delegate as? AppDelegate
                        appdelegate?.makeRootViewController()
                        
                        
                    }
                    
                       
                   }
               }
    }
    
    @IBAction func onClickChangePass(_ sender: Any) {
    
        guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "ChangePassViewController") as? ChangePassViewController else {
                  return
            }
        tabViewController.emailStr = self.txtEmail!.text!
        changeMainViewController(to: tabViewController)
        
        
    }
    @IBAction func onClickSave(_ sender: Any) {
        
        
        updateProfileAPI()
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        
        
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.makeRootViewController()

    }
    
     @IBAction func onClickEditImage(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")

            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
  /*  func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
        
        
    } */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if #available(iOS 11.0, *) {
            let imageURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.imageURL)] as! URL
            UserDefaults.standard.set("\(imageURL)", forKey: "loginuserimage")
            setUserProfileData()
        } else {
            // Fallback on earlier versions
        }
        
        self.dismiss(animated: true, completion: nil);
       
    }
    
    
    
}
    
    


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
