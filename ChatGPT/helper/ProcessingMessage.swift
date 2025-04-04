//
//  ProcessingMessage.swift
//  ChatGPT
//
//  Created by 大地瓜 on 3/19/25.
//

import SwiftUI

struct ProcessingMessage: View {
    var body: some View {
        HStack {
            Text("Thinking")
            ProgressView()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ProcessingMessage()
}
