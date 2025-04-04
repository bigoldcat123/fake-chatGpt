//
//  ContentView.swift
//  ChatGPT
//
//  Created by 大地瓜 on 3/19/25.
//
import SwiftUI
import SwiftData

let prompt = "Message ChatGPT"
struct ChatView: View {
    @Namespace var bottomID
    @Environment(\.modelContext) var modelContext
    
    @Query var messageGroup:[MessageGroup]
    @Binding var currentMessageIdx:Int
    @State var ipt:String = prompt
    @FocusState var isFocused:Bool
    @State private var textHeight: CGFloat = 30 // 1行高度
    @State private var keyboardVisible = false
    @State private var isAlerted = false
    
    @State private var showSheet = false
//    @State var messages:[Message] = []
    
    
    
    
    
    let maxHeight: CGFloat = 20.333 * 5 // 9 行的最大高度
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    // top anchor
                    HStack {
                        Spacer()
                    }
                    ForEach(messageGroup[currentMessageIdx].messages) {message in
                        switch message.role {
                        case .assistant:
                            AssisterMessage(message: message.content)
                        case .user:
                            UserMessage(message: message.content)
                        case .processing:
                            ProcessingMessage()
                        case .system:
                            HStack{}
                        }
                    }

                    // bottom anchor
                    HStack {
                        Spacer()
                    }
                    .id(bottomID)
                }
                .defaultScrollAnchor(.bottom)
                .sheet(isPresented: $showSheet, content: {
                    SheetView(messageGroup:messageGroup,currentIdx:$currentMessageIdx)
                })
                .background(.white)
                .onTapGesture {
                    print("e")
                    isFocused = false
                }// bottom area
                .safeAreaInset(edge: .bottom,alignment: .leading) {
                    VStack(alignment:.leading) {
                        TextEditor(text: $ipt)
                            .foregroundStyle(!isFocused && ipt == prompt ? .secondary :.primary)
                            .frame(height: min(textHeight, maxHeight)) // 限制最大高度
                            .focused($isFocused)
                            .padding()
                        // show prompt
                            .onChange(of: isFocused) { oldValue, newValue in
                                if newValue == false && ipt.count == 0 {
                                    ipt = prompt
                                }
                                if newValue == true && ipt == prompt {
                                    ipt = ""
                                }
                                if newValue {
                                    withAnimation {
                                        proxy.scrollTo(bottomID)
                                    }
                                }
                            }
                        EditorButtonGroup(text: ipt) {
                            sendMessage()
                        }
                    }
                    .background {
                        CustomRoundedRectangle()
                            .foregroundStyle(.white)
                            .shadow(radius: 7,y:-13)
                    }
                    .background(.white)
                    
                }
                // top area
                .safeAreaInset(edge: .top) {
                    HelperHead(sheetIsShow: $showSheet,addNewTopic:{
                        if messageGroup[currentMessageIdx].messages.count == 0 {
                            //TODO
                            isAlerted = true
                            return
                        }
                        let may_ok_idx = messageGroup.firstIndex { x in
                            x.messages.count == 0
                        }
                        if let may_ok_idx {
                            currentMessageIdx = may_ok_idx
                            return
                        }
                        let newGroup = MessageGroup(messages: [], title: "new Topic\(messageGroup.count)")
                        modelContext.insert(newGroup)
                        try! modelContext.save()
                        let idx = messageGroup.firstIndex { x in
                            x.id == newGroup.id
                        }!
                        currentMessageIdx = idx
                    })
                }
                .alert("you are ALREADY in new Topic!", isPresented: $isAlerted, actions: {
//                    isAlerted = false
                    Text("Fine")
                })
                .onAppear {// listen keyBoard notification
                    listenForKeyboardNotifications()
                }
                .onChange(of: keyboardVisible) { oldValue, newValue in
                    if newValue {
                        withAnimation {
                            proxy.scrollTo(bottomID)
                        }
                    }
                }
                // listening the height of textEditor
                .background{
                    Text(ipt)
                        .padding(.horizontal)
                        .background {
                            GeometryReader { gProxy in
                                Color.clear.onChange(of: ipt) { // listening the height of textEditor CORE!
                                    let height = gProxy.size.height < 20 ? 20 :gProxy.size.height
                                    print(height)
                                    withAnimation {
                                        textHeight = height + 8
                                    }
                                }
                            }
                        }
                }
            }
        }
        
        
    }
    
    func listenForKeyboardNotifications() {
#if os(iOS)
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { _ in
            print("keyboard show!")
            keyboardVisible = true
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            keyboardVisible = false
        }
#endif
    }
    func sendMessage() {
        messageGroup[currentMessageIdx].messages.append(.init(role: .user, content: ipt))
        let reqBody = MessageReqBody(messages: messageGroup[currentMessageIdx].messages)
        messageGroup[currentMessageIdx].messages.append(.init(role: .processing, content: ""))
        
        Task{
            await reqBody.send { r in
                DispatchQueue.main.async {
                    if let lastIndex = messageGroup[currentMessageIdx].messages.indices.last {
//                        withAnimation {
                            messageGroup[currentMessageIdx].messages[lastIndex].content.append(r)
//                        }
                    }
                }
            }resSuccessAction: {
                messageGroup[currentMessageIdx].messages.removeLast()
                messageGroup[currentMessageIdx].messages.append(.init(role: .assistant, content: ""))
            }finished: {
                try! modelContext.save()
            }
        }
        ipt = ""
        textHeight = 30
        isFocused = false
    }
}



struct TextHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 20
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
