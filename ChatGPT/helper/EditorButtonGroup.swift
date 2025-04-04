//
//  EditorButtonGroup.swift
//  ChatGPT
//
//  Created by 大地瓜 on 3/19/25.
//

import SwiftUI

struct EditorButtonGroup: View {
    
//    @Binding var showSheet:Bool
    var text:String
    
    var actionA: () -> Void
    
    var isTexted:Bool {
        if text != prompt && !text.isEmpty {
            return true
        }else {
            return false
        }
    }
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .bold()
                    .padding(.all,8)
                    .background(Color.secondary,in: .circle.stroke(lineWidth: 1))
            }
            
            
            Button {
                
            } label: {
                Label("Search", systemImage: "globe")
                    .bold()
                    .padding(.all,8)
                    .background(Color.secondary,in:RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 1))
            }
            
            Button {
                
            } label: {
                Label("Reason", systemImage: "chandelier")
                    .bold()
                    .padding(.all,7)
                    .background(Color.secondary,in:RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 1))
            }
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "mic")
                    .bold()
                    .padding(.all,7)
                    .background(Color.secondary,in:.circle.stroke(lineWidth: 1))
            }
            
            Button {
                actionA()
            } label: {
                Image(systemName:isTexted ? "paperplane" : "waveform")
                    .bold()
                    .padding(.all,7)
                    .background(.black,in:.circle)
                    .foregroundStyle(.white)
            }


            

        }
        .padding(.horizontal)
        .padding(.bottom)
        .font(.caption)
        .foregroundStyle(.primary)
    }
}

#Preview {
    @Previewable @State var show = false
    EditorButtonGroup(text: "") {
        
    }
}
