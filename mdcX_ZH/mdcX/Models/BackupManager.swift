import Foundation

class BackupManager: ObservableObject {
    static let shared = BackupManager()
    @Published var backups: [BackupItem] = []
    @Published var isBackingUp = false
    
    private let backupDirectory: URL
    private let fileManager = FileManager.default
    
    struct BackupItem: Identifiable, Codable {
        var id = UUID()
        var name: String
        var date: Date
        var files: [String]
        var description: String
        var thumbnailPath: String?
    }
    
    private init() {
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        backupDirectory = documentsDirectory.appendingPathComponent("Backups")
        
        do {
            try fileManager.createDirectory(at: backupDirectory, withIntermediateDirectories: true)
            loadBackups()
        } catch {
            print("创建备份目录失败: \(error)")
        }
    }
    
    func loadBackups() {
        let metadataURL = backupDirectory.appendingPathComponent("metadata.json")
        
        if fileManager.fileExists(atPath: metadataURL.path) {
            do {
                let data = try Data(contentsOf: metadataURL)
                backups = try JSONDecoder().decode([BackupItem].self, from: data)
            } catch {
                print("加载备份元数据失败: \(error)")
            }
        }
    }
    
    func saveBackupMetadata() {
        let metadataURL = backupDirectory.appendingPathComponent("metadata.json")
        
        do {
            let data = try JSONEncoder().encode(backups)
            try data.write(to: metadataURL)
        } catch {
            print("保存备份元数据失败: \(error)")
        }
    }
    
    func createBackup(name: String, files: [String], description: String, completion: @escaping (Bool, String) -> Void) {
        isBackingUp = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let backupId = UUID()
            let backupFolder = self.backupDirectory.appendingPathComponent(backupId.uuidString)
            
            do {
                try self.fileManager.createDirectory(at: backupFolder, withIntermediateDirectories: true)
                
                var copiedFiles: [String] = []
                for filePath in files {
                    if self.fileManager.fileExists(atPath: filePath) {
                        let fileName = URL(fileURLWithPath: filePath).lastPathComponent
                        let destination = backupFolder.appendingPathComponent(fileName)
                        
                        // 尝试复制文件
                        do {
                            try self.fileManager.copyItem(atPath: filePath, toPath: destination.path)
                            copiedFiles.append(filePath)
                        } catch {
                            print("复制文件失败 \(filePath): \(error)")
                        }
                    }
                }
                
                // 创建备份截图
                let screenshotName = "screenshot.jpg"
                // 这里应添加截图逻辑
                
                let newBackup = BackupItem(
                    id: backupId,
                    name: name,
                    date: Date(),
                    files: copiedFiles,
                    description: description,
                    thumbnailPath: backupFolder.appendingPathComponent(screenshotName).path
                )
                
                DispatchQueue.main.async {
                    self.backups.append(newBackup)
                    self.saveBackupMetadata()
                    self.isBackingUp = false
                    completion(true, "成功备份 \(copiedFiles.count) 个文件")
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.isBackingUp = false
                    completion(false, "创建备份失败: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func restoreBackup(_ backup: BackupItem, completion: @escaping (Bool, String) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let backupFolder = self.backupDirectory.appendingPathComponent(backup.id.uuidString)
            var restoredCount = 0
            var errors: [String] = []
            
            for filePath in backup.files {
                let fileName = URL(fileURLWithPath: filePath).lastPathComponent
                let source = backupFolder.appendingPathComponent(fileName)
                
                if self.fileManager.fileExists(atPath: source.path) {
                    do {
                        // 尝试强制覆盖原文件
                        if self.fileManager.fileExists(atPath: filePath) {
                            try self.fileManager.removeItem(atPath: filePath)
                        }
                        try self.fileManager.copyItem(atPath: source.path, toPath: filePath)
                        restoredCount += 1
                    } catch {
                        errors.append("\(fileName): \(error.localizedDescription)")
                    }
                }
            }
            
            DispatchQueue.main.async {
                if errors.isEmpty {
                    completion(true, "成功恢复 \(restoredCount) 个文件")
                } else {
                    completion(false, "恢复了 \(restoredCount) 个文件，但有 \(errors.count) 个错误")
                }
            }
        }
    }
    
    func deleteBackup(_ backup: BackupItem) {
        let backupFolder = backupDirectory.appendingPathComponent(backup.id.uuidString)
        
        do {
            try fileManager.removeItem(at: backupFolder)
            if let index = backups.firstIndex(where: { $0.id == backup.id }) {
                backups.remove(at: index)
                saveBackupMetadata()
            }
        } catch {
            print("删除备份失败: \(error)")
        }
    }
}