# 1位元減器設計 (1-bit Subtractor Design)
<img width="1198" height="375" alt="image" src="https://github.com/user-attachments/assets/f99974f8-a5cc-465b-8ac0-647975bcbd50" />

## 專案概述

本專案使用 Verilog HDL 實現 1 位元的 **半減器 (Half Subtractor)** 和 **全減器 (Full Subtractor)**，並利用半減器的模組化設計構建全減器。

---

## 1. 半減器 (Half Subtractor)

### 模組定義

```verilog
module half_sub_1bit (
    input A,      // 被減數 (Minuend)
    input B,      // 減數 (Subtrahend)
    output D,     // 差輸出 (Difference)
    output Bout   // 借位輸出 (Borrow Out)
);
```

### 功能描述

半減器執行 1 位元的減法運算：**A - B**，不考慮借位輸入。

### 邏輯方程式

- **差 (D)**：D = A ⊕ B
- **借位輸出 (Bout)**：Bout = Ā · B

### 真值表

| A | B | D | Bout | 說明            |
|---|---|---|------|-----------------|
| 0 | 0 | 0 | 0    | 0 - 0 = 0       |
| 0 | 1 | 1 | 1    | 0 - 1 = 1 (需借位) |
| 1 | 0 | 1 | 0    | 1 - 0 = 1       |
| 1 | 1 | 0 | 0    | 1 - 1 = 0       |

### 邏輯圖

```
    A ─┐
       ├─[XOR]─── D
    B ─┤
    
    A ●─┐
       ├─[AND]─── Bout
    B ─┘
```

### 應用場景

- 作為全減器的基本構件
- 用於多位元減器的最低位運算
- 簡單的 1 位元減法運算

---

## 2. 全減器 (Full Subtractor)

### 模組定義

```verilog
module full_sub_1bit (
    input A,      // 被減數 (Minuend)
    input B,      // 減數 (Subtrahend)
    input Bin,    // 借位輸入 (Borrow In)
    output D,     // 差輸出 (Difference)
    output Bout   // 借位輸出 (Borrow Out)
);
```

### 功能描述

全減器執行 1 位元的減法運算：**A - B - Bin**，考慮來自低位的借位。

### 邏輯方程式

- **差 (D)**：D = (A ⊕ B) ⊕ Bin = A ⊕ B ⊕ Bin
- **借位輸出 (Bout)**：Bout = (Ā · B) + (Ā · Bin) + (B · Bin)

或簡化為：
- **Bout = Bout1 OR Bout2**，其中：
  - Bout1 = Ā · B （第一個半減器的借位）
  - Bout2 = D̄1 · Bin （第二個半減器的借位）

### 真值表

| A | B | Bin | D | Bout | 說明 |
|---|---|-----|---|------|------|
| 0 | 0 | 0   | 0 | 0    | 0 - 0 - 0 = 0 |
| 0 | 0 | 1   | 1 | 1    | 0 - 0 - 1 = 1 (需借位) |
| 0 | 1 | 0   | 1 | 1    | 0 - 1 - 0 = 1 (需借位) |
| 0 | 1 | 1   | 0 | 1    | 0 - 1 - 1 = 0 (需借位) |
| 1 | 0 | 0   | 1 | 0    | 1 - 0 - 0 = 1 |
| 1 | 0 | 1   | 0 | 0    | 1 - 0 - 1 = 0 |
| 1 | 1 | 0   | 0 | 0    | 1 - 1 - 0 = 0 |
| 1 | 1 | 1   | 1 | 1    | 1 - 1 - 1 = 1 (需借位) |

### 實現架構

本設計採用 **層級結構**，使用兩個半減器和一個 OR 門：

```
    A ─┐         D1 ─┐
       ├─[HS1]─────┬─┤
    B ─┤         Bout1┤  ┌─[HS2]─── D
                      │  │
                 Bin ─┴──┤
                          Bout2┤
                                 ├─[OR]─── Bout
                            Bout1─┘
```

**步驟詳解：**

1. **第一級 (HS1)**：半減器計算 A - B
   - 輸出差值：D1 = A ⊕ B
   - 輸出借位：Bout1 = Ā · B

2. **第二級 (HS2)**：半減器計算 D1 - Bin
   - 輸出最終差值：D = D1 ⊕ Bin = A ⊕ B ⊕ Bin
   - 輸出借位：Bout2 = D̄1 · Bin

3. **借位合併**：Bout = Bout1 | Bout2
   - 任何一級產生借位，就向上級輸出借位

### 應用場景

- 多位元減法運算的各位數計算
- 減法計算單元的核心組件
- CPU 和 ALU 中的減法功能實現

---

## 3. 檔案結構

```
full_sub_1bit/
├── full_sub_1bit.v      # Verilog 源程式碼（包含半減器和全減器）
└── README.md            # 本文檔
```

---

## 4. 設計特點

### 優點

1. **模組化設計**
   - 全減器利用半減器模組實現，代碼重用率高
   - 易於擴展到多位元減器設計

2. **邏輯清晰**
   - 採用層級結構實現
   - 邏輯流程易於理解和驗證

3. **硬體實現友好**
   - 純組合邏輯設計，無時序延遲問題
   - 易於合成為 FPGA/CPLD 硬體

4. **低功耗**
   - 所有邏輯均為基本門電路
   - 功耗小，性能穩定

### 設計對比

| 特性 | 半減器 | 全減器 |
|-----|--------|--------|
| **輸入變數** | 2 (A, B) | 3 (A, B, Bin) |
| **借位輸入** | 無 | 有 |
| **應用範圍** | 最低位 | 各位數 |
| **邏輯複雜度** | 低 | 中 |

---

## 5. 使用示例

### Verilog 例化（多位元減器）

```verilog
// 4 位元減器設計範例
module sub_4bit (
    input [3:0] A,
    input [3:0] B,
    output [3:0] D,
    output Bout
);

    wire [4:0] Borrow;
    assign Borrow[0] = 0;  // 最低位借位輸入為 0
    
    // 第 0 位（最低位）使用全減器
    full_sub_1bit fs0 (.A(A[0]), .B(B[0]), .Bin(Borrow[0]), 
                        .D(D[0]), .Bout(Borrow[1]));
    
    // 第 1-3 位均使用全減器
    full_sub_1bit fs1 (.A(A[1]), .B(B[1]), .Bin(Borrow[1]), 
                        .D(D[1]), .Bout(Borrow[2]));
    full_sub_1bit fs2 (.A(A[2]), .B(B[2]), .Bin(Borrow[2]), 
                        .D(D[2]), .Bout(Borrow[3]));
    full_sub_1bit fs3 (.A(A[3]), .B(B[3]), .Bin(Borrow[3]), 
                        .D(D[3]), .Bout(Borrow[4]));
    
    assign Bout = Borrow[4];  // 最高位的借位輸出

endmodule
```

---

## 6. 硬體合成注意事項

### Vivado / ISE 合成

- 語法符合 IEEE 1364-2001 (Verilog-2001) 標準
- 組合邏輯設計，綜合後自動優化
- 建議添加約束文件 (XDC/UCF) 設定管腳分配和時序要求

### 時序性能

- **傳播延遲**：取決於硬體工具的優化和目標器件
- **臨界路徑**：二級延遲 (HS1 → HS2 → OR)
- **最大頻率**：一般在數百 MHz 以上

### Testbench 驗證

建議編寫 testbench 對所有真值表情況進行驗證：

```verilog
// 簡易 testbench 示例
initial begin
    // 測試全減器所有組合
    A=0; B=0; Bin=0; #10;
    A=0; B=0; Bin=1; #10;
    A=0; B=1; Bin=0; #10;
    // ... 其他組合 ...
end
```

---

## 7. 參考資源

- **Verilog HDL 參考**：IEEE Std 1364-2005
- **數位邏輯設計**：減法器基本原理
- **FPGA/CPLD 設計**：組合邏輯綜合與實現

---

## 8. 修訂历史

| 版本 | 日期 | 描述 |
|-----|------|------|
| 1.0 | 2026-03-12 | 初始版本：半減器和全減器設計 |

---

## 許可證

本設計為教學用途，可自由使用和修改。

---

**作者注**：本設計是 CPLD 114-2 課程的練習項目，重點展示模組化硬體設計和邏輯結構的正確實現。
