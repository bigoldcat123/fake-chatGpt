
import SwiftUI
import SwiftData
struct ContentView:View {
    @Query var messageGroup:[MessageGroup]
    @State var currentMessageIdx = 0
    @Environment(\.modelContext) var modelContext
    
    var msgNotEmpty:Bool {
        messageGroup.count != 0
    }
    
    var body: some View {
        if msgNotEmpty {
            ChatView(currentMessageIdx: $currentMessageIdx)
        }else {
            ProgressView()
                .onAppear(){
                    modelContext.insert(MessageGroup(messages: [], title: "hello"))
                    try! modelContext.save()
                }
        }
    }
}
