//
//  ProfileViewController.swift
//  TabbarWithSideMenu
//
//  Created by admin on 2/13/20.
//  Copyright © 2020 sunil.prajapati. All rights reserved.
//

import UIKit

class ProfileViewController: SideBaseViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = LeftMenuItems.profile.rawValue
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate!.isProfile = true
        
        appdelegate?.makeRootViewController()
        toggleLeft()
 

    }

}
