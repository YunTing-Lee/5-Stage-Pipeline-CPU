# 5-Stage-Pipeline-CPU

## 開發平台
Windows 10

## 開發環境
Icarus Verilog

# 架構圖
![image](https://github.com/YunTing-Lee/5-Stage-Pipeline-CPU/blob/main/Pictures/Architecture.png)

# 設計重點說明
1. lw : 先在control_single進行必要之訊號賦值，使最後DataMemory的ADDR為rs，WD為rt，經過DataMemory後即可將ADDR(rs)指向之位置中的內容讀進去rt並寫回register。
2. sw : 先在control_single進行必要之訊號賦值，使最後DataMemory的ADDR為rs，WD為rt，經過DataMemory後即可將WD（rt)指向之位置中的資料寫進ADDR（rs）中。
3. addiu :類似於ADD，只是ADD是將rs的內容加上rt的內容寫回rd，而ADDIU則是將rs的內容加上immed寫回rt，因此只要確保進ALU時的inputA是rs、inputB是immed、最終DataMemory的WD是rt，其餘皆都和ADD相同。
4. multu : 利用funct來判斷是否進行乘法，一旦要進行乘法，必須stall 32個clock 才有辦法完成，故會有一個module來進行對PC以及IF_ID輸出部寫入訊號進行stall直到32 clock進行完成後，將會對HiLo輸出寫入信號，HILo將會把乘法的結果寫入，並且保持至下次的輸入信號輸入。
5. mfhi : rs以及rt均為零，並且沒有給一定要做的指令故ALU計算並不會有結果，僅需將ALU後的多工器給輸出訊號ALU_OUT 設為0,hi中的內容，不用經過data Memory而是直接將hi的內容寫回指定rd暫存器內即可。
6. mflo : rs以及rt均為零，並且沒有給一定要做的指令故ALU計算並不會有結果，僅需將ALU後的多工器給出輸出訊號ALU_OUT 設為1，輸出hi中的內容，不用經過data Memory而是直接將hi的內容寫回指定rd暫存器內即可。
7. j : 跳躍指令，控制訊號Jump設為1，將指令中低26位元指令偏移量左移2位元變成28位元位置偏移量，前面接上PC+4的最高4位元形成32位元，當作要跳去的位置。
8. jal : 前半部與j指令相同，但要將返回位置return address (PC+4)存在r31暫存器中，因為要寫回暫存器，所以將RegWrite設為1，MemtoReg設為2表示選擇PC+4作為寫入的內容，RegDst設為2表示選擇第31號暫存器寫入。
9. beq : 將指令中低16位元指令偏移量左移2位元變成18位元位置偏移量，並將它做有號數擴充成32位元，控制訊號Branch設為1，在Instruction Decode接段，將Register File輸出之RD1與RD2做比較，判斷是否相等，若相等，則Zero訊號設為1，否則Zero為0，利用Branch & Zero的結果設定PCSrc， PCSrc若為1則選擇(PC+4+位移量)作為下一個cycle的PC，若PCSrc為0，則選擇正常的PC+4。
10. nop :指令32位元全為0，不執行任何動作來達到stall的作用
