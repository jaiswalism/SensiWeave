import SwiftUI

@main
struct SensiWeaveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    let persistenceController = PersistenceController.shared
    @AppStorage(Constants.UserDefaultsKeys.isDarkMode) private var isDarkMode = false
    @AppStorage(Constants.UserDefaultsKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @State private var isShowingSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isShowingSplash {
                    SplashScreenView(isActive: $isShowingSplash)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                } else if hasCompletedOnboarding {
                    ContentView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                } else {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}


