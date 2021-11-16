
import UIKit
import Alamofire
import CoreLocation
import Photos
import AVKit
import DKImagePickerController
import Foundation
import GooglePlaces


class AddListViewController: SideBaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate,DKImageAssetExporterObserver {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAddLocation: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var lblSelectLocation: UILabel!
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var scrollData: UIScrollView!
    @IBOutlet weak var LastView: UIView!
    
    
    var dictselectedData = NSMutableDictionary()
    var arrListDetails = NSArray()
    var searchText = ""
    var imagePicker: UIImagePickerController!
    var arrListingImages = NSMutableArray()
    var arrImageData = NSMutableArray()
    
    var arrBase64String = NSMutableArray()
    var arrBase64StringOLDImage = NSMutableArray()
    var ImageBaseString = ""
    var locationManager = CLLocationManager()
    var lat = Double()
    var long = Double()
    
    var pickerController: DKImagePickerController!
    var assets: [DKAsset]?
    var exportManually = false
    var count = 0
    var ans = Int()
    var maxReturnCount = Int()
    var placesClient = GMSPlacesClient()
    var predictions: [GMSAutocompletePrediction] = []
    
    enum ImageSource {
        case photoLibrary
        case camera
    }

    
    // HC Parking
    @IBOutlet weak var HCParking_rate1: UIImageView!
    @IBOutlet weak var HCParking_rate2: UIImageView!
    @IBOutlet weak var HCParking_rate3: UIImageView!
    @IBOutlet weak var HCParking_rate4: UIImageView!
    @IBOutlet weak var HCParking_rate5: UIImageView!
    
    @IBOutlet weak var HCParking_located1: UIImageView!
    @IBOutlet weak var HCParking_located2: UIImageView!
    @IBOutlet weak var HCParking_located3: UIImageView!
    @IBOutlet weak var HCParking_located4: UIImageView!
    
    // HC Entrance
    
    @IBOutlet weak var HCEntrance_rate1: UIImageView!
    @IBOutlet weak var HCEntrance_rate2: UIImageView!
    @IBOutlet weak var HCEntrance_rate3: UIImageView!
    @IBOutlet weak var HCEntrance_rate4: UIImageView!
    @IBOutlet weak var HCEntrance_rate5: UIImageView!
    
    @IBOutlet weak var HCEntrance_located1: UIImageView!
    @IBOutlet weak var HCEntrance_located2: UIImageView!
    @IBOutlet weak var HCEntrance_located3: UIImageView!
    @IBOutlet weak var HCEntrance_located4: UIImageView!
    @IBOutlet weak var HCEntrance_located5: UIImageView!
    @IBOutlet weak var HCEntrance_located6: UIImageView!
    
    @IBOutlet weak var HCEntrance_type1: UIImageView!
    @IBOutlet weak var HCEntrance_type2: UIImageView!
    @IBOutlet weak var HCEntrance_type3: UIImageView!
    @IBOutlet weak var HCEntrance_type4: UIImageView!
    @IBOutlet weak var HCEntrance_type5: UIImageView!
    
    @IBOutlet weak var HCEntrance_doortype1: UIImageView!
    @IBOutlet weak var HCEntrance_doortype2: UIImageView!
    @IBOutlet weak var HCEntrance_doortype3: UIImageView!
    
    @IBOutlet weak var HCEntrance_width1: UIImageView!
    @IBOutlet weak var HCEntrance_width2: UIImageView!
    @IBOutlet weak var HCEntrance_width3: UIImageView!
    
    
    // Spaciousness
    
    @IBOutlet weak var Spaciousness_rate1: UIImageView!
    @IBOutlet weak var Spaciousness_rate2: UIImageView!
    @IBOutlet weak var Spaciousness_rate3: UIImageView!
    @IBOutlet weak var Spaciousness_rate4: UIImageView!
    @IBOutlet weak var Spaciousness_rate5: UIImageView!
    
    @IBOutlet weak var Spaciousness_venue1: UIImageView!
    @IBOutlet weak var Spaciousness_venue2: UIImageView!
    @IBOutlet weak var Spaciousness_venue3: UIImageView!
    
    // Seating
    
    @IBOutlet weak var Seating_rate1: UIImageView!
    @IBOutlet weak var Seating_rate2: UIImageView!
    @IBOutlet weak var Seating_rate3: UIImageView!
    @IBOutlet weak var Seating_rate4: UIImageView!
    @IBOutlet weak var Seating_rate5: UIImageView!
    
    @IBOutlet weak var Seating_located1: UIImageView!
    @IBOutlet weak var Seating_located2: UIImageView!
    @IBOutlet weak var Seating_located3: UIImageView!
    @IBOutlet weak var Seating_located4: UIImageView!
    
    
    // Bathroom
    
    @IBOutlet weak var Bathroom_rate1: UIImageView!
    @IBOutlet weak var Bathroom_rate2: UIImageView!
    @IBOutlet weak var Bathroom_rate3: UIImageView!
    @IBOutlet weak var Bathroom_rate4: UIImageView!
    @IBOutlet weak var Bathroom_rate5: UIImageView!
    
    @IBOutlet weak var Bathroom_door1: UIImageView!
    @IBOutlet weak var Bathroom_door2: UIImageView!
    @IBOutlet weak var Bathroom_door3: UIImageView!
    @IBOutlet weak var Bathroom_door4: UIImageView!
    
    @IBOutlet weak var Bathroom_opening1: UIImageView!
    @IBOutlet weak var Bathroom_opening2: UIImageView!
    @IBOutlet weak var Bathroom_opening3: UIImageView!
    
    @IBOutlet weak var Bathroom_stall1: UIImageView!
    @IBOutlet weak var Bathroom_stall2: UIImageView!
    @IBOutlet weak var Bathroom_stall3: UIImageView!
    
    @IBOutlet weak var Bathroom_amenities1: UIImageView!
    @IBOutlet weak var Bathroom_amenities2: UIImageView!
    @IBOutlet weak var Bathroom_amenities3: UIImageView!
    
    @IBOutlet weak var Bathroom_changtable1: UIImageView!
    @IBOutlet weak var Bathroom_changtable2: UIImageView!
    @IBOutlet weak var Bathroom_changtable3: UIImageView!
    
    // Ramp
    @IBOutlet weak var Ramp_rate1: UIImageView!
    @IBOutlet weak var Ramp_rate2: UIImageView!
    @IBOutlet weak var Ramp_rate3: UIImageView!
    @IBOutlet weak var Ramp_rate4: UIImageView!
    @IBOutlet weak var Ramp_rate5: UIImageView!
    
    @IBOutlet weak var Ramp_steepness1: UIImageView!
    @IBOutlet weak var Ramp_steepness2: UIImageView!
    @IBOutlet weak var Ramp_steepness3: UIImageView!
    @IBOutlet weak var Ramp_steepness4: UIImageView!
    
    // Elevator
    @IBOutlet weak var Elevator_rate1: UIImageView!
    @IBOutlet weak var Elevator_rate2: UIImageView!
    @IBOutlet weak var Elevator_rate3: UIImageView!
    @IBOutlet weak var Elevator_rate4: UIImageView!
    @IBOutlet weak var Elevator_rate5: UIImageView!
    
    @IBOutlet weak var Elevator_spaciousness1: UIImageView!
    @IBOutlet weak var Elevator_spaciousness2: UIImageView!
    @IBOutlet weak var Elevator_spaciousness3: UIImageView!
    @IBOutlet weak var Elevator_spaciousness4: UIImageView!
    
    // Mobility
    
    @IBOutlet weak var Mobility_type1: UIImageView!
    @IBOutlet weak var Mobility_type2: UIImageView!
    @IBOutlet weak var Mobility_type3: UIImageView!
    @IBOutlet weak var Mobility_type4: UIImageView!
    @IBOutlet weak var Mobility_type5: UIImageView!
    @IBOutlet weak var Mobility_type6: UIImageView!
    
    @IBOutlet weak var txtFeedback: UITextView!
    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var btnAddListing: UIButton!
    
    @IBOutlet weak var lblPleaseWait: UILabel!
    @IBOutlet weak var viewPleaseWait: UIView!
    @IBOutlet weak var viewSpinner: UIView!
    
    var spinner = JTMaterialSpinner()
    
    let sentryManager = SentryManager()
    let debouncer = Debouncer(timeInterval: 0.01)
    
    var elevator_rate = 0.0
    var ramp_rate = 0.0
    var bathroom_rate = 0.0
    var seating_rate = 0.0
    var venue_rate = 0.0
    var entrance_rate = 0.0
    var parking_rate = 0.0
    
    var entrance = ""
    var location_of_handicapped_parking = ""
    var new_hc_entrance = ""
    var door_entrance = ""
    var width_entrance = ""
    var spaciousness_of_venue = ""
    var seating_located = ""
    var bathroom_opening_directions = ""
    var ease_of_opening = ""
    var size_of_stal = ""
    var aminities = ""
    var changing_table = ""
    var steepness_of_the_ramp = ""
    var size_of_the_elevator = ""
    var mobility = ""
    
    var locationname = ""
    var address = ""

    
    //var alertDelegate:CommonAlertprotocol?
    
    //MARK:- UIViewController Initialize Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = LeftMenuItems.addListTab.rawValue
        locationManager.delegate = self
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        loadAllMethods()
    }
    
    deinit {
        DKImagePickerControllerResource.customLocalizationBlock = nil
        DKImagePickerControllerResource.customImageBlock = nil
        
        DKImageExtensionController.unregisterExtension(for: .camera)
        DKImageExtensionController.unregisterExtension(for: .inlineCamera)
        
        DKImageAssetExporter.sharedInstance.remove(observer: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.SelectedIndex = 3
        appdelegate!.isProfile = false
        txtSearch.text = ""
        arrListingImages = []
        
    }
    
    func loadAllMethods(){
        
       // lat = 42.19141320477831
       // long = -70.99167370946718
        
        viewSearch.layer.cornerRadius = 18.0
        viewSearch.layer.borderWidth = 1.0
        viewSearch.layer.borderColor = UIColor.gray.cgColor
        btnAddLocation.layer.cornerRadius = 20.0
        setToolBar()
        tblSearch.isHidden = true
        tblSearch.delegate = self
        tblSearch.dataSource = self
        collection.delegate = self
        collection.dataSource = self
        scrollData.isHidden = true
        scrollData.contentSize = CGSize(width: 0, height: LastView.frame.origin.y + LastView.frame.size.height)
        txtFeedback.layer.cornerRadius = 5.0
        txtFeedback.layer.borderColor = UIColor.lightGray.cgColor
        txtFeedback.layer.borderWidth = 1.0
        btnAddPhoto.layer.cornerRadius = btnAddPhoto.frame.size.height/2
        btnAddListing.layer.cornerRadius = btnAddListing.frame.size.height/2
        
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
        txtFeedback.inputAccessoryView = numberToolbar
    }
    
    @objc func doneWithNumberPad() {
        print("arrListDetails.count is---- ",arrListDetails.count)
//        txtSearch.text = ""
//        tblSearch.isHidden = true
        self.view.endEditing(true)
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
       
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            
           self.spinner.endRefreshing()
           self.viewSpinner.isHidden = true
            
        }*/
        
    }
    
    func searchApi(){
        
//        let filter = GMSAutocompleteFilter()
//        filter.type = .establishment
//        filter.country = Locale.current.regionCode
//
//        placesClient.findAutocompletePredictions(fromQuery: searchText, filter: filter, sessionToken: nil) { prediction, error in
//            if let prediction = prediction {
//                self.predictions = prediction
//            } else {
//                self.predictions.removeAll()
//            }
//            self.tblSearch.isHidden = false
//            self.tblSearch.reloadData()
//        }
//
//        guard predictions.isEmpty else { return }
//        let newFilter = GMSAutocompleteFilter()
//        newFilter.type = .establishment
//        placesClient.findAutocompletePredictions(fromQuery: searchText, filter: newFilter, sessionToken: nil) { prediction, error in
//            if let prediction = prediction {
//                self.predictions = prediction
//                if self.predictions.isEmpty {
//                    let filter = GMSAutocompleteFilter()
//                    filter.type = .establishment
//                    self.placesClient.findAutocompletePredictions(fromQuery: self.searchText, filter: filter, sessionToken: nil) { prediction, error in
//                        if let prediction = prediction {
//                            self.predictions = prediction
//                        } else {
//                            self.predictions.removeAll()
//                        }
//                    }
//                }
//            } else {
//                self.predictions.removeAll()
//            }
//            self.tblSearch.isHidden = false
//            self.tblSearch.reloadData()
//        }
        
        guard searchText.count > 2 else { return }
        
        let url = "https://wheretowheel.us/api/hotels/location_search_v2?name=\(searchText)&lat=\(lat)&lon=\(long)"
        
        AF.request(url, method: .post, parameters: [:]).responseJSON { response in

            if response.value != nil {

                let sentryMessage = SentryManager.Message(state: .success, request: response.request, response: response.response, responseData: response.data!, level: .info)
                self.sentryManager.log(with: sentryMessage)

                let responseData = response.value as! NSDictionary
                let res = responseData.value(forKey: "response") as! NSDictionary

                let rsDic = res.mutableCopy() as! NSMutableDictionary
                let resDic = self.removeNullFromDict(dict: rsDic)
                print(resDic)
                let status = String(describing: resDic["status"]!)
                if( String(describing: status) == "1"){
                    //change on 07.01.2021
                    self.arrListDetails = []
                    ///***************
                    self.arrListDetails = resDic.value(forKey: "listing_details") as! NSArray
                    if(self.arrListDetails.count == 0){

                        self.tblSearch.isHidden = true
                        self.btnAddLocation.isUserInteractionEnabled = false
                       /*let alert = UIAlertController(title: "search data not found", message: "", preferredStyle: .actionSheet)
                       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                       self.present(alert, animated: true, completion: nil)*/

                    }else{
                        self.btnAddLocation.isUserInteractionEnabled = true
                        self.tblSearch.isHidden = false
                        self.tblSearch.reloadData()

                    }
                }else{
                    self.tblSearch.isHidden = true
                    self.btnAddLocation.isUserInteractionEnabled = false
                     /*let alert = UIAlertController(title: "search data not found", message: "", preferredStyle: .actionSheet)
                     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                     self.present(alert, animated: true, completion: nil)*/

                    /* let alert = UIAlertView()
                     alert.title = "Where To Wheel"
                     alert.message = "search data not found"
                     alert.addButton(withTitle: "Ok")
                     alert.show()*/
                }
            }
        }
    }
    
   /* func addListingApi(){
        
        
        guard let userid = UserDefaults.standard.value(forKey: "userid") else {
           
            
            return
        }
        
        // specific selected search user id
       // let userId = dictselectedData.value(forKey: "user_id") as! String
        
        // login user id
        let userId = userid
        let locationname = dictselectedData.value(forKey: "location_name") as! String
        let address = dictselectedData.value(forKey: "address") as! String
        let lat = dictselectedData.value(forKey: "latitude") as? String
        let long = dictselectedData.value(forKey: "longitude") as? String
        
        
        let url = "https://wheretowheel.us/api/user/add_listing_req"
        let parameters: Parameters = ["user_id" : userId, "location_name" : locationname, "address" : address, "latitude" : "\(lat ?? "")", "longitude" : "\(long ?? "")", "hc_parking_rating" : "\(parking_rate)", "location_of_handicapped_parking" : location_of_handicapped_parking, "handicapped_accessible_entrance" : "", "rate_entrance" : "\(entrance_rate)", "entrance" : entrance, "door_entrance" : door_entrance, "width_of_entrance" : width_entrance, "rate_venue_specious" : "\(venue_rate)", "spaciousness_of_venue" : spaciousness_of_venue, "rate_acc_setting" : "\(seating_rate)", "located" : seating_located, "rate_acc_bathroom" : "\(bathroom_rate)", "entrance_opening_directions" : bathroom_opening_directions, "ease_of_opening" : ease_of_opening , "size_of_stall" : size_of_stal, "accessible_bathroom_amenities" : aminities, "changing_table" : changing_table, "rate_ramp" : "\(ramp_rate)", "steepness_of_the_ramp" : steepness_of_the_ramp, "rate_elevator" : "\(elevator_rate)", "size_of_the_elevator" : size_of_the_elevator, "mobility" : mobility, "new_hc_entrance" : new_hc_entrance, "other_feedback" : txtFeedback.text!]

        AF.upload(multipartFormData: { multipartFormData in
            
            if(self.assets != nil){
                
                for item in self.assets! {
                    
                    let asset = item
                    let layout = self.collection.collectionViewLayout as! UICollectionViewFlowLayout
                    asset.fetchImage(with: layout.itemSize.toPixel(), completeBlock: { image, info in
                    
                           self.arrImageData.add(image!)
                    })
                }
            }
            
            for image in self.arrImageData {
                
                let imageData = UIImageJPEGRepresentation(image as! UIImage, 0.05)?.base64EncodedData()
              //  let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
                
                multipartFormData.append(imageData!, withName: "uploadimage", fileName: "image.jpg", mimeType: "image/jpeg")
               
            }
            
            for image2 in self.arrListingImages {
                
                let imageData = UIImageJPEGRepresentation(image2 as! UIImage, 0.05)
                multipartFormData.append(imageData!, withName: "uploadimage", fileName: "image.jpg", mimeType: "image/jpeg")
            }
            
            for image1 in self.arrListingImages {
                
                let imageData = UIImageJPEGRepresentation(image1 as! UIImage, 0.05)
                multipartFormData.append(imageData!, withName: "oldImage", fileName: "image.jpg", mimeType: "image/jpeg")
            }
            
            for (key, value) in parameters {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to: url)
            .responseJSON { response in
                debugPrint(response)
                print("Success: \(response.result)")
                print("Responce: \(response)")
                self.spinner.endRefreshing()
                self.viewSpinner.isHidden = true
                
                switch response.result {
                case .success:
                    print(response)
                    let alert = UIAlertController(title: "List added successfully", message: "", preferredStyle: .actionSheet)
                    //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            
                            let tabbar = self.navigationController?.tabBarController as! CustomTabBarViewController
                            tabbar.setSelectIndex(from: 1, to: 0)
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                        }}))
                    
                    self.present(alert, animated: true, completion: nil)
                    break
                    
                case .failure(let error):
                    print(error)
                }
        }
        
    } */
    
    func addListingApi(){
        
        
        guard let userid = UserDefaults.standard.value(forKey: "userid") else {
        
            return
        }
        
        // specific selected search user id
       // let userId = dictselectedData.value(forKey: "user_id") as! String
        
        // login user id
        let userId = userid
        let locationname = dictselectedData.value(forKey: "name") as! String
        let address = dictselectedData.value(forKey: "address") as! String
        let lat = dictselectedData.value(forKey: "latitude") as? String
        let long = dictselectedData.value(forKey: "longitude") as? String
        
        let requestOptions = PHImageRequestOptions()
//        requestOptions.version = .original
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.resizeMode = .exact
        requestOptions.isSynchronous = true
        requestOptions.isNetworkAccessAllowed = true
        
        
        if(self.assets != nil){
            
            
            for item in self.assets! {
                let asset = item
                asset.fetchImage(with: CGSize(width: 1080, height: 1080), options: requestOptions, completeBlock: { image, info in
                    print("Resolution is \(image?.size)")
                    let imageData = image?.jpegData(compressionQuality: 1)
                       self.arrImageData.add(imageData!)
                })
            }
        }
        
        if(self.arrImageData.count > 0){
            
            for imageData in self.arrImageData {
                let imageStr = (imageData as! Data).base64EncodedString(options: .lineLength64Characters)
                
                arrBase64String.add(imageStr)

            }
            
        }else{
            
            for image2 in self.arrListingImages {
                
                let url = image2
                let Imgview = UIImageView()
                Imgview.loadImageUsingCacheWithURLString(url as! String, placeHolder: UIImage(named: "placeholder"))
                
                let imageData = Imgview.image!.jpegData(compressionQuality: 1.0)
                let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
                 
                arrBase64String.add(imageStr)
               
            }
            
        }
       
        /*for image1 in self.arrListingImages {
            
            let url = image1
            let Imgview = UIImageView()
            Imgview.loadImageUsingCacheWithURLString(url as! String, placeHolder: UIImage(named: "placeholder"))
            
            
            let imageData = UIImageJPEGRepresentation(Imgview.image!, 0.05)
            let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
             
            arrBase64StringOLDImage.add(imageStr)
            
        }*/
        
       
       // print("\(json(from:arrBase64String as Any) ?? "")")
      //  print("\(json(from:arrBase64StringOLDImage as Any) ?? "")")
        
        // Convert to data
        
        // Add 
    
        let url = "https://wheretowheel.us/api/user/add_listing_req_new"
        let parameters: Parameters = ["user_id" : userId, "location_name" : locationname, "address" : address, "latitude" : "\(lat ?? "")", "longitude" : "\(long ?? "")", "hc_parking_rating" : "\(parking_rate)", "location_of_handicapped_parking" : location_of_handicapped_parking, "handicapped_accessible_entrance" : "", "rate_entrance" : "\(entrance_rate)", "entrance" : entrance, "door_entrance" : door_entrance, "width_of_entrance" : width_entrance, "rate_venue_specious" : "\(venue_rate)", "spaciousness_of_venue" : spaciousness_of_venue, "rate_acc_setting" : "\(seating_rate)", "located" : seating_located, "rate_acc_bathroom" : "\(bathroom_rate)", "entrance_opening_directions" : bathroom_opening_directions, "ease_of_opening" : ease_of_opening , "size_of_stall" : size_of_stal, "accessible_bathroom_amenities" : aminities, "changing_table" : changing_table, "rate_ramp" : "\(ramp_rate)", "steepness_of_the_ramp" : steepness_of_the_ramp, "rate_elevator" : "\(elevator_rate)", "size_of_the_elevator" : size_of_the_elevator, "mobility" : mobility, "new_hc_entrance" : new_hc_entrance, "other_feedback" : txtFeedback.text!, "oldImage" : ""]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (index, imageData) in self.arrImageData.enumerated() {
                multipartFormData.append(imageData as! Data, withName: "uploadimage[]", fileName: "image\(index)", mimeType: "image/jpeg")
            }
            
            for (key, value) in parameters {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url).responseJSON { response in
            if response.value != nil {
                
                print(parameters.count.byteSize)
                
                print(response.value as Any)
                self.spinner.endRefreshing()
                self.viewSpinner.isHidden = true
                let responseData = response.value as! NSDictionary
                let res = responseData.value(forKey: "response") as! NSDictionary
                let message = res.value(forKey: "message") as! String
                
                //////CHANGE on 12.01.2021
                
                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    print("Ok Pressed")
                    self.okAction()
                    }))
                /*alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    print("Cancel Pressed")
                    self.cancelAction()
                    }))*/
                self.present(alert, animated: true, completion: nil)
                
                ////////////////////////////////////////
                
                /*let alert = UIAlertController(title: message, message: "", preferredStyle: .actionSheet)
                //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        
                        let tabbar = self.navigationController?.tabBarController as! CustomTabBarViewController
                        tabbar.setSelectIndex(from: 1, to: 0)
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                    @unknown default:
                        print("default")
                    }}))
                
                self.present(alert, animated: true, completion: nil)*/
                
            }
        }

//
// MARK: - Uncomment lines below to impelement original upload implementation
//        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
//
//            if response.value != nil {
//
//                print(parameters.count.byteSize)
//
//                print(response.value as Any)
//                self.spinner.endRefreshing()
//                self.viewSpinner.isHidden = true
//                let responseData = response.value as! NSDictionary
//                let res = responseData.value(forKey: "response") as! NSDictionary
//                let message = res.value(forKey: "message") as! String
//
//                //////CHANGE on 12.01.2021
//
//                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
//                    print("Ok Pressed")
//                    self.okAction()
//                    }))
//                /*alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
//                    print("Cancel Pressed")
//                    self.cancelAction()
//                    }))*/
//                self.present(alert, animated: true, completion: nil)
//
//                ////////////////////////////////////////
//
//                /*let alert = UIAlertController(title: message, message: "", preferredStyle: .actionSheet)
//                //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                    switch action.style{
//                    case .default:
//
//                        let tabbar = self.navigationController?.tabBarController as! CustomTabBarViewController
//                        tabbar.setSelectIndex(from: 1, to: 0)
//
//                    case .cancel:
//                        print("cancel")
//
//                    case .destructive:
//                        print("destructive")
//
//                    @unknown default:
//                        print("default")
//                    }}))
//
//                self.present(alert, animated: true, completion: nil)*/
//
//            }
//        }
// MARK: - Uncomment lines above to impelement original upload implementation
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func okAction(){
        let tabbar = self.navigationController?.tabBarController as! CustomTabBarViewController
        tabbar.setSelectIndex(from: 1, to: 0)
    }
    
    func cancelAction(){
        let tabbar = self.navigationController?.tabBarController as! CustomTabBarViewController
        tabbar.setSelectIndex(from: 1, to: 0)
    }
    //MARK:- SET All Data
    func setSelectedData(){
        
        setHCParkingRate()
        setHCEntranceRate()
        setVenueRate()
        setseatingRate()
        setBathroomRate()
        setRampRate()
        setElevatorRate()
        setHCParkingLocated()
        setElevator()
        setAmenities()
        setVenueRate()
        setChangeTable()
        setBathroomSize()
        setEntranceDoor()
        setEntranceType()
        setMobilityType()
        setEntranceWidth()
        setSteepnessOfRamp()
        setBathroomOpening()
        setBathroomDoorFunction()
        setSeatingLocated()
        setVenueSpaciousness()
        setEntranceLocated()
        txtFeedback.text = ""
        //txtFeedback.text = dictselectedData.value(forKey: "other_feedback") as? String
        
    }
    
    func setHCParkingRate(){
        
        
          if(dictselectedData.count > 0){
        
            
          //  let rate = dictselectedData.value(forKey: "hc_parking_rating")
            let rat: NSString = dictselectedData.value(forKey: "hc_parking_rating") as? NSString ?? ""
            let rate = rat.intValue
               
            if(Int(rate) > 0) {
        
                for i in 1...Int(rate) {
                    
                    switch i {
                    case 1:
                        parking_rate = 1.0
                        HCParking_rate1.image = UIImage(named: "star-blue")
                        break
                    case 2:
                        parking_rate = 2.0
                        HCParking_rate2.image = UIImage(named: "star-blue")
                        break
                        
                    case 3:
                        parking_rate = 3.0
                        HCParking_rate3.image = UIImage(named: "star-blue")
                        break
                        
                    case 4:
                        parking_rate = 4.0
                        HCParking_rate4.image = UIImage(named: "star-blue")
                        break
                        
                    case 5:
                        parking_rate = 5.0
                        HCParking_rate5.image = UIImage(named: "star-blue")
                        break
                        
                        
                    default:
                        break
                    }
                }
            }
          }else{
                let rate = 5
                   
                if(Int(rate) > 0) {
            
                    for i in 1...Int(rate) {
                        
                        switch i {
                        case 1:
                            parking_rate = 1.0
                            HCParking_rate1.image = UIImage(named: "star-grey")//
                            break
                        case 2:
                            parking_rate = 2.0
                            HCParking_rate2.image = UIImage(named: "star-grey")
                            break
                            
                        case 3:
                            parking_rate = 3.0
                            HCParking_rate3.image = UIImage(named: "star-grey")
                            break
                            
                        case 4:
                            parking_rate = 4.0
                            HCParking_rate4.image = UIImage(named: "star-grey")
                            break
                            
                        case 5:
                            parking_rate = 5.0
                            HCParking_rate5.image = UIImage(named: "star-grey")
                            break
                            
                            
                        default:
                            break
                        }
                    }
                }
        }
    }
    
    func setHCEntranceRate(){
        
        
          if(dictselectedData.count > 0){
        
            
          //  let rate = dictselectedData.value(forKey: "hc_parking_rating")
            let rat: NSString = dictselectedData.value(forKey: "hc_entrance_rating") as? NSString ?? ""
            let rate = rat.intValue
               
            if(Int(rate) > 0) {
        
                for i in 1...Int(rate) {
                    
                    switch i {
                    case 1:
                        entrance_rate = 1.0
                        HCEntrance_rate1.image = UIImage(named: "star-blue")
                        break
                    case 2:
                        entrance_rate = 2.0
                        HCEntrance_rate2.image = UIImage(named: "star-blue")
                        break
                        
                    case 3:
                        entrance_rate = 3.0
                        HCEntrance_rate3.image = UIImage(named: "star-blue")
                        break
                        
                    case 4:
                        entrance_rate = 4.0
                        HCEntrance_rate4.image = UIImage(named: "star-blue")
                        break
                        
                    case 5:
                        entrance_rate = 5.0
                        HCEntrance_rate5.image = UIImage(named: "star-blue")
                        break
                        
                        
                    default:
                        break
                    }
                }
            }
        }else{
                let rate = 5
                   
                if(Int(rate) > 0) {
            
                    for i in 1...Int(rate) {
                        
                        switch i {
                        case 1:
                            entrance_rate = 1.0
                            HCEntrance_rate1.image = UIImage(named: "star-grey")
                            break
                        case 2:
                            entrance_rate = 2.0
                            HCEntrance_rate2.image = UIImage(named: "star-grey")
                            break
                            
                        case 3:
                            entrance_rate = 3.0
                            HCEntrance_rate3.image = UIImage(named: "star-grey")
                            break
                            
                        case 4:
                            entrance_rate = 4.0
                            HCEntrance_rate4.image = UIImage(named: "star-grey")
                            break
                            
                        case 5:
                            entrance_rate = 5.0
                            HCEntrance_rate5.image = UIImage(named: "star-grey")
                            break
                            
                            
                        default:
                            break
                        }
                    }
                }
        }
    }
    
    func setVenueRate(){
        
        
          if(dictselectedData.count > 0){
        
            
         
            let rat: NSString = dictselectedData.value(forKey: "rate_venue_specious") as? NSString ?? ""
            let rate = rat.intValue
               
            if(Int(rate) > 0) {
        
                for i in 1...Int(rate) {
                    
                    switch i {
                    case 1:
                        
                        venue_rate = 1.0
                        Spaciousness_rate1.image = UIImage(named: "star-blue")
                        break
                    case 2:
                        venue_rate = 2.0
                        Spaciousness_rate2.image = UIImage(named: "star-blue")
                        break
                        
                    case 3:
                        venue_rate = 3.0
                        Spaciousness_rate3.image = UIImage(named: "star-blue")
                        break
                        
                    case 4:
                        venue_rate = 4.0
                        Spaciousness_rate4.image = UIImage(named: "star-blue")
                        break
                        
                    case 5:
                        venue_rate = 5.0
                        Spaciousness_rate5.image = UIImage(named: "star-blue")
                        break
                        
                        
                    default:
                        break
                    }
                }
            }
          }else{
                let rate = 5
                   
                if(Int(rate) > 0) {
            
                    for i in 1...Int(rate) {
                        
                        switch i {
                        case 1:
                            
                            venue_rate = 1.0
                            Spaciousness_rate1.image = UIImage(named: "star-grey")
                            break
                        case 2:
                            venue_rate = 2.0
                            Spaciousness_rate2.image = UIImage(named: "star-grey")
                            break
                            
                        case 3:
                            venue_rate = 3.0
                            Spaciousness_rate3.image = UIImage(named: "star-grey")
                            break
                            
                        case 4:
                            venue_rate = 4.0
                            Spaciousness_rate4.image = UIImage(named: "star-grey")
                            break
                            
                        case 5:
                            venue_rate = 5.0
                            Spaciousness_rate5.image = UIImage(named: "star-grey")
                            break
                            
                            
                        default:
                            break
                        }
                    }
                }
        }
    }
    
    func setseatingRate(){
        
        
          if(dictselectedData.count > 0){
        
            
         
            let rat: NSString = dictselectedData.value(forKey: "rate_acc_setting") as? NSString ?? ""
            let rate = rat.intValue
               
            if(Int(rate) > 0) {
        
                for i in 1...Int(rate) {
                    
                    switch i {
                    case 1:
                        
                        seating_rate = 1.0
                        Seating_rate1.image = UIImage(named: "star-blue")
                        break
                    case 2:
                        
                        seating_rate = 2.0
                        Seating_rate2.image = UIImage(named: "star-blue")
                        break
                        
                    case 3:
                        seating_rate = 3.0
                        Seating_rate3.image = UIImage(named: "star-blue")
                        break
                        
                    case 4:
                        
                        seating_rate = 4.0
                        Seating_rate4.image = UIImage(named: "star-blue")
                        break
                        
                    case 5:
                        seating_rate = 5.0
                        Seating_rate5.image = UIImage(named: "star-blue")
                        break
                        
                    default:
                        break
                    }
                }
            }
          }else{
                let rate = 5
                   
                if(Int(rate) > 0) {
            
                    for i in 1...Int(rate) {
                        
                        switch i {
                        case 1:
                            
                            seating_rate = 1.0
                            Seating_rate1.image = UIImage(named: "star-grey")
                            break
                        case 2:
                            
                            seating_rate = 2.0
                            Seating_rate2.image = UIImage(named: "star-grey")
                            break
                            
                        case 3:
                            seating_rate = 3.0
                            Seating_rate3.image = UIImage(named: "star-grey")
                            break
                            
                        case 4:
                            
                            seating_rate = 4.0
                            Seating_rate4.image = UIImage(named: "star-grey")
                            break
                            
                        case 5:
                            seating_rate = 5.0
                            Seating_rate5.image = UIImage(named: "star-grey")
                            break
                            
                        default:
                            break
                        }
                    }
                }
        }
    }
    
    func setBathroomRate(){
        
        
          if(dictselectedData.count > 0){
    
            let rat: NSString = dictselectedData.value(forKey: "rate_acc_bathroom") as? NSString ?? ""
            let rate = rat.intValue
               
            if(Int(rate) > 0) {
        
                for i in 1...Int(rate) {
                    
                    switch i {
                    case 1:
                        
                        Bathroom_rate1.image = UIImage(named: "star-blue")
                        break
                    case 2:
                        
                        Bathroom_rate2.image = UIImage(named: "star-blue")
                        break
                        
                    case 3:
                        
                        Bathroom_rate3.image = UIImage(named: "star-blue")
                        break
                        
                    case 4:
                        
                        Bathroom_rate4.image = UIImage(named: "star-blue")
                        break
                        
                    case 5:
                        
                        Bathroom_rate5.image = UIImage(named: "star-blue")
                        break
                        
                        
                    default:
                        break
                    }
                }
            }
          }else{
            let rate = 5
                   
                if(Int(rate) > 0) {
            
                    for i in 1...Int(rate) {
                        
                        switch i {
                        case 1:
                            
                            Bathroom_rate1.image = UIImage(named: "star-grey")
                            break
                        case 2:
                            
                            Bathroom_rate2.image = UIImage(named: "star-grey")
                            break
                            
                        case 3:
                            
                            Bathroom_rate3.image = UIImage(named: "star-grey")
                            break
                            
                        case 4:
                            
                            Bathroom_rate4.image = UIImage(named: "star-grey")
                            break
                            
                        case 5:
                            
                            Bathroom_rate5.image = UIImage(named: "star-grey")
                            break
                            
                            
                        default:
                            break
                        }
                    }
                }
        }
    }
    
    func setRampRate(){
           
           
             if(dictselectedData.count > 0){
       
               let rat: NSString = dictselectedData.value(forKey: "rate_ramp") as? NSString ?? ""
               let rate = rat.intValue
                  
               if(Int(rate) > 0) {
           
                   for i in 1...Int(rate) {
                       
                       switch i {
                       case 1:
                           
                           ramp_rate = 1.0
                           Ramp_rate1.image = UIImage(named: "star-blue")
                           break
                       case 2:
                           
                           ramp_rate = 2.0
                           Ramp_rate2.image = UIImage(named: "star-blue")
                           break
                           
                       case 3:
                        
                           ramp_rate = 3.0
                           Ramp_rate3.image = UIImage(named: "star-blue")
                           break
                           
                       case 4:
                           
                           ramp_rate = 4.0
                           Ramp_rate4.image = UIImage(named: "star-blue")
                           break
                           
                       case 5:
                           
                           ramp_rate = 5.0
                           Ramp_rate5.image = UIImage(named: "star-blue")
                           break
                           
                           
                       default:
                           break
                       }
                   }
               }
             }else{
                let rate = 5
                       
                    if(Int(rate) > 0) {
                
                        for i in 1...Int(rate) {
                            
                            switch i {
                            case 1:
                                
                                ramp_rate = 1.0
                                Ramp_rate1.image = UIImage(named: "star-grey")
                                break
                            case 2:
                                
                                ramp_rate = 2.0
                                Ramp_rate2.image = UIImage(named: "star-grey")
                                break
                                
                            case 3:
                             
                                ramp_rate = 3.0
                                Ramp_rate3.image = UIImage(named: "star-grey")
                                break
                                
                            case 4:
                                
                                ramp_rate = 4.0
                                Ramp_rate4.image = UIImage(named: "star-grey")
                                break
                                
                            case 5:
                                
                                ramp_rate = 5.0
                                Ramp_rate5.image = UIImage(named: "star-grey")
                                break
                                
                                
                            default:
                                break
                            }
                        }
                    }
        }
       }
    
    func setElevatorRate(){
              
              
                if(dictselectedData.count > 0){
          
                  let rat: NSString = dictselectedData.value(forKey: "rate_elevator") as? NSString ?? ""
                  let rate = rat.intValue
                     
                  if(Int(rate) > 0) {
              
                      for i in 1...Int(rate) {
                          
                          switch i {
                          case 1:
                              
                              elevator_rate = 1.0
                              Elevator_rate1.image = UIImage(named: "star-blue")
                              break
                          case 2:
                              
                              elevator_rate = 2.0
                              Elevator_rate2.image = UIImage(named: "star-blue")
                              break
                              
                          case 3:
                            
                              elevator_rate = 3.0
                              Elevator_rate3.image = UIImage(named: "star-blue")
                              break
                              
                          case 4:
                              
                              elevator_rate = 4.0
                              Elevator_rate4.image = UIImage(named: "star-blue")
                              break
                              
                          case 5:
                              
                              elevator_rate = 5.0
                              Elevator_rate5.image = UIImage(named: "star-blue")
                              break
                              
                              
                          default:
                              break
                          }
                      }
                  }
                }else{
                    let rate = 5
                           
                        if(Int(rate) > 0) {
                    
                            for i in 1...Int(rate) {
                                
                                switch i {
                                case 1:
                                    
                                    elevator_rate = 1.0
                                    Elevator_rate1.image = UIImage(named: "star-grey")
                                    break
                                case 2:
                                    
                                    elevator_rate = 2.0
                                    Elevator_rate2.image = UIImage(named: "star-grey")
                                    break
                                    
                                case 3:
                                  
                                    elevator_rate = 3.0
                                    Elevator_rate3.image = UIImage(named: "star-grey")
                                    break
                                    
                                case 4:
                                    
                                    elevator_rate = 4.0
                                    Elevator_rate4.image = UIImage(named: "star-grey")
                                    break
                                    
                                case 5:
                                    
                                    elevator_rate = 5.0
                                    Elevator_rate5.image = UIImage(named: "star-grey")
                                    break
                                    
                                    
                                default:
                                    break
                                }
                            }
                        }
        }
          }
    
    //
    
    func setHCParkingLocated(){
        
        if dictselectedData.count > 0{
            
            let location = dictselectedData.value(forKey: "location_of_handicapped_parking") as? String
            
            
            if(location == "Front"){
                
                HCParking_located1.image = UIImage(named: "radiob")
                HCParking_located2.image = UIImage(named: "radiob1")
                HCParking_located3.image = UIImage(named: "radiob1")
                HCParking_located4.image = UIImage(named: "radiob1")
                
            }else if(location == "Street"){
                
                
                HCParking_located1.image = UIImage(named: "radiob1")
                HCParking_located2.image = UIImage(named: "radiob")
                HCParking_located3.image = UIImage(named: "radiob1")
                HCParking_located4.image = UIImage(named: "radiob1")
                
            }else if(location == "Back"){
                
                HCParking_located1.image = UIImage(named: "radiob1")
                HCParking_located2.image = UIImage(named: "radiob1")
                HCParking_located3.image = UIImage(named: "radiob")
                HCParking_located4.image = UIImage(named: "radiob1")
                
                
            }else if(location == "Parking Lot"){
                
                HCParking_located1.image = UIImage(named: "radiob1")
                HCParking_located2.image = UIImage(named: "radiob1")
                HCParking_located3.image = UIImage(named: "radiob1")
                HCParking_located4.image = UIImage(named: "radiob")
            }
        }else{
            HCParking_located1.image = UIImage(named: "radiob1")
            HCParking_located2.image = UIImage(named: "radiob1")
            HCParking_located3.image = UIImage(named: "radiob1")
            HCParking_located4.image = UIImage(named: "radiob1")
        }
        
    }
    
    func setEntranceLocated(){
        
        if dictselectedData.count > 0{
            
            let location = dictselectedData.value(forKey: "entrance") as? String
            
            
            if(location == "Front"){
                
                HCEntrance_located1.image = UIImage(named: "radiob")
                HCEntrance_located2.image = UIImage(named: "radiob1")
                HCEntrance_located3.image = UIImage(named: "radiob1")
                HCEntrance_located4.image = UIImage(named: "radiob1")
                HCEntrance_located5.image = UIImage(named: "radiob1")
                HCEntrance_located6.image = UIImage(named: "radiob1")
                
            }else if(location == "Back"){
                
                
                HCEntrance_located1.image = UIImage(named: "radiob1")
                HCEntrance_located2.image = UIImage(named: "radiob")
                HCEntrance_located3.image = UIImage(named: "radiob1")
                HCEntrance_located4.image = UIImage(named: "radiob1")
                HCEntrance_located5.image = UIImage(named: "radiob1")
                HCEntrance_located6.image = UIImage(named: "radiob1")
                
            }else if(location == "Left Of the Building"){
                
                HCEntrance_located1.image = UIImage(named: "radiob1")
                HCEntrance_located2.image = UIImage(named: "radiob1")
                HCEntrance_located3.image = UIImage(named: "radiob")
                HCEntrance_located4.image = UIImage(named: "radiob1")
                HCEntrance_located5.image = UIImage(named: "radiob1")
                HCEntrance_located6.image = UIImage(named: "radiob1")
                
            }else if(location == "Street"){
                
                HCEntrance_located1.image = UIImage(named: "radiob1")
                HCEntrance_located2.image = UIImage(named: "radiob1")
                HCEntrance_located3.image = UIImage(named: "radiob1")
                HCEntrance_located4.image = UIImage(named: "radiob")
                HCEntrance_located5.image = UIImage(named: "radiob1")
                HCEntrance_located6.image = UIImage(named: "radiob1")
                
            }else if(location == "None"){
                
                HCEntrance_located1.image = UIImage(named: "radiob1")
                HCEntrance_located2.image = UIImage(named: "radiob1")
                HCEntrance_located3.image = UIImage(named: "radiob1")
                HCEntrance_located4.image = UIImage(named: "radiob1")
                HCEntrance_located5.image = UIImage(named: "radiob")
                HCEntrance_located6.image = UIImage(named: "radiob1")
                
            }else if(location == "Right Of the building"){
                
                HCEntrance_located1.image = UIImage(named: "radiob1")
                HCEntrance_located2.image = UIImage(named: "radiob1")
                HCEntrance_located3.image = UIImage(named: "radiob1")
                HCEntrance_located4.image = UIImage(named: "radiob1")
                HCEntrance_located5.image = UIImage(named: "radiob1")
                HCEntrance_located6.image = UIImage(named: "radiob")
                
            }
        }else{
            HCEntrance_located1.image = UIImage(named: "radiob1")
            HCEntrance_located2.image = UIImage(named: "radiob1")
            HCEntrance_located3.image = UIImage(named: "radiob1")
            HCEntrance_located4.image = UIImage(named: "radiob1")
            HCEntrance_located5.image = UIImage(named: "radiob1")
            HCEntrance_located6.image = UIImage(named: "radiob1")
        }
        
    }
    
    func setEntranceType(){
        
        if(dictselectedData.count > 0){
            
            let type = dictselectedData.value(forKey: "new_hc_entrance") as? String
            
            if(type == "Street Level"){
                
                HCEntrance_type1.image = UIImage(named: "radiob")
                HCEntrance_type2.image = UIImage(named: "radiob1")
                HCEntrance_type3.image = UIImage(named: "radiob1")
                HCEntrance_type4.image = UIImage(named: "radiob1")
                HCEntrance_type5.image = UIImage(named: "radiob1")
                
            }else if(type == "Elevator"){
            
                HCEntrance_type1.image = UIImage(named: "radiob1")
                HCEntrance_type2.image = UIImage(named: "radiob")
                HCEntrance_type3.image = UIImage(named: "radiob1")
                HCEntrance_type4.image = UIImage(named: "radiob1")
                HCEntrance_type5.image = UIImage(named: "radiob1")
                
            }else if(type == "None"){
                
                HCEntrance_type1.image = UIImage(named: "radiob1")
                HCEntrance_type2.image = UIImage(named: "radiob1")
                HCEntrance_type3.image = UIImage(named: "radiob")
                HCEntrance_type4.image = UIImage(named: "radiob1")
                HCEntrance_type5.image = UIImage(named: "radiob1")
                
            }else if(type == "Ramp"){
                
                HCEntrance_type1.image = UIImage(named: "radiob1")
                HCEntrance_type2.image = UIImage(named: "radiob1")
                HCEntrance_type3.image = UIImage(named: "radiob1")
                HCEntrance_type4.image = UIImage(named: "radiob")
                HCEntrance_type5.image = UIImage(named: "radiob1")
                
                
            }else if(type == "Portable Ramp"){
                
                HCEntrance_type1.image = UIImage(named: "radiob1")
                HCEntrance_type2.image = UIImage(named: "radiob1")
                HCEntrance_type3.image = UIImage(named: "radiob1")
                HCEntrance_type4.image = UIImage(named: "radiob1")
                HCEntrance_type5.image = UIImage(named: "radiob")
                
                
            }
            
        }else{
            HCEntrance_type1.image = UIImage(named: "radiob1")
            HCEntrance_type2.image = UIImage(named: "radiob1")
            HCEntrance_type3.image = UIImage(named: "radiob1")
            HCEntrance_type4.image = UIImage(named: "radiob1")
            HCEntrance_type5.image = UIImage(named: "radiob1")
        }
        
        
    }
    
    func setEntranceDoor(){
           
           if(dictselectedData.count > 0){
               
               let type = dictselectedData.value(forKey: "door_entrance") as? String
               
               if(type == "Automatic"){
                   
                HCEntrance_doortype1.image = UIImage(named: "radiob")
                HCEntrance_doortype2.image = UIImage(named: "radiob1")
                HCEntrance_doortype3.image = UIImage(named: "radiob1")
                
               }else if(type == "No Doors"){
               
                HCEntrance_doortype1.image = UIImage(named: "radiob1")
                HCEntrance_doortype2.image = UIImage(named: "radiob")
                HCEntrance_doortype3.image = UIImage(named: "radiob1")
                   
               }else if(type == "Manual"){
                   
                HCEntrance_doortype1.image = UIImage(named: "radiob1")
                HCEntrance_doortype2.image = UIImage(named: "radiob1")
                HCEntrance_doortype3.image = UIImage(named: "radiob")
                   
               }
               
           }else{
            HCEntrance_doortype1.image = UIImage(named: "radiob1")
            HCEntrance_doortype2.image = UIImage(named: "radiob1")
            HCEntrance_doortype3.image = UIImage(named: "radiob1")
        }
           
           
       }
    
    func setEntranceWidth(){
        
        if(dictselectedData.count > 0){
            
            let type = dictselectedData.value(forKey: "width_of_entrance") as? String
            
            if(type == "Too narrow"){
                
                HCEntrance_width1.image = UIImage(named: "radiob")
                HCEntrance_width2.image = UIImage(named: "radiob1")
                HCEntrance_width3.image = UIImage(named: "radiob1")
                
            }else if(type == "Spacious"){
                
                HCEntrance_width1.image = UIImage(named: "radiob1")
                HCEntrance_width2.image = UIImage(named: "radiob")
                HCEntrance_width3.image = UIImage(named: "radiob1")
                
            }else if(type == "Adequate"){
                
                HCEntrance_width1.image = UIImage(named: "radiob1")
                HCEntrance_width2.image = UIImage(named: "radiob1")
                HCEntrance_width3.image = UIImage(named: "radiob")
                
            }
            
        }else{
            HCEntrance_width1.image = UIImage(named: "radiob1")
            HCEntrance_width2.image = UIImage(named: "radiob1")
            HCEntrance_width3.image = UIImage(named: "radiob1")
        }
        
        
    }
    
    func setVenueSpaciousness(){
        
        if(dictselectedData.count > 0){
            
            let type = dictselectedData.value(forKey: "spaciousness_of_venue") as? String
            
            if(type == "Too Tight"){
                Spaciousness_venue1.image = UIImage(named: "radiob")
                Spaciousness_venue2.image = UIImage(named: "radiob1")
                Spaciousness_venue3.image = UIImage(named: "radiob1")
                
            }else if(type == "Adequate"){
                
                Spaciousness_venue1.image = UIImage(named: "radiob1")
                Spaciousness_venue2.image = UIImage(named: "radiob")
                Spaciousness_venue3.image = UIImage(named: "radiob1")
                
            }else if(type == "Spacious"){
                
                Spaciousness_venue1.image = UIImage(named: "radiob1")
                Spaciousness_venue2.image = UIImage(named: "radiob1")
                Spaciousness_venue3.image = UIImage(named: "radiob")
                
            }
        }else{
            Spaciousness_venue1.image = UIImage(named: "radiob1")
            Spaciousness_venue2.image = UIImage(named: "radiob1")
            Spaciousness_venue3.image = UIImage(named: "radiob1")
        }
    }
    
    func setSeatingLocated(){
        
        if(dictselectedData.count > 0){
            
            let type = dictselectedData.value(forKey: "located") as? String
            
            if(type == "Seating thoughout"){
                
                Seating_located1.image = UIImage(named: "radiob")
                Seating_located2.image = UIImage(named: "radiob1")
                Seating_located3.image = UIImage(named: "radiob1")
                Seating_located4.image = UIImage(named: "radiob1")
                
            }else if(type == "Outside"){
                
                Seating_located1.image = UIImage(named: "radiob1")
                Seating_located2.image = UIImage(named: "radiob")
                Seating_located3.image = UIImage(named: "radiob1")
                Seating_located4.image = UIImage(named: "radiob1")
                
            }else if(type == "Designated Area"){
                
                Seating_located1.image = UIImage(named: "radiob1")
                Seating_located2.image = UIImage(named: "radiob1")
                Seating_located3.image = UIImage(named: "radiob")
                Seating_located4.image = UIImage(named: "radiob1")
                
            }else if(type == "None"){
                
                Seating_located1.image = UIImage(named: "radiob1")
                Seating_located2.image = UIImage(named: "radiob1")
                Seating_located3.image = UIImage(named: "radiob1")
                Seating_located4.image = UIImage(named: "radiob")
                
            }
        }else{
            Seating_located1.image = UIImage(named: "radiob1")
            Seating_located2.image = UIImage(named: "radiob1")
            Seating_located3.image = UIImage(named: "radiob1")
            Seating_located4.image = UIImage(named: "radiob1")
        }
        
    }
    
    func setBathroomDoorFunction(){
        
        if(dictselectedData.count > 0){
            
            let type = dictselectedData.value(forKey: "entrance_opening_directions") as? String
            
            if(type == "Opens out"){
                
                Bathroom_door1.image = UIImage(named: "radiob")
                Bathroom_door2.image = UIImage(named: "radiob1")
                Bathroom_door3.image = UIImage(named: "radiob1")
                Bathroom_door4.image = UIImage(named: "radiob1")
                
            }else if(type == "No door"){
                
                Bathroom_door1.image = UIImage(named: "radiob1")
                Bathroom_door2.image = UIImage(named: "radiob")
                Bathroom_door3.image = UIImage(named: "radiob1")
                Bathroom_door4.image = UIImage(named: "radiob1")
                
            }else if(type == "Opens in"){
                
                Bathroom_door1.image = UIImage(named: "radiob1")
                Bathroom_door2.image = UIImage(named: "radiob1")
                Bathroom_door3.image = UIImage(named: "radiob")
                Bathroom_door4.image = UIImage(named: "radiob1")
                
            }else if(type == "Didn't use"){
                
                Bathroom_door1.image = UIImage(named: "radiob1")
                Bathroom_door2.image = UIImage(named: "radiob1")
                Bathroom_door3.image = UIImage(named: "radiob1")
                Bathroom_door4.image = UIImage(named: "radiob")
                
            }
        }else{
            Bathroom_door1.image = UIImage(named: "radiob1")
            Bathroom_door2.image = UIImage(named: "radiob1")
            Bathroom_door3.image = UIImage(named: "radiob1")
            Bathroom_door4.image = UIImage(named: "radiob1")
        }
    }
    
    func setBathroomOpening(){
        
        if(dictselectedData.count > 0){
            
            let type = dictselectedData.value(forKey: "ease_of_opening") as? String
            
            if(type == "Easy"){
                
                Bathroom_opening1.image = UIImage(named: "radiob")
                Bathroom_opening2.image = UIImage(named: "radiob1")
                Bathroom_opening3.image = UIImage(named: "radiob1")
                
            }else if(type == "Difficult to open"){
                
                Bathroom_opening1.image = UIImage(named: "radiob1")
                Bathroom_opening2.image = UIImage(named: "radiob")
                Bathroom_opening3.image = UIImage(named: "radiob1")
                
            }else if(type == "Average"){
                
                Bathroom_opening1.image = UIImage(named: "radiob1")
                Bathroom_opening2.image = UIImage(named: "radiob1")
                Bathroom_opening3.image = UIImage(named: "radiob")
                
            }
            
        }else{
            Bathroom_opening1.image = UIImage(named: "radiob1")
            Bathroom_opening2.image = UIImage(named: "radiob1")
            Bathroom_opening3.image = UIImage(named: "radiob1")
        }
        
        
    }
    
    func setBathroomSize(){
        
        if(dictselectedData.count > 0){
            
            let type = dictselectedData.value(forKey: "size_of_stall") as? String
            
            if(type == "Too small"){
                
                Bathroom_stall1.image = UIImage(named: "radiob")
                Bathroom_stall2.image = UIImage(named: "radiob1")
                Bathroom_stall3.image = UIImage(named: "radiob1")
                
            }else if(type == "Spacious"){
                
                Bathroom_stall1.image = UIImage(named: "radiob1")
                Bathroom_stall2.image = UIImage(named: "radiob")
                Bathroom_stall3.image = UIImage(named: "radiob1")
                
            }else if(type == "Adequate"){
                
                Bathroom_stall1.image = UIImage(named: "radiob1")
                Bathroom_stall2.image = UIImage(named: "radiob1")
                Bathroom_stall3.image = UIImage(named: "radiob")
                
            }
            
        }else{
            Bathroom_stall1.image = UIImage(named: "radiob1")
            Bathroom_stall2.image = UIImage(named: "radiob1")
            Bathroom_stall3.image = UIImage(named: "radiob1")
        }
        
        
    }
    
    func setAmenities(){
          
          if(dictselectedData.count > 0){
              
              let type = dictselectedData.value(forKey: "accessible_bathroom_amenities") as? String
              
              if(type == "Fully accessible"){
                  
                  Bathroom_amenities1.image = UIImage(named: "radiob")
                  Bathroom_amenities2.image = UIImage(named: "radiob1")
                  Bathroom_amenities3.image = UIImage(named: "radiob1")
                  
              }else if(type == "None"){
                  
                  Bathroom_amenities1.image = UIImage(named: "radiob1")
                  Bathroom_amenities2.image = UIImage(named: "radiob")
                  Bathroom_amenities3.image = UIImage(named: "radiob1")
                  
              }else if(type == "Some Amenities"){
                  
                  Bathroom_amenities1.image = UIImage(named: "radiob1")
                  Bathroom_amenities2.image = UIImage(named: "radiob1")
                  Bathroom_amenities3.image = UIImage(named: "radiob")
                  
              }
          }else{
            Bathroom_amenities1.image = UIImage(named: "radiob1")
            Bathroom_amenities2.image = UIImage(named: "radiob1")
            Bathroom_amenities3.image = UIImage(named: "radiob1")
        }
      }
    
    func setChangeTable(){
        
        if(dictselectedData.count > 0){
            
            let type = dictselectedData.value(forKey: "changing_table") as? String
            
            if(type == "Yes"){
                
                Bathroom_changtable1.image = UIImage(named: "radiob")
                Bathroom_changtable2.image = UIImage(named: "radiob1")
                Bathroom_changtable3.image = UIImage(named: "radiob1")
                
            }else if(type == "Didn't Check"){
                
                Bathroom_changtable1.image = UIImage(named: "radiob1")
                Bathroom_changtable2.image = UIImage(named: "radiob")
                Bathroom_changtable3.image = UIImage(named: "radiob1")
                
            }else if(type == "No"){
                
                Bathroom_changtable1.image = UIImage(named: "radiob1")
                Bathroom_changtable2.image = UIImage(named: "radiob1")
                Bathroom_changtable3.image = UIImage(named: "radiob")
                
            }
        }else{
            Bathroom_changtable1.image = UIImage(named: "radiob1")
            Bathroom_changtable2.image = UIImage(named: "radiob1")
            Bathroom_changtable3.image = UIImage(named: "radiob1")
        }
    }
    
    func setSteepnessOfRamp(){
        
        if(dictselectedData.count > 0){
            
            let type = dictselectedData.value(forKey: "steepness_of_the_ramp") as? String
            
            if(type == "Easy garde"){
                
                Ramp_steepness1.image = UIImage(named: "radiob")
                Ramp_steepness2.image = UIImage(named: "radiob1")
                Ramp_steepness3.image = UIImage(named: "radiob1")
                Ramp_steepness4.image = UIImage(named: "radiob1")
                
            }else if(type == "Too steep" || type == "Too Steepness"){
                
                Ramp_steepness1.image = UIImage(named: "radiob1")
                Ramp_steepness2.image = UIImage(named: "radiob")
                Ramp_steepness3.image = UIImage(named: "radiob1")
                Ramp_steepness4.image = UIImage(named: "radiob1")
                
            }else if(type == "Medium grade"){
                
                Ramp_steepness1.image = UIImage(named: "radiob1")
                Ramp_steepness2.image = UIImage(named: "radiob1")
                Ramp_steepness3.image = UIImage(named: "radiob")
                Ramp_steepness4.image = UIImage(named: "radiob1")
                
            }else if(type == "None"){
                
                Ramp_steepness1.image = UIImage(named: "radiob1")
                Ramp_steepness2.image = UIImage(named: "radiob1")
                Ramp_steepness3.image = UIImage(named: "radiob1")
                Ramp_steepness4.image = UIImage(named: "radiob")
                
            }
        }else{
            Ramp_steepness1.image = UIImage(named: "radiob1")
            Ramp_steepness2.image = UIImage(named: "radiob1")
            Ramp_steepness3.image = UIImage(named: "radiob1")
            Ramp_steepness4.image = UIImage(named: "radiob1")
        }
        
    }
    
    func setElevator(){
           
           if(dictselectedData.count > 0){
               
               let type = dictselectedData.value(forKey: "size_of_the_elevator") as? String
               
               if(type == "Too small"){
                   
                   Elevator_spaciousness1.image = UIImage(named: "radiob")
                   Elevator_spaciousness2.image = UIImage(named: "radiob1")
                   Elevator_spaciousness3.image = UIImage(named: "radiob1")
                   Elevator_spaciousness4.image = UIImage(named: "radiob1")
                   
               }else if(type == "Spacious"){
                   
                   Elevator_spaciousness1.image = UIImage(named: "radiob1")
                   Elevator_spaciousness2.image = UIImage(named: "radiob")
                   Elevator_spaciousness3.image = UIImage(named: "radiob1")
                   Elevator_spaciousness4.image = UIImage(named: "radiob1")
                   
               }else if(type == "Adequate"){
                   
                   Elevator_spaciousness1.image = UIImage(named: "radiob1")
                   Elevator_spaciousness2.image = UIImage(named: "radiob1")
                   Elevator_spaciousness3.image = UIImage(named: "radiob")
                   Elevator_spaciousness4.image = UIImage(named: "radiob1")
                   
               }else if(type == "None"){
                   
                   Elevator_spaciousness1.image = UIImage(named: "radiob1")
                   Elevator_spaciousness2.image = UIImage(named: "radiob1")
                   Elevator_spaciousness3.image = UIImage(named: "radiob1")
                   Elevator_spaciousness4.image = UIImage(named: "radiob")
                   
               }
           }else{
            Elevator_spaciousness1.image = UIImage(named: "radiob1")
            Elevator_spaciousness2.image = UIImage(named: "radiob1")
            Elevator_spaciousness3.image = UIImage(named: "radiob1")
            Elevator_spaciousness4.image = UIImage(named: "radiob1")
        }
           
       }
    
    func setMobilityType(){
        
        if(dictselectedData.count > 0){
            
            let type = dictselectedData.value(forKey: "mobility") as? String
            
            if(type == "Electric WheelChair"){
                
                Mobility_type1.image = UIImage(named: "radiob")
                Mobility_type2.image = UIImage(named: "radiob1")
                Mobility_type3.image = UIImage(named: "radiob1")
                Mobility_type4.image = UIImage(named: "radiob1")
                Mobility_type5.image = UIImage(named: "radiob1")
                Mobility_type6.image = UIImage(named: "radiob1")
                
            }else if(type == "Able body"){
                
                Mobility_type1.image = UIImage(named: "radiob1")
                Mobility_type2.image = UIImage(named: "radiob")
                Mobility_type3.image = UIImage(named: "radiob1")
                Mobility_type4.image = UIImage(named: "radiob1")
                Mobility_type5.image = UIImage(named: "radiob1")
                Mobility_type6.image = UIImage(named: "radiob1")
                
            }else if(type == "Crutches/Walker"){
                
                Mobility_type1.image = UIImage(named: "radiob1")
                Mobility_type2.image = UIImage(named: "radiob1")
                Mobility_type3.image = UIImage(named: "radiob")
                Mobility_type4.image = UIImage(named: "radiob1")
                Mobility_type5.image = UIImage(named: "radiob1")
                Mobility_type6.image = UIImage(named: "radiob1")
                
            }else if(type == "Manual Wheelchair"){
                
                Mobility_type1.image = UIImage(named: "radiob1")
                Mobility_type2.image = UIImage(named: "radiob1")
                Mobility_type3.image = UIImage(named: "radiob1")
                Mobility_type4.image = UIImage(named: "radiob")
                Mobility_type5.image = UIImage(named: "radiob1")
                Mobility_type6.image = UIImage(named: "radiob1")
                
            }else if(type == "Scooter"){
                
                Mobility_type1.image = UIImage(named: "radiob1")
                Mobility_type2.image = UIImage(named: "radiob1")
                Mobility_type3.image = UIImage(named: "radiob1")
                Mobility_type4.image = UIImage(named: "radiob1")
                Mobility_type5.image = UIImage(named: "radiob")
                Mobility_type6.image = UIImage(named: "radiob1")
                
            }else if(type == "Baby Walker"){
                
                Mobility_type1.image = UIImage(named: "radiob1")
                Mobility_type2.image = UIImage(named: "radiob1")
                Mobility_type3.image = UIImage(named: "radiob1")
                Mobility_type4.image = UIImage(named: "radiob1")
                Mobility_type5.image = UIImage(named: "radiob1")
                Mobility_type6.image = UIImage(named: "radiob")
                
            }
        }else{
            Mobility_type1.image = UIImage(named: "radiob1")
            Mobility_type2.image = UIImage(named: "radiob1")
            Mobility_type3.image = UIImage(named: "radiob1")
            Mobility_type4.image = UIImage(named: "radiob1")
            Mobility_type5.image = UIImage(named: "radiob1")
            Mobility_type6.image = UIImage(named: "radiob1")
        }
    }
    
    //MARK:- Button Action for add listing
    @IBAction func onClickAddLocation(_ sender: Any) {
        
        //self.assets = nil
       // arrListingImages = []
        
        
        if(txtSearch.text != ""){
//            clearAllPreviousData()r
            scrollData.isHidden = false
        }else{
            
            let alert = UIAlertController(title: "Please add location", message: "", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }

    }
    
    //MARK:- Clear All Previous Data
    func clearAllPreviousData(){
        
        self.dictselectedData.removeAllObjects()
        self.arrListDetails = []
        self.searchText = ""
        self.assets?.removeAll()
        self.arrListingImages.removeAllObjects()
        self.arrImageData.removeAllObjects()

        self.arrBase64String.removeAllObjects()
        self.arrBase64StringOLDImage.removeAllObjects()
        
        setSelectedData()
        collection.reloadData()
    }
    
    @IBAction func onClickAddPhoto(_ sender: UIButton) {
        
        
        if(arrImageData.count == 6){
            
            
            let alert = UIAlertController(title: "Sorry! You can add Maximum 6 Images...", message: "", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }else{
            
           /* let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
                
                self.selectImageFrom(.camera)
              
            }))
            alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
               
                self.selectImageFrom(.photoLibrary)
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil) */
            
            
            showImagePicker()
        }

}
    
    @IBAction func onClickAddListing(_ sender: UIButton) {
        
        loadLoader()
        self.view.endEditing(true)
        addListingApi()
        clearAllPreviousData()
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showImagePicker() {
         
        pickerController = DKImagePickerController()
        pickerController.assetType = .allPhotos
        
        if self.exportManually {
            DKImageAssetExporter.sharedInstance.add(observer: self)
        }
        
        if let assets = self.assets {
            pickerController.select(assets: assets)
        }
        
        pickerController.exportStatusChanged = { status in
            switch status {
            case .exporting:
                print("exporting")
            case .none:
                print("none")
            }
        }
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            self.updateAssets(assets: assets)
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        
        if pickerController.UIDelegate == nil {
            pickerController.UIDelegate = AssetClickHandler()
        }
        
        if pickerController.inline {
            //self.showInlinePicker()
        } else {
            self.present(pickerController, animated: true) {}
        }
    }
    
    func updateAssets(assets: [DKAsset]) {
        print("didSelectAssets")
        
        self.assets = assets
        collection.reloadData()
        
        if pickerController.exportsWhenCompleted {
            for asset in assets {
                if let error = asset.error {
                    print("exporterDidEndExporting with error:\(error.localizedDescription)")
                } else {
                    print("exporterDidEndExporting:\(asset.localTemporaryPath!)")
                }
            }
        }
        
        if self.exportManually {
            DKImageAssetExporter.sharedInstance.exportAssetsAsynchronously(assets: assets, completion: nil)
        }
    }
    
    // MARK: - Inline Mode
    
   /* func showInlinePicker() {
        let pickerView = self.pickerController.view!
        pickerView.frame = CGRect(x: 0, y: 170, width: self.view.bounds.width, height: 200)
        self.view.addSubview(pickerView)
        
        let doneButton = UIButton(type: .custom)
        doneButton.setTitleColor(UIColor.blue, for: .normal)
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        doneButton.frame = CGRect(x: 0, y: pickerView.frame.maxY, width: pickerView.bounds.width / 2, height: 50)
        self.view.addSubview(doneButton)
        self.pickerController.selectedChanged = { [unowned self] in
            self.updateDoneButtonTitle(doneButton)
        }
        self.updateDoneButtonTitle(doneButton)
        
        let albumButton = UIButton(type: .custom)
        albumButton.setTitleColor(UIColor.blue, for: .normal)
        albumButton.setTitle("Album", for: .normal)
        albumButton.addTarget(self, action: #selector(showAlbum), for: .touchUpInside)
        albumButton.frame = CGRect(x: doneButton.frame.maxX, y: doneButton.frame.minY, width: doneButton.bounds.width, height: doneButton.bounds.height)
        self.view.addSubview(albumButton)
    } */

    
    // MARK: - DKImagePickerControllerBaseUIDelegate

    class AssetClickHandler: DKImagePickerControllerBaseUIDelegate {
        
       // var count = 0
        let vc = AddListViewController()
        
        override func imagePickerController(_ imagePickerController: DKImagePickerController, didSelectAssets: [DKAsset]) {
            //tap to select asset
            //use this place for asset selection customisation
        
            imagePickerController.maxSelectableCount = 6
        
            print("didClickAsset with resolution: \(didSelectAssets.first!.image?.size)")
            print("didClickAsset for selection")
        }
        
        override func imagePickerController(_ imagePickerController: DKImagePickerController, didDeselectAssets: [DKAsset]) {
            //tap to deselect asset
            //use this place for asset deselection customisation
            print("didClickAsset for deselection")
        }
    }
    
     
    
    
   /* func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //profileImage.image = image
        //let imageData = UIImageJPEGRepresentation(image, 0.05)
        arrImageData.add(image)
        self.dismiss(animated: true, completion: nil)
        collection.reloadData()
    } */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrListDetails.count
//        return predictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addListSearchCell", for: indexPath)
            as! addListSearchCell
        
        let dictTemp = arrListDetails[indexPath.row] as! NSDictionary
        cell.lblTitle.text = dictTemp.value(forKey: "name") as? String
        cell.lblDesc.text = dictTemp.value(forKey: "address") as? String
        
//        cell.lblTitle.text = predictions[indexPath.row].attributedPrimaryText.string
//        cell.lblDesc.text = predictions[indexPath.row].attributedSecondaryText?.string
        
        tblSearch.rowHeight = 80
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        locationname = predictions[indexPath.row].attributedPrimaryText.string
//        address = predictions[indexPath.row].attributedSecondaryText?.string ?? ""
        
        
        let dict = arrListDetails[indexPath.row] as! NSDictionary
        //change on 07.01.2021
        dictselectedData.removeAllObjects()
        ////**********/
        dictselectedData = dict.mutableCopy() as! NSMutableDictionary
        
        dictselectedData = removeNullFromDict(dict: dictselectedData)
        
// MARK: - Uncomment lines below to show default location images
//        let imge1  = dictselectedData.value(forKey: "list_image") as! String
//        let imge2  = dictselectedData.value(forKey: "listing_image1") as! String
//        let imge3  = dictselectedData.value(forKey: "listing_image2") as! String
//        let imge4  = dictselectedData.value(forKey: "listing_image3") as! String
//
//        if(imge1 != ""){
//
//            arrListingImages.add(imge1)
//        }
//
//        if(imge2 != ""){
//
//            arrListingImages.add(imge2)
//        }
//
//        if(imge3 != ""){
//
//            arrListingImages.add(imge3)
//        }
//
//        if(imge4 != ""){
//
//            arrListingImages.add(imge4)
//        }
// MARK: - Uncomment lines above to show default location images
        
        txtSearch.text = dictselectedData.value(forKey: "name") as? String
        tblSearch.isHidden = true
        self.view.endEditing(true)
        collection.reloadData()
        
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ///change on 07.12.2021
        guard textField.text!.isEmpty else { return }
        tblSearch.isHidden = true
        self.clearAllPreviousData()
        ///************
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text!.isEmpty else { return }
        tblSearch.isHidden = true
        self.clearAllPreviousData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                print("Backspace was pressed")
                
                if(textField.text?.count == 1){
                    
                    tblSearch.isHidden = true
                    
                }else{
                    
                    searchText = textField.text! + string
                    
                    makeRequest()
                    if(searchText == ""){
                        
                        tblSearch.isHidden = true
                    }
                }
            }else{
                
                searchText = textField.text! + string
    
                makeRequest()
                if(searchText == ""){
                    
                    tblSearch.isHidden = true
                }
            }
        }
        
        
        
        return true
    }
    
    @IBAction func onClickHCParkingRatings(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            
            parking_rate = 1.0
            HCParking_rate1.image = UIImage(named: "star-blue")
            HCParking_rate2.image = UIImage(named: "star-grey")
            HCParking_rate3.image = UIImage(named: "star-grey")
            HCParking_rate4.image = UIImage(named: "star-grey")
            HCParking_rate5.image = UIImage(named: "star-grey")
            break
            
        case 1:
            
            parking_rate = 2.0
            HCParking_rate1.image = UIImage(named: "star-blue")
            HCParking_rate2.image = UIImage(named: "star-blue")
            HCParking_rate3.image = UIImage(named: "star-grey")
            HCParking_rate4.image = UIImage(named: "star-grey")
            HCParking_rate5.image = UIImage(named: "star-grey")
            break
            
        case 2:
            
            parking_rate = 3.0
            HCParking_rate1.image = UIImage(named: "star-blue")
            HCParking_rate2.image = UIImage(named: "star-blue")
            HCParking_rate3.image = UIImage(named: "star-blue")
            HCParking_rate4.image = UIImage(named: "star-grey")
            HCParking_rate5.image = UIImage(named: "star-grey")
            break
            
        case 3:
            
            parking_rate = 4.0
            HCParking_rate1.image = UIImage(named: "star-blue")
            HCParking_rate2.image = UIImage(named: "star-blue")
            HCParking_rate3.image = UIImage(named: "star-blue")
            HCParking_rate4.image = UIImage(named: "star-blue")
            HCParking_rate5.image = UIImage(named: "star-grey")
            break
            
        case 4:
            
            parking_rate = 5.0
            HCParking_rate1.image = UIImage(named: "star-blue")
            HCParking_rate2.image = UIImage(named: "star-blue")
            HCParking_rate3.image = UIImage(named: "star-blue")
            HCParking_rate4.image = UIImage(named: "star-blue")
            HCParking_rate5.image = UIImage(named: "star-blue")
            break
            
        default:
            
            parking_rate = 1.0
            HCParking_rate1.image = UIImage(named: "star-blue")
            HCParking_rate2.image = UIImage(named: "star-grey")
            HCParking_rate3.image = UIImage(named: "star-grey")
            HCParking_rate4.image = UIImage(named: "star-grey")
            HCParking_rate5.image = UIImage(named: "star-grey")
        }
        
    }
    
    @IBAction func onClickHCParkingLocated(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            location_of_handicapped_parking = "Front"
            HCParking_located1.image = UIImage(named: "radiob")
            HCParking_located2.image = UIImage(named: "radiob1")
            HCParking_located3.image = UIImage(named: "radiob1")
            HCParking_located4.image = UIImage(named: "radiob1")
            
            break
            
        case 1:
            
            location_of_handicapped_parking = "Street"
            HCParking_located1.image = UIImage(named: "radiob1")
            HCParking_located2.image = UIImage(named: "radiob")
            HCParking_located3.image = UIImage(named: "radiob1")
            HCParking_located4.image = UIImage(named: "radiob1")
            break
            
        case 2:
            
            location_of_handicapped_parking = "Back"
            HCParking_located1.image = UIImage(named: "radiob1")
            HCParking_located2.image = UIImage(named: "radiob1")
            HCParking_located3.image = UIImage(named: "radiob")
            HCParking_located4.image = UIImage(named: "radiob1")
            break
            
        case 3:
            
            location_of_handicapped_parking = "Parking Lot"
            HCParking_located1.image = UIImage(named: "radiob1")
            HCParking_located2.image = UIImage(named: "radiob1")
            HCParking_located3.image = UIImage(named: "radiob1")
            HCParking_located4.image = UIImage(named: "radiob")
            break
            
        default:
            
            HCParking_located1.image = UIImage(named: "radiob1")
            HCParking_located2.image = UIImage(named: "radiob")
            HCParking_located3.image = UIImage(named: "radiob")
            HCParking_located4.image = UIImage(named: "radiob")
        }
        
    }
    
    @IBAction func onClickHCEntranceRatings(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            
            entrance_rate = 1.0
            HCEntrance_rate1.image = UIImage(named: "star-blue")
            HCEntrance_rate2.image = UIImage(named: "star-grey")
            HCEntrance_rate3.image = UIImage(named: "star-grey")
            HCEntrance_rate4.image = UIImage(named: "star-grey")
            HCEntrance_rate5.image = UIImage(named: "star-grey")
            break
            
        case 1:
            
            entrance_rate = 2.0
            HCEntrance_rate1.image = UIImage(named: "star-blue")
            HCEntrance_rate2.image = UIImage(named: "star-blue")
            HCEntrance_rate3.image = UIImage(named: "star-grey")
            HCEntrance_rate4.image = UIImage(named: "star-grey")
            HCEntrance_rate5.image = UIImage(named: "star-grey")
            break
            
        case 2:
            
            entrance_rate = 3.0
            HCEntrance_rate1.image = UIImage(named: "star-blue")
            HCEntrance_rate2.image = UIImage(named: "star-blue")
            HCEntrance_rate3.image = UIImage(named: "star-blue")
            HCEntrance_rate4.image = UIImage(named: "star-grey")
            HCEntrance_rate5.image = UIImage(named: "star-grey")
            break
            
        case 3:
            
            entrance_rate = 4.0
            HCEntrance_rate1.image = UIImage(named: "star-blue")
            HCEntrance_rate2.image = UIImage(named: "star-blue")
            HCEntrance_rate3.image = UIImage(named: "star-blue")
            HCEntrance_rate4.image = UIImage(named: "star-blue")
            HCEntrance_rate5.image = UIImage(named: "star-grey")
            break
            
        case 4:
            
            entrance_rate = 5.0
            HCEntrance_rate1.image = UIImage(named: "star-blue")
            HCEntrance_rate2.image = UIImage(named: "star-blue")
            HCEntrance_rate3.image = UIImage(named: "star-blue")
            HCEntrance_rate4.image = UIImage(named: "star-blue")
            HCEntrance_rate5.image = UIImage(named: "star-blue")
            break
            
        default:
            
            entrance_rate = 1.0
            HCEntrance_rate1.image = UIImage(named: "star-blue")
            HCEntrance_rate2.image = UIImage(named: "star-grey")
            HCEntrance_rate3.image = UIImage(named: "star-grey")
            HCEntrance_rate4.image = UIImage(named: "star-grey")
            HCEntrance_rate5.image = UIImage(named: "star-grey")
        }
        
    }
    
    @IBAction func onClickHCEntranceLocated(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            entrance = "Front"
            HCEntrance_located1.image = UIImage(named: "radiob")
            HCEntrance_located2.image = UIImage(named: "radiob1")
            HCEntrance_located3.image = UIImage(named: "radiob1")
            HCEntrance_located4.image = UIImage(named: "radiob1")
            HCEntrance_located5.image = UIImage(named: "radiob1")
            HCEntrance_located6.image = UIImage(named: "radiob1")
            
            break
            
        case 1:
            
            entrance = "Back"
            HCEntrance_located1.image = UIImage(named: "radiob1")
            HCEntrance_located2.image = UIImage(named: "radiob")
            HCEntrance_located3.image = UIImage(named: "radiob1")
            HCEntrance_located4.image = UIImage(named: "radiob1")
            HCEntrance_located5.image = UIImage(named: "radiob1")
            HCEntrance_located6.image = UIImage(named: "radiob1")
            break
            
        case 2:
            
            entrance = "Left of the biliding"
            HCEntrance_located1.image = UIImage(named: "radiob1")
            HCEntrance_located2.image = UIImage(named: "radiob1")
            HCEntrance_located3.image = UIImage(named: "radiob")
            HCEntrance_located4.image = UIImage(named: "radiob1")
            HCEntrance_located5.image = UIImage(named: "radiob1")
            HCEntrance_located6.image = UIImage(named: "radiob1")
            break
            
        case 3:
            
            entrance = "Street"
            HCEntrance_located1.image = UIImage(named: "radiob1")
            HCEntrance_located2.image = UIImage(named: "radiob1")
            HCEntrance_located3.image = UIImage(named: "radiob1")
            HCEntrance_located4.image = UIImage(named: "radiob")
            HCEntrance_located5.image = UIImage(named: "radiob1")
            HCEntrance_located6.image = UIImage(named: "radiob1")
            break
            
        case 4:
            
            entrance = "None"
            HCEntrance_located1.image = UIImage(named: "radiob1")
            HCEntrance_located2.image = UIImage(named: "radiob1")
            HCEntrance_located3.image = UIImage(named: "radiob1")
            HCEntrance_located4.image = UIImage(named: "radiob1")
            HCEntrance_located5.image = UIImage(named: "radiob")
            HCEntrance_located6.image = UIImage(named: "radiob1")
            break
            
        case 5:
            
            entrance = "Right of the building"
            HCEntrance_located1.image = UIImage(named: "radiob1")
            HCEntrance_located2.image = UIImage(named: "radiob1")
            HCEntrance_located3.image = UIImage(named: "radiob1")
            HCEntrance_located4.image = UIImage(named: "radiob1")
            HCEntrance_located5.image = UIImage(named: "radiob1")
            HCEntrance_located6.image = UIImage(named: "radiob")
            break
            
        default:
            
            HCParking_located1.image = UIImage(named: "radiob1")
            HCParking_located2.image = UIImage(named: "radiob")
            HCParking_located3.image = UIImage(named: "radiob")
            HCParking_located4.image = UIImage(named: "radiob")
        }
        
    }
    
    @IBAction func onClickHCEntranceType(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            new_hc_entrance = "Street Level"
            HCEntrance_type1.image = UIImage(named: "radiob")
            HCEntrance_type2.image = UIImage(named: "radiob1")
            HCEntrance_type3.image = UIImage(named: "radiob1")
            HCEntrance_type4.image = UIImage(named: "radiob1")
            HCEntrance_type5.image = UIImage(named: "radiob1")
            
            
            break
            
        case 1:
            
            new_hc_entrance = "Elevator"
            HCEntrance_type1.image = UIImage(named: "radiob1")
            HCEntrance_type2.image = UIImage(named: "radiob")
            HCEntrance_type3.image = UIImage(named: "radiob1")
            HCEntrance_type4.image = UIImage(named: "radiob1")
            HCEntrance_type5.image = UIImage(named: "radiob1")
            
            break
            
        case 2:
            
            new_hc_entrance = "none"
            HCEntrance_type1.image = UIImage(named: "radiob1")
            HCEntrance_type2.image = UIImage(named: "radiob1")
            HCEntrance_type3.image = UIImage(named: "radiob")
            HCEntrance_type4.image = UIImage(named: "radiob1")
            HCEntrance_type5.image = UIImage(named: "radiob1")
            
            break
            
        case 3:
            
            new_hc_entrance = "Ramp"
            HCEntrance_type1.image = UIImage(named: "radiob1")
            HCEntrance_type2.image = UIImage(named: "radiob1")
            HCEntrance_type3.image = UIImage(named: "radiob1")
            HCEntrance_type4.image = UIImage(named: "radiob")
            HCEntrance_type5.image = UIImage(named: "radiob1")
            
            break
            
        case 4:
            
            new_hc_entrance = "Portable Ramp"
            HCEntrance_type1.image = UIImage(named: "radiob1")
            HCEntrance_type2.image = UIImage(named: "radiob1")
            HCEntrance_type3.image = UIImage(named: "radiob1")
            HCEntrance_type4.image = UIImage(named: "radiob1")
            HCEntrance_type5.image = UIImage(named: "radiob")
            
            break
            
        default:
            
            HCParking_located1.image = UIImage(named: "radiob1")
            HCParking_located2.image = UIImage(named: "radiob")
            HCParking_located3.image = UIImage(named: "radiob")
            HCParking_located4.image = UIImage(named: "radiob")
        }
        
    }
    
    @IBAction func onClickHCEntranceDoor(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            door_entrance = "Automatic"
            HCEntrance_doortype1.image = UIImage(named: "radiob")
            HCEntrance_doortype2.image = UIImage(named: "radiob1")
            HCEntrance_doortype3.image = UIImage(named: "radiob1")
            
            
            
            break
            
        case 1:
            
            door_entrance = "No Doors"
            HCEntrance_doortype1.image = UIImage(named: "radiob1")
            HCEntrance_doortype2.image = UIImage(named: "radiob")
            HCEntrance_doortype3.image = UIImage(named: "radiob1")
            
            
            break
            
        case 2:
            
            door_entrance = "Manual"
            HCEntrance_doortype1.image = UIImage(named: "radiob1")
            HCEntrance_doortype2.image = UIImage(named: "radiob1")
            HCEntrance_doortype3.image = UIImage(named: "radiob")
            
            break
        default:
            
            HCParking_located1.image = UIImage(named: "radiob1")
            HCParking_located2.image = UIImage(named: "radiob")
            HCParking_located3.image = UIImage(named: "radiob")
            HCParking_located4.image = UIImage(named: "radiob")
        }
        
    }
    
    @IBAction func onClickHCEntrancewidth(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            width_entrance = "Too narrow"
            HCEntrance_width1.image = UIImage(named: "radiob")
            HCEntrance_width2.image = UIImage(named: "radiob1")
            HCEntrance_width3.image = UIImage(named: "radiob1")
            
            
            
            break
            
        case 1:
            
            width_entrance = "Spacious"
            HCEntrance_width1.image = UIImage(named: "radiob1")
            HCEntrance_width2.image = UIImage(named: "radiob")
            HCEntrance_width3.image = UIImage(named: "radiob1")
            
            
            break
            
        case 2:
            
            width_entrance = "Adequate"
            HCEntrance_width1.image = UIImage(named: "radiob1")
            HCEntrance_width2.image = UIImage(named: "radiob1")
            HCEntrance_width3.image = UIImage(named: "radiob")
            
            break
        default:
            
            HCParking_located1.image = UIImage(named: "radiob1")
            HCParking_located2.image = UIImage(named: "radiob")
            HCParking_located3.image = UIImage(named: "radiob")
            HCParking_located4.image = UIImage(named: "radiob")
        }
        
    }
    
    @IBAction func onClickSpaciousnessRatings(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            
            venue_rate = 1.0
            Spaciousness_rate1.image = UIImage(named: "star-blue")
            Spaciousness_rate2.image = UIImage(named: "star-grey")
            Spaciousness_rate3.image = UIImage(named: "star-grey")
            Spaciousness_rate4.image = UIImage(named: "star-grey")
            Spaciousness_rate5.image = UIImage(named: "star-grey")
            break
            
        case 1:
            
            venue_rate = 2.0
            Spaciousness_rate1.image = UIImage(named: "star-blue")
            Spaciousness_rate2.image = UIImage(named: "star-blue")
            Spaciousness_rate3.image = UIImage(named: "star-grey")
            Spaciousness_rate4.image = UIImage(named: "star-grey")
            Spaciousness_rate5.image = UIImage(named: "star-grey")
            break
            
        case 2:
            
            venue_rate = 3.0
            Spaciousness_rate1.image = UIImage(named: "star-blue")
            Spaciousness_rate2.image = UIImage(named: "star-blue")
            Spaciousness_rate3.image = UIImage(named: "star-blue")
            Spaciousness_rate4.image = UIImage(named: "star-grey")
            Spaciousness_rate5.image = UIImage(named: "star-grey")
            break
            
        case 3:
            
            venue_rate = 4.0
            Spaciousness_rate1.image = UIImage(named: "star-blue")
            Spaciousness_rate2.image = UIImage(named: "star-blue")
            Spaciousness_rate3.image = UIImage(named: "star-blue")
            Spaciousness_rate4.image = UIImage(named: "star-blue")
            Spaciousness_rate5.image = UIImage(named: "star-grey")
            break
            
        case 4:
            
            venue_rate = 5.0
            Spaciousness_rate1.image = UIImage(named: "star-blue")
            Spaciousness_rate2.image = UIImage(named: "star-blue")
            Spaciousness_rate3.image = UIImage(named: "star-blue")
            Spaciousness_rate4.image = UIImage(named: "star-blue")
            Spaciousness_rate5.image = UIImage(named: "star-blue")
            break
            
        default:
            
            venue_rate = 1.0
            Spaciousness_rate1.image = UIImage(named: "star-blue")
            Spaciousness_rate2.image = UIImage(named: "star-grey")
            Spaciousness_rate3.image = UIImage(named: "star-grey")
            Spaciousness_rate4.image = UIImage(named: "star-grey")
            Spaciousness_rate5.image = UIImage(named: "star-grey")
        }
        
    }
    
    @IBAction func onClickSpaciousnessVenue(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            spaciousness_of_venue = "Too Tight"
            Spaciousness_venue1.image = UIImage(named: "radiob")
            Spaciousness_venue2.image = UIImage(named: "radiob1")
            Spaciousness_venue3.image = UIImage(named: "radiob1")
            
            
            
            break
            
        case 1:
            
            spaciousness_of_venue = "Adequate"
            Spaciousness_venue1.image = UIImage(named: "radiob1")
            Spaciousness_venue2.image = UIImage(named: "radiob")
            Spaciousness_venue3.image = UIImage(named: "radiob1")
            
            
            break
            
        case 2:
            
            spaciousness_of_venue = "Spacious"
            Spaciousness_venue1.image = UIImage(named: "radiob1")
            Spaciousness_venue2.image = UIImage(named: "radiob1")
            Spaciousness_venue3.image = UIImage(named: "radiob")
            
            break
            
        default:
            
            Spaciousness_venue1.image = UIImage(named: "radiob1")
            Spaciousness_venue2.image = UIImage(named: "radiob")
            Spaciousness_venue3.image = UIImage(named: "radiob")
            
        }
        
    }
    
    @IBAction func onClickSeatingRatings(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            
            seating_rate = 1.0
            Seating_rate1.image = UIImage(named: "star-blue")
            Seating_rate2.image = UIImage(named: "star-grey")
            Seating_rate3.image = UIImage(named: "star-grey")
            Seating_rate4.image = UIImage(named: "star-grey")
            Seating_rate5.image = UIImage(named: "star-grey")
            break
            
        case 1:
            
            seating_rate = 2.0
            Seating_rate1.image = UIImage(named: "star-blue")
            Seating_rate2.image = UIImage(named: "star-blue")
            Seating_rate3.image = UIImage(named: "star-grey")
            Seating_rate4.image = UIImage(named: "star-grey")
            Seating_rate5.image = UIImage(named: "star-grey")
            break
            
        case 2:
            
            seating_rate = 3.0
            Seating_rate1.image = UIImage(named: "star-blue")
            Seating_rate2.image = UIImage(named: "star-blue")
            Seating_rate3.image = UIImage(named: "star-blue")
            Seating_rate4.image = UIImage(named: "star-grey")
            Seating_rate5.image = UIImage(named: "star-grey")
            break
            
        case 3:
            
            seating_rate = 4.0
            Seating_rate1.image = UIImage(named: "star-blue")
            Seating_rate2.image = UIImage(named: "star-blue")
            Seating_rate3.image = UIImage(named: "star-blue")
            Seating_rate4.image = UIImage(named: "star-blue")
            Seating_rate5.image = UIImage(named: "star-grey")
            break
            
        case 4:
            
            seating_rate = 5.0
            Seating_rate1.image = UIImage(named: "star-blue")
            Seating_rate2.image = UIImage(named: "star-blue")
            Seating_rate3.image = UIImage(named: "star-blue")
            Seating_rate4.image = UIImage(named: "star-blue")
            Seating_rate5.image = UIImage(named: "star-blue")
            break
            
        default:
            
            seating_rate = 1.0
            Seating_rate1.image = UIImage(named: "star-blue")
            Seating_rate2.image = UIImage(named: "star-grey")
            Seating_rate3.image = UIImage(named: "star-grey")
            Seating_rate4.image = UIImage(named: "star-grey")
            Seating_rate5.image = UIImage(named: "star-grey")
        }
        
    }
    
    @IBAction func onClickSettingLocated(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            seating_located = "Seating throughout"
            Seating_located1.image = UIImage(named: "radiob")
            Seating_located2.image = UIImage(named: "radiob1")
            Seating_located3.image = UIImage(named: "radiob1")
            Seating_located4.image = UIImage(named: "radiob1")
            
            
            
            break
            
        case 1:
            
            seating_located = "Outside"
            Seating_located1.image = UIImage(named: "radiob1")
            Seating_located2.image = UIImage(named: "radiob")
            Seating_located3.image = UIImage(named: "radiob1")
            Seating_located4.image = UIImage(named: "radiob1")
            
            
            break
            
        case 2:
            
            seating_located = "Designated Area"
            Seating_located1.image = UIImage(named: "radiob1")
            Seating_located2.image = UIImage(named: "radiob1")
            Seating_located3.image = UIImage(named: "radiob")
            Seating_located4.image = UIImage(named: "radiob1")
            
            
            break
            
        case 3:
            
            seating_located = "None"
            Seating_located1.image = UIImage(named: "radiob1")
            Seating_located2.image = UIImage(named: "radiob1")
            Seating_located3.image = UIImage(named: "radiob1")
            Seating_located4.image = UIImage(named: "radiob")
            
            
            break
            
        default:
            
            Seating_located1.image = UIImage(named: "radiob1")
            Seating_located2.image = UIImage(named: "radiob")
            Seating_located3.image = UIImage(named: "radiob")
            Seating_located4.image = UIImage(named: "radiob")
        }
        
    }
    
    @IBAction func onClickBathroomRatings(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            
            bathroom_rate = 1.0
            Bathroom_rate1.image = UIImage(named: "star-blue")
            Bathroom_rate2.image = UIImage(named: "star-grey")
            Bathroom_rate3.image = UIImage(named: "star-grey")
            Bathroom_rate4.image = UIImage(named: "star-grey")
            Bathroom_rate5.image = UIImage(named: "star-grey")
            break
            
        case 1:
            
            bathroom_rate = 2.0
            Bathroom_rate1.image = UIImage(named: "star-blue")
            Bathroom_rate2.image = UIImage(named: "star-blue")
            Bathroom_rate3.image = UIImage(named: "star-grey")
            Bathroom_rate4.image = UIImage(named: "star-grey")
            Bathroom_rate5.image = UIImage(named: "star-grey")
            break
            
        case 2:
            
            bathroom_rate = 3.0
            Bathroom_rate1.image = UIImage(named: "star-blue")
            Bathroom_rate2.image = UIImage(named: "star-blue")
            Bathroom_rate3.image = UIImage(named: "star-blue")
            Bathroom_rate4.image = UIImage(named: "star-grey")
            Bathroom_rate5.image = UIImage(named: "star-grey")
            break
            
        case 3:
            
            bathroom_rate = 4.0
            Bathroom_rate1.image = UIImage(named: "star-blue")
            Bathroom_rate2.image = UIImage(named: "star-blue")
            Bathroom_rate3.image = UIImage(named: "star-blue")
            Bathroom_rate4.image = UIImage(named: "star-blue")
            Bathroom_rate5.image = UIImage(named: "star-grey")
            break
            
        case 4:
            
            
            bathroom_rate = 5.0
            Bathroom_rate1.image = UIImage(named: "star-blue")
            Bathroom_rate2.image = UIImage(named: "star-blue")
            Bathroom_rate3.image = UIImage(named: "star-blue")
            Bathroom_rate4.image = UIImage(named: "star-blue")
            Bathroom_rate5.image = UIImage(named: "star-blue")
            break
            
        default:
            
            
            bathroom_rate = 1.0
            Bathroom_rate1.image = UIImage(named: "star-blue")
            Bathroom_rate2.image = UIImage(named: "star-grey")
            Bathroom_rate3.image = UIImage(named: "star-grey")
            Bathroom_rate4.image = UIImage(named: "star-grey")
            Bathroom_rate5.image = UIImage(named: "star-grey")
        }
        
    }
    
    @IBAction func onClickBathroomDoor(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            bathroom_opening_directions = "Opens out"
            Bathroom_door1.image = UIImage(named: "radiob")
            Bathroom_door2.image = UIImage(named: "radiob1")
            Bathroom_door3.image = UIImage(named: "radiob1")
            Bathroom_door4.image = UIImage(named: "radiob1")
            
            break
            
        case 1:
            
            bathroom_opening_directions = "No door"
            Bathroom_door1.image = UIImage(named: "radiob1")
            Bathroom_door2.image = UIImage(named: "radiob")
            Bathroom_door3.image = UIImage(named: "radiob1")
            Bathroom_door4.image = UIImage(named: "radiob1")
            
            break
            
        case 2:
            
            bathroom_opening_directions = "Opens in"
            Bathroom_door1.image = UIImage(named: "radiob1")
            Bathroom_door2.image = UIImage(named: "radiob1")
            Bathroom_door3.image = UIImage(named: "radiob")
            Bathroom_door4.image = UIImage(named: "radiob1")
            
            break
            
        case 3:
            
            bathroom_opening_directions = "Didn't use"
            Bathroom_door1.image = UIImage(named: "radiob1")
            Bathroom_door2.image = UIImage(named: "radiob1")
            Bathroom_door3.image = UIImage(named: "radiob1")
            Bathroom_door4.image = UIImage(named: "radiob")
            
            
            break
            
            
        default:
            
            Bathroom_door1.image = UIImage(named: "radiob1")
            Bathroom_door2.image = UIImage(named: "radiob")
            Bathroom_door3.image = UIImage(named: "radiob")
            Bathroom_door4.image = UIImage(named: "radiob")
        }
        
    }
    
    @IBAction func onClickBathroomOpening(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            ease_of_opening = "Easy"
            Bathroom_opening1.image = UIImage(named: "radiob")
            Bathroom_opening2.image = UIImage(named: "radiob1")
            Bathroom_opening3.image = UIImage(named: "radiob1")
            break
            
        case 1:
            
            ease_of_opening = "Difficult to open"
            Bathroom_opening1.image = UIImage(named: "radiob1")
            Bathroom_opening2.image = UIImage(named: "radiob")
            Bathroom_opening3.image = UIImage(named: "radiob1")
            
            break
            
        case 2:
            
            ease_of_opening = "Average"
            Bathroom_opening1.image = UIImage(named: "radiob1")
            Bathroom_opening2.image = UIImage(named: "radiob1")
            Bathroom_opening3.image = UIImage(named: "radiob")
            break
            
            
            
        default:
            
            Bathroom_door1.image = UIImage(named: "radiob1")
            Bathroom_door2.image = UIImage(named: "radiob")
            Bathroom_door3.image = UIImage(named: "radiob")
            Bathroom_door4.image = UIImage(named: "radiob")
        }
        
    }
    
    @IBAction func onClickBathroomStall(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            size_of_stal = "Too small"
            Bathroom_stall1.image = UIImage(named: "radiob")
            Bathroom_stall2.image = UIImage(named: "radiob1")
            Bathroom_stall3.image = UIImage(named: "radiob1")
            break
            
        case 1:
            
            size_of_stal = "Spacious"
            Bathroom_stall1.image = UIImage(named: "radiob1")
            Bathroom_stall2.image = UIImage(named: "radiob")
            Bathroom_stall3.image = UIImage(named: "radiob1")
            
            break
            
        case 2:
            
            size_of_stal = "Adequate"
            Bathroom_stall1.image = UIImage(named: "radiob1")
            Bathroom_stall2.image = UIImage(named: "radiob1")
            Bathroom_stall3.image = UIImage(named: "radiob")
            break
            
        default:
            
            Bathroom_stall1.image = UIImage(named: "radiob1")
            Bathroom_stall2.image = UIImage(named: "radiob")
            Bathroom_stall3.image = UIImage(named: "radiob")
            
        }
        
    }
    
    @IBAction func onClickBathroomAmenities(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            aminities = "Fully accessible"
            Bathroom_amenities1.image = UIImage(named: "radiob")
            Bathroom_amenities2.image = UIImage(named: "radiob1")
            Bathroom_amenities3.image = UIImage(named: "radiob1")
            break
            
        case 1:
            
            aminities = "None"
            Bathroom_amenities1.image = UIImage(named: "radiob1")
            Bathroom_amenities2.image = UIImage(named: "radiob")
            Bathroom_amenities3.image = UIImage(named: "radiob1")
            
            break
            
        case 2:
            
            aminities = "Some Amenities"
            Bathroom_amenities1.image = UIImage(named: "radiob1")
            Bathroom_amenities2.image = UIImage(named: "radiob1")
            Bathroom_amenities3.image = UIImage(named: "radiob")
            break
            
        default:
            
            Bathroom_amenities1.image = UIImage(named: "radiob1")
            Bathroom_amenities2.image = UIImage(named: "radiob")
            Bathroom_amenities3.image = UIImage(named: "radiob")
            
        }
        
    }
    
    @IBAction func onClickBathroomChangeTable(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            changing_table = "Yes"
            Bathroom_changtable1.image = UIImage(named: "radiob")
            Bathroom_changtable2.image = UIImage(named: "radiob1")
            Bathroom_changtable3.image = UIImage(named: "radiob1")
            break
            
        case 1:
            
            changing_table = "Didn't check"
            Bathroom_changtable1.image = UIImage(named: "radiob1")
            Bathroom_changtable2.image = UIImage(named: "radiob")
            Bathroom_changtable3.image = UIImage(named: "radiob1")
            
            break
            
        case 2:
            
            changing_table = "No"
            Bathroom_changtable1.image = UIImage(named: "radiob1")
            Bathroom_changtable2.image = UIImage(named: "radiob1")
            Bathroom_changtable3.image = UIImage(named: "radiob")
            break
            
        default:
            
            Bathroom_changtable1.image = UIImage(named: "radiob1")
            Bathroom_changtable2.image = UIImage(named: "radiob")
            Bathroom_changtable3.image = UIImage(named: "radiob")
            
        }
        
    }
    
    @IBAction func onClickRampRatings(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            
            ramp_rate = 1.0
            Ramp_rate1.image = UIImage(named: "star-blue")
            Ramp_rate2.image = UIImage(named: "star-grey")
            Ramp_rate3.image = UIImage(named: "star-grey")
            Ramp_rate4.image = UIImage(named: "star-grey")
            Ramp_rate5.image = UIImage(named: "star-grey")
            break
            
        case 1:
            
            ramp_rate = 2.0
            Ramp_rate1.image = UIImage(named: "star-blue")
            Ramp_rate2.image = UIImage(named: "star-blue")
            Ramp_rate3.image = UIImage(named: "star-grey")
            Ramp_rate4.image = UIImage(named: "star-grey")
            Ramp_rate5.image = UIImage(named: "star-grey")
            break
            
        case 2:
            
            ramp_rate = 3.0
            Ramp_rate1.image = UIImage(named: "star-blue")
            Ramp_rate2.image = UIImage(named: "star-blue")
            Ramp_rate3.image = UIImage(named: "star-blue")
            Ramp_rate4.image = UIImage(named: "star-grey")
            Ramp_rate5.image = UIImage(named: "star-grey")
            break
            
        case 3:
            
            ramp_rate = 4.0
            Ramp_rate1.image = UIImage(named: "star-blue")
            Ramp_rate2.image = UIImage(named: "star-blue")
            Ramp_rate3.image = UIImage(named: "star-blue")
            Ramp_rate4.image = UIImage(named: "star-blue")
            Ramp_rate5.image = UIImage(named: "star-grey")
            break
            
        case 4:
            
            ramp_rate = 5.0
            Ramp_rate1.image = UIImage(named: "star-blue")
            Ramp_rate2.image = UIImage(named: "star-blue")
            Ramp_rate3.image = UIImage(named: "star-blue")
            Ramp_rate4.image = UIImage(named: "star-blue")
            Ramp_rate5.image = UIImage(named: "star-blue")
            break
            
        default:
            
            ramp_rate = 1.0
            Ramp_rate1.image = UIImage(named: "star-blue")
            Ramp_rate2.image = UIImage(named: "star-grey")
            Ramp_rate3.image = UIImage(named: "star-grey")
            Ramp_rate4.image = UIImage(named: "star-grey")
            Ramp_rate5.image = UIImage(named: "star-grey")
        }
        
    }
    
    @IBAction func onClickRampSteepness(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            steepness_of_the_ramp = "Easy grade"
            Ramp_steepness1.image = UIImage(named: "radiob")
            Ramp_steepness2.image = UIImage(named: "radiob1")
            Ramp_steepness3.image = UIImage(named: "radiob1")
            Ramp_steepness4.image = UIImage(named: "radiob1")
            
            break
            
        case 1:
            
            steepness_of_the_ramp = "Too steep"
            Ramp_steepness1.image = UIImage(named: "radiob1")
            Ramp_steepness2.image = UIImage(named: "radiob")
            Ramp_steepness3.image = UIImage(named: "radiob1")
            Ramp_steepness4.image = UIImage(named: "radiob1")
            
            
            break
            
        case 2:
            
            steepness_of_the_ramp = "Medium grade"
            Ramp_steepness1.image = UIImage(named: "radiob1")
            Ramp_steepness2.image = UIImage(named: "radiob1")
            Ramp_steepness3.image = UIImage(named: "radiob")
            Ramp_steepness4.image = UIImage(named: "radiob1")
            
            
            break
            
        case 3:
            
            steepness_of_the_ramp = "None"
            Ramp_steepness1.image = UIImage(named: "radiob1")
            Ramp_steepness2.image = UIImage(named: "radiob1")
            Ramp_steepness3.image = UIImage(named: "radiob1")
            Ramp_steepness4.image = UIImage(named: "radiob")
            
            break
            
        default:
            
            Ramp_steepness1.image = UIImage(named: "radiob1")
            Ramp_steepness2.image = UIImage(named: "radiob")
            Ramp_steepness3.image = UIImage(named: "radiob")
            Ramp_steepness4.image = UIImage(named: "radiob")
        }
        
    }
    
    @IBAction func onClickElevatorRatings(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            
            elevator_rate = 1.0
            Elevator_rate1.image = UIImage(named: "star-blue")
            Elevator_rate2.image = UIImage(named: "star-grey")
            Elevator_rate3.image = UIImage(named: "star-grey")
            Elevator_rate4.image = UIImage(named: "star-grey")
            Elevator_rate5.image = UIImage(named: "star-grey")
            break
            
        case 1:
            
            elevator_rate = 2.0
            Elevator_rate1.image = UIImage(named: "star-blue")
            Elevator_rate2.image = UIImage(named: "star-blue")
            Elevator_rate3.image = UIImage(named: "star-grey")
            Elevator_rate4.image = UIImage(named: "star-grey")
            Elevator_rate5.image = UIImage(named: "star-grey")
            break
            
        case 2:
            
            elevator_rate = 3.0
            Elevator_rate1.image = UIImage(named: "star-blue")
            Elevator_rate2.image = UIImage(named: "star-blue")
            Elevator_rate3.image = UIImage(named: "star-blue")
            Elevator_rate4.image = UIImage(named: "star-grey")
            Elevator_rate5.image = UIImage(named: "star-grey")
            break
            
        case 3:
            
            elevator_rate = 4.0
            Elevator_rate1.image = UIImage(named: "star-blue")
            Elevator_rate2.image = UIImage(named: "star-blue")
            Elevator_rate3.image = UIImage(named: "star-blue")
            Elevator_rate4.image = UIImage(named: "star-blue")
            Elevator_rate5.image = UIImage(named: "star-grey")
            break
            
        case 4:
            
            elevator_rate = 5.0
            Elevator_rate1.image = UIImage(named: "star-blue")
            Elevator_rate2.image = UIImage(named: "star-blue")
            Elevator_rate3.image = UIImage(named: "star-blue")
            Elevator_rate4.image = UIImage(named: "star-blue")
            Elevator_rate5.image = UIImage(named: "star-blue")
            break
            
        default:
            
            elevator_rate = 1.0
            Elevator_rate1.image = UIImage(named: "star-blue")
            Elevator_rate2.image = UIImage(named: "star-grey")
            Elevator_rate3.image = UIImage(named: "star-grey")
            Elevator_rate4.image = UIImage(named: "star-grey")
            Elevator_rate5.image = UIImage(named: "star-grey")
        }
        
    }
    
    @IBAction func onClickElevatorSpeciousness(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            
            size_of_the_elevator = "Too small"
            Elevator_spaciousness1.image = UIImage(named: "radiob")
            Elevator_spaciousness2.image = UIImage(named: "radiob1")
            Elevator_spaciousness3.image = UIImage(named: "radiob1")
            Elevator_spaciousness4.image = UIImage(named: "radiob1")
            
            break
            
        case 1:
            
            size_of_the_elevator = "Spacious"
            Elevator_spaciousness1.image = UIImage(named: "radiob1")
            Elevator_spaciousness2.image = UIImage(named: "radiob")
            Elevator_spaciousness3.image = UIImage(named: "radiob1")
            Elevator_spaciousness4.image = UIImage(named: "radiob1")
            
            break
            
        case 2:
            
            size_of_the_elevator = "Adequate"
            Elevator_spaciousness1.image = UIImage(named: "radiob1")
            Elevator_spaciousness2.image = UIImage(named: "radiob1")
            Elevator_spaciousness3.image = UIImage(named: "radiob")
            Elevator_spaciousness4.image = UIImage(named: "radiob1")
            
            break
            
        case 3:
            
            size_of_the_elevator = "None"
            Elevator_spaciousness1.image = UIImage(named: "radiob1")
            Elevator_spaciousness2.image = UIImage(named: "radiob1")
            Elevator_spaciousness3.image = UIImage(named: "radiob1")
            Elevator_spaciousness4.image = UIImage(named: "radiob")
            
            break
            
            
            
        default:
            
            Elevator_spaciousness1.image = UIImage(named: "star-blue")
            Elevator_spaciousness2.image = UIImage(named: "star-grey")
            Elevator_spaciousness3.image = UIImage(named: "star-grey")
            Elevator_spaciousness4.image = UIImage(named: "star-grey")
            
        }
        
    }
    
    @IBAction func onClickMobilityUser(_ sender: UIButton) {
        
        
        switch sender.tag {
        case 0:
            
            mobility = "Electric WheelChair"
            Mobility_type1.image = UIImage(named: "radiob")
            Mobility_type2.image = UIImage(named: "radiob1")
            Mobility_type3.image = UIImage(named: "radiob1")
            Mobility_type4.image = UIImage(named: "radiob1")
            Mobility_type5.image = UIImage(named: "radiob1")
            Mobility_type6.image = UIImage(named: "radiob1")
            
            break
            
        case 1:
            
            mobility = "Able body"
            Mobility_type1.image = UIImage(named: "radiob1")
            Mobility_type2.image = UIImage(named: "radiob")
            Mobility_type3.image = UIImage(named: "radiob1")
            Mobility_type4.image = UIImage(named: "radiob1")
            Mobility_type5.image = UIImage(named: "radiob1")
            Mobility_type6.image = UIImage(named: "radiob1")
            break
            
        case 2:
            
            mobility = "Crutches/Walker"
            Mobility_type1.image = UIImage(named: "radiob1")
            Mobility_type2.image = UIImage(named: "radiob1")
            Mobility_type3.image = UIImage(named: "radiob")
            Mobility_type4.image = UIImage(named: "radiob1")
            Mobility_type5.image = UIImage(named: "radiob1")
            Mobility_type6.image = UIImage(named: "radiob1")
            break
            
        case 3:
            
            mobility = "Manual WheelChair"
            Mobility_type1.image = UIImage(named: "radiob1")
            Mobility_type2.image = UIImage(named: "radiob1")
            Mobility_type3.image = UIImage(named: "radiob1")
            Mobility_type4.image = UIImage(named: "radiob")
            Mobility_type5.image = UIImage(named: "radiob1")
            Mobility_type6.image = UIImage(named: "radiob1")
            break
            
        case 4:
            
            mobility = "Scooter"
            Mobility_type1.image = UIImage(named: "radiob1")
            Mobility_type2.image = UIImage(named: "radiob1")
            Mobility_type3.image = UIImage(named: "radiob1")
            Mobility_type4.image = UIImage(named: "radiob1")
            Mobility_type5.image = UIImage(named: "radiob")
            Mobility_type6.image = UIImage(named: "radiob1")
            break
            
        case 5:
            
            mobility = "Baby Walker"
            Mobility_type1.image = UIImage(named: "radiob1")
            Mobility_type2.image = UIImage(named: "radiob1")
            Mobility_type3.image = UIImage(named: "radiob1")
            Mobility_type4.image = UIImage(named: "radiob1")
            Mobility_type5.image = UIImage(named: "radiob1")
            Mobility_type6.image = UIImage(named: "radiob")
            break
            
        default:
            
            Mobility_type1.image = UIImage(named: "radiob1")
            Mobility_type2.image = UIImage(named: "radiob")
            Mobility_type3.image = UIImage(named: "radiob")
            Mobility_type4.image = UIImage(named: "radiob")
            Mobility_type5.image = UIImage(named: "radiob")
            Mobility_type6.image = UIImage(named: "radiob")
        }
        
    }
    
    // MARK: - Collection UIDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
      /*  let num1 = self.assets?.count ?? 0;
        let num2 = arrListingImages.count;

       
        ans = num1+num2;
        
        if (ans > 4){
            
            maxReturnCount = 4
            return 4
            
        }else{
            maxReturnCount = ans
            return ans
        } */
      
        
        if(self.assets?.count ?? 0 > 0){
            
            return self.assets?.count ?? 0
            
        }else{
            
            return arrListingImages.count
        }
        
        
       // return arrListingImages.count
       // return self.assets?.count ?? 0 + arrListingImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addListPhotoCell", for: indexPath) as! addListPhotoCell
        
        /*  let url = arrListingImages[indexPath.item]
          cell.imgSelectedImage.loadImageUsingCacheWithURLString(url as! String, placeHolder: UIImage(named: "placeholder")) */
        
        
        
        if(self.assets?.count ?? 0 > 0){
            
            let asset = self.assets![indexPath.row]
            var maskView: UIView?
            
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let tag = indexPath.row + 1
            cell.tag = tag
            
            asset.fetchImage(with: layout.itemSize.toPixel(), completeBlock: { image, info in
                if cell.tag == tag {
                    cell.imgSelectedImage.image = image
                    
                    
                }
                
            })
            
            maskView?.isHidden = !self.exportManually
            
            
        }else{
            
            let url = arrListingImages[indexPath.item]
            cell.imgSelectedImage.loadImageUsingCacheWithURLString(url as! String, placeHolder: UIImage(named: "placeholder"))
            
        }
        
        
        
        
       /* if(arrListingImages.count > 0){
            
            if(indexPath.item < arrListingImages.count){
                
                let url = arrListingImages[indexPath.item]
                cell.imgSelectedImage.loadImageUsingCacheWithURLString(url as! String, placeHolder: UIImage(named: "placeholder"))
            }else{
                
                var assetIndex = Int()
                assetIndex = maxReturnCount-(indexPath.item+1)
                
                let asset = self.assets![assetIndex]
                var maskView: UIView?
                
                    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                    let tag = indexPath.row + 1
                    cell.tag = tag
                
                    asset.fetchImage(with: layout.itemSize.toPixel(), completeBlock: { image, info in
                        if cell.tag == tag {
                            cell.imgSelectedImage.image = image
                            
                         
                        }
                        
                    })
                
                maskView?.isHidden = !self.exportManually
                
            }
            
        }else{
            
            let asset = self.assets![indexPath.row]
            var maskView: UIView?
            
                let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                let tag = indexPath.row + 1
                cell.tag = tag
            
                asset.fetchImage(with: layout.itemSize.toPixel(), completeBlock: { image, info in
                    if cell.tag == tag {
                        cell.imgSelectedImage.image = image
                        
                     
                    }
                    
                })
            
            maskView?.isHidden = !self.exportManually
            
        } */
        
        
        cell.imgSelectedImage.contentMode = .scaleToFill
        //cell.imgSelectedImage.image = arrImageData[indexPath.item] as? UIImage
        
        
        
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/3 - 10, height: collectionView.frame.size.width/3 + 10)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let location = locations.last{
            
            
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            
        }
        
    }
    
    
}
extension String
{
    var parseJSONString: AnyObject?
    {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)

        if let jsonData = data
        {
            // Will return an object or nil if JSON decoding fails
            do
            {
                let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
                if let jsonResult = message as? NSMutableArray
                {
                    print(jsonResult)

                    return jsonResult //Will return the json array output
                }
                else
                {
                    return nil
                }
            }
            catch let error as NSError
            {
                print("An error occurred: \(error)")
                return nil
            }
        }
        else
        {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}
extension Int {
    var byteSize: String {
        return ByteCountFormatter().string(fromByteCount: Int64(self))
    }
}


extension AddListViewController {
    func makeRequest() {
        debouncer.renewInterval()
        print("renew interval")
        debouncer.handler = {
            self.searchApi()
        }
    }
}
