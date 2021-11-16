import UIKit
import Alamofire
import MapKit
import GoogleMaps
import SDWebImage


class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GMSMapViewDelegate,UITextViewDelegate{

  
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var imgRate1: UIImageView!
    @IBOutlet weak var imgRate2: UIImageView!
    @IBOutlet weak var imgRate3: UIImageView!
    @IBOutlet weak var imgRate4: UIImageView!
    @IBOutlet weak var imgRate5: UIImageView!
    @IBOutlet weak var viewAddReview: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var lblPleaseWait: UILabel!
    @IBOutlet weak var viewPleaseWait: UIView!
    @IBOutlet weak var viewSpinner: UIView!
    var spinner:JTMaterialSpinner!

    
    var listId = ""
    var catid = ""
    var dictData = NSDictionary()
    var arrRatting = NSArray()
    var arrHeaderImages = NSArray()
    var arrFacility = NSArray()
    var arrComents = NSArray()
    var rate = 0
    var isOn = false
    var portalid = ""
    var selectedItemListId = ""
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            self.loadAllMethods()
        }
        
    }
    
    //MARK:- my selector that was defined above
    @objc func willEnterForeground() {
        // do stuff
        DispatchQueue.main.async {
            //self.loadAllMethods()
            self.tblData.reloadData()
        }
    }
    
    //MARK:- Methods
    
    func loadAllMethods(){
        
        let deledate = UIApplication.shared.delegate as? AppDelegate
        deledate?.isDetailScreen = true
        
        setDelegates()
        detailApiCall()
        
     /*   if(isOn == true){
            
           
            
        }else{
            
          //  YelpDetail()
            
        }*/
        
        
       // getHeaderImageArray()
        
        setToolBar()
        viewAddReview.layer.cornerRadius = 5.0
        btnPost.layer.cornerRadius = btnPost.frame.size.height/2
        txtMessage.layer.borderColor = UIColor.blue.cgColor
        txtMessage.layer.borderWidth = 1.0
    
        loadLoader()
    }
    
    func setDelegates(){
        
        tblData.delegate = self
        tblData.dataSource = self
        
    }
    
    @objc func loadTbl(){
        DispatchQueue.main.async {
          self.tblData.reloadData()
        }
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
            
            spinner.endRefreshing()
            self.viewSpinner.isHidden = true
            
        }*/
        
    }
    
    func removeLoader(){
        DispatchQueue.main.async {
            self.spinner.endRefreshing()
          self.viewSpinner.isHidden = true
        }
    }
    
    func detailApiCall(){
        
        let url = "https://wheretowheel.us/api/hotels/listing_details?listing_id=\(listId)"
        
        AF.request(url, method: .post, parameters: [:]).responseJSON { response in
            
            ///////////for test purpose
            
            /*let alert = UIAlertView()
            alert.title = "Where To Wheel"
            alert.message = String(describing: response)
            alert.addButton(withTitle: "Ok")
            alert.show()*/
            
            
            ///////////
    
            if response.value != nil {
                
                
                let responseData = response.value as! NSDictionary
                
                let rsDic = responseData.mutableCopy() as! NSMutableDictionary
                let resDic = self.removeNullFromDict(dict: rsDic)
                
                self.dictData = resDic.value(forKey: "response") as! NSDictionary
                self.arrRatting = self.dictData.value(forKey: "Ratingtag") as! NSArray
                if let images = self.dictData.value(forKey: "Images") as? NSArray {
                    self.arrHeaderImages = images
                }
                self.arrFacility = self.dictData.value(forKey: "Facilites") as! NSArray
                
               /* let review = self.dictData.value(forKey: "reviews") as! NSArray
                self.arrComents = review.value(forKey: "reviews") as! NSArray*/
                
               /* guard let name = nameField.text else {
                    show("No name to submit")
                    return
                }*/
                ///////////for test purpose
                
                /*let alert = UIAlertView()
                alert.title = "Where To Wheel"
                alert.message = String(describing: rsDic)
                alert.addButton(withTitle: "Ok")
                alert.show()*/
                
                
                ///////////
                
                if let str = self.dictData.value(forKey: "reviews") as? String{
                    
                    print("this is string = \(str)")
                    
                }else{
                    
                     self.arrComents = self.dictData.value(forKey: "reviews") as! NSArray
                    
                }

                
               
                
                // let defaults = UserDefaults.standard
               //  defaults.set(self.arrFacility, forKey: "Facilites")
               //  defaults.synchronize()
                
                UserDefaults.standard.set(self.arrFacility, forKey: "Facilites")
                DispatchQueue.main.async {
                self.removeLoader()
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
    
  /*  func YelpDetail(){
            
            let url = "https://wheretowheel.us/api/hotels/listing_details_yelp?yelp_id=\(listId)"
            
            AF.request(url, method: .post, parameters: [:]).responseJSON { response in
        
                if response.value != nil {
                    
                    
                    let responseData = response.value as! NSDictionary
                  
                    let res = responseData.value(forKey: "response") as! NSDictionary
                      self.dictData = res.value(forKey: "listing_details") as! NSDictionary
                  //  self.arrRatting = self.dictData.value(forKey: "Ratingtag") as! NSArray
                    self.arrHeaderImages = self.dictData.value(forKey: "photos") as! NSArray
                    self.arrFacility = self.dictData.value(forKey: "categories") as! NSArray
                    
    //                let defaults = UserDefaults.standard
    //                defaults.set(self.arrFacility, forKey: "Facilites")
    //                defaults.synchronize()
                    
                    UserDefaults.standard.set(self.arrFacility, forKey: "Facilites")
                    self.tblData.reloadData()
                   
                }
            }
        }**/
    
    func addReviewCall(){
           
       // let userId = dictData.value(forKey: "user_id") as! String
        let userId = UserDefaults.standard.value(forKey: "userid") as! String
    
        let url = "https://wheretowheel.us/api/hotels/add_review"
        
        let parameters: Parameters = ["user_id": userId, "rating": rate, "reviews": txtMessage.text!,"listing_id": listId,"rating_id": 0]

               AF.request(url, method: .post, parameters: parameters).responseJSON { response in
                
                let responseData = response.value as! NSDictionary
                let res = responseData.value(forKey: "response") as! NSDictionary
                let message = res.value(forKey: "message") as? String
                
                let alertController = UIAlertController(title: "Where To Wheel", message: message, preferredStyle: .alert)

                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                
                    self.viewDidLoad()
                }
                // Add the actions
                alertController.addAction(okAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
        
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
    
    func changeMainViewController(to viewController: UIViewController) {
        //Change main viewcontroller of side menu view controller
        let navigationViewController = UINavigationController(rootViewController: viewController)
        slideMenuController()?.changeMainViewController(navigationViewController, close: true)
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

        let lat1 : NSString = dictData.value(forKey: "latitude") as! NSString
        let lng1 : NSString = dictData.value(forKey: "longitude") as! NSString

        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue

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
    
    func setToolBar(){
        
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
       // UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtMessage.inputAccessoryView = numberToolbar
    }
    
    @objc func doneWithNumberPad() {
        
        
        self.view.endEditing(true)
        
    }

    //MARK:- IBActions
    
    @IBAction func onClickRattingButtons(_ sender: UIButton) {
        
        
        switch sender.tag {
            
        case 0:
            
            rate = 1
            imgRate1.image = UIImage(named: "star-blue")
            imgRate2.image = UIImage(named: "star-grey")
            imgRate3.image = UIImage(named: "star-grey")
            imgRate4.image = UIImage(named: "star-grey")
            imgRate5.image = UIImage(named: "star-grey")
            break
            
        case 1:
            
            rate = 2
            imgRate1.image = UIImage(named: "star-blue")
            imgRate2.image = UIImage(named: "star-blue")
            imgRate3.image = UIImage(named: "star-grey")
            imgRate4.image = UIImage(named: "star-grey")
            imgRate5.image = UIImage(named: "star-grey")
            break
            
        case 2:
            
            rate = 3
            imgRate1.image = UIImage(named: "star-blue")
            imgRate2.image = UIImage(named: "star-blue")
            imgRate3.image = UIImage(named: "star-blue")
            imgRate4.image = UIImage(named: "star-grey")
            imgRate5.image = UIImage(named: "star-grey")
            break
            
        case 3:
            
            rate = 4
            imgRate1.image = UIImage(named: "star-blue")
            imgRate2.image = UIImage(named: "star-blue")
            imgRate3.image = UIImage(named: "star-blue")
            imgRate4.image = UIImage(named: "star-blue")
            imgRate5.image = UIImage(named: "star-grey")
            break
            
            
        case 4:
            
            rate = 5
            imgRate1.image = UIImage(named: "star-blue")
            imgRate2.image = UIImage(named: "star-blue")
            imgRate3.image = UIImage(named: "star-blue")
            imgRate4.image = UIImage(named: "star-blue")
            imgRate5.image = UIImage(named: "star-blue")
            break
            
        default:
            imgRate1.image = UIImage(named: "star-grey")
            imgRate2.image = UIImage(named: "star-grey")
            imgRate3.image = UIImage(named: "star-grey")
            imgRate4.image = UIImage(named: "star-grey")
            imgRate5.image = UIImage(named: "star-grey")
            break
        }
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        
        
        
      /*  guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "DashboardDetailViewController") as? DashboardDetailViewController else {
            return
        }
        tabViewController.catid = catid
        changeMainViewController(to: tabViewController)*/
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func onClickPost(_ sender: Any) {
        
        addReviewCall()
        scroll.isHidden = true
        
    }
    
    @objc @IBAction func onClickAddressButtons(_ sender: UIButton) {
        
        if sender.tag == 0{
            
          
            open(scheme: dictData.value(forKey: "website_address") as! String)
            
        }else if sender.tag == 1{
            
            open(scheme: "tel://\(dictData.value(forKey: "phone_number") ?? "")")
            
        }else if sender.tag == 2{
            
            openMapForPlace()
            
        }else if sender.tag == 3{
            
            let login = UserDefaults.standard.bool(forKey: "isLogin")
            
            if login {
                
                scroll.isHidden = false
                
            }else{
                
                
                showAlertWith(title: "Go", message: "Please Login or SignUp First...")
            
            }
            
            
            
        }else if sender.tag == 4{
            
            /*guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "TableBookViewController") as? TableBookViewController else {
                return
            }
            
             //  let dictTemp = arrListDetails[sender.tag] as! NSDictionary
            tabViewController.listid = dictData.value(forKey: "id") as! String
            tabViewController.portalid = dictData.value(forKey: "portal_id") as! String*/
            
            selectedItemListId = dictData.value(forKey: "id") as! String
            portalid = dictData.value(forKey: "portal_id") as! String
            
            performSegue(withIdentifier: "bookTable", sender: self)
            
            
            
            
            //changeMainViewController(to: tabViewController)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "bookTable") {
         
         let vc = segue.destination as! TableBookViewController
          vc.portalid = portalid
          vc.listid = selectedItemListId
         
        }
    }
    
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
           
           let alertController = UIAlertController(title: "", message: message, preferredStyle: style)
           let action = UIAlertAction(title: title, style: .default) { (action) in
              // self.dismiss(animated: true, completion: nil)
               
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
    
    
    
    
     @objc func onClickShareButtons(_ sender: UIButton) {
           
        
        
          
        if(sender.tag == 0){
            
            let str = String(describing: self.dictData["facebook_share"]!)
            let url = URL(string:str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            if(url != nil){
                UIApplication.shared.open(url!)
                //UIApplication.shared.canOpenURL(url!)
            }
            
            //let url = NSURL(string: dictData.value(forKey: "facebook_share") as! String)!
            //UIApplication.shared.openURL(url as URL)
            
        }else if(sender.tag == 1){
            
            let str = String(describing: self.dictData["twitter"]!)
            let url = URL(string:str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            if(url != nil){
                UIApplication.shared.open(url!)
                //UIApplication.shared.canOpenURL(url!)
            }
            
            //let url = NSURL(string: dictData.value(forKey: "twitter") as! String)!
            //UIApplication.shared.openURL(url as URL)
            
        }else if(sender.tag == 2){
            
            let str = String(describing: self.dictData["instagram"]!)
            let url = URL(string:str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            if(url != nil){
                UIApplication.shared.open(url!)
                //UIApplication.shared.canOpenURL(url!)
            }
            
            //let url = NSURL(string: dictData.value(forKey: "instagram") as! String)!
            //UIApplication.shared.openURL(url as URL)
            
        }else if(sender.tag == 3){
            
            let str = String(describing: self.dictData["google_plus"]!)
            let url = URL(string:str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            if(url != nil){
                UIApplication.shared.open(url!)
                //UIApplication.shared.canOpenURL(url!)
            }
            
            //let url = NSURL(string: dictData.value(forKey: "google_plus") as! String)!
            //UIApplication.shared.openURL(url as URL)
            
        }else{
            
            let str = String(describing: self.dictData["linkedin"]!)
            let url = URL(string:str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            if(url != nil){
                UIApplication.shared.open(url!)
                //UIApplication.shared.canOpenURL(url!)
            }
            
            //let url = NSURL(string: dictData.value(forKey: "linkedin") as! String)!
            //UIApplication.shared.openURL(url as URL)
            
        }
    
    }
    
    
    func setImage(from url: String, imageview : UIImageView) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                imageview.image = image
            }
        }
    }
    
    func downloadImage(from url: URL,imageview : UIImageView) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                imageview.image = UIImage(data: data)
                self.index = self.index + 1
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    //MARK:- Tableview delegates and datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 12
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
            
        }else if(section == 6){
            
            return 1
            
        }else if(section == 7){
            
            return 1
            
        }else if(section == 8){
            
            return 1
            
        }else if(section == 9){
            
            return arrRatting.count
            
        }else if(section == 10){
            
            return 1
            
        }else if(section == 11){
            
            return arrComents.count
            
        }else{
            
            return 1
            
        }
     
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var placeholderImage: UIImage? = nil
        if placeholderImage == nil {
            placeholderImage = UIImage(named: "placeholder")
        }
        
        if(indexPath.section == 0){
            
                let identifier = "topImageCell"
                
                var cell: topImageCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? topImageCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "topImageCell", bundle: nil), forCellReuseIdentifier:  identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? topImageCell
                    
                }
                
            tblData.rowHeight = 200
            
            if(arrHeaderImages.count > 0){
        
                
                Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                    
                    let randomNumber = Int.random(in: 0...self.arrHeaderImages.count-1)
                    
                    print("index is = \(self.index)")
                    
                    if self.index > self.arrHeaderImages.count - 1 {
                        
                        self.index = 0
                    }
                    
                    let dictTemp = self.arrHeaderImages[self.index] as! NSDictionary
                    
                    
                    if let url1 = dictTemp.value(forKey: "Image"){
                        
                        let url : NSString = url1 as! NSString
                        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                        let searchURL : NSURL = NSURL(string: urlStr as String)!
                        self.downloadImage(from: searchURL as URL, imageview: cell.imgHeader)
                       // weak var imageView = cell.imgHeader
                        
                     /*   imageView?.sd_setImage(with: searchURL as URL, placeholderImage: placeholderImage, options:  indexPath.item == 0 ? SDWebImageOptions(rawValue: SDWebImageOptions.RawValue(Int(1 << 3))) : [], context: [
                            SDWebImageContextOption.imageThumbnailPixelSize: CGSize(width: 280, height: 240)
                            ], progress: nil, completed: { image, error, cacheType, imageURL in
                                
                                let operation = imageView?.sd_imageLoadOperation(forKey: imageView?.sd_latestOperationKey) as? SDWebImageCombinedOperation
                                let token = operation?.loaderOperation as? SDWebImageDownloadToken
                                if #available(iOS 10.0, *) {
                                    let metrics = token?.metrics
                                    if metrics != nil {
                                        if let c = (imageURL!.absoluteString as NSString).cString(using: String.Encoding.utf8.rawValue), let duration = metrics?.taskInterval.duration {
                                            index = index + 1
                                            print("Metrics: \(c) download in (\(duration)) seconds\n")
                                        }
                                    }
                                }
                        })*/
                        
                        
                        
                    }
                    
                    
                    
                }
                
            }
        
            return cell
            
        }else if(indexPath.section == 1){
            
            
          //  if(indexPath.row == 0){
                
                
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
                
        //    }
            
            
        }else if(indexPath.section == 2){
            
            //  if(indexPath.row == 0){
            
            
            let identifier = "addressThirdCell"
            
            var cell: addressThirdCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? addressThirdCell
            
            if cell == nil {
                
                tableView.register(UINib(nibName: "addressThirdCell", bundle: nil), forCellReuseIdentifier:  identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? addressThirdCell
                
            }
            
            
            cell.btnBookTable.layer.cornerRadius = cell.btnBookTable.frame.size.height/2
            
            cell.lblAddress.text = dictData.value(forKey: "address") as? String
            cell.lblOpenTime.text = "\(dictData.value(forKey: "time_opening_from") ?? "") - \(dictData.value(forKey: "time_opening_to") ?? "")"
            
            
            //   cell.openDay.text = dictData.value(forKey: "")
            
            
            cell.btnWeb.tag = 0
            cell.btnCall.tag = 1
            cell.btnGoogleDirection.tag = 2
            cell.btnChat.tag = 3
            cell.btnBookTable.tag = 4
            
            //let img = UIImage(named: "2m")
            //cell.btnGoogleDirection.setImage(img, for: .normal)
            //cell.btnGoogleDirection.tintColor = .black
            
            cell.btnWeb.addTarget(self, action: #selector(onClickAddressButtons), for: .touchUpInside)
            cell.btnCall.addTarget(self, action: #selector(onClickAddressButtons), for: .touchUpInside)
            cell.btnChat.addTarget(self, action: #selector(onClickAddressButtons), for: .touchUpInside)
            cell.btnGoogleDirection.addTarget(self, action: #selector(onClickAddressButtons), for: .touchUpInside)
            cell.btnBookTable.addTarget(self, action: #selector(onClickAddressButtons), for: .touchUpInside)
            
            tblData.rowHeight = 110
            
            return cell
            
            //  }
        }else if(indexPath.section == 3){
            

          //  if(indexPath.row == 0){
                

                let identifier = "aboutForthCell"
                
                var cell: aboutForthCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? aboutForthCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "aboutForthCell", bundle: nil), forCellReuseIdentifier:  identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? aboutForthCell
                    
                }
            
                cell.lblDesc.text = dictData.value(forKey: "description") as? String
            
                cell.lblDesc.frame = CGRect(x: cell.lblDesc.frame.origin.x, y: cell.lblDesc.frame.origin.y, width: cell.lblDesc.frame.size.width, height: getLabelHeight(cell.lblDesc))
            
                tblData.rowHeight = cell.lblDesc.frame.origin.y + cell.lblDesc.frame.size.height + 10;
                
                return cell

           // }

        }else if(indexPath.section == 4){
            
            
            let identifier = "featchersFifthCell"
            
            if(arrFacility.count > 0){
                
                
                var cell: featchersFifthCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? featchersFifthCell
                               
                               if cell == nil {
                                   
                                   tableView.register(UINib(nibName: "featchersFifthCell", bundle: nil), forCellReuseIdentifier:  identifier)
                                   cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? featchersFifthCell
                                   
                               }
                           
                               /*    if(dictData.count > 0){
                                   
                                   cell.listId = dictData.value(forKey: "id") as! String
                                   
                               } */
                
                if(arrFacility.count <= 3){
                    
                       tblData.rowHeight = 40
                    
                }else if(arrFacility.count <= 6){
                    
                       tblData.rowHeight = 80
                    
                }else if(arrFacility.count <= 9){
                    
                       tblData.rowHeight = 120
                    
                }else if(arrFacility.count <= 12){
                    
                       tblData.rowHeight = 160
                    
                }else{
                    
                    tblData.rowHeight = 240
                    
                }
                            
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
                
                //   cell.textLabel?.text = "Where to Wheel Ratings:"
                
                tblData.rowHeight = 20
                
                return cell
            }
                
               
            
        }else if (indexPath.section == 5){
            
            
            let identifier = "mapSixthCell"
                
                var cell: mapSixthCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? mapSixthCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "mapSixthCell", bundle: nil), forCellReuseIdentifier:  identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? mapSixthCell
                    
                }
            
            if(dictData.count > 0){
                
                                let lat1 : NSString = dictData.value(forKey: "latitude") as! NSString
                                let lng1 : NSString = dictData.value(forKey: "longitude") as! NSString

                                 let late:CLLocationDegrees =  lat1.doubleValue
                                 let long:CLLocationDegrees =  lng1.doubleValue
                           
                               let camera = GMSCameraPosition.camera(withLatitude: late,
                                                                 longitude: long,
                                                                       zoom: 10)
                           
                                 cell.map.camera = camera
                                 let position = CLLocationCoordinate2D(latitude: late, longitude: long)
                DispatchQueue.main.async{
                    
                    let london = GMSMarker(position: position)
                    let address = String(describing: self.dictData["address"]!)
                                     london.title = address
                                     london.icon = UIImage(named: "pin")
                                     london.map = cell.map
                    
                }
                                 
                           
                
            }
            
                tblData.rowHeight = 200
                
                return cell
            
        }else if(indexPath.section == 6){
            
            
            let identifier = "reviewSeventhCell"
                
                var cell: reviewSeventhCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? reviewSeventhCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "reviewSeventhCell", bundle: nil), forCellReuseIdentifier:  identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? reviewSeventhCell
                    
                }
            
            if(dictData.count > 0){
                
                 let rat = dictData.value(forKey: "yelp_rating") as! NSNumber
                 let rate = rat.intValue
                
              //  let rat1 = dictData.value(forKey: "google_rating") as! NSNumber
                //let rate1 = rat1.intValue
                
                
                let rat1: NSString = dictData.value(forKey: "rating") as? NSString ?? ""
                let rate1 = rat1.intValue
                
                
                if(Int(rate1) > 0){
                    
                    for i in 1...Int(rate1) {
                        
                        switch i {
                        case 1:
                            
                            cell.rate1G.image = UIImage(named: "star-yellow")
                            break
                        case 2:
                            
                            cell.rate2G.image = UIImage(named: "star-yellow")
                            break
                            
                        case 3:
                            
                            cell.rate3G.image = UIImage(named: "star-yellow")
                            break
                            
                        case 4:
                            
                            cell.rate4G.image = UIImage(named: "star-yellow")
                            break
                            
                        case 5:
                            
                            cell.rate5G.image = UIImage(named: "star-yellow")
                            break
                            
                            
                        default:
                            break
                        }
                    }
                    
                }
                
                
                
                
                if(Int(rate) > 0){
                    
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
                
             
            
            
                tblData.rowHeight = 90
                
                return cell
            
        }else if(indexPath.section == 7){
            
            let identifier = "shareEighthCell"
                
                var cell: shareEighthCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? shareEighthCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "shareEighthCell", bundle: nil), forCellReuseIdentifier:  identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? shareEighthCell
                    
                }
            
                 cell.btnfb.tag = 0
                 cell.btnTwetter.tag = 1
                 cell.btnInsta.tag = 2
                 cell.btnGoogle.tag = 3
                 cell.btnLinkdin.tag = 4
                cell.btnfb.addTarget(self, action: #selector(onClickShareButtons), for: .touchUpInside)
                cell.btnTwetter.addTarget(self, action: #selector(onClickShareButtons), for: .touchUpInside)
                cell.btnInsta.addTarget(self, action: #selector(onClickShareButtons), for: .touchUpInside)
                cell.btnGoogle.addTarget(self, action: #selector(onClickShareButtons), for: .touchUpInside)
                cell.btnLinkdin.addTarget(self, action: #selector(onClickShareButtons), for: .touchUpInside)
                tblData.rowHeight = 120
                
                return cell
            
        }else if(indexPath.section == 8){
            
             let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
        
             cell.textLabel?.text = "Where to Wheel Ratings:"
            
            tblData.rowHeight = 30
            
            return cell
            
        }else if(indexPath.section == 9){
            
            let identifier = "rattingNingthCell"
                
                var cell: rattingNingthCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? rattingNingthCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "rattingNingthCell", bundle: nil), forCellReuseIdentifier:  identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? rattingNingthCell
                    
                }
            
          
            
            if(indexPath.item == arrRatting.count - 1){
                
                cell.lblSeprator.isHidden = false
                
            }else{
                
                
               cell.lblSeprator.isHidden = true
                
            }
            
            
                let dictTemp = arrRatting[indexPath.item] as! NSDictionary
                cell.lblRate.text = dictTemp.value(forKey: "rating_tag") as? String
            
               if(arrRatting.count > 0){
                
                 cell.imgIcon.loadImageUsingCacheWithURLString(dictTemp.value(forKey: "Image") as! String, placeHolder: UIImage(named: "placeholder"))
                
               //  let rat: NSString = dictTemp.value(forKey: "rating")
                 let rat = dictTemp.value(forKey: "rating") as! NSNumber
                 let rate = rat.intValue
                
                if(Int(rate) > 0){
                    
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
            tblData.rowHeight = 55
            return cell
            
            
        }else if(indexPath.section == 10){
            
             let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
        
             cell.textLabel?.text = "User comments/Experience"
            
             tblData.rowHeight = 20
            
            return cell
            
        }else if(indexPath.section == 11){
            
            
            let identifier = "lastCell"
                
                var cell: lastCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? lastCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "lastCell", bundle: nil), forCellReuseIdentifier:  identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? lastCell
                    
                }
            
           /* let dictTemp = arrComents[indexPath.row] as! NSDictionary
            let dict = dictTemp.value(forKey: "user") as! NSDictionary*/
            
          /*  let dictTemp = arrComents[indexPath.row] as! NSDictionary
            let dict = dictTemp.value(forKey: "user") as! NSDictionary
            cell.lblName.text = dict.value(forKey: "name") as? String
            cell.lblDesc.text = dictTemp.value(forKey: "text") as? String
            
            cell.lblDesc.frame = CGRect(x: cell.lblDesc.frame.origin.x, y: cell.lblDesc.frame.origin.y, width: cell.lblDesc.frame.size.width, height: getLabelHeight(cell.lblDesc))
            
            tblData.rowHeight = cell.lblDesc.frame.origin.y + cell.lblDesc.frame.size.height + 10;
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.width/2
            
            if let url = dict.value(forKey: "image_url") as? String { */
            
            let dictTemp = arrComents[indexPath.row] as! NSDictionary
            cell.lblName.text = dictTemp.value(forKey: "user_name") as? String
            cell.lblDesc.text = dictTemp.value(forKey: "review") as? String
            cell.lblDesc.numberOfLines = 0;
            
            cell.lblDesc.frame = CGRect(x: cell.lblDesc.frame.origin.x, y: cell.lblDesc.frame.origin.y, width: cell.lblDesc.frame.size.width, height: getLabelHeight(cell.lblDesc))
            
            tblData.rowHeight = cell.lblDesc.frame.origin.y + cell.lblDesc.frame.size.height + 20;
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.width/2
            
            if let url = dictTemp.value(forKey: "user_image") as? String {
                
                 cell.imgProfile.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
            
                return cell
            
        }else{
            
            let identifier = "lastCell"
                
                var cell: lastCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? lastCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "lastCell", bundle: nil), forCellReuseIdentifier:  identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? lastCell
                }
                tblData.rowHeight = 70
                return cell
        }
        
    }
    
    //MARK: - textViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "   write a comment" {
            
            textView.text = ""
            
        }
        
    }
        
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
