import UIKit

class addressThirdCell: UITableViewCell {
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnBookTable: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnGoogleDirection: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnWeb: UIButton!
    @IBOutlet weak var lblOpenTime: UILabel!
    @IBOutlet weak var openDay: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
