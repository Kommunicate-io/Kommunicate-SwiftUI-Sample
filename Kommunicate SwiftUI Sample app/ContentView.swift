//
//  ContentView.swift
//  Kommunicate SwiftUI Sample app
//
//  Created by Mukesh on 18/09/20.
//

import UIKit
import Applozic
import SwiftUI
import Kommunicate

struct ContentView: View {
    @State private var showingLogin = false

    var body: some View {
        NavigationView {
            Button("Launch chat", action: { showConversation() })
            .navigationBarTitle("Welcome", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button("Sign out") {
                        self.onSignOut()
                    }
            )
        }
        .onAppear(perform: initialActions)
        .sheet(isPresented: $showingLogin) {
            LoginView(isPresented: self.$showingLogin)
        }
    }

    func initialActions() {
        showingLogin = !KMUserDefaultHandler.isLoggedIn()
    }

    func showConversation() {
        guard let topVC = UIApplication.topViewController() else { return }
        Kommunicate.createAndShowConversation(from: topVC) { error in
            if let error = error {
                print("Error while launching: \(error.localizedDescription)")
            }
        }
    }

    func onSignOut() {
        Kommunicate.logoutUser { (result) in
            switch result {
            case .success(_):
                print("Logout success")
                showingLogin = true
            case .failure( _):
                print("Logout failure, now registering remote notifications(if not registered)")
                if !UIApplication.shared.isRegisteredForRemoteNotifications {
                    UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                        if granted {
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        }
                        DispatchQueue.main.async {
                            showingLogin = true
                        }
                    }
                } else {
                    showingLogin = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIApplication {
    class func topViewController(
        base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
