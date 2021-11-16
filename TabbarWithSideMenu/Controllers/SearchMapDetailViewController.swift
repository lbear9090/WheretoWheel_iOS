import UIKit
import Alamofire
import MapKit
import GoogleMaps

class SearchMapDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var imgRate1: UIImageView!
    @IBOutlet weak var imgRate2: UIImageView!
    @IBOutlet weak var imgRate3: UIImageView!
    @IBOutlet weak var imgRate4: UIImageView!
    @IBOutlet weak var imgRate5: UIImageView!
    @IBOutlet weak var lblPleaseWait: UILabel!
    @IBOutlet weak var viewPleaseWait: UIView!
    @IBOutlet weak var viewSpinner: UIView!
    var dictData = NSDictionary()
    var arrListDetails = NSArray()
    var id = ""
    var arrCategory = NSArray()
    var arrComents = NSArray()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            self.tblData.delegate = self
            self.tblData.dataSource = self
            self.loadLoader()
            self.detailApi()
            
            let deledate = UIApplication.shared.delegate as? AppDelegate
            deledate?.isDetailScreen = false
        }
    }
    
    //MARK:- my selector that was defined above
    @objc func willEnterForeground() {
        // do stuff
        DispatchQueue.main.async {
            //self.tblData.delegate = self
            //self.tblData.dataSource = self
            //self.loadLoader()
            //self.detailApi()
            
            //let deledate = UIApplication.shared.delegate as? AppDelegate
            //deledate?.isDetailScreen = false
            self.tblData.reloadData()
        }
    }
    
    func loadLoader(){
        
        
        viewSpinner.isHidden = false
        let spinner = JTMaterialSpinner()
       
        viewPleaseWait.layer.cornerRadius = 5.0
        viewPleaseWait.addSubview(spinner)
       
        spinner.frame = CGRect(x: 25, y: 45, width: 40, height: 40)
        
        spinner.circleLayer.lineWidth = 3.0;
        spinner.circleLayer.strokeColor = UIColor.blue.cgColor;
        spinner.beginRefreshing()
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            
            spinner.endRefreshing()
            self.viewSpinner.isHidden = true
            
        }
        
    }
    
    @objc func loadTbl(){
        DispatchQueue.main.async {
          self.tblData.reloadData()
        }
    }
    
    func detailApi(){
        

        let url = "https://wheretowheel.us/api/hotels/listing_details_yelp?yelp_id=\(id)"

        AF.request(url, method: .get, parameters: [:]).responseJSON { response in
            print(response)
            
            if response.value != nil {
                
                let responseData = response.value as! NSDictionary
                let res = responseData.value(forKey: "response") as! NSDictionary
                
                let rsDic = res.mutableCopy() as! NSMutableDictionary
                let resDic = self.removeNullFromDict(dict: rsDic)
                
                
                self.dictData = resDic.value(forKey: "listing_details") as! NSDictionary
                self.arrCategory = self.dictData.value(forKey: "categories") as! NSArray
                let review = self.dictData.value(forKey: "reviews") as! NSDictionary
                self.arrComents = review.value(forKey: "reviews") as! NSArray
                
                let defaults = UserDefaults.standard
                defaults.set(self.arrCategory, forKey: "Facilites")
                defaults.synchronize()
                DispatchQueue.main.async {
                  self.tblData.reloadData()
                }

                self.perform(#selector(self.loadTbl), with: nil, afterDelay: 0.5)
                
            }else{
                
                /*let alert = UIAlertView()
                alert.title = "Where To Wheel"
                alert.message = "search data not found"
                alert.addButton(withTitle: "Ok")
                alert.show()*/
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
    
    @objc @IBAction func onClickAddressButtons(_ sender: UIButton) {
        
        if sender.tag == 0{
            
          
            open(scheme: dictData.value(forKey: "url") as! String)
            
        }else if sender.tag == 1{
            
            open(scheme: "tel://\(dictData.value(forKey: "display_phone") ?? "")")
            
        }else if sender.tag == 2{
            
            openMapForPlace()
            
        }
    }
    
    func open(scheme: String) {
         if let url = URL(string: scheme) {
           if #available(iOS 10, *) {
             UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
               completionHandler: {
                 (success) in
                  print("Open \(scheme): \(success)")
              })
           } else {
             let success = UIApplication.shared.openURL(url)
             print("Open \(scheme): \(success)")
           }
         }
       }
    
    func openMapForPlace() {

      //  let lat1 : NSString = dictData.value(forKey: "latitude") as! NSString
       // let lng1 : NSString = dictData.value(forKey: "longitude") as! NSString

        let latitude:CLLocationDegrees =  dictData.value(forKey: "latitude") as! CLLocationDegrees
        let longitude:CLLocationDegrees =  dictData.value(forKey: "longitude") as! CLLocationDegrees

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        //mapItem.name = "\(self.venueName)"
        mapItem.openInMaps(launchOptions: options)

    }
    
    @IBAction func onClickBack(_ sender: Any) {
        
     //   let appdelegate = UIApplication.shared.delegate as? AppDelegate
      //  appdelegate?.makeRootViewController()
        
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0){
            
            return 1
            
        }else if(section == 1){
            
            return 1
            
        }else if(section == 2){
            
            return 1
            
        }else if(section == 3){
            
            return 1
            
        }else if(section == 4){
            
           return 1
            
        }else if(section == 5){
            
           return 1
            
        }else {
            
             return arrComents.count
        }
     
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            
                let identifier = "topImageCell"
                
                var cell: topImageCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? topImageCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "topImageCell", bundle: nil), forCellReuseIdentifier:  identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? topImageCell
                    
                }
            
            if(dictData.count > 0){
                

                 let url = dictData.value(forKey: "image_url") as! String
                 
                cell.imgHeader.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
                     
            }
            
           // let url = dictData.value(forKey: "image_url") as! String
            
           // cell.imgHeader.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
                
            tblData.rowHeight = 200
    
            return cell
            
        }else if(indexPath.section == 1){
            
                let identifier = "nameSecondCell"
                
                var cell: nameSecondCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? nameSecondCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "nameSecondCell", bundle: nil), forCellReuseIdentifier:  identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? nameSecondCell
                    
                }
                
             cell.lblName.text = dictData.value(forKey: "name") as? String
            
            
            if(dictData.count > 0){
                
                let rat: NSString = dictData.value(forKey: "rating") as? NSString ?? ""
                let rate = rat.intValue
               // let rate = rate1.rounded()
                
                if(Int(rate) > 0) {
                    
                    for i in 1...Int(rate) {
                        
                        switch i {
                        case 1:
                            
                            cell.rate1.image = UIImage(named: "star-yellow")
                            break
                        case 2:
                            
                            cell.rate2.image = UIImage(named: "star-yellow")
                            break
                            
                        case 3:
                            
                            cell.rate3.image = UIImage(named: "star-yellow")
                            break
                            
                        case 4:
                            
                            cell.rate4.image = UIImage(named: "star-yellow")
                            break
                            
                        case 5:
                            
                            cell.rate5.image = UIImage(named: "star-yellow")
                            break
                            
                            
                        default:
                            break
                        }
                    }
                    
                }


            
                
            }
            
                tblData.rowHeight = 70
                
                return cell
                
     
            
        }else if(indexPath.section == 2){
            
           
            
            let identifier = "addreassMapCell"
            
            var cell: addreassMapCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? addreassMapCell
            
            if cell == nil {
                
                tableView.register(UINib(nibName: "addreassMapCell", bundle: nil), forCellReuseIdentifier:  identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? addreassMapCell
                
            }
        
            cell.lblAddress.text = dictData.value(forKey: "address") as? String
            cell.lblCityState.text = "\(dictData.value(forKey: "city") ?? "")" + "," + "\(dictData.value(forKey: "country") ?? "")" + "," + "\(dictData.value(forKey: "state") ?? "")"
            cell.lblZip.text = "Zip code :" + "\(dictData.value(forKey: "zip_code") ?? "")"
            cell.lblMobile.text = dictData.value(forKey: "phone") as? String
            
            cell.btnWeb.tag = 0
            cell.btnCall.tag = 1
            cell.btnDirection.tag = 2
          
            //cell.btnWeb.setImage(UIImage(named: "globe"), for: .normal)
            //cell.btnCall.setImage(UIImage(named: "phone.fill"), for: .normal)
            //cell.btnDirection.setImage(UIImage(named: "arrow.up.right.diamond.fill"), for: .normal)
            //let img = UIImage(named: "2m")
            //cell.btnDirection.setImage(img, for: .normal)
            //cell.btnDirection.tintColor = .black
            
            cell.btnWeb.addTarget(self, action: #selector(onClickAddressButtons), for: .touchUpInside)
            cell.btnCall.addTarget(self, action: #selector(onClickAddressButtons), for: .touchUpInside)
            cell.btnDirection.addTarget(self, action: #selector(onClickAddressButtons), for: .touchUpInside)
           
            
            tblData.rowHeight = 110
            
            return cell
            
            //  }
        }else if(indexPath.section == 3){
            
           let identifier = "featchersFifthCell"
            
            if(arrComents.count > 0){
                
                
                var cell: featchersFifthCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? featchersFifthCell
                               
                               if cell == nil {
                                   
                                   tableView.register(UINib(nibName: "featchersFifthCell", bundle: nil), forCellReuseIdentifier:  identifier)
                                   cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? featchersFifthCell
                                   
                               }
                           
                               /*    if(dictData.count > 0){
                                   
                                   cell.listId = dictData.value(forKey: "id") as! String
                                   
                               } */
                
                if(arrComents.count <= 3){
                    
                       tblData.rowHeight = 65
                    
                }else if(arrComents.count <= 6){
                    
                       tblData.rowHeight = 80
                    
                }else if(arrComents.count <= 9){
                    
                       tblData.rowHeight = 120
                    
                }else if(arrComents.count <= 12){
                    
                       tblData.rowHeight = 250
                    
                }else{
                    
                    tblData.rowHeight = 280
                    
                }
                            
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "searchMapDetail")!
                
                //   cell.textLabel?.text = "Where to Wheel Ratings:"
                
                tblData.rowHeight = 20
                
                return cell
            }
         
        }else if(indexPath.section == 4){
            
            
            let identifier = "mapSixthCell"
                
                var cell: mapSixthCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? mapSixthCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "mapSixthCell", bundle: nil), forCellReuseIdentifier:  identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? mapSixthCell
                    
                }
            
            if(dictData.count > 0){
                
                //let lat1 : NSString = dictData.value(forKey: "latitude") as! NSString
                //  let lng1 : NSString = dictData.value(forKey: "longitude") as! NSString
                
                let late:CLLocationDegrees =  dictData.value(forKey: "latitude") as! CLLocationDegrees
                let long:CLLocationDegrees =  dictData.value(forKey: "longitude") as! CLLocationDegrees
                
                let camera = GMSCameraPosition.camera(withLatitude: late,
                                                      longitude: long,
                                                      zoom: 10)
                
                cell.map.camera = camera
                let position = CLLocationCoordinate2D(latitude: late, longitude: long)
                let london = GMSMarker(position: position)
                london.title = "London"
                london.icon = UIImage(named: "pin1")
                london.map = cell.map
                
                
            }
            
                tblData.rowHeight = 200
                
                return cell
            
        }else if(indexPath.section == 5){
            
         
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchMapDetail")!
                
                cell.textLabel?.text = "User comments/Experience"
                tblData.rowHeight = 20
                return cell
        
        }else{
            
            
            let identifier = "lastCell"
            
            var cell: lastCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? lastCell
            
            if cell == nil {
                
                tableView.register(UINib(nibName: "lastCell", bundle: nil), forCellReuseIdentifier:  identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? lastCell
                
            }
            
            
            
            let dictTemp = arrComents[indexPath.row] as! NSDictionary
            let dict = dictTemp.value(forKey: "user") as! NSDictionary
            cell.lblName.text = dict.value(forKey: "name") as? String
            cell.lblDesc.text = dictTemp.value(forKey: "text") as? String
            
            cell.lblDesc.frame = CGRect(x: cell.lblDesc.frame.origin.x, y: cell.lblDesc.frame.origin.y, width: cell.lblDesc.frame.size.width, height: getLabelHeight(cell.lblDesc))
            
            tblData.rowHeight = cell.lblDesc.frame.origin.y + cell.lblDesc.frame.size.height + 10;
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.width/2
            
            if let url = dict.value(forKey: "image_url") as? String {
                
                 cell.imgProfile.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
            
           
            
            // tblData.rowHeight = 200
            
            return cell
            
        }
        
    }
    
    func getLabelHeight(_ label: UILabel?) -> CGFloat {
           let constraint = CGSize(width: label?.frame.size.width ?? 0.0, height: CGFloat.greatestFiniteMagnitude)
           var size: CGSize

           let context = NSStringDrawingContext()
           var boundingBox: CGSize? = nil
           if let font = label?.font {
               boundingBox = label?.text?.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [
               NSAttributedString.Key.font: font
           ], context: context).size
           }

           size = CGSize(width: ceil(boundingBox?.width ?? 0.0), height: ceil(boundingBox?.height ?? 0.0))

           return size.height
       }


}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
