// ========================================
// 1位元半減器 (Half Subtractor)
// ========================================
// 輸入: A (被減數), B (減數)
// 輸出: D (差), Bout (借位輸出)
//
// 邏輯方程式：
// D    = A XOR B
// Bout = NOT A AND B
// ========================================

module half_sub_1bit (
    input A,      // 被減數
    input B,      // 減數
    output D,     // 差輸出
    output Bout   // 借位輸出
);

    // 差的計算：A - B
    assign D = A ^ B;
    
    // 借位輸出：當 A < B 時需要借位 (NOT A AND B)
    assign Bout = ~A & B;

endmodule
