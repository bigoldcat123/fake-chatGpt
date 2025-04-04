//
//  SheetView.swift
//  ChatGPT
//
//  Created by 大地瓜 on 3/20/25.
//

import SwiftUI

struct SheetView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    var messageGroup:[MessageGroup]
    @Binding var currentIdx:Int
    @State var searchText = ""
    var filteredMessageGroup:[MessageGroup] {
        messageGroup.filter{x in
            if searchText.count != 0 {
                x.title.contains(searchText)
            }else {
                true
            }
            
        }
    }
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredMessageGroup){msgG in
                    let index = messageGroup.firstIndex { x in
                        x == msgG
                    }!
                    Button {
                        currentIdx = index
                        dismiss()
                    } label: {
                        Text(msgG.title)
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            
                            currentIdx = 0
                            if messageGroup.count == 1 {
                                messageGroup.first!.messages.removeAll()
                                messageGroup.first!.title = "newTopic!"
                            }else {
                                modelContext.delete(msgG)
                                try! modelContext.save()
                            }

                        }
                    }
                }
                
            }
            .navigationTitle("Topics")
            .searchable(text: $searchText, prompt: "search~")
        }

    }
}

