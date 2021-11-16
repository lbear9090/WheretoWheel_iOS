
import UIKit

class FAQViewController: UIViewController {
    
   

       @IBOutlet weak var tableView: UITableView!
       @IBOutlet weak var viewCover: UIView!
       
       var sections = [
           Section(section: "What is where ti wheel ?", rows: ["Where to Wheel is a user community dedicated to helping others with disabilities to find and rate accessible places around the world. Our mission is to allow users to empower themselves and empower others by adding to our listings!"], expanded: false),
           Section(section: "How can I involved with where to wheel ?", rows: ["Join our community to add reviews of places and share this site with your friends!"], expanded: false),
           Section(section: "Do I have to join? how do i Join ?", rows: ["You don’t have to join but it helps contribute info to our community. You can join by simply creating an account. By logging in with Facebook, Google or Email."], expanded: false),
           Section(section: "How do I add a listing ?", rows: ["Simply go to add listing. Then drag slide bar on each of accessibility features. 5 wheels is excellent and 1 wheel is poor."], expanded: false)
       ]

    override func viewDidLoad() {
        super.viewDidLoad()

         self.navigationController?.navigationBar.isHidden = true
         viewCover.layer.cornerRadius = 5.0
        
        
    }

    @IBAction func onCLickBack(_ sender: Any) {
        
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.makeRootViewController()
        
    }
}


extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections[indexPath.section].expanded {
            
            if(indexPath.section == 0) {
                
                return 150
                
            }
            
            if indexPath.section == 1 {
                
                return 80
                
            }else if indexPath.section == 2{
                
                return 100
            }else{
                
                return 80
            }
            
            //  return 44
        }else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].section, section: section, delegate: self)
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
        let rowIndex = indexPath.row
       
        cell.textLabel?.text = sections[indexPath.section].rows[rowIndex]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.5
        
       
        
      
        return cell
    }
}

extension FAQViewController: ExpandableHeaderViewDelegate {
    
    func toogleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        tableView.beginUpdates()
        for i in 0 ..< sections[section].rows.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
}
