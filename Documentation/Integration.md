## Integrating Kommunicate in SwiftUI

Integrating Kommunicate iOS SDK in a SwiftUI project.

### Conversation

1. Complete the [installation](https://docs.kommunicate.io/docs/ios-installation.html) and [user authentication](https://docs.kommunicate.io/docs/ios-authentication) process as described in the [docs](https://docs.kommunicate.io/docs/ios-installation).
2. To launch a conversation from SwiftUI View, add this helper function in any of the project files:

```swift
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
```
This helper function will be required to show a Conversation list or a Conversation thread.

3. Now, all of the Conversation launch functions mentioned in the [docs](https://docs.kommunicate.io/docs/ios-conversation) can be used as shown here:

```swift
func showConversation() {
    guard let topVC = UIApplication.topViewController() else { return }
    Kommunicate.createAndShowConversation(from: topVC) { error in
        if let error = error {
            print("Error while launching: \(error.localizedDescription)")
        }
    }
}
```

Call above function on the tap of a button:

```swift
struct ContentView: View {

    var body: some View {
        NavigationView {
            Button("Launch chat", action: { showConversation() })
                .navigationBarTitle("Welcome", displayMode: .inline)
        }
    }
}
```

### Push Notification

1. Create an [AppDelegate file](https://github.com/Kommunicate-io/Kommunicate-SwiftUI-Sample/blob/master/Kommunicate%20SwiftUI%20Sample%20app/AppDelegate.swift) if it's not present in the project. Make sure `@main` tag is added on top to indicate that it's the top-level entry point.
2. Now, follow all the steps from [Push notification](https://docs.kommunicate.io/docs/ios-pushnotification) docs.