
import UIKit
import Alamofire

class HistoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var lblPleaseWait: UILabel!
    @IBOutlet weak var viewPleaseWait: UIView!
    @IBOutlet weak var viewSpinner: UIView!
    
    var arrHistoryDetail = NSArray()
    var spinner = JTMaterialSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()

          self.navigationController?.navigationBar.isHidden = true
          
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async{
            self.loadLoader()
            self.callHistoryAPI()
            self.collection.delegate = self;
            self.collection.dataSource = self;
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async{
            self.collection.reloadData()
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
       
       /* DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            
           // self.spinner.endRefreshing()
          //  self.viewSpinner.isHidden = true
            
        }*/
    }
    
    func callHistoryAPI(){
        
        
       // let userid = UserDefaults.standard.value(forKey: "userid") as! String
        
        guard let userid = UserDefaults.standard.value(forKey: "userid") else {
           
            
            return
        }
        
        let url = "https://wheretowheel.us/api/user/booking_history?user_id=\(userid)"
        
        AF.request(url, method: .post, parameters: [:]).responseJSON { response in
        
            
            
            if response.value != nil {
                
                
                let responseData = response.value as! NSDictionary
                let res = responseData.value(forKey: "response") as! NSDictionary
                
                let rsDic = res.mutableCopy() as! NSMutableDictionary
                let resDic = self.removeNullFromDict(dict: rsDic)
                if(String(describing: resDic["status"]!) == "1"){
                    self.arrHistoryDetail = resDic.value(forKey: "Booking_details") as! NSArray
                    print(self.arrHistoryDetail)
                    DispatchQueue.main.async{
                        self.collection.reloadData()
                    }
                    
                }else{
                    let alert = UIAlertController(title: "No booking found", message: "", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                
                 self.spinner.endRefreshing()
                 self.viewSpinner.isHidden = true
                
            }else{
                
                self.spinner.endRefreshing()
                self.viewSpinner.isHidden = true
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
    
    func downloadImage(from url: URL,imageview : UIImageView) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
           
            DispatchQueue.main.async() {
    
                imageview.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    @IBAction func onCLickBack(_ sender: Any) {
        
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.makeRootViewController()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrHistoryDetail.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! historyCell
        cell.backgroundColor = .white
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
        
        let dictTemp = arrHistoryDetail[indexPath.item] as! NSDictionary
        cell.lblTitle.text = dictTemp.value(forKey: "booking_restaurant") as? String
        cell.lblSubTitle.text = dictTemp.value(forKey: "description") as? String
        cell.lblDate.text = dictTemp.value(forKey: "booking_date") as? String
        cell.lblTime.text = dictTemp.value(forKey: "booking_time") as? String
        
        
        if let url1 = dictTemp.value(forKey: "img"){
            
            let url : NSString = url1 as! NSString
            let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
            let searchURL : NSURL = NSURL(string: urlStr as String)!
            self.downloadImage(from: searchURL as URL, imageview: cell.img)
           
        }
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 1. request an UITraitCollection instance
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            return CGSize(width: collectionView.frame.size.width/2 - 20, height: collectionView.frame.size.width/4 + 20)
        case .phone:
            print("iPhone and iPod touch style UI")
            return CGSize(width: collectionView.frame.size.width - 20, height: collectionView.frame.size.width/4 + 20)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        return CGSize(width: collectionView.frame.size.width - 20, height: collectionView.frame.size.width/4 + 20)
    }
    
    
    /*func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let numberOfSets = CGFloat(1)

        let width = (collectionView.frame.size.width - (numberOfSets * view.frame.size.width / 15))/numberOfSets

        let height = collectionView.frame.size.height / 2

        return CGSize(width: width, height: height);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAtIndex section: Int) -> UIEdgeInsets {

        let cellWidthPadding = collectionView.frame.size.width / 30
        let cellHeightPadding = collectionView.frame.size.height / 4
        return UIEdgeInsets(top: cellHeightPadding,left: cellWidthPadding, bottom: cellHeightPadding,right: cellWidthPadding)
    }*/

}
