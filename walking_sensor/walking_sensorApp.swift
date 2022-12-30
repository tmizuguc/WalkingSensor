import SwiftUI

@main
struct walking_sensorApp: App {
    let persistentController = PersistentController()
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistentController.container.viewContext)
        }
    }
}
