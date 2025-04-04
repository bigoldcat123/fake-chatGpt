//
//  AssisterMessage.swift
//  ChatGPT
//
//  Created by 大地瓜 on 3/19/25.
//

import SwiftUI
import MarkdownUI

struct AssisterMessage: View {
    var message:String
    var body: some View {
        VStack(alignment:.leading){
            HStack {
                Spacer()
            }
            HStack {
                Markdown(message)
            }
        }
        .padding()
    }
}

#Preview {
    AssisterMessage(message: "")
}
