# 批量目录复制脚本 (Batch Directory Copy Script)

## 📝 简介

这是一个 Windows 批处理脚本，用于根据文件列表批量复制目录及其所有内容（包括子目录和文件）到指定的备份位置。

## ✨ 功能特点

- ✅ 批量处理多个目录
- ✅ 递归复制所有子目录和文件
- ✅ 保留文件属性和时间戳
- ✅ 自动重试机制（失败后重试 5 次）
- ✅ 详细的日志记录
- ✅ 进度显示和统计报告
- ✅ 无需管理员权限
- ✅ 智能跳过不存在的源目录

## 📋 系统要求

- Windows 操作系统
- robocopy 命令（Windows 内置）
- 足够的磁盘空间用于备份

## 📁 文件说明

| 文件名 | 说明 |
|--------|------|
| `copy.bat` | 主脚本文件 |
| `filepaths.txt` | 需要复制的目录列表（每行一个相对路径） |
| `copy_log.txt` | 运行日志文件（自动生成） |

## 🚀 使用方法

### 1. 准备目录列表文件

创建或准备 `filepaths.txt` 文件，每行一个相对路径，例如：

```
e9a9bbd6-5a22-40a1-a353-2c8a2e625d57\FILE_NAME\
0742d8ec-01b1-49ab-b2fe-efdb3935c00a\FILE_NAME\
8c601e8c-282d-4b6c-aa78-4b1bf95e601f\FILE_NAME\
```

**注意**：
- 路径是相对于源根目录的
- 可以带或不带结尾的反斜杠
- 文件编码应为 UTF-8

### 2. 配置脚本参数

打开 `copy.bat`，修改以下配置变量：

```batch
set "FILEPATHS_FILE=filepaths.txt"        REM 目录列表文件
set "SOURCE_ROOT=D:\ceshiCopy\mxuploadpath\mxuploadpath\T_FLOW_ACCFILE"  REM 源根目录
set "BACKUP_ROOT=D:\backup_root\mxuploadpath\mxuploadpath\T_FLOW_ACCFILE"  REM 目标根目录
set "LOG_FILE=copy_log.txt"               REM 日志文件名
```

### 3. 运行脚本

双击 `copy.bat` 或在命令提示符中运行：

```cmd
copy.bat
```

### 4. 查看结果

运行完成后会显示统计报告：

```
====================================
Copy Complete - Summary Report
====================================
Total directories processed: 12547
Directories not found:       1234
Successfully copied:         11313
Failed to copy:              0
====================================
```

详细日志保存在 `copy_log.txt` 中。

## 📊 退出码说明

脚本使用 robocopy 的退出码，含义如下：

| 退出码 | 状态 | 说明 |
|--------|------|------|
| 0 | ✅ 成功 | 没有文件需要复制（目录为空或文件已存在） |
| 1 | ✅ 成功 | 文件已成功复制 |
| 2 | ✅ 成功 | 存在额外文件，但复制成功 |
| 3 | ✅ 成功 | 复制成功且存在额外文件 |
| 4+ | ❌ 失败 | 复制过程中出现错误 |
| 16 | ❌ 严重错误 | 完全失败（如权限不足、目录不存在） |

## ⚙️ 高级配置

### Robocopy 参数说明

脚本使用的 robocopy 参数：

```batch
robocopy "源目录" "目标目录" /E /COPY:DAT /R:5 /W:10 /NP
```

| 参数 | 说明 |
|------|------|
| `/E` | 复制所有子目录（包括空目录） |
| `/COPY:DAT` | 复制数据、属性、时间戳（不需要管理员权限） |
| `/R:5` | 失败时重试 5 次 |
| `/W:10` | 每次重试等待 10 秒 |
| `/NP` | 不显示百分比进度 |

### 修改重试次数和等待时间

如果遇到网络不稳定或文件被占用的情况，可以调整：

```batch
robocopy ... /R:10 /W:30    REM 重试10次，每次等待30秒
```

### 使用完整权限复制（需要管理员权限）

如果需要复制安全信息和审计信息，可以改为：

```batch
robocopy ... /COPYALL
```

**注意**：需要以管理员身份运行脚本。

## 📝 日志文件格式

`copy_log.txt` 包含详细的复制信息：

```
==================================
Copy Script Log
Start time: 周二 2025/10/28 17:38:42.54
==================================

[1] e9a9bbd6-5a22-40a1-a353-2c8a2e625d57\FILE_NAME
  SRC: D:\ceshiCopy\...\e9a9bbd6-...\FILE_NAME
  TGT: D:\backup_root\...\e9a9bbd6-...\FILE_NAME
  [OK] Exit code: 1

[2] 0742d8ec-01b1-49ab-b2fe-efdb3935c00a\FILE_NAME
  [SKIPPED] Source not found

==================================
Summary Report
==================================
Total directories processed: 2
Directories not found:       1
Successfully copied:         1
Failed to copy:              0
End time: 周二 2025/10/28 17:38:42.95
==================================
```

## ⚠️ 常见问题

### 1. 权限不足错误

**错误信息**：
```
ERROR : You do not have the Manage Auditing user right.
```

**解决方法**：
- 脚本已使用 `/COPY:DAT` 参数，不需要管理员权限
- 如果仍有问题，右键脚本 → 以管理员身份运行

### 2. 源目录不存在

**日志显示**：
```
[SKIPPED] Source not found
```

**解决方法**：
- 检查 `SOURCE_ROOT` 配置是否正确
- 检查 `filepaths.txt` 中的路径是否正确
- 确认源文件确实存在

### 3. 文件被占用

**错误信息**：
```
The process cannot access the file because it is being used by another process.
```

**解决方法**：
- 脚本会自动重试 5 次，每次等待 10 秒
- 关闭正在使用这些文件的程序
- 增加重试次数：`/R:10 /W:30`

### 4. 没有处理任何目录

**可能原因**：
- `filepaths.txt` 文件编码问题
- 文件路径不正确

**解决方法**：
```powershell
# 使用 PowerShell 创建正确编码的文件
Get-Content old_file.txt | Out-File -FilePath filepaths.txt -Encoding UTF8
```

## 📌 注意事项

1. **备份前检查**：确保有足够的磁盘空间
2. **路径格式**：确保 `filepaths.txt` 使用正确的相对路径
3. **文件编码**：`filepaths.txt` 应为 UTF-8 编码
4. **大量文件**：处理大量目录时可能需要较长时间，请耐心等待
5. **日志文件**：定期清理 `copy_log.txt`，避免文件过大

## 🔧 故障排除

### 查看实时进度

在另一个命令提示符窗口中运行：

```powershell
Get-Content copy_log.txt -Wait -Tail 20
```

### 测试单个目录

创建只包含几个路径的测试文件：

```powershell
Get-Content filepaths.txt -Head 5 > test_paths.txt
```

修改脚本使用 `test_paths.txt` 进行测试。

### 检查 robocopy 版本

```cmd
robocopy /?
```

## 📄 许可证

本脚本为开源脚本，可自由使用和修改。

## 🤝 贡献

欢迎提出问题和改进建议。

## 📞 联系方式

如有问题，请查看日志文件 `copy_log.txt` 获取详细错误信息。

---

**最后更新**: 2025年10月28日  
**版本**: 1.0

