//
//  HelperHead.swift
//  ChatGPT
//
//  Created by 大地瓜 on 3/19/25.
//

import SwiftUI

struct HelperHead: View {
    @Binding var sheetIsShow:Bool
    @State var isPoppedOver = false
    var addNewTopic:() -> Void
    var body: some View {
        HStack {
            Button {
                sheetIsShow.toggle()
            } label: {
                Image(systemName: "ellipsis")
            }

            Spacer()
            Button {
                isPoppedOver.toggle()
            } label: {
                HStack {
                    Text("ChatGPT")
                    Image(systemName: "chevron.forward")
                }
            }
            .popover(isPresented: $isPoppedOver,arrowEdge: .top) {
//                List {
                    Button {
                        
                    } label: {
                        HStack {
                            Text("Share")
                            Spacer()
                            Image(systemName: "star")
                        }
                    }
//                }
            }
            Spacer()
            Button {
                addNewTopic()
                
            } label: {
                Image(systemName: "square.and.pencil")
            }
        }
        .padding()
        .bold()
        .font(.headline)
        .foregroundStyle(.primary)
        .background(.white)
    }
}
