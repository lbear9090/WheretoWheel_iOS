//
//  CustomTabBarViewController.swift
//  TabbarWithSideMenu
//
//  Created by Sunil Prajapati on 20/04/18.
//  Copyright © 2018 sunil.prajapati. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class CustomTabBarViewController: RAMAnimatedTabBarController {
    
    //MARK:- UIViewController Initialize Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LeftMenuItems.tabView.rawValue
        
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
       // self.selectedIndex = appdelegate!.SelectedIndex!
        self.setSelectIndex(from: 0, to: appdelegate!.SelectedIndex!)
       
        
        
        if(appdelegate!.isProfile == true){
        
          toggleLeft()
            
        }else{
            
            
        }
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    
}
