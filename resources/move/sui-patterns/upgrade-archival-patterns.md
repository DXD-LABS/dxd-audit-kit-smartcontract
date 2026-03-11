# Sui Pattern: Immutable Upgrade | 不可变升级模式 | Mẫu thiết kế : Immutable Upgrade

Sử dụng `UpgradeCap` để quản lý phiên bản package một cách an toàn mà không làm mất trạng thái của các objects cũ. | Use `UpgradeCap` to manage package versions safely without losing the state of old objects. | 使用 `UpgradeCap` 安全地管理包版本，而不会丢失旧对象的状态。


---

## 📦 Archival System Pattern | 存档系统模式 | Mẫu thiết kế : Archival System

Sử dụng `sui::event`
 để đẩy dữ liệu ra off-chain (Walrus/Indexers) nhằm tạo lịch sử có thể kiểm chứng. | Use `sui::event` to push data off-chain (Walrus/Indexers) to create a verifiable history. | 使用 `sui::event` 将数据推送到链下（Walrus/Indexers），以创建可验证的历史记录。

## Vuln Mitigated: AGENT-013 (Side-Channel Leak)
Dữ liệu lưu trữ off-chain có thể được mã hóa và chứng thực mà không làm lộ trạng thái on-chain nhạy cảm.
