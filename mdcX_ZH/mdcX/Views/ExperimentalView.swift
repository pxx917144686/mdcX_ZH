//
//  ExperimentalView.swift
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

import SwiftUI

//// 如果AlertItem不是共享工具，则在本地定义它。
//fileprivate struct AlertItem: Identifiable {
//    let id = UUID()
//    var title: Text
//    var message: Text?
//    var primaryButton: Alert.Button
//    var secondaryButton: Alert.Button?
//}
/*class ExperimentRunner: ObservableObject {

    func performXPCRespring(logStore: LogStore,
                            statusUpdate: @escaping (String) -> Void,
                            processingUpdate: @escaping (Bool) -> Void) {
        processingUpdate(true)
        statusUpdate("尝试进行XPC重启...")
        logStore.append(message: "EXP_RUNNER: 尝试通过XPC进行重启...")

        DispatchQueue.global(qos: .userInitiated).async {
            let result = attempt_respring_via_xpc()

            DispatchQueue.main.async {
                if result == 0 {
                    statusUpdate("XPC命令已发送。如果存在漏洞，可能会重启。")
                    logStore.append(message: "EXP_RUNNER: XPC重启命令发送成功。")
                } else {
                    statusUpdate("XPC命令失败（代码: \(result)）。")
                    logStore.append(message: "EXP_RUNNER: XPC重启命令失败（C代码: \(result)）。")
                    processingUpdate(false)
                }
            }
        }
    }

    func performGenericFileZero(
        targetPath: String,
        tweakName: String,
        logStore: LogStore,
        statusUpdate: @escaping (String) -> Void,
        processingUpdate: @escaping (Bool) -> Void
    ) {
        processingUpdate(true)
        let fileName = (targetPath as NSString).lastPathComponent
        statusUpdate("尝试清零'\(fileName)'以进行\(tweakName)...")
        logStore.append(message: "EXP_RUNNER: 尝试\(tweakName): \(targetPath)")

        DispatchQueue.global(qos: .userInitiated).async {
            var success = false
            var c_result: Int32 = -1

            if targetPath.isEmpty {
                c_result = -99 
            } else {
                targetPath.withCString { cPathPtr in
                    c_result = zero_out_first_page(cPathPtr)
                    success = (c_result == 0)
                }
            }

            DispatchQueue.main.async {
                if success {
                    statusUpdate("'\(fileName)'已清零以进行\(tweakName)。效果可能需要重启。")
                    logStore.append(message: "EXP_RUNNER: \(tweakName) - 目标文件清零成功。")
                } else {
                    statusUpdate("清零'\(fileName)'以进行\(tweakName)失败（代码: \(c_result)）。")
                    logStore.append(message: "EXP_RUNNER: \(tweakName) - 清零目标文件失败（C代码: \(c_result)）。")
                }
                processingUpdate(false)
            }
        }
    }
}

struct ExperimentalView: View {
    @ObservedObject var logStore: LogStore
    @StateObject private var experimentRunner = ExperimentRunner()

    @State private var xpcRespringStatus: String = ""
    @State private var isProcessingXPCRespring: Bool = false
    @State private var fileCorruptionSbPlistStatus: String = ""
    @State private var isProcessingFileCorruptionSbPlist: Bool = false
    @State private var fileCorruptionCacheStatus: String = ""
    @State private var isProcessingFileCorruptionCache: Bool = false


    @State private var alertItem: AlertItem?

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                Image(systemName: "beaker.halffull")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .padding(.top)

                Text("危险区域: 实验")
                    .font(.title.bold())
                    .foregroundColor(.red)

                Text("这些功能极不稳定，依赖于iOS版本，并可能导致设备无法使用而需要恢复。请极度谨慎。仅供测试使用。")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Divider().padding(.vertical, 15)

                ExperimentActionView(
                    title: "重启 (XPC崩溃)",
                    description: "尝试通过精心制作的XPC消息使'com.apple.backboard.TouchDeliveryPolicyServer'崩溃。成功取决于特定的（通常较旧的）漏洞。",
                    buttonLabel: "尝试XPC重启",
                    buttonColor: .orange,
                    status: $xpcRespringStatus,
                    isProcessing: $isProcessingXPCRespring
                ) {
                    self.alertItem = AlertItem(
                        title: Text("确认XPC重启"),
                        message: Text("此方法具有风险并针对系统服务。确保您了解其影响。继续？"),
                        primaryButton: .destructive(Text("是的，尝试XPC")) {
                            experimentRunner.performXPCRespring(
                                logStore: logStore,
                                statusUpdate: { newStatus in xpcRespringStatus = newStatus },
                                processingUpdate: { newProcessing in isProcessingXPCRespring = newProcessing }
                            )
                        },
                        secondaryButton: .cancel()
                    )
                }

                Divider().padding(.vertical, 15)

                ExperimentActionView(
                    title: "重启 (损坏SB Plist)",
                    description: "尝试通过清零SpringBoard的偏好文件使其崩溃。极度危险。目标: '/var/mobile/Library/Preferences/com.apple.springboard.plist'",
                    buttonLabel: "尝试SB Plist损坏",
                    buttonColor: .purple,
                    status: $fileCorruptionSbPlistStatus,
                    isProcessing: $isProcessingFileCorruptionSbPlist
                ) {
                    let targetPath = "/var/mobile/Library/Preferences/com.apple.springboard.plist"
                    let targetFileName = (targetPath as NSString).lastPathComponent
                    
                    self.alertItem = AlertItem(
                        title: Text("极度危险！"),
                        message: Text("您即将清零'\(targetFileName)'。这可能导致启动循环、数据丢失或SpringBoard无法使用，需要设备恢复。这对文件是不可逆的。仅在您愿意擦除的测试设备上继续。\n\n您是否绝对确定？"),
                        primaryButton: .destructive(Text("我理解风险，继续")) {
                            experimentRunner.performGenericFileZero(
                                targetPath: targetPath,
                                tweakName: "SB Plist损坏",
                                logStore: logStore,
                                statusUpdate: { newStatus in fileCorruptionSbPlistStatus = newStatus },
                                processingUpdate: { newProcessing in isProcessingFileCorruptionSbPlist = newProcessing }
                            )
                        },
                        secondaryButton: .cancel(Text("不！立即取消"))
                    )
                }
                
                Divider().padding(.vertical, 15)

                ExperimentActionView(
                    title: "重启 (损坏缓存文件 - PoC)",
                    description: "尝试通过清零假设的SpringBoard缓存文件触发UI重新加载。效果可能有所不同。目标: '/var/mobile/Library/Caches/com.apple.springboard/Cache.db'",
                    buttonLabel: "尝试缓存损坏",
                    buttonColor: .green,
                    status: $fileCorruptionCacheStatus,
                    isProcessing: $isProcessingFileCorruptionCache
                ) {
                    let cacheTargetPath = "/var/mobile/Library/Caches/com.apple.springboard/Cache.db"
                    let cacheFileName = (cacheTargetPath as NSString).lastPathComponent

                    self.alertItem = AlertItem(
                        title: Text("确认缓存损坏"),
                        message: Text("损坏'\(cacheFileName)'可能导致UI故障或SpringBoard数据刷新。与plist相比，启动循环的风险较低，但该缓存的数据丢失是确定的。继续？"),
                        primaryButton: .destructive(Text("损坏缓存")) {
                             experimentRunner.performGenericFileZero(
                                targetPath: cacheTargetPath,
                                tweakName: "缓存文件损坏",
                                logStore: logStore,
                                statusUpdate: { newStatus in fileCorruptionCacheStatus = newStatus },
                                processingUpdate: { newProcessing in isProcessingFileCorruptionCache = newProcessing }
                            )
                        },
                        secondaryButton: .cancel()
                    )
                }


                VStack(alignment: .leading) {
                     Text("实验操作日志 (共享):")
                         .font(.caption.bold())
                     LogView(logMessages: $logStore.messages, logStore: logStore)
                 }.padding(.top, 20)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("实验区域")
        .alert(item: $alertItem) { item in
            Alert(title: item.title, message: item.message, primaryButton: item.primaryButton, secondaryButton: item.secondaryButton ?? .cancel())
        }
    }
}

struct ExperimentActionView: View {
    let title: String
    let description: String
    let buttonLabel: String
    let buttonColor: Color
    @Binding var status: String
    @Binding var isProcessing: Bool

    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button(action: action) {
                if isProcessing {
                    HStack {
                        Text("处理中...")
                            .frame(maxWidth: .infinity, alignment: .center)
                        ProgressView()
                            .scaleEffect(0.8)
                            .frame(width: 20, height: 20)
                    }
                } else {
                    Text(buttonLabel)
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(CustomButtonStyle(color: buttonColor))
            .disabled(isProcessing)

            if !status.isEmpty {
                HStack {
                    Text("状态:")
                    Text(status)
                        .font(.caption)
                        .foregroundColor(status.contains("Sent") || status.contains("Zeroed") || status.contains("OK") || status.contains("Success") ? .green : (status.contains("Failed") || status.contains("Error") ? .red : .orange))
                        .lineLimit(2)
                }
                .padding(.top, 3)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

struct ExperimentalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExperimentalView(logStore: LogStore())
        }
    }
}
*/
