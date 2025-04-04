//
//  UserMessage.swift
//  ChatGPT
//
//  Created by 大地瓜 on 3/19/25.
//

import SwiftUI

struct UserMessage: View {
    var message:String
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Text(message)
                    .padding()
                    .background(.secondary.opacity(0.2),in: RoundedRectangle(cornerRadius: 20))
                    .padding(.trailing)
            }
        }
    }
}

#Preview {
    UserMessage(message: "")
}
