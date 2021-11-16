
import UIKit
import RAMAnimatedTabBarController
import CoreData
import SDWebImage
import Alamofire

class DashboardViewController: SideBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var lblPleaseWait: UILabel!
    @IBOutlet weak var viewPleaseWait: UIView!
    @IBOutlet weak var viewSpinner: UIView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    var tabbar:CustomTabBarViewController!
    var arrCategoryData = [[String: AnyObject]]()
    var spinner = JTMaterialSpinner()
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DashboardCategoty.self))
        let sortDescriptor = NSSortDescriptor(key: "catid", ascending: true,
                                              selector: #selector(NSString.localizedStandardCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()

    //MARK:- UIViewController Initialize Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "User Tab"
        
        loadAllMethod()
     
        
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2-100, width: 150, height: 35))
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
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        (self.navigationController?.parent as? CustomTabBarViewController)?.animationTabBarHidden(false)
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        
        appdelegate?.SelectedIndex = 0
        
        if(appdelegate!.isProfile == true){
            
            
        }else{
             
             loadLoader()
        }
        
        
        appdelegate!.isProfile = false
    
       
    }
    
    func loadAllMethod(){
    
        collection.delegate = self;
        collection.dataSource = self;
        viewSearch.layer.borderWidth = 1.0
        viewSearch.layer.borderColor = UIColor.black.cgColor
        viewSearch.layer.cornerRadius = viewSearch.frame.size.height/2
        updateContent()
      
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
            
            self.spinner.endRefreshing()
           self.viewSpinner.isHidden = true
            
        }
        
    }
    
    func updateContent() {
        
        let url = "https://wheretowheel.us/api/hotels/categories"
        
        AF.request(url, method: .post, parameters: [:]).responseJSON { response in
            
            
            if response.value != nil {
                
                let responseData = response.value as! NSDictionary
                let res = responseData.value(forKey: "response") as! NSDictionary
                self.arrCategoryData = (res.value(forKey: "categorylist") as! NSArray) as! [[String : AnyObject]]
                self.clearData()
                self.saveInCoreDataWith(array: (res.value(forKey: "categorylist") as? [[String: AnyObject]])!)
               
                do {
                    try self.fetchedhResultController.performFetch()
                    print("COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
                    
                    /* DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                        self.spinner.endRefreshing()
                        self.viewSpinner.isHidden = true
                    }*/
                    
                } catch let error  {
                    print("ERROR: \(error)")
                }
                self.collection.reloadData()
            }
            
        }
        
        
        
       
      /*  let service = APIService()
        service.getDataWith { (result) in
            switch result {
            case .Success(let data):
                self.arrCategoryData = data
                self.clearData()
                self.saveInCoreDataWith(array: data)
                //self.collection.reloadData()

            case .Error(let message):
                DispatchQueue.main.async {
                    self.showAlertWith(title: "Error", message: message)
                }
            }
        }*/
        
       }
       
     func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
           
           let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
           let action = UIAlertAction(title: title, style: .default) { (action) in
               self.dismiss(animated: true, completion: nil)
           }
           alertController.addAction(action)
           self.present(alertController, animated: true, completion: nil)
       }
    
    private func clearData() {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DashboardCategoty.self))
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
        if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: "DashboardCategoty", into: context) as? DashboardCategoty {
            photoEntity.categoryname = dictionary["category_name"] as? String
            photoEntity.catid = dictionary["category_id"] as? String
            photoEntity.photourl = dictionary["app_icon"] as? String
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
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func changeMainViewController(to viewController: UIViewController) {
           //Change main viewcontroller of side menu view controller
           let navigationViewController = UINavigationController(rootViewController: viewController)
           slideMenuController()?.changeMainViewController(navigationViewController, close: true)
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
        
             return count
            
        }else{
            
          
            return 0
        }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       /* var placeholderImage: UIImage? = nil
        if placeholderImage == nil {
            placeholderImage = UIImage(named: "placeholder")
        }*/

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DashboardCell
      //  cell.imgItem.sd_imageTransition = SDWebImageTransition.fade
      //  cell.imgItem.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        
    
        if let photo = fetchedhResultController.object(at: indexPath) as? DashboardCategoty {
            cell.setPhotoCellWith(photo: photo)
            
            cell.lblItemName.text = photo.categoryname
            
         /*   weak var imageView = cell.imgItem
            
            imageView?.sd_setImage(with: URL(string: photo.photourl ?? ""), placeholderImage: placeholderImage, options:  indexPath.item == 0 ? SDWebImageOptions(rawValue: SDWebImageOptions.RawValue(Int(1 << 3))) : [], context: [
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
               }) */
            
            
        }
        
        if(arrCategoryData.count > 0){
            
            let dictTemp = arrCategoryData[indexPath.item] as NSDictionary
            cell.lblItemName.text = dictTemp.value(forKey: "category_name") as? String
            
        }
      
        /*weak var imageView = cell.imgItem
     
        imageView?.sd_setImage(with: URL(string: ""), placeholderImage: placeholderImage, options:  indexPath.item == 0 ? SDWebImageOptions(rawValue: SDWebImageOptions.RawValue(Int(1 << 3))) : [], context: [
            SDWebImageContextOption.imageThumbnailPixelSize: CGSize(width: 280, height: 240)
        ], progress: nil, completed: { image, error, cacheType, imageURL in
            
            let operation = imageView!.sd_imageLoadOperation(forKey: imageView?.sd_latestOperationKey) as! SDWebImageCombinedOperation
            let token = operation.loaderOperation as! SDWebImageDownloadToken
            if #available(iOS 10.0, *) {
                let metrics = token.metrics
                if metrics != nil {
                    if let c = (imageURL!.absoluteString as NSString).cString(using: String.Encoding.utf8.rawValue), let duration = metrics?.taskInterval.duration {
                        print("Metrics: \(c) download in (\(duration)) seconds\n")
                    }
                }
            }
        })*/

        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "DashboardDetailViewController") as? DashboardDetailViewController else {
            return
        }
        
       // let dictTemp = arrCategoryData[indexPath.item] as NSDictionary
        
       // tabViewController.catid = dictTemp.value(forKey: "category_id") as! String
      //  tabViewController.catname = dictTemp.value(forKey: "category_name") as! String
        
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DashboardCategoty")
        let sortDescriptor = NSSortDescriptor(key: "catid", ascending: true,
                                              selector: #selector(NSString.localizedStandardCompare(_:)))
        request.sortDescriptors = [sortDescriptor]
            request.returnsObjectsAsFaults = false
            do {
                let result = try CoreDataStack.sharedInstance.persistentContainer.viewContext.fetch(request)
                
                let data:NSManagedObject = result[indexPath.item] as! NSManagedObject

                tabViewController.catid = data.value(forKey: "catid") as! String
                tabViewController.catname = data.value(forKey: "categoryname") as! String
        
                
            } catch {
                
                print("Failed")
            }
            
        
        changeMainViewController(to: tabViewController)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/3 - 10, height: collectionView.frame.size.width/3 + 27)
    }
    
    @IBAction func onClickSearchButton(_ sender: Any) {
        
      //  tabbar.selectedIndex
        let tabbar = self.navigationController?.tabBarController as! CustomTabBarViewController
        tabbar.setSelectIndex(from: 0, to: 1)
    }
    
}




