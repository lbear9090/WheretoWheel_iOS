
import UIKit
import CoreLocation
import Alamofire
import GoogleMaps
import SDWebImage
import skpsmtpmessage





class LocationViewController: SideBaseViewController,CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GMSMapViewDelegate,SKPSMTPMessageDelegate {
    

    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewSegment: UIView!
    @IBOutlet weak var imgList: UIImageView!
    @IBOutlet weak var lblList: UILabel!
    @IBOutlet weak var lblMap: UILabel!
    @IBOutlet weak var imgMap: UIImageView!
    @IBOutlet weak var viewList: UIView!
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var onoffSwitch: UISwitch!
    @IBOutlet weak var btnNearMe: UIButton!
    @IBOutlet weak var lblPleaseWait: UILabel!
    @IBOutlet weak var viewPleaseWait: UIView!
    @IBOutlet weak var viewSpinner: UIView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var txtLat: UITextField!
    @IBOutlet weak var txtLon: UITextField!
    @IBOutlet weak var btnMAnualLocation: UIButton!
    
    var locationManager = CLLocationManager()
    var lat = Double()
    var long = Double()
    var arrListDetails = NSArray()
    var arrMapData = NSArray()
    let spinner = JTMaterialSpinner()
    var listId = ""
    var portalId = ""
    var markerPosiion = 0
    

    //MARK:- UIViewController Initialize Methods
    override func viewDidLoad() {

        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = LeftMenuItems.settingsTab.rawValue
        loadAllMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.SelectedIndex = 2
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        if(appdelegate!.isProfile == true){
            
            
        }else{
            
            loadLoader()
        }
        
        appdelegate!.isProfile = false
    }
    
  
    func loadAllMethod(){
        
        setShadow()
        locationManager.delegate = self
        collection.delegate = self;
        collection.dataSource = self;
        map.delegate = self
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
       
        
    }
    
    func setShadow(){
        
        viewSegment.layer.masksToBounds = false
        viewSegment?.layer.shadowColor = UIColor.gray.cgColor
        viewSegment?.layer.shadowOffset =  CGSize.zero
        viewSegment?.layer.shadowOpacity = 2.5
        viewSegment?.layer.shadowRadius = 4
        
    }
    
    func loadLoader(){
        
        
        viewSpinner.isHidden = false
       // let spinner = JTMaterialSpinner()
       
        viewPleaseWait.layer.cornerRadius = 5.0
        viewPleaseWait.addSubview(spinner)
       
        spinner.frame = CGRect(x: 25, y: 45, width: 40, height: 40)
        
        spinner.circleLayer.lineWidth = 3.0;
        spinner.circleLayer.strokeColor = UIColor.blue.cgColor;
        spinner.beginRefreshing()
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            
            self.spinner.endRefreshing()
            self.viewSpinner.isHidden = true
            self.checkGPS()
        }
    }
    
    func checkGPS(){
        
        
    if CLLocationManager.locationServicesEnabled() {
         switch(CLLocationManager.authorizationStatus()) {
         case .notDetermined, .restricted, .denied:
             //open setting app when location services are disabled
         openSettingApp(message:NSLocalizedString("please.enable.location.services.to.continue.using.the.app", comment: ""))
         case .authorizedAlways, .authorizedWhenInUse:
             print("Access")
         }
     } else {
         print("Location services are not enabled")
         openSettingApp(message:NSLocalizedString("please.enable.location.services.to.continue.using.the.app", comment: ""))
     }
        
    }
    
    func openSettingApp(message: String) {
        let alertController = UIAlertController (title: "APP_NAME_TITLE", message:message , preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: NSLocalizedString("settings", comment: ""), style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        //let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .default, handler: nil)
        //alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func listApiCall(){
        
        locationManager.stopUpdatingLocation()
        
       
      //   let url = "https://wheretowheel.us/api/hotels/listview_current?lat=42.35843&lon=-71.05977"
        
        
       //  if(onoffSwitch.isOn == false){
            
            let url = "https://wheretowheel.us/api/hotels/location_search?category_id=&lat=\(lat)&lon=\(long)"
           // let url = "https://wheretowheel.us/api/hotels/location_search?category_id=&lat=42.19141320477831&lon=-70.99167370946718"
            AF.request(url, method: .get, parameters: [:]).responseJSON { response in
                
                
                if response.value != nil {
                    
                    let responseData = response.value as! NSDictionary
                    let res = responseData.value(forKey: "response") as! NSDictionary
                    
                    let rsDict = res.mutableCopy() as! NSMutableDictionary
                    let resDic = self.removeNullFromDict(dict: rsDict)
                    let status = resDic.value(forKey: "status") as! Int
                                   
                    if(status == 1){
                                       
                        let arrTemp = resDic.value(forKey: "listing_details") as! NSArray
                        
                    
                        if(self.onoffSwitch.isOn == false){
                            
                            
                            let givenDescriptor = NSSortDescriptor(key: "data_status", ascending: false)
                            let sortDescriptors = [givenDescriptor]
                            //self.arrListDetails = arrTemp.sortedArray(using: sortDescriptors) as NSArray
                            self.arrListDetails = arrTemp as NSArray
                            
                        }else{
                            
                            let predicate = NSPredicate(format:"data_status == 1")
                            let filteredArray = arrTemp.filtered(using: predicate) as NSArray
                            
                            let givenDescriptor = NSSortDescriptor(key: "data_status", ascending: false)
                            let sortDescriptors = [givenDescriptor]
                            //self.arrListDetails = filteredArray.sortedArray(using: sortDescriptors) as NSArray
                            self.arrListDetails = filteredArray as NSArray
                            
                            
                        }
                         self.collection.reloadData()
                        
                                    
                    }else{
                        
                        self.arrListDetails = NSArray()
                        self.collection.reloadData()
                        let alertController = UIAlertController(title: "", message: "Data not available", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        
                         self.spinner.endRefreshing()
                    }
                   
                    
                }
            }
        
      /*  }else{
            
           
            let url = "https://wheretowheel.us/api/hotels/listview_current?&lat=\(lat)&lon=\(long)"
            
            AF.request(url, method: .get, parameters: [:]).responseJSON { response in
                
                
                if response.value != nil {
                    
                    let responseData = response.value as! NSDictionary
                    let res = responseData.value(forKey: "response") as! NSDictionary
                    
                    let status = res.value(forKey: "status") as! Int
                                   
                    if(status == 1){
                                       
                        let arrTemp = res.value(forKey: "listing_details") as! NSArray
                        
                        let givenDescriptor = NSSortDescriptor(key: "category_status", ascending: false)
                        let sortDescriptors = [givenDescriptor]
                        self.arrListDetails = arrTemp.sortedArray(using: sortDescriptors) as NSArray
                        self.collection.reloadData()
                                    
                    }else{
                        
                        self.arrListDetails = NSArray()
                        self.collection.reloadData()
                        let alertController = UIAlertController(title: "", message: "Data not available", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        
                         self.spinner.endRefreshing()
                    }
                    
                }
            }
            
        } */
    
    }
    
    func mapPinApiCall(){
          
          
          let url = "https://wheretowheel.us/api/hotels/location_search?category_id=&lat=\(lat)&lon=\(long)"
        //  let url = "https://wheretowheel.us/api/hotels/location_search?category_id=&lat=42.19141320477831&lon=-70.99167370946718"
         //  let url = "https://wheretowheel.us/api/hotels/map_listview?lat=42.35843&lon=-71.05977"
          
          AF.request(url, method: .post, parameters: [:]).responseJSON { response in
          
              
              
              if response.value != nil {
                  
                  
                  let responseData = response.value as! NSDictionary
                 // print(responseData)
                
                  let res = responseData.value(forKey: "response") as! NSDictionary
                  let rsDict = res.mutableCopy() as! NSMutableDictionary
                  let resDic = self.removeNullFromDict(dict: rsDict)
                
                  self.arrMapData = resDic.value(forKey: "listing_details") as! NSArray
                 
                  DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { // Change `2.0` to the desired number of seconds.
                    
                    self.setPinOnMap()
                  }
                
                  
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
    
    func setPinOnMap(){
           
       // for data in arrMapData {
        for (index, data) in arrMapData.enumerated() {
            
            let dict = data as! NSDictionary
            
            let datastatus = dict.value(forKey: "data_status") as! Int
            
            if(datastatus == 1){
                
                let lat1 : NSString = dict.value(forKey: "latitude") as! NSString
                let lng1 : NSString = dict.value(forKey: "longitude") as! NSString
                
                let late:CLLocationDegrees =  lat1.doubleValue
                let long:CLLocationDegrees =  lng1.doubleValue
                
                let position = CLLocationCoordinate2D(latitude: late, longitude: long)
                let london = GMSMarker(position: position)
                //london.title = "London"
                london.icon = UIImage(named: "marker_wtw")
                london.userData = index
                london.title = dict.value(forKey: "name") as? String
                london.snippet = dict.value(forKey: "address") as? String
                london.map = map
                
                
            }else if(datastatus == 2){
                
                
                let late = dict.value(forKey: "latitude") as! Double
                let long = dict.value(forKey: "longitude") as! Double
                
                let position = CLLocationCoordinate2D(latitude: late, longitude: long)
                let london = GMSMarker(position: position)
                //london.title = "London"
                london.icon = UIImage(named: "pin1")
                london.title = dict.value(forKey: "name") as? String
                london.snippet = dict.value(forKey: "address") as? String
                london.userData = index
                london.map = map
                
            }
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("Tapped")
        let n = marker.userData as! Int
        markerPosiion = n
       // performSegue(withIdentifier: "mapDetail", sender: self)
        
        let data = arrMapData[markerPosiion] as! NSDictionary
        listId = data.value(forKey: "id") as? String ?? ""
        
        let datastatus = data.value(forKey: "data_status") as! Int
        
        if(datastatus == 2){
            
            performSegue(withIdentifier: "searchMapDetail", sender: self)
            
        }else{
            
            performSegue(withIdentifier: "DetailViewController", sender: self)
        }
        
        
        
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "searchMapDetail") {
            let vc = segue.destination as! SearchMapDetailViewController
            vc.id = listId
        }
        
        if (segue.identifier == "DetailViewController") {
            
            let vc = segue.destination as! DetailViewController
            vc.listId = listId
        }
    }*/
    
    
    
    @IBAction func onClickBack(_ sender: Any) {
        
        
        let tabbar = self.navigationController?.tabBarController as! CustomTabBarViewController
        tabbar.setSelectIndex(from: 2, to: 0)
        
    }
    
    @IBAction func onClickNearMe(_ sender: Any) {
        print("Im from LocationViewController")
        
    }
    
    @IBAction func onClickList(_ sender: Any) {
        
        
        map.isHidden = true
        lblList.textColor = .white
        imgList.setImageColor(color: UIColor.white)
        lblMap.textColor = .gray
        imgMap.setImageColor(color: UIColor.gray)
        viewList.backgroundColor = .blue
        viewMap.backgroundColor = .white
        
        
    }
    
    @IBAction func onClickMap(_ sender: Any) {
        
        
        map.isHidden = false
        lblMap.textColor = .white
        imgMap.setImageColor(color: UIColor.white)
        lblList.textColor = .gray
        imgList.setImageColor(color: UIColor.gray)
        viewList.backgroundColor = .white
        viewMap.backgroundColor = .blue
    
    }
    
     @IBAction func onClickManualLocation(_ sender: Any) {
        
        lat = Double(txtLat.text!)!
        long = Double(txtLon.text!)!
        loadLoader()
        listApiCall()
        mapPinApiCall()
    }
    
    @IBAction func changeSwiftState(_ sender: Any) {
        viewSpinner.isHidden = false
        spinner.beginRefreshing()
        loadLoader()
        listApiCall()
    }
    
    func downloadImage(from url: URL,imageview : UIImageView,indicator : UIActivityIndicatorView) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
           
            DispatchQueue.main.async() {
                 
                 indicator.color = .clear
                imageview.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrListDetails.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var placeholderImage: UIImage? = nil
        if placeholderImage == nil {
            placeholderImage = UIImage(named: "placeholder")
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LocationListCell
        cell.imgBig.sd_imageTransition = SDWebImageTransition.fade
        cell.imgBig.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        cell.contentView.layer.cornerRadius = 5.0;
        cell.contentView.layer.borderWidth = 1.0;
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0;
        cell.layer.shadowOpacity = 0.5;
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        if(arrListDetails.count > 0){
            
            let dictTemp = arrListDetails[indexPath.item] as! NSDictionary
            //let dictTemp1 = arrMapData[indexPath.item] as! NSDictionary
            cell.lblName.text = dictTemp.value(forKey: "name") as? String
            cell.lbldesc.text = "\(dictTemp.value(forKey: "city") as? String ?? ""),\(dictTemp.value(forKey: "state") as? String ?? "")"
            let distance = dictTemp.value(forKey: "distance") as? String
           // cell.lblMI.text = String(distance!.prefix(5))
            cell.lblMI.text = distance
            cell.lblNumber.text = dictTemp.value(forKey: "zipcode") as? String
           // cell.indicator.color = .white
        //    if(onoffSwitch.isOn == false){
                
                let datastatus = dictTemp.value(forKey: "data_status") as! Int
                
                if(datastatus == 1){
                    
                    cell.imgAppIcon.image = UIImage(named: "appicon")
                    let distance = dictTemp.value(forKey: "distance") as? String
                    // cell.lblMI.text = String(distance!.prefix(5))
                    cell.lblMI.text = distance
                    
                }else{
                    
                    cell.imgAppIcon.image = UIImage(named: "yelp_icon")
                    let distance = dictTemp.value(forKey: "distance") as! Double
                    // cell.lblMI.text = String(distance!.prefix(5))
                    cell.lblMI.text = "\(distance)"
                }
                
           /* }else{
                
                
                let datastatus = dictTemp.value(forKey: "category_status") as! Int
                
                
                if(datastatus == 0){
                    
                    cell.imgAppIcon.image = UIImage(named: "appicon")
                    //let distance = dictTemp.value(forKey: "distance") as? String
                    // cell.lblMI.text = String(distance!.prefix(5))
                  //  cell.lblMI.text = distance
                    
                }else{
                    
                    cell.imgAppIcon.image = UIImage(named: "yelp_icon")
                   // let distance = dictTemp.value(forKey: "distance") as! Double
                    // cell.lblMI.text = String(distance!.prefix(5))
                  //  cell.lblMI.text = "\(distance)"
                }
                
                let distance = dictTemp.value(forKey: "distance") as? String
                let length : Int = distance!.count
                
                if(length > 5){
                    
                    cell.lblMI.text = String(distance!.prefix(5))
                }else{
                    
                    cell.lblMI.text = distance
                    
                }
                
                
            }*/
           
            
            
    
            if let url1 = dictTemp.value(forKey: "img"){
                
                let url : NSString = url1 as! NSString
                let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                let searchURL : NSURL = NSURL(string: urlStr as String)!
                
                weak var imageView = cell.imgBig
                
                imageView?.sd_setImage(with: searchURL as URL, placeholderImage: placeholderImage, options:  indexPath.item == 0 ? SDWebImageOptions(rawValue: SDWebImageOptions.RawValue(Int(1 << 3))) : [], context: [
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
                
                /*  let url : NSString = url1 as! NSString
                 let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                 let searchURL : NSURL = NSURL(string: urlStr as String)!
                 self.downloadImage(from: searchURL as URL, imageview: cell.imgBig, indicator: cell.indicator)
                 //self.downloadImage(from: searchURL as URL, imageview: cell.imgBig) */
            }
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = arrListDetails[indexPath.row] as! NSDictionary
        listId = data.value(forKey: "id") as! String
        
        let datastatus = data.value(forKey: "data_status") as! Int
            
        if(datastatus == 2){
            
            performSegue(withIdentifier: "searchMapDetail", sender: self)
            
        }else{
            
            performSegue(withIdentifier: "DetailViewController", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
     //   if(isOnState == true) {
            
            
            if (segue.identifier == "DetailViewController") {
                
                let vc = segue.destination as! DetailViewController
                vc.listId = listId
               // vc.catid = catid
               
                
            }
            
      //  }else{
            
            if (segue.identifier == "searchMapDetail") {
                
                let vc = segue.destination as! SearchMapDetailViewController
                vc.id = listId
                
            }
        
           if (segue.identifier == "booktable") {
            
            let vc = segue.destination as! TableBookViewController
             vc.portalid = portalId
             vc.listid = listId
            
           }
            
      //  }
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width - 20, height: collectionView.frame.size.width/5 + 20)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           
           
           if let location = locations.last{
                 
               
               lat = location.coordinate.latitude
               long = location.coordinate.longitude
               //txtLat.text = "\(lat)"
              // txtLon.text = "\(long)"
               listApiCall()
               mapPinApiCall()
              
             // sendEmail(lat: lat, lon: long)
               
              let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                     longitude: location.coordinate.longitude,
                                                           zoom: 13)
            
            /*  let camera = GMSCameraPosition.camera(withLatitude: 42.35843,
               longitude: -71.05977,
                  zoom: 13)*/
               
                     map.camera = camera
                     let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                     let london = GMSMarker(position: position)
                    // london.title = "London"
                    // london.icon = UIImage(named: "pin")
                     london.map = map
                     locationManager.stopUpdatingLocation()
               
           }
       
       }
    
    func messageSent(_ message: SKPSMTPMessage!) {
        print("Successfully sent email!")
        let alertController = UIAlertController(title: "SMTP MAIL", message: "Successfully sent email", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func messageFailed(_ message: SKPSMTPMessage!, error: Error!) {
        print("Sending email failed!")
        print("error is = \(String(describing: error))")
        let alertController = UIAlertController(title: "SMTP MAIL", message: "Sending email failed!", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
       func sendEmail(lat : Double, lon : Double){
        
        let message = SKPSMTPMessage()
        message.relayHost = "smtp.gmail.com"
        message.login = "flipworktech@gmail.com"
        message.pass = "#vora2007#"
        message.requiresAuth = true
        message.wantsSecure = true
        message.relayPorts = [465]
        message.fromEmail = "flipworktech@gmail.com"
        message.toEmail = "divyesh.vora2007@gmail.com"
        message.subject = "This is Location screen(Near Me)"
    
        let messagePart = [kSKPSMTPPartContentTypeKey: "text/plain", kSKPSMTPPartMessageKey: "Current screen is Third menu Location screen and current lat is: \(lat) and lon is : \(lon)"]
        message.parts = [messagePart]
        
        
     /*   let messageBody = "your email body message"
        //for example :   NSString *messageBody = [NSString stringWithFormat:@"Tour Name: %@\nName: %@\nEmail: %@\nContact No: %@\nAddress: %@\nNote: %@",selectedTour,nameField.text,emailField.text,foneField.text,addField.text,txtView.text];
        // Now creating plain text email message
        let plainMsg = [
            kSKPSMTPPartContentTypeKey : "text/plain",
            kSKPSMTPPartMessageKey : messageBody,
            kSKPSMTPPartContentTransferEncodingKey : "8bit"
        ]
        message.parts = [plainMsg] */
        
        message.delegate = self
        message.send()
        
    }
    
    
}








// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
