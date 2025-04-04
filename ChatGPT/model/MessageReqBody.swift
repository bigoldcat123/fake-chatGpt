//
//  MessageReqBody.swift
//  swift-study
//
//  Created by 大地瓜 on 3/20/25.
//

import Foundation
let secret = "Bearer sk-100586485edf4acb84b0e13717358a42"
struct MessageReqBody: Codable {
    var model: String = "deepseek-chat"
    let messages: [Message]
//    var temperature: Double = 0.7
//    var max_tokens: Int = -1
    var stream: Bool = true
    
    func send(action:(String) -> Void,resSuccessAction:() -> Void,finished:() -> Void) async {
        let jsonEncoder = JSONEncoder()
        let data = try! jsonEncoder.encode(self)
        let url = URL(string: "https://api.deepseek.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(secret, forHTTPHeaderField: "Authorization")
        request.httpBody = data
        do {
            let (asyncBytes, response) = try await URLSession.shared.bytes(for: request)
            // 确保是 HTTP 200 响应
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                resSuccessAction()
                action("sorry! the connetiong is broken !!!")
                print("服务器返回错误状态,\((response as! HTTPURLResponse).statusCode)")
                return
            }
            let jsonDecoder = JSONDecoder()
            resSuccessAction()
            for try await line in asyncBytes.lines {
                print(line.utf8)
                if String(line.utf8).starts(with: ":") {
                    continue
                }
                var data = line.data(using: .utf8)!
                data.removeSubrange(0...5)
                let msg = try jsonDecoder.decode(ReceivedMsg.self, from: data)
                if let choice = msg.choices.first {
                    if let reason = choice.finish_reason {
                        print(reason)
                        break
                    }
                        action(choice.delta.content!)
      
                }
            }
            finished()
        } catch {
            action("sorry! the connetiong is broken !!!")
            print("流式数据读取失败: \(error)")
        }
    }
}


