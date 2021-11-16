
import UIKit

class addreassMapCell: UITableViewCell {

    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCityState: UILabel!
    @IBOutlet weak var lblZip: UILabel!
    
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnWeb: UIButton!
    @IBOutlet weak var btnDirection: UIButton!
    @IBOutlet weak var lblMobile: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
