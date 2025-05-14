//
//  LogStore.swift
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

import SwiftUI

class LogStore: ObservableObject {
    @Published var messages: String = "系统调整工具已初始化。\n"

    func append(message: String) {
        DispatchQueue.main.async {
            let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
            self.messages += "\(timestamp): \(message)\n"
        }
    }

    func clear() {
        DispatchQueue.main.async {
            self.messages = "日志已在 \(DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)) 清除。\n"
        }
    }
}
