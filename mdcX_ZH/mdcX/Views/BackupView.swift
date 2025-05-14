import SwiftUI

struct BackupView: View {
    @ObservedObject var backupManager = BackupManager.shared
    @ObservedObject var logStore: LogStore
    
    @State private var showingCreateBackupSheet = false
    @State private var backupName = ""
    @State private var backupDescription = ""
    @State private var selectedPaths: [String] = []
    @State private var isRestoring = false
    @State private var alertItem: AlertItem?
    
    // 预定义的系统路径
    private let commonSystemPaths = [
        "/System/Library/PrivateFrameworks/CoreMaterial.framework",
        "/System/Library/PrivateFrameworks/SpringBoard.framework",
        "/System/Library/Audio/UISounds",
        "/System/Library/PrivateFrameworks/SpringBoardHome.framework"
    ]
    
    var body: some View {
        List {
            Section(header: Text("备份管理工具")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("创建备份可以保存系统文件的原始状态，以便在应用调整后恢复。")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        self.showingCreateBackupSheet = true
                    }) {
                        Label("创建新备份", systemImage: "plus.square.fill")
                            .font(.headline)
                    }
                    .buttonStyle(CustomButtonStyle(color: .blue))
                    .padding(.vertical, 5)
                }
                .padding(.vertical, 8)
            }
            
            if backupManager.isBackingUp {
                Section {
                    HStack {
                        Text("创建备份中...")
                        Spacer()
                        ProgressView()
                    }
                }
            }
            
            Section(header: Text("已保存的备份")) {
                if backupManager.backups.isEmpty {
                    Text("尚未创建备份")
                        .foregroundColor(.secondary)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(backupManager.backups.sorted(by: { $0.date > $1.date })) { backup in
                        BackupItemView(backup: backup) {
                            confirmRestoreBackup(backup)
                        } deleteAction: {
                            confirmDeleteBackup(backup)
                        }
                    }
                }
            }
            
            Section(header: Text("关于备份")) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("⚠️ 备份可能需要管理员权限才能恢复系统文件。")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    Text("⚠️ 系统更新或重启后可能会还原某些文件的修改。")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .padding(.vertical, 3)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("备份管理")
        .sheet(isPresented: $showingCreateBackupSheet) {
            NavigationView {
                CreateBackupView(
                    logStore: logStore,
                    backupName: $backupName,
                    backupDescription: $backupDescription,
                    selectedPaths: $selectedPaths,
                    commonSystemPaths: commonSystemPaths,
                    onCreate: createBackup
                )
                .navigationTitle("创建新备份")
                .navigationBarItems(
                    leading: Button("取消") { showingCreateBackupSheet = false },
                    trailing: Button("创建") { createBackup() }
                        .disabled(backupName.isEmpty || selectedPaths.isEmpty)
                )
            }
        }
        .alert(item: $alertItem) { item in
            Alert(title: item.title, message: item.message, primaryButton: item.primaryButton, secondaryButton: item.secondaryButton ?? .cancel())
        }
    }
    
    private func createBackup() {
        if backupName.isEmpty {
            alertItem = AlertItem(
                title: Text("错误"),
                message: Text("请输入备份名称"),
                primaryButton: .default(Text("确定"))
            )
            return
        }
        
        if selectedPaths.isEmpty {
            alertItem = AlertItem(
                title: Text("错误"),
                message: Text("请选择至少一个要备份的路径"),
                primaryButton: .default(Text("确定"))
            )
            return
        }
        
        backupManager.createBackup(
            name: backupName,
            files: selectedPaths,
            description: backupDescription.isEmpty ? "创建于 \(Date().formatted())" : backupDescription
        ) { success, message in
            logStore.append(message: "备份结果: \(message)")
            
            alertItem = AlertItem(
                title: Text(success ? "成功" : "警告"),
                message: Text(message),
                primaryButton: .default(Text("确定"))
            )
            
            // 重置表单
            self.backupName = ""
            self.backupDescription = ""
            self.selectedPaths = []
            self.showingCreateBackupSheet = false
        }
    }
    
    private func confirmRestoreBackup(_ backup: BackupManager.BackupItem) {
        alertItem = AlertItem(
            title: Text("确认恢复"),
            message: Text("您确定要恢复来自\"\(backup.name)\"的\(backup.files.count)个文件吗？这将覆盖当前系统文件。"),
            primaryButton: .destructive(Text("恢复")) {
                restoreBackup(backup)
            },
            secondaryButton: .cancel()
        )
    }
    
    private func restoreBackup(_ backup: BackupManager.BackupItem) {
        isRestoring = true
        logStore.append(message: "正在恢复备份: \(backup.name)")
        
        backupManager.restoreBackup(backup) { success, message in
            isRestoring = false
            logStore.append(message: "恢复结果: \(message)")
            
            alertItem = AlertItem(
                title: Text(success ? "恢复成功" : "恢复问题"),
                message: Text(message),
                primaryButton: .default(Text("确定"))
            )
        }
    }
    
    private func confirmDeleteBackup(_ backup: BackupManager.BackupItem) {
        alertItem = AlertItem(
            title: Text("确认删除"),
            message: Text("您确定要删除备份"\(backup.name)"吗？此操作不可撤销。"),
            primaryButton: .destructive(Text("删除")) {
                backupManager.deleteBackup(backup)
                logStore.append(message: "已删除备份: \(backup.name)")
            },
            secondaryButton: .cancel()
        )
    }
}

struct BackupItemView: View {
    let backup: BackupManager.BackupItem
    let restoreAction: () -> Void
    let deleteAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                VStack(alignment: .leading) {
                    Text(backup.name)
                        .font(.headline)
                    
                    Text("创建于: \(backup.date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(backup.files.count)个文件")
                    .font(.caption)
                    .padding(5)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(4)
            }
            
            if !backup.description.isEmpty {
                Text(backup.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack {
                Button(action: restoreAction) {
                    Label("恢复", systemImage: "arrow.clockwise")
                        .font(.caption)
                }
                .buttonStyle(.borderless)
                .foregroundColor(.blue)
                
                Spacer()
                
                Button(action: deleteAction) {
                    Label("删除", systemImage: "trash")
                        .font(.caption)
                }
                .buttonStyle(.borderless)
                .foregroundColor(.red)
            }
            .padding(.top, 5)
        }
        .padding(.vertical, 5)
    }
}

struct CreateBackupView: View {
    @ObservedObject var logStore: LogStore
    @Binding var backupName: String
    @Binding var backupDescription: String
    @Binding var selectedPaths: [String]
    
    let commonSystemPaths: [String]
    let onCreate: () -> Void
    
    @State private var customPath = ""
    @State private var expandedSections: Set<String> = []
    
    var body: some View {
        Form {
            Section(header: Text("备份信息")) {
                TextField("备份名称", text: $backupName)
                TextField("描述 (可选)", text: $backupDescription)
            }
            
            Section(header: Text("选择要备份的文件")) {
                ForEach(commonSystemPaths, id: \.self) { basePath in
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedSections.contains(basePath) },
                            set: { isExpanded in
                                if isExpanded {
                                    expandedSections.insert(basePath)
                                } else {
                                    expandedSections.remove(basePath)
                                }
                            }
                        ),
                        content: {
                            FilePathsList(basePath: basePath, selectedPaths: $selectedPaths, logStore: logStore)
                        },
                        label: {
                            Text(URL(fileURLWithPath: basePath).lastPathComponent)
                                .font(.headline)
                        }
                    )
                }
            }
            
            Section(header: Text("添加自定义路径")) {
                HStack {
                    TextField("输入完整路径", text: $customPath)
                    
                    Button(action: {
                        if !customPath.isEmpty && !selectedPaths.contains(customPath) {
                            selectedPaths.append(customPath)
                            customPath = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                
                if !selectedPaths.isEmpty {
                    ForEach(selectedPaths, id: \.self) { path in
                        HStack {
                            Text(path)
                                .font(.caption)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Button(action: {
                                selectedPaths.removeAll { $0 == path }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            
            Section {
                Button(action: onCreate) {
                    HStack {
                        Spacer()
                        Text("创建备份")
                        Spacer()
                    }
                }
                .disabled(backupName.isEmpty || selectedPaths.isEmpty)
            }
        }
    }
}

struct FilePathsList: View {
    let basePath: String
    @Binding var selectedPaths: [String]
    @ObservedObject var logStore: LogStore
    
    @State private var filePaths: [String] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if isLoading {
                HStack {
                    ProgressView()
                    Text("加载中...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 5)
            } else if filePaths.isEmpty {
                Text("没有找到文件或无法访问")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 5)
            } else {
                ForEach(filePaths, id: \.self) { path in
                    HStack {
                        Image(systemName: "doc")
                            .foregroundColor(.blue)
                        
                        Text(URL(fileURLWithPath: path).lastPathComponent)
                            .font(.system(.caption, design: .monospaced))
                        
                        Spacer()
                        
                        if selectedPaths.contains(path) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedPaths.contains(path) {
                            selectedPaths.removeAll { $0 == path }
                        } else {
                            selectedPaths.append(path)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .onAppear {
            loadFilePaths()
        }
    }
    
    private func loadFilePaths() {
        isLoading = true
        filePaths = []
        
        DispatchQueue.global(qos: .userInitiated).async {
            let fileManager = FileManager.default
            
            do {
                let items = try fileManager.contentsOfDirectory(atPath: basePath)
                var paths: [String] = []
                
                for item in items {
                    let fullPath = URL(fileURLWithPath: basePath).appendingPathComponent(item).path
                    var isDir: ObjCBool = false
                    
                    if fileManager.fileExists(atPath: fullPath, isDirectory: &isDir) && !isDir.boolValue {
                        paths.append(fullPath)
                    }
                }
                
                DispatchQueue.main.async {
                    self.filePaths = paths
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.logStore.append(message: "加载路径失败 \(basePath): \(error.localizedDescription)")
                }
            }
        }
    }
}

// 在ContentView中添加公共方法
extension ContentView {
    public func publicGetTweaks() -> [Tweak] {
        return tweaks
    }
}

// 在PresetManager中添加公共方法
extension PresetManager {
    public func publicColorToString(_ color: Color) -> String {
        return colorToString(color)
    }
}
