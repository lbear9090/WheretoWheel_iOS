
import UIKit
import GoogleMaps
import Alamofire
import RAMAnimatedTabBarController

class SearchController: SideBaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,GMSMapViewDelegate {
    
    
    @IBOutlet weak var btnMapBack: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var map: GMSMapView!
    
    @IBOutlet weak var lblPleaseWait: UILabel!
    @IBOutlet weak var viewPleaseWait: UIView!
    @IBOutlet weak var viewSpinner: UIView!
    
    @IBOutlet weak var tblSearch: UITableView!
    var arrListDetails = NSArray()
    var arrPlace = NSArray()
    var searchText = ""
    var latitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    var locationManager = CLLocationManager()
    var markerPosiion = 0
    var spinner = JTMaterialSpinner()
    var listId = "0"
    
    //MARK:- UIViewController Initialize Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = LeftMenuItems.pinTab.rawValue
        loadAllMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.SelectedIndex = 1
        appdelegate!.isProfile = false
    }
    
    func loadAllMethod(){
        
        map.isHidden = true
        viewSearch.layer.cornerRadius = viewSearch.frame.size.height/2
        viewSearch.layer.borderWidth = 1.0
        viewSearch.layer.borderColor = UIColor.black.cgColor
        setToolBar()
        map.delegate = self
        tblSearch.delegate = self
        tblSearch.dataSource = self
        
    }
    
    func setToolBar(){
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            // UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtSearch.inputAccessoryView = numberToolbar
      

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
    
    @objc func doneWithNumberPad() {

        txtSearch.text = ""
        tblSearch.isHidden = true
        self.view.endEditing(true)
        
    }
    
    func searchApi(){
        
        
        let url = "https://wheretowheel.us/api/hotels/search_place?place=\(searchText)"
        
        
        AF.request(url, method: .post, parameters: [:]).responseJSON { response in
            
            
            if response.value != nil {
                
                let responseData = response.value as! NSDictionary
                let res = responseData.value(forKey: "response") as! NSDictionary
                
                let rsDic = res.mutableCopy() as! NSMutableDictionary
                let resDic = self.removeNullFromDict(dict: rsDic)
                
                self.arrListDetails = resDic.value(forKey: "listing_details") as! NSArray
                self.tblSearch.isHidden = false
                self.tblSearch.reloadData()
            
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
    
    func placeApi(){
        
        
        let url = "https://wheretowheel.us/api/hotels/location_search?lat=\(latitude ?? 0.0)&lon=\(longitude ?? 0.0)"
        
        var firstLocation = CLLocationCoordinate2D()
        AF.request(url, method: .post, parameters: [:]).responseJSON { response in
            
            
            if response.value != nil {
                
                let responseData = response.value as! NSDictionary
                let res = responseData.value(forKey: "response") as! NSDictionary
                
                let rsDic = res.mutableCopy() as! NSMutableDictionary
                let resDic = self.removeNullFromDict(dict: rsDic)
                
                let arrTemp = resDic.value(forKey: "listing_details") as! NSArray
                self.arrPlace = arrTemp
                print(arrTemp)
                
                if(arrTemp.count > 0){
                    
                    for n in 0...arrTemp.count - 1 {
                        
                        let dic = arrTemp[n] as! NSDictionary
                        
                     //   let lat : NSString = dic.value(forKey: "latitude") as! NSString
//                        let lon : NSString = dic.value(forKey: "longitude") as! NSString
                         
                        let lat = dic.value(forKey: "latitude")
                        let lon = dic.value(forKey: "longitude")
                        
                        if let l1 = lat as? String, let lo1 = lon as? String {
                            
                            let lat1 : NSString = l1 as NSString
                            let lon1 : NSString = lo1 as NSString
                            
                            let position = CLLocationCoordinate2D(latitude: lat1.doubleValue,longitude: lon1.doubleValue)
                            let london = GMSMarker(position: position)
                            london.title = dic.value(forKey: "name") as? String
                            london.snippet = dic.value(forKey: "address") as? String
                            
                            let status = dic.value(forKey: "data_status") as! Int
                            
                            if(status == 2){
                                
                                london.icon = UIImage(named: "pin1")
                            }else{
                                
                                london.icon = UIImage(named: "marker_wtw")
                            }
                            
                            london.map = self.map
                            london.userData = n
                            
                            if(n == 0){
                                
                                firstLocation = (london as GMSMarker).position
                            }
                            
                            var bounds1 = GMSCoordinateBounds(coordinate: firstLocation,coordinate: firstLocation)
                            
                            
                            bounds1 = bounds1.includingCoordinate(london.position)
                            
                            let update = GMSCameraUpdate.fit(bounds1, withPadding: CGFloat(15))
                            self.map.animate(with: update)
                            
                            
                        }
                        
                        if let l1 = lat as? Double,let lo1 = lon as? Double{
                            
                            
                            let position = CLLocationCoordinate2D(latitude: l1,longitude: lo1)
                            let london = GMSMarker(position: position)
                            london.title = dic.value(forKey: "name") as? String
                            london.snippet = dic.value(forKey: "address") as? String
                            
                            let status = dic.value(forKey: "data_status") as! Int
                            
                            if(status == 2){
                                
                                london.icon = UIImage(named: "pin1")
                            }else{
                                
                                london.icon = UIImage(named: "marker_wtw")
                            }
                           // london.icon = UIImage(named: "pin1")
                            london.map = self.map
                            london.userData = n
                            
                            if(n == 0){
                                
                                firstLocation = (london as GMSMarker).position
                            }
                            
                            var bounds1 = GMSCoordinateBounds(coordinate: firstLocation,coordinate: firstLocation)
                            
                            
                            bounds1 = bounds1.includingCoordinate(london.position)
                            
                            let update = GMSCameraUpdate.fit(bounds1, withPadding: CGFloat(15))
                            self.map.animate(with: update)
                            
                        }
                        
                        
                        
                        
                        
                      /*  guard let latitude:CLLocationDegrees =  (dic.value(forKey: "latitude") as! CLLocationDegrees) else{
                            
                            return
                        }
                        
                        guard let longitude:CLLocationDegrees = (dic.value(forKey: "longitude") as! CLLocationDegrees) else{
                            
                            return
                        }*/
                        
                       
                       
                    }
                    
                }
                self.tblSearch.isHidden = true
                self.map.isHidden = false
                self.btnMapBack.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    
                    self.spinner.endRefreshing()
                   self.viewSpinner.isHidden = true
                    
                }
                
                
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("Tapped")
        let n = marker.userData as! Int
        markerPosiion = n
       // performSegue(withIdentifier: "mapDetail", sender: self)
        
        let data = arrPlace[markerPosiion] as! NSDictionary
        listId = data.value(forKey: "id") as? String ?? ""
        
        let datastatus = data.value(forKey: "data_status") as! Int
        
        if(datastatus == 2){
            
            performSegue(withIdentifier: "mapDetail", sender: self)
            
        }else{
            
            performSegue(withIdentifier: "DetailViewController", sender: self)
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "mapDetail") {
            let vc = segue.destination as! SearchMapDetailViewController
            vc.id = listId
        }
        
        if (segue.identifier == "DetailViewController") {
            
            let vc = segue.destination as! DetailViewController
            vc.listId = listId
        }
    }
    
    
    func focusMapToShowMarkers(markers: [GMSMarker]) {

        guard let currentUserLocation = locationManager.location?.coordinate else {
            return
        }

        var bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: currentUserLocation,
                                                              coordinate: currentUserLocation)

        _ = markers.map {
            bounds = bounds.includingCoordinate($0.position)
            self.map.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 15.0))
        }
    }
    
    
    
    @IBAction func onClickMapBack(_ sender: Any) {
        
        map.clear()
       // map = nil
        txtSearch.text = ""
        tblSearch.isHidden = true
        map.isHidden = true
        btnMapBack.isHidden = true
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
    
        let tabbar = self.navigationController?.tabBarController as! CustomTabBarViewController
        tabbar.setSelectIndex(from: 1, to: 0)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrListDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        as! SearchCell
        
        let dictTemp = arrListDetails[indexPath.row] as! NSDictionary
        cell.lblName.text = dictTemp.value(forKey: "place_name") as? String
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let dictTemp = arrListDetails[indexPath.row] as! NSDictionary
      //   let lat1 : NSString = dictTemp.value(forKey: "lat") as! NSString
      //   let lng1 : NSString = dictTemp.value(forKey: "long") as! NSString
        latitude =  dictTemp.value(forKey: "lat") as? CLLocationDegrees
        longitude = dictTemp.value(forKey: "long") as? CLLocationDegrees
        self.tblSearch.isHidden = true
        self.map.isHidden = false
        loadLoader()
        placeApi()
        doneWithNumberPad()
         
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        searchText = textField.text! + string
        searchApi()
        return true
    }
    
    func changeMainViewController(to viewController: UIViewController) {
           //Change main viewcontroller of side menu view controller
           let navigationViewController = UINavigationController(rootViewController: viewController)
           slideMenuController()?.changeMainViewController(navigationViewController, close: true)
    }
       
}
