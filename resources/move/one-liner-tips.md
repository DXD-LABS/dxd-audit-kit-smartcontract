# One-Liner Tips cho Move/Sui Dev & Auditor | One-Liner Tips for Move/Sui Devs & Auditors | Move/Sui 开发者与审计员的一句话提示

- **Capability**: "Không public borrow cap → dùng ownership hoặc &mut." | "Do not expose capability borrowing publicly → use ownership or `&mut`." | "不要公开借用权能 → 使用所有权或 `&mut`。"
- **Flash Loan**: "Hot potato phải destroy trong tx – không drop!" | "Hot potato must be destroyed within the transaction – do not drop!" | "热土豆必须在交易内销毁 – 不要丢弃！"
- **Oracle**: "Luôn check timestamp + max_age để tránh stale price." | "Always check timestamp + `max_age` to avoid stale prices." | "始终检查时间戳 + `max_age` 以避免过时价格。"
- **Kiosk**: "KioskOwnerCap là chìa khóa – không có cap thì không list/withdraw." | "KioskOwnerCap is key – without the cap, you cannot list or withdraw." | "KioskOwnerCap 是关键 – 没有它，你无法列出或提取。"
- **Upgrade**: "Version phải tăng dần – no downgrade attack." | "Version must increase incrementally – no downgrade attack." | "版本必须递增 – 严禁降级攻击。"
- **Storage**: "Delete object khi không cần – tránh storage bloat DoS." | "Delete objects when not needed – avoid storage bloat DoS." | "不需要时删除对象 – 避免存储膨胀导致的 DoS。"

💡 Share tip nào hay thì PR vào repo nhé! | Share your best tips via a PR to this repo! | 欢迎通过 PR 向此仓库分享您的最佳提示！
