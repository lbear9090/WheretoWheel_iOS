//
//  LeftMenuViewController.swift
//  TabbarWithSideMenu
//
//  Created by Sunil Prajapati on 20/04/18.
//  Copyright © 2018 sunil.prajapati. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import SDWebImage
class LeftMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    

    //MARK:- IBOutlet And Variable Declaration
    var leftMenu = ["My Details", "History", "About us", "Terms & Conditions", "Privacy policy","FAQ","Contact us"]
    var leftMenuImage = ["mydetails", "history", "aboutus", "faq", "terms","faq","contact"]
    @IBOutlet weak var tableLeftMenu: UITableView!
    
    //MARK:- UIViewController Initialize Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let login = UserDefaults.standard.bool(forKey: "isLogin")
        
        if login {
            
             leftMenu = ["My Details", "History", "About us", "Terms & Conditions", "Privacy policy","FAQ","Contact us","Logout"]
             leftMenuImage = ["mydetails", "history", "aboutus", "faq", "terms","faq","contact","logout"]
            
        }else{
            
            
             leftMenu = ["My Details", "History", "About us", "Terms & Conditions", "Privacy policy","FAQ","Contact us"]
             leftMenuImage = ["mydetails", "history", "aboutus", "faq", "terms","faq","contact"]
            
        }
        
        
        tableLeftMenu.tableFooterView = UIView()
        tableLeftMenu.dataSource = self;
        tableLeftMenu.delegate = self;
        
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
        
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
    
    //MARK:- Other Methods
    func changeMainViewController(to viewController: UIViewController) {
        //Change main viewcontroller of side menu view controller
        let navigationViewController = UINavigationController(rootViewController: viewController)
        slideMenuController()?.changeMainViewController(navigationViewController, close: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        as! sidemenuCell
        
        cell.imgIcon.image = UIImage(named: leftMenuImage[indexPath.row])
        cell.lblName.text = leftMenu[indexPath.row]
        tableLeftMenu.rowHeight = 60
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           guard let leftHeaderView = loadFromNibNamed(ViewID.leftHeaderView) as? LeftHeaderView else {
               print("Left Header view not found")
               return nil
           }
        
        
        let login = UserDefaults.standard.bool(forKey: "isLogin")
               
        if login {
                var placeholderImage: UIImage? = nil
                if placeholderImage == nil {
                    placeholderImage = UIImage(named: "placeholder")
                }
                
                let username = UserDefaults.standard.value(forKey: "username")
                leftHeaderView.lblProfileName.text = username as? String
                
                let imgurl = UserDefaults.standard.object(forKey: "loginuserimage") as? String ?? ""
            
            let url : NSString = imgurl as NSString
            let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
            let searchURL : NSURL = NSURL(string: urlStr as String)!
            
            weak var imageView = leftHeaderView.IBimgViewHeader
            
            imageView?.sd_setImage(with: searchURL as URL, placeholderImage: placeholderImage, options:  0 == 0 ? SDWebImageOptions(rawValue: SDWebImageOptions.RawValue(Int(1 << 3))) : [], context: [
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
            })
            
                
                            
        }
         
           return leftHeaderView
       }
       
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 160
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            
            let login = UserDefaults.standard.bool(forKey: "isLogin")
            
            if login {
                
                guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "UserPRofileViewController") as? UserPRofileViewController else {
                              return
                          }
                          changeMainViewController(to: tabViewController)
                
            }else{
                
                
                self.showAlertWith(title: "Go", message: "Please Login or SignUp First...")
                
            }
            
            
          
            break
        case 1:
            
            guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController else {
                return
            }
            changeMainViewController(to: tabViewController)
            break
        case 2:
            
            guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController else {
                return
            }
            
            changeMainViewController(to: tabViewController)
            
            break
        case 3:
            
            guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "TermsConditionsViewController") as? TermsConditionsViewController else {
                return
            }
            
            changeMainViewController(to: tabViewController)
            
            break
        case 4:
            
            guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "PricacyPolicyViewController") as? PricacyPolicyViewController else {
                return
            }
            
            changeMainViewController(to: tabViewController)
            break
        case 5:
            
            guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as? FAQViewController else {
                return
            }
            changeMainViewController(to: tabViewController)
            
            
            break
        case 6:
            
            guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as? ContactUsViewController else {
                return
            }
            changeMainViewController(to: tabViewController)
            break
            
        case 7:
            
            UserDefaults.standard.set(false, forKey: "isLogin")
            let loginManager = LoginManager()
            loginManager.logOut()
            GIDSignIn.sharedInstance().signOut()
            UserDefaults.standard.set("", forKey: "loginuserimage")
            guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
                return
            }
            changeMainViewController(to: tabViewController)
            
            break
        default:
            
            let vc = AboutViewController() //change this to your class name
            self.present(vc, animated: true, completion: nil)
            break
        }
        
        
    }
    
}

/*//MARK:- UITableViewDataSource Methods
extension LeftMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftMenu.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let tableViewCell = UITableViewCell()
        tableViewCell.textLabel?.text = leftMenu[indexPath.row]
        tableViewCell.selectionStyle = .none
        tableViewCell.backgroundColor = UIColor(red: 224/255, green: 230/255, blue: 230/255, alpha: 1.0)
        return tableViewCell
    }
}

//MARK:- UITableViewDelegate Methods
extension LeftMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let leftHeaderView = loadFromNibNamed(ViewID.leftHeaderView) as? LeftHeaderView else {
            print("Left Header view not found")
            return nil
        }
        return leftHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let leftMenuItem = LeftMenuItems(rawValue: leftMenu[indexPath.row]) else {
            print("Left Menu Item not found")
            return
        }
        
        switch leftMenuItem {
            
            case .tabView:
                guard let tabViewController = storyboard?.instantiateViewController(withIdentifier: ViewControllerID.customTabbarViewController) as? CustomTabBarViewController else {
                    return
                }
                changeMainViewController(to: tabViewController)
            
            case .mainView:
                guard let mainViewController = storyboard?.instantiateViewController(withIdentifier: ViewControllerID.mainViewController) as? MainViewController else {
                    return
                }
                changeMainViewController(to: mainViewController)
            
            case .nonMenu:
                guard let nonMenuController = storyboard?.instantiateViewController(withIdentifier: ViewControllerID.nonMenuViewController) as? NonMenuViewController else {
                    return
                }
                changeMainViewController(to: nonMenuController)
            
            
            case .settingsTab, .pinTab:
               
                let toIndex = (leftMenuItem == .settingsTab) ? TabItem.settings.rawValue : TabItem.pin.rawValue
                
                //Check here Custom TabBar ViewController is already exist then we just set index other wise we instantiate view controller and set index
                if let customTabBar = ((slideMenuController()?.mainViewController as? UINavigationController)?.viewControllers.first as? CustomTabBarViewController) {
                    
                    let currentIndex = customTabBar.selectedIndex
                    customTabBar.setSelectIndex(from: currentIndex, to: toIndex) //Side Menu View Controller's method
                    changeMainViewController(to: customTabBar)
                    
                } else {
                    guard let customTabBar = storyboard?.instantiateViewController(withIdentifier: ViewControllerID.customTabbarViewController) as? CustomTabBarViewController else {
                            return
                    }
                    customTabBar.setSelectIndex(from: 0, to: toIndex)
                    changeMainViewController(to: customTabBar)
                }
            
            case .addListTab:
            
             let toIndex = (leftMenuItem == .addListTab) ? TabItem.addlist.rawValue : TabItem.pin.rawValue
             
             //Check here Custom TabBar ViewController is already exist then we just set index other wise we instantiate view controller and set index
             if let customTabBar = ((slideMenuController()?.mainViewController as? UINavigationController)?.viewControllers.first as? CustomTabBarViewController) {
                 
                 let currentIndex = customTabBar.selectedIndex
                 customTabBar.setSelectIndex(from: currentIndex, to: toIndex) //Side Menu View Controller's method
                 changeMainViewController(to: customTabBar)
                 
             } else {
                 guard let customTabBar = storyboard?.instantiateViewController(withIdentifier: ViewControllerID.customTabbarViewController) as? CustomTabBarViewController else {
                         return
                 }
                 customTabBar.setSelectIndex(from: 0, to: toIndex)
                 changeMainViewController(to: customTabBar)
             }
            
            
            case .profile:
            
            
                 guard let customTabBar = storyboard?.instantiateViewController(withIdentifier: ViewControllerID.customTabbarViewController) as? CustomTabBarViewController else {
                         return
                 }
                 changeMainViewController(to: customTabBar)
            
        }
    }
}*/
