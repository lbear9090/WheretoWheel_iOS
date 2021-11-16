import UIKit
import CoreLocation
import GoogleMaps
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import CoreData
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    var locationmanager = CLLocationManager()
    var SelectedIndex: Int?
    var isProfile: Bool?
    var isDetailScreen: Bool?
    var arrFeatchers = NSArray()
    let imageCache1 = NSCache<NSString, UIImage>()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       // makeRootViewController()
        SentryManager.shared.start(with: "https://dc7f502e2c6044ba9e2eecfa1b61b4b6@o879082.ingest.sentry.io/5889099")
        SelectedIndex = 0
        isProfile = false
        setLocationPermission()
        //GMSServices.provideAPIKey("AIzaSyBM4pQ7dbqEHbHgTpq-dKT9nVrPuR6LDqQ")
        GMSServices.provideAPIKey("AIzaSyAJC0Vr32pNz5mpIvkWjGmWL0zv3e8IfhA")
        GMSPlacesClient.provideAPIKey("AIzaSyDhIC7WEhq2Z0zzslHFg2JFO96viMSQ3gg")
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        CoreDataStack.sharedInstance.applicationDocumentsDirectory()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            
            
            let login = UserDefaults.standard.bool(forKey: "isLogin")
            
            if login {
                
                makeRootViewController()
                
            }else{
                
                
                
            }
            
            print("Not first launch.")
        }
        else {
            print("First launch, setting NSUserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(false, forKey: "isLogin")
            
        }
        
        
        return true
    }
    
    func  setLocationPermission(){
        
        locationmanager.delegate = self
        locationmanager.requestAlwaysAuthorization()
        locationmanager.requestWhenInUseAuthorization()
        
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = ApplicationDelegate.shared.application(app, open: url, options: options)
        
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        CoreDataStack.sharedInstance.saveContext()
    }
}

//MARK:- Other ApppDelegate Methods
extension AppDelegate {
    
    //Make Root View Controller
    func makeRootViewController() {
        let storyboard = UIStoryboard(name: StoryboardID.main, bundle: nil)
        
        guard let customTabbarViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerID.customTabbarViewController) as? CustomTabBarViewController,
            let leftMenuViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerID.leftMenuViewController) as? LeftMenuViewController,
            let rightMenuController = storyboard.instantiateViewController(withIdentifier: ViewControllerID.rightMenuViewController) as? RightMenuViewController else {
            return
        }
        
        let navigationViewController: UINavigationController = UINavigationController(rootViewController: customTabbarViewController)
        
        //Create Side Menu View Controller with main, left and right view controller
       // let sideMenuViewController = SlideMenuController(mainViewController: navigationViewController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuController)
        
         let sideMenuViewController = SlideMenuController(mainViewController: navigationViewController, leftMenuViewController: leftMenuViewController)
        
        window?.rootViewController = sideMenuViewController
        window?.makeKeyAndVisible()
        
    }
}
