import UIKit
import Alamofire
import FSCalendar


class TableBookViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBookNow: UIButton!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtNumberOfGuest: UITextField!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var viewTopCal: UIView!
    @IBOutlet weak var viewMainCal: UIView!
    @IBOutlet weak var viewSelectTime: UIView!
    @IBOutlet weak var btnOkTime: UIButton!
    @IBOutlet weak var btnCancelTime: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var lblPleaseWait: UILabel!
    @IBOutlet weak var viewPleaseWait: UIView!
    @IBOutlet weak var viewSpinner: UIView!
    var spinner = JTMaterialSpinner()
    
    var portalid = ""
    var listid = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        loadAllMethods()
    
    }
    
    func loadAllMethods(){
        
        viewMainCal.isHidden = true
        viewSelectTime.isHidden = true
        btnBookNow.layer.cornerRadius = btnBookNow.frame.size.height/2
        setDateOnHeader()
        setToolBar()
        setPadding(textfied: txtDate)
        setPadding(textfied: txtTime)
        setPadding(textfied: txtNumberOfGuest)
        
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
       
       /* DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            
           // self.spinner.endRefreshing()
          //  self.viewSpinner.isHidden = true
            
        }*/
    }
    
    func setToolBar(){
        
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
       // UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtNumberOfGuest.inputAccessoryView = numberToolbar
        txtDate.inputAccessoryView = numberToolbar
        txtTime.inputAccessoryView = numberToolbar
        
    }
    
    @objc func doneWithNumberPad() {
        
        
        self.view.endEditing(true)
        
    }
    
    func setPadding(textfied : UITextField){
        
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textfied.frame.height))
        textfied.leftView = paddingView
        textfied.leftViewMode = UITextField.ViewMode.always
        
    }

    func setDateOnHeader(){
        
        var date = Date()
        
        if(calendar.selectedDate == nil){
            
            date = Date()
            
        }else{
            
            date = calendar.selectedDate!
            
        }
        
        let cal = Calendar.current
        let year = cal.component(.year, from: date)
        let dateString = convertDateToString(date: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date1 = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "EEE, MMM dd"
        let final = dateFormatter.string(from: date1!)
        lblYear.text = "\(year)"
        lblDate.text = final
        
    }
    
    
    
    func changeMainViewController(to viewController: UIViewController) {
           //Change main viewcontroller of side menu view controller
           let navigationViewController = UINavigationController(rootViewController: viewController)
           slideMenuController()?.changeMainViewController(navigationViewController, close: true)
        
    }
    
    func tableBookApiCall(){
        
        let userid = UserDefaults.standard.value(forKey: "userid") as! String
        
        let url = "https://wheretowheel.us/api/hotels/booking?listing_id=\(listid)&user_id=\(userid)&portal_id=\(portalid)&date_of_booking=\(txtDate.text!)&time_of_booking=12:50PM&no_of_guests=\(txtNumberOfGuest.text!)"
        
        AF.request(url, method: .post, parameters: [:]).responseJSON { response in
        
            
            
            if response.value != nil {
                
                
                let responseData = response.value as! NSDictionary
                let res = responseData.value(forKey: "response") as! NSDictionary
                let status = res.value(forKey: "status") as! Int
               
               if(status == 1){
                
                
               /* guard let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController else {
                           return
                       }
                    
                self.changeMainViewController(to: tabViewController)*/
                 DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    
                    self.spinner.endRefreshing()
                    self.viewSpinner.isHidden = true
                    self.performSegue(withIdentifier: "history", sender: self)
                    
                }
                
                 
                
                }
                
            }
        
        }
        
    }
    
   
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yy-MM-dd"
        return  dateFormatter.string(from: date!)

    }
    
    func convertDateToString( date: Date) -> String {
       //let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    @IBAction func onClickTime(_ sender: Any) {
        viewSelectTime.isHidden = false
        
    }
    
    @IBAction func onClickBookNow(_ sender: Any) {
        loadLoader()
        tableBookApiCall()
    }
    
    @IBAction func onClickBackk(_ sender: Any) {
     /*   guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "DashboardDetailViewController") as? DashboardDetailViewController else {
                   return
               }
            
        changeMainViewController(to: tabViewController)*/
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickCancelCal(_ sender: Any) {
        viewMainCal.isHidden = true
    }
    
    @IBAction func onClickOkCal(_ sender: Any) {
        
        var date = Date()

        if(calendar.selectedDate == nil){
            date = Date()
        }else{
            date = calendar.selectedDate!
        }
      
        let dateString = convertDateToString(date: date)
        txtDate.text = convertDateFormater(dateString)
        viewMainCal.isHidden = true
    }
    
    @IBAction func onClickDate(_ sender: Any) {
        viewMainCal.isHidden = false
        //change on 19.01.2021
        //viewSelectTime.isHidden = false

    }

    @IBAction func onClickCancelTime(_ sender: Any) {
        viewSelectTime.isHidden = true
    }
    
    @IBAction func onClickOkTime(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let ouptputTime = dateFormatter.string(from: timePicker.date)
        txtTime.text = ouptputTime
        viewSelectTime.isHidden = true
    }
    
    @IBAction func changeTime(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let ouptputTime = dateFormatter.string(from: sender.date)
        txtTime.text = ouptputTime
    }
}
