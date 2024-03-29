//
//  Enums.swift
//  TabbarWithSideMenu
//
//  Created by Sunil Prajapati on 20/04/18.
//  Copyright © 2018 sunil.prajapati. All rights reserved.
//

enum LeftMenuItems: String {
    case tabView = "Tab View"
    case mainView = "Main View"
    case nonMenu = "Non Menu View"
    case settingsTab = "Settings Tab"
    case pinTab = "Pin Tab"
    case addListTab = "AddList Tab"
    case profile = "Profile Tab"
}

enum TabItem: Int {
    case user = 0
    case pin
    case settings
    case addlist
    
    init() {
        self = .user
    }
}

enum ViewControllerID {
    static let mainViewController = "MainViewController"
    static let leftMenuViewController = "LeftMenuViewController"
    static let rightMenuViewController = "RightMenuViewController"
    static let secondViewController = "SecondViewController"
    static let nonMenuViewController = "NonMenuViewController"
    static let customTabbarViewController = "CustomTabBarViewController"
    static let locationViewController = "LocationViewController"
    static let addListViewController = "AddListViewController"
    static let profileViewController = "ProfileViewController"
}

enum ViewID {
    static let leftHeaderView = "LeftHeaderView"
}

enum StoryboardID {
    static let main = "Main"
}
