//
//  AppDelegate.swift
//  Preview
//
//  Created by Лера Тарасенко on 28.01.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIToolbar.appearance().barStyle = .black
        setupPageControl()
        setupNavigationBar()
        setupTabBar()
       
        return true
    }
    
    private func setupPageControl(){
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = #colorLiteral(red: 0.2440046668, green: 0.2874416113, blue: 0.3687180877, alpha: 1)
        appearance.currentPageIndicatorTintColor = UIColor.white
    }
    
    private func setupNavigationBar(){
        let attrs = [NSAttributedString.Key.font : UIFont.nextButton,
                     NSAttributedString.Key.foregroundColor : UIColor.white] as [NSAttributedString.Key : Any]
        
        UINavigationBar.appearance().tintColor = Colors.blue
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().isTranslucent = true
        
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "back")
    }
    
    private func setupTabBar(){
        UITabBar.appearance().tintColor = Colors.blue
        UITabBar.appearance().unselectedItemTintColor = Colors.notSelected
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SavedNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

