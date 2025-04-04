//
//  ChatGPTApp.swift
//  ChatGPT
//
//  Created by 大地瓜 on 3/19/25.
//

import SwiftUI
import SwiftData
@main
struct ChatGPTApp: App {
    var modelContainer:ModelContainer? {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true, allowsSave: false)
            let container = try ModelContainer(for: MessageGroup.self, configurations: configuration)
            return container
        }catch {
            print(error.localizedDescription)
        }
        return nil
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .modelContainer(modelContainer!)
                .modelContainer(for: [MessageGroup.self],inMemory: false)
        }
    }
}
