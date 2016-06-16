0	Lw r1, (20)r0		;R1=4
4	Lw r2, (24)r0		;R2=1
8	Add r3,r2,r1    	;R3=5	//LW-ALU:forwarding:1 stall
0C	Sub r4,r1,r3      	;R4=1	//ALU-ALU
10	And r5,r3,r1     	;R5=4	//无冲突
14	Or r6,r3,r1		;R6=5	//无冲突
18	addi r6,r3,4		;r6=9	//无冲突
1C	Add r7, r0, r1		;R7=4	//无冲突
20	Lw r8,0(r7)     	;R8=8	//ALU-LW
24	Sw r8,8(r7)    		;	//LW-SW：forwarding可以解决
28	Lw r9, 8(r7)		;R9=8
2C	Sw r7, 0(r9)		;	//LW-SW: forwarding:1 stall
30	Lw r10,0(r9)		;r10=4
34	Add r10, r1, r1 	;R10=8
38	Add r11, r2,r2		;R11=2
3C	Add r10,r1,r2		;R10=5
40	Beq r10, r11 ,8   	; not taken//ALU-BEQ;	branch
44	Lw r1, (8)r7		;R1=8
48	Lw r2, (24)r0		;R2=1
4C	Add r3,r2,r1		;R3=9	//LW-ALU
50	Sub r4,r1,r3		;R4=1
54	Addi r20, r4, 1 	;R20=2	//ALU-addi
58	Ori r20, r4, 1   	;R20=1	//无冲突
5C	Bne r1, r2, 4  		; taken
60	Lw r1, (20)r0		; 
64	Lw r2, (24)r0		;
68	Add r3,r2,r1		;
6C	Sub r4,r3,r1		;
70	J 0			;//j