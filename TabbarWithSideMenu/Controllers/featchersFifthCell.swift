
import UIKit
import Alamofire

class featchersFifthCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collection: UICollectionView!
    
    var arrData = NSArray()
    var listId = ""
    
    override func awakeFromNib() {
        
        super.awakeFromNib()

        //let defaults = UserDefaults.standard
        
        collection.delegate = self;
        collection.dataSource = self;
        collection.register(UINib(nibName: "featcherCollectionCell", bundle: nil), forCellWithReuseIdentifier: "featcherCollectionCell")
        collection.reloadData()
        
        if let arrTemp = UserDefaults.standard.value(forKey: "Facilites"){
             
            arrData = arrTemp as! NSArray
            print(arrData)
            collection.reloadData()
            
        }
       
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return arrData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featcherCollectionCell", for: indexPath) as! featcherCollectionCell
     
        let cellIdentifier = "featcherCollectionCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? featcherCollectionCell
        
        cell?.contentView.layer.cornerRadius = 10.0
        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.clear.cgColor
        cell?.contentView.layer.masksToBounds = true
        cell?.layer.shadowColor = UIColor.black.cgColor
        cell?.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell?.layer.shadowRadius = 2.0
        cell?.layer.shadowOpacity = 0.5
        cell?.layer.masksToBounds = false
        cell?.layer.shadowPath = UIBezierPath(roundedRect: cell!.bounds, cornerRadius: (cell?.contentView.layer.cornerRadius)!).cgPath
        
       let dictTemp = arrData[indexPath.item] as! NSDictionary
        
        let deledate = UIApplication.shared.delegate as? AppDelegate
        
        if(deledate?.isDetailScreen == true){
            
             cell?.lblName.text = dictTemp.value(forKey: "facilite") as? String
            
        }else{
            
            cell?.lblName.text = dictTemp.value(forKey: "title") as? String
            
        }
        
       // cell?.lblName.text = dictTemp.value(forKey: "title") as? String
        
       // cell?.lblName.text = "hello 1234 manshdg 4562"
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/3 - 9, height: 50)
        
    }
    
    
    
}
