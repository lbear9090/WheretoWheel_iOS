import UIKit
import SDWebImage

class DashboardCell: UICollectionViewCell {
    
    
   // @IBOutlet weak var roundView: UIView!
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var imgItem: SDAnimatedImageView!
    
    func setPhotoCellWith(photo: DashboardCategoty) {
        
        DispatchQueue.main.async {
           // self.authorLabel.text = photo.author
          // self.lblItemName.text = photo.categoryname
            if let url = photo.photourl {
                self.imgItem.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
        }
    }
}

