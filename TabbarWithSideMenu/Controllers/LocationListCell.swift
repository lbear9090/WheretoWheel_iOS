import UIKit
import SDWebImage

class LocationListCell: UICollectionViewCell {
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnBookTable: UIButton!
    @IBOutlet weak var imgBig: SDAnimatedImageView!
    @IBOutlet weak var lblMI: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lbldesc: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgAppIcon: UIImageView!
    
   /* func setPhotoCellWith(photo: List) {
        
        DispatchQueue.main.async {
           // self.authorLabel.text = photo.author
          // self.lblItemName.text = photo.categoryname
            if let url = photo.imgURL{
                self.imgBig.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
        }
    } */
}
