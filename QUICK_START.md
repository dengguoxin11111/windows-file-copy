# 快速入门指南

## 🚀 三步开始使用

### 第一步：准备文件列表

创建 `filepaths.txt` 文件，内容示例：

```
folder1\subfolder\
folder2\subfolder\
folder3\subfolder\
```

### 第二步：配置脚本

打开 `copy.bat`，修改这两行：

```batch
set "SOURCE_ROOT=D:\你的源目录路径"
set "BACKUP_ROOT=D:\你的备份目录路径"
```

### 第三步：运行

双击 `copy.bat` 即可开始复制！

---

## 📋 完整示例

假设你有以下文件结构：

```
D:\ceshiCopy\
└── mxuploadpath\
    └── T_FLOW_ACCFILE\
        ├── abc-123\FILE_NAME\
        │   └── file1.txt
        └── def-456\FILE_NAME\
            └── file2.txt
```

### 1. 创建 `filepaths.txt`

```
abc-123\FILE_NAME\
def-456\FILE_NAME\
```

### 2. 配置 `copy.bat`

```batch
set "SOURCE_ROOT=D:\ceshiCopy\mxuploadpath\T_FLOW_ACCFILE"
set "BACKUP_ROOT=D:\backup\T_FLOW_ACCFILE"
```

### 3. 运行后的结果

```
D:\backup\
└── T_FLOW_ACCFILE\
    ├── abc-123\FILE_NAME\
    │   └── file1.txt
    └── def-456\FILE_NAME\
        └── file2.txt
```

---

## ✅ 运行结果示例

```
====================================
Batch Directory Copy Script
====================================

[OK] Found filepaths.txt
[OK] Source directory exists
====================================
Starting directory copy process
====================================
Source: D:\ceshiCopy\mxuploadpath\T_FLOW_ACCFILE
Target: D:\backup\T_FLOW_ACCFILE
====================================

[1] abc-123\FILE_NAME
  Copying...
  [OK] Exit code: 1

[2] def-456\FILE_NAME
  Copying...
  [OK] Exit code: 1

====================================
Copy Complete - Summary Report
====================================
Total directories processed: 2
Directories not found:       0
Successfully copied:         2
Failed to copy:              0
====================================

Log file saved to: copy_log.txt

Press any key to exit...
```

---

## 💡 小提示

1. **测试先行**：先用几个目录测试，确认无误后再批量处理
2. **查看日志**：遇到问题时查看 `copy_log.txt` 获取详细信息
3. **路径格式**：路径末尾的反斜杠 `\` 可加可不加，脚本会自动处理
4. **中文支持**：脚本支持中文路径和文件名

---

## ❓ 常见问题

**Q: 为什么显示 "Source not found"？**  
A: 检查源目录路径是否正确，确保 `SOURCE_ROOT + 相对路径` 能找到目录

**Q: 可以复制文件而不是目录吗？**  
A: 可以，但需要修改脚本。当前版本专为目录设计

**Q: 会覆盖已存在的文件吗？**  
A: 是的，robocopy 会覆盖旧文件，保持最新版本

**Q: 需要管理员权限吗？**  
A: 不需要，脚本使用 `/COPY:DAT` 参数，普通用户即可运行

---

完整文档请参阅 [README.md](README.md)

