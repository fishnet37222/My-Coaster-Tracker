//
//  My_Coaster_TrackerApp.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 11/17/20.
//

import SwiftUI
import CoreData

var shortcutItemToHandle: UIApplicationShortcutItem?
let quickActionSettings = QuickActionSettings()

class PersistanceManager {
	let persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "CoasterModel")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	init() {
		let center = NotificationCenter.default
		let notification = UIApplication.willResignActiveNotification
		
		center.addObserver(forName: notification, object: nil, queue: nil) { [weak self] _ in
			guard let self = self else { return }
			
			if self.persistentContainer.viewContext.hasChanges {
				try? self.persistentContainer.viewContext.save()
			}
		}
	}
}

@main
struct My_Coaster_TrackerApp: App {
	@Environment(\.scenePhase) var lifeCycle
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	let persistanceManager = PersistanceManager()
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(quickActionSettings)
				.environment(\.managedObjectContext, persistanceManager.persistentContainer.viewContext)
        }
		.onChange(of: lifeCycle) { (newLifeCyclePhase) in
			switch newLifeCyclePhase {
			case .active :
				guard shortcutItemToHandle != nil else { return }
				quickActionSettings.wasTapped = true
			case .background:
				print("background")
			case .inactive:
				print("inactive")
			@unknown default:
				print("default")
			}
		}
    }
	
	class AppDelegate: NSObject, UIApplicationDelegate {
		func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
			if let shortcutItem = options.shortcutItem {
				shortcutItemToHandle = shortcutItem
			}
			
			let sceneConfiguration = UISceneConfiguration(name: "Custom Configuration", sessionRole: connectingSceneSession.role)
			sceneConfiguration.delegateClass = CustomSceneDelegate.self
			return sceneConfiguration
		}
	}
	
	class CustomSceneDelegate: UIResponder, UIWindowSceneDelegate {
		func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
			shortcutItemToHandle = shortcutItem
		}
	}
}
