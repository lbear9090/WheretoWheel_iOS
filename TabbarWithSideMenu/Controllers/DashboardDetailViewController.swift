
import UIKit
import CoreLocation
import GoogleMaps
import Alamofire
import CoreData
import SDWebImage


class DashboardDetailViewController: UIViewController,CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GMSMapViewDelegate,NSFetchedResultsControllerDelegate {
    
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
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var viewCollectionList: UIView!
    
    
    var locationManager = CLLocationManager()
    var lat = Double()
    var long = Double()
    var catid = ""
    var catname = ""
    var arrListDetails = NSArray()
    var arrYelpData = NSArray()
    var arrServerData = NSArray()
    var listId = ""
    var portalId = ""
    var isOnState = false
    var count = 0
    var arrImages = NSMutableArray()
    var markerPosiion = 0
    
    var spinner = JTMaterialSpinner()
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: List.self))
        let sortDescriptor = NSSortDescriptor(key: "status", ascending: true,
                                              selector: #selector(NSString.localizedStandardCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
         loadAllMethod()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadLoader()
        if (CLLocationManager.locationServicesEnabled())
          {
              locationManager = CLLocationManager()
              locationManager.delegate = self
              locationManager.desiredAccuracy = kCLLocationAccuracyBest
              locationManager.requestAlwaysAuthorization()
              locationManager.startUpdatingLocation()
        }
        
        
    }
    
    func loadAllMethod(){
        
          self.navigationController?.navigationBar.isHidden = true
          setShadow()
          locationManager.delegate = self
          collection.delegate = self;
          collection.dataSource = self;
          map.delegate = self
          btnNearMe.setTitle(catname, for: .normal)
        
        /*if (CLLocationManager.locationServicesEnabled())
               {
                   locationManager = CLLocationManager()
                   locationManager.delegate = self
                   locationManager.desiredAccuracy = kCLLocationAccuracyBest
                   locationManager.requestAlwaysAuthorization()
                   locationManager.startUpdatingLocation()
             }*/
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
          spinner = JTMaterialSpinner()
         
          viewPleaseWait.layer.cornerRadius = 5.0
          viewPleaseWait.addSubview(spinner)
         
          spinner.frame = CGRect(x: 25, y: 45, width: 40, height: 40)
          
          spinner.circleLayer.lineWidth = 3.0;
          spinner.circleLayer.strokeColor = UIColor.blue.cgColor;
          spinner.beginRefreshing()
         
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
              
             // self.spinner.endRefreshing()
            //  self.viewSpinner.isHidden = true
              self.checkGPS()
          }
      }
    
    func checkGPS(){
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                //open setting app when location services are disabled
                openSettingApp(message:NSLocalizedString("please enable location services to continue using the app", comment: ""))
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
            openSettingApp(message:NSLocalizedString("please enable location services to continue using the app", comment: ""))
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
    
    func ApiCall(){
        
        locationManager.stopUpdatingLocation()
        
        do {
            try self.fetchedhResultController.performFetch()
         //   print("COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
        } catch let error  {
            print("ERROR: \(error)")
        }
        
        
     //   if(onoffSwitch.isOn == false){
            
            isOnState = false
            let url = "https://wheretowheel.us/api/hotels/list_view_yelp"
            let parameters: Parameters = ["category_id": catid, "lat": lat, "lon": long]
           // let parameters: Parameters = ["category_id": catid, "lat": "42.19141320477831", "lon": "-70.99167370946718"]
            
                AF.request(url, method: .post, parameters: parameters).responseJSON { response in
                       print(response)
                    
                    if response.value != nil {
                        
                        
                        let responseData = response.value as! NSDictionary
                        let res = responseData.value(forKey: "response") as! NSDictionary
                        
                        let rsDic = res.mutableCopy() as! NSMutableDictionary
                        let resDic = self.removeNullFromDict(dict: rsDic)
                        
                        self.arrListDetails = resDic.value(forKey: "listing_details") as! NSArray
                        
                        
                        if(self.onoffSwitch.isOn == false){
                            
                            
                            let givenDescriptor = NSSortDescriptor(key: "data_status", ascending: false)
                            let sortDescriptors = [givenDescriptor]
                            let ordered = self.arrListDetails.sortedArray(using: sortDescriptors)
                            
                            self.clearData()
                            // self.saveInCoreDataWith(array: (res.value(forKey: "listing_details") as? [[String: AnyObject]])!)
                            self.saveInCoreDataWith(array: (ordered as? [[String: AnyObject]])!)
                            
                        }else{
                            
                            let predicate = NSPredicate(format:"data_status == 1")
                            let filteredArray = self.arrListDetails.filtered(using: predicate) as NSArray
                            print(filteredArray)
                            
                            let givenDescriptor = NSSortDescriptor(key: "data_status", ascending: false)
                            let sortDescriptors = [givenDescriptor]
                            let ordered = filteredArray.sortedArray(using: sortDescriptors)
                            self.clearData()
                            self.saveInCoreDataWith(array: (ordered as? [[String: AnyObject]])!)
                            
                            
                        }
                    
                        print(self.arrListDetails)
                      /*  self.collection.reloadData()*/
                        
                      
                      //  self.getImageArray()
                        self.collection.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            
                            self.spinner.endRefreshing()
                            self.viewSpinner.isHidden = true
                           
                        }
                
                    }else{
                        print("No Data Found")
                    }
                    
            }
        
       /* }else{
            
            isOnState = true
            let url = "https://wheretowheel.us/api/hotels/listview?category_id=\(catid)&lat=\(lat)&lon=\(long)"
          //  let url = "https://wheretowheel.us/api/hotels/listview?category_id=\(catid)&lat=42.35843&lon=-71.05977"
            
            AF.request(url, method: .post, parameters: [:]).responseJSON { response in
            

                if response.value != nil {
                    
    
                    let responseData = response.value as! NSDictionary
                  
                    let res = responseData.value(forKey: "response") as! NSDictionary
                    self.arrListDetails = res.value(forKey: "listing_details") as! NSArray
                    self.clearData()
                    self.saveInCoreDataWith(array: (res.value(forKey: "listing_details") as? [[String: AnyObject]])!)
                    self.getImageArray()
                    self.collection.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                        
                        self.spinner.endRefreshing()
                        self.viewSpinner.isHidden = true
                       
                    }
                }
            }
        }*/
    }
    

    func mapAPI(){
        
        let url = "https://wheretowheel.us/api/hotels/location_search?category_id=\(catid)&lat=\(lat)&lon=\(long)"
        
   // let url = "https://wheretowheel.us/api/hotels/location_search?category_id=\(catid)&lat=42.19141320477831&lon=-70.99167370946718"
        
        AF.request(url, method: .post, parameters: [:]).responseJSON { response in
            
            if response.value != nil {
                
                
                let responseData = response.value as! NSDictionary
                let res = responseData.value(forKey: "response") as! NSDictionary
                let status = res.value(forKey: "status") as! Int
                
                if(status != 0){
                    
                    self.arrServerData = res.value(forKey: "listing_details") as! NSArray
                    self.arrYelpData = responseData.value(forKey: "yelp_data") as! NSArray
                    
                    print(responseData)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { // Change `2.0` to the desired number of seconds.
                       
                        self.setPinOnMap()
                    }

                }
            
            }
        }
    }
    
    func setPinOnMap(){
        
        //for data in arrYelpData {
        for (index, data) in arrYelpData.enumerated() {
            
            let dict = data as! NSDictionary
            
            let rsDic = dict.mutableCopy() as! NSMutableDictionary
            let resDic = self.removeNullFromDict(dict: rsDic)
            
            let lat = resDic.value(forKey: "latitude") as! CLLocationDegrees
            let lon = resDic.value(forKey: "longitude") as! CLLocationDegrees
            let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let london = GMSMarker(position: position)
          // london.title = "London"
            london.title = resDic.value(forKey: "item_name") as? String
            london.snippet = resDic.value(forKey: "address") as? String
            london.userData = index
            london.icon = UIImage(named: "pin1")
            london.map = map
            //london.index(ofAccessibilityElement: 0)
            
            
        }
        
      //  for data1 in arrServerData {
          for (index, data1) in arrServerData.enumerated() {
            
            let dict = data1 as! NSDictionary
            
            let rsDic = dict.mutableCopy() as! NSMutableDictionary
            let resDic = self.removeNullFromDict(dict: rsDic)

            
          //  let lat = dict.value(forKey: "latitude") as! CLLocationDegrees
         //   let lon = dict.value(forKey: "longitude") as! CLLocationDegrees
            
           let lat1 : NSString = resDic.value(forKey: "latitude") as! NSString
           let lng1 : NSString = resDic.value(forKey: "longitude") as! NSString

            let latitude:CLLocationDegrees =  lat1.doubleValue
            let longitude:CLLocationDegrees =  lng1.doubleValue
            
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let london = GMSMarker(position: position)
           // london.title = "London"
            london.title = resDic.value(forKey: "name") as? String
            london.snippet = resDic.value(forKey: "address") as? String
            london.icon = UIImage(named: "marker_wtw")
            london.userData = index
            london.map = map
        
            
            
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
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        print(marker)
        let n = marker.userData as! Int
        markerPosiion = n
        let image = marker.icon!
        
        if(image == UIImage(named: "marker_wtw")) {
            
            let data = arrServerData[markerPosiion] as! NSDictionary
            
            let rsDic = data.mutableCopy() as! NSMutableDictionary
            let resDic = self.removeNullFromDict(dict: rsDic)
            
            listId = resDic.value(forKey: "id") as? String ?? ""
            performSegue(withIdentifier: "DetailViewController", sender: self)
            
        }else{
            
            let data = arrYelpData[markerPosiion] as! NSDictionary
            
            let rsDic = data.mutableCopy() as! NSMutableDictionary
            let resDic = self.removeNullFromDict(dict: rsDic)
            
            listId = resDic.value(forKey: "yelp_id") as? String ?? ""
            performSegue(withIdentifier: "searchMapDetail", sender: self)
            
        }
        
    
       
        
         /*let datastatus = data.value(forKey: "data_status") as! Int
        
        let data = arrServerData[markerPosiion] as! NSDictionary
        
       
        
        
        
        listId = data.value(forKey: "id") as? String ?? ""
        
       
        
        if(datastatus == 2){
            
            performSegue(withIdentifier: "searchMapDetail", sender: self)
            
        }else{
            
            
        }*/
        
        
        
    }
    

    func getImageArray(){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        request.returnsObjectsAsFaults = false
        let image = UIImageView()
        let indicator = UIActivityIndicatorView()
         do {
                   let result = try CoreDataStack.sharedInstance.persistentContainer.viewContext.fetch(request)
                   for data in result as! [NSManagedObject] {
                    
                    if let url1 = data.value(forKey: "imgURL"){
                            
                            let url : NSString = url1 as! NSString
                            let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                            let searchURL : NSURL = NSURL(string: urlStr as String)!
                            //cell.imgBig.image = UIImage(named: "Splash")
                            self.downloadImage(from: searchURL as URL, imageview: image, indicator: indicator)
                            
                        }
                    
                    
                    
                 }
              
               } catch {
                
                   
                   print("Failed")
               }
        
    }
    
    
    private func clearData() {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: List.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    private func createPhotoEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: "List", into: context) as? List {
          
            photoEntity.distance = "\(dictionary["distance"] ?? 0.0 as AnyObject)"
            photoEntity.imgURL = dictionary["img"] as? String
            photoEntity.name = dictionary["name"] as? String
            photoEntity.state = dictionary["state"] as? String
            photoEntity.city = dictionary["city"] as? String
            photoEntity.zipcode = dictionary["zipcode"] as? String
            photoEntity.id = dictionary["id"] as? String
            photoEntity.portal_id = "\(dictionary["portal_id"] ?? 0 as AnyObject)"
            photoEntity.status = "\(dictionary["data_status"] ?? 1 as AnyObject)"
            
            
            return photoEntity
        }
        return nil
    }
    
    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createPhotoEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
          
        } catch let error {
            print(error)
        }
        
      //  collection.reloadData()
    }
    
    
    @IBAction func changeSwiftState(_ sender: Any) {
        
        viewSpinner.isHidden = false
        spinner.beginRefreshing()
        ApiCall()
        collection.reloadData()
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        
        
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.makeRootViewController()
        
    }
    
    @IBAction func onClickNearMe(_ sender: Any) {
        
        print("Im from Dashboard")
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
    
    @objc @IBAction func onClickBookTable(_ sender: UIButton) {
        
        let login = UserDefaults.standard.bool(forKey: "isLogin")
        
        if login {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
                  /* let sortDescriptor = NSSortDescriptor(key: "status", ascending: false,
                                                         selector: #selector(NSString.localizedStandardCompare(_:)))*/
            
                   
                   let sortDescriptor1 = NSSortDescriptor(key: "distance", ascending: true,
                   selector: #selector(NSString.localizedStandardCompare(_:)))
    
                   request.sortDescriptors = [sortDescriptor1]
                   //request.sortDescriptors = [sortDescriptor]
                   request.returnsObjectsAsFaults = false
                   do {
                       let result = try CoreDataStack.sharedInstance.persistentContainer.viewContext.fetch(request)
                       
                       let data:NSManagedObject = result[sender.tag] as! NSManagedObject
                       listId = data.value(forKey: "id") as! String
                       portalId = data.value(forKey: "portal_id") as! String
                       
                   } catch {
                       
                       print("Failed")
                   }
               
                   self.performSegue(withIdentifier: "booktable", sender: self);
                   
           
        }else{
            
            
            self.showAlertWith(title: "Go", message: "Please Login or SignUp First...")
            
        }
        
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
        
            guard let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
                return
            }
            self.changeMainViewController(to: tabViewController)
            
        }
        let action2 = UIAlertAction(title: "Cancel", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func changeMainViewController(to viewController: UIViewController) {
        //Change main viewcontroller of side menu view controller
        let navigationViewController = UINavigationController(rootViewController: viewController)
        slideMenuController()?.changeMainViewController(navigationViewController, close: true)
    }
    
    func downloadImage(from url: URL,imageview : UIImageView,indicator : UIActivityIndicatorView) {
        
       let delegate = UIApplication.shared.delegate as! AppDelegate
    
        let imgcatch1 = delegate.imageCache1
        imageview.image = nil
       
       
        
        let urlstring = "\(url)"
        if let cachedImage = imgcatch1.object(forKey: urlstring as NSString) {
            print("catch loded %@",urlstring)
            indicator.color = .clear
            imageview.image = cachedImage
            
            return
        }
        
        
        
        if let url = URL(string:  (urlstring as NSString) as String) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
             
               
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                   
                    DispatchQueue.main.async {
                        imageview.image = UIImage(named: "placeholder")
                    }
                    return
                }
                
               
                
                DispatchQueue.main.async {
                    if let data = data {
                        
                        if let downloadedImage = UIImage(data: data) {
                            
                            print("catch string : %@",urlstring)
                            delegate.imageCache1.setObject(downloadedImage, forKey: NSString(string: urlstring))
                            imageview.image = downloadedImage
                            indicator.color = .clear
                           
                        }
                    }
                }
                
            }).resume()
        }
        
       
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
       /* if(onoffSwitch.isOn == false){
            
            return arrListDetails.count;
            
        }else{
            
            return count
        }*/
        
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
        let dictTemp = arrListDetails[indexPath.item] as! NSDictionary
        cell.btnBookTable.addTarget(self, action: #selector(onClickBookTable), for: .touchUpInside)
        cell.btnBookTable.tag = indexPath.item
        cell.btnBookTable.layer.cornerRadius = cell.btnBookTable.frame.size.height/2
        
        if(catid == "1"){
            
            cell.btnBookTable.isHidden = false
            
        }else{
            
            cell.btnBookTable.isHidden = true
            
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        let sortDescriptor = NSSortDescriptor(key: "status", ascending: false,
                                                     selector: #selector(NSString.localizedStandardCompare(_:)))
        
        let sortDescriptor1 = NSSortDescriptor(key: "distance", ascending: true,
        selector: #selector(NSString.localizedStandardCompare(_:)))
        
        //request.sortDescriptors = [sortDescriptor,sortDescriptor1]
        request.sortDescriptors = [sortDescriptor1]
        request.returnsObjectsAsFaults = false
        do {
            let result = try CoreDataStack.sharedInstance.persistentContainer.viewContext.fetch(request)
            
            let data:NSManagedObject = result[indexPath.item] as! NSManagedObject
            
            
            
            cell.lblName.text = data.value(forKey: "name") as? String
            cell.lbldesc.text = "\(data.value(forKey: "city") as? String ?? ""),\(data.value(forKey: "state") as? String ?? "")"
            cell.lblMI.text = data.value(forKey: "distance") as? String
            cell.lblNumber.text = data.value(forKey: "zipcode") as? String
            
            if(data.value(forKey: "status") as! String == "2"){
                
                cell.imgAppIcon.image = UIImage(named: "yelp_icon")
                cell.btnBookTable.isHidden = true
                
            }else{
                
                
                cell.imgAppIcon.image = UIImage(named: "appicon")
                cell.btnBookTable.isHidden = false
            }
            
            if let url1 = data.value(forKey: "imgURL"){
                
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
                
            }
        } catch {
            
            print("Failed")
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
       /* guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
                   return
        }*/
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        let sortDescriptor = NSSortDescriptor(key: "status", ascending: false,
                                                     selector: #selector(NSString.localizedStandardCompare(_:)))
        
        let sortDescriptor1 = NSSortDescriptor(key: "distance", ascending: true,
        selector: #selector(NSString.localizedStandardCompare(_:)))
        
        //request.sortDescriptors = [sortDescriptor,sortDescriptor1]
        request.sortDescriptors = [sortDescriptor1]
        request.returnsObjectsAsFaults = false
        do {
            
            let result = try CoreDataStack.sharedInstance.persistentContainer.viewContext.fetch(request)
            let data:NSManagedObject = result[indexPath.item] as! NSManagedObject
            listId = data.value(forKey: "id") as! String
            
            if(data.value(forKey: "status") as! String == "2"){
                
                 performSegue(withIdentifier: "searchMapDetail", sender: self)
                
            }else{
                
                 performSegue(withIdentifier: "DetailViewController", sender: self)
            }
    
            
        } catch {
            
            print("Failed")
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
     //   if(isOnState == true) {
            
            
            if (segue.identifier == "DetailViewController") {
                
                let vc = segue.destination as! DetailViewController
                vc.listId = listId
                vc.catid = catid
               
                
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
            
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                        zoom: 13)
            
            /* let camera = GMSCameraPosition.camera(withLatitude: 42.35843,
                          longitude: -71.05977,
                             zoom: 13)*/
            
                  map.camera = camera
                  let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                  let london = GMSMarker(position: position)
                  //london.title = "London"
                 // london.icon = UIImage(named: "pin")
                  london.map = map 
        }
        
        ApiCall()
        mapAPI()
    
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
