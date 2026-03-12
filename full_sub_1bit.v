// ========================================
// 1位元半減器 (Half Subtractor)
// ========================================
module half_sub_1bit (
    input A,      // 被減數
    input B,      // 減數
    output D,     // 差輸出
    output Bout   // 借位輸出
);

    assign D = A ^ B;
    assign Bout = ~A & B;

endmodule


// ========================================
// 1位元全減器 (Full Subtractor)
// 利用兩個半減器實現
// ========================================
// 輸入: A (被減數), B (減數), Bin (借位輸入)
// 輸出: D (差), Bout (借位輸出)
//
// 實現原理：
// 第一個半減器：計算 A - B → D1, Bout1
// 第二個半減器：計算 D1 - Bin → D, Bout2
// 借位輸出：Bout = Bout1 OR Bout2
// ========================================

module full_sub_1bit (
    input A,      // 被減數
    input B,      // 減數
    input Bin,    // 借位輸入
    output D,     // 差輸出
    output Bout   // 借位輸出
);

    wire D1, Bout1, Bout2;
    
    // 第一個半減器：計算 A - B
    half_sub_1bit HS1 (
        .A(A),
        .B(B),
        .D(D1),
        .Bout(Bout1)
    );
    
    // 第二個半減器：計算 D1 - Bin
    half_sub_1bit HS2 (
        .A(D1),
        .B(Bin),
        .D(D),
        .Bout(Bout2)
    );
    
    // 借位輸出：任何一級產生借位就輸出借位
    assign Bout = Bout1 | Bout2;

endmodule
