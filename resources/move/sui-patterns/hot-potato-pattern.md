# Sui Pattern: Hot Potato | Sui Pattern: Hot Potato | Sui 设计模式：热土豆

Hot Potato là một design pattern quan trọng trên Sui Move. Tên gọi này xuất phát từ trò chơi truyền củ khoai tây nóng: nếu bạn nhận nó, bạn phải ném nó cho người khác ngay lập tức, không thể giữ lại. | Hot Potato is a crucial design pattern in Sui Move. The name comes from the hot potato game: if you receive it, you must throw it to someone else immediately; you cannot keep it. | 热土豆是 Sui Move 中的一个关键设计模式。这个名字来源于烫手山芋游戏：如果你收到了它，你必须立即扔给别人；你不能保留它。

## Khái Niệm Cơ Bản | Basic Concepts | 基本概念

Một cấu trúc dữ liệu không có bất kỳ logic `ability` nào (`key`, `store`, `copy`, `drop` bị khuyết) là một Hot Potato. | A data structure without any `ability` logic (lacking `key`, `store`, `copy`, `drop`) is a Hot Potato. | 没有任何 `ability` 逻辑（缺少 `key`、`store`、`copy`、`drop`）的数据结构就是热土豆。

Bởi vì nó thiếu `drop`, bạn không thể bỏ qua nó (như cách kết thúc hàm thông thường). Do thiếu `key` và `store`, bạn không thể lưu trữ nó vào Global Storage. Hệ quả: **Bạn bắt buộc phải pass struct này vào một hàm khác để phân giải và tiêu thụ (consume) nó hoàn toàn** trước khi kết thúc transaction block. | Because it lacks `drop`, you cannot ignore it (like a normal function exit). Because it lacks `key` and `store`, you cannot store it in Global Storage. Consequence: **You must pass this struct into another function to resolve and completely consume it** before the transaction block ends. | 因为它缺少 `drop`，你不能忽略它（就像普通的函数退出一样）。因为它缺少 `key` 和 `store`，你不能将它存储在全局存储中。结果：**你必须将此结构体传递给另一个函数以解析并完全消费它** 在交易区块结束之前。

## Ứng dụng: Flashloan | Application: Flashloan | 应用：闪电贷

Mục tiêu là cho vay tiền không cần thế chấp, MIỄN LÀ người dùng phải trả lại tiền cộng lãi trong cùng một giao dịch. | The goal is to lend money without collateral, AS LONG AS the user repays the principal and interest within the same transaction. | 目标是无抵押借贷，前提是用户在同一交易中偿还本金和利息。

```move
module sui_patterns::hot_potato_flashloan {
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};

    // 1. Hot Potato struct (Receipt)
    struct Receipt { amount_to_repay: u64 }
    // ... setup and Flashloan functions ...
}
```

### An Ninh Thực Tiễn | Practical Security | 实用安全

* **Không thể Cheat | Cannot Cheat | 不能作弊:** Move verifier tại thời điểm compile sẽ lỗi nếu bạn thử drop cái Receipt. | The Move verifier at compile time will throw an error if you try to drop the Receipt. | 如果您尝试丢弃 Receipt，Move 验证器将在编译时抛出错误。
* **PTB Flexibility | PTB Flexibility | PTB 灵活性:** Người dùng có thế nhận tiền mượn, đi làm việc khác, rồi gọi hàm `repay` ở lệnh cuối cùng của PTB. | Users can receive the borrowed money, do other things, and then call the `repay` function in the final PTB command. | 用户可以收到借来的钱，做其他事情，然后在 PTB 的最后一个命令中调用 `repay` 函数。
* **Rủi ro Flashloan Re-entrancy/Price manipulation | Flashloan Risk | 闪电贷风险:** Không có Re-entrancy, nhưng có thể sập bẫy Flashloan đệm vào các hàm của PTB khác nhau. | There's no Re-entrancy, but it can fall into Flashloan traps placed in different PTB functions. | 没有重入，但它可能会陷入置于不同 PTB 函数中的闪电贷陷阱。
