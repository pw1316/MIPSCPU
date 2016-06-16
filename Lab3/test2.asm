00	Lw r1, (20)r0	;R1=4	IF ID EX ME WB																				 IF ID EX
04	Lw r2, (24)r0	;R2=1	   IF ID EX ME WB																			    IF ID
08	Add r3,r2,r1    ;R3=5		  IF ID ID EX ME WB																			   IF
0C	Sub r4,r1,r3    ;R4=1			 IF IF ID EX ME WB
10  And r5,r3,r1    ;R5=4  				   IF ID EX ME WB
14	Or r6,r3,r1		;R6=5				      IF ID EX ME WB
18	addi r6,r3,4	;r6=9						 IF ID EX ME WB
1C	Add r7, r0, r1	;R7=4							IF ID EX ME WB
20	Lw r8,0(r7)     ;R8=7							   IF ID EX ME WB
24	Sw r8,8(r7)    	;									  IF ID EX ME WB
28	Lw r9, 8(r7)	;R9=7									 IF ID EX ME WB
2C	Sw r7, 0(r9)	;											IF ID ID EX ME WB
30	Lw r10,0(r9)	;r10=4										   IF IF ID EX ME WB
34	Add r10, r1, r1 ;R10=8												 IF ID EX ME WB
38	Add r11, r2,r2	;R11=2													IF ID EX ME WB
3C	Add r10,r1,r2	;R10=5													   IF ID EX ME WB
40	Beq r1, r2 ,8   ;															  IF ID EX ME WB
44	Lw r1, (8)r7	;R1=7															 IF ID EX ME WB
48	Lw r2, (24)r0	;R2=1																IF ID EX ME WB
4C	Add r3,r2,r1	;R3=8																   IF ID ID EX ME WB	
50	Sub r4,r1,r3	;R4=1																	  IF IF ID EX ME WB
54	Addi r20, r4, 1 ;R20=2																			IF ID EX ME WB
58	Ori r20, r4, 1  ;R20=1																			   IF ID EX ME WB
5C	Bne r1, r2, 4  	;																					  IF ID EX ME WB
60	Lw r1, (20)r0	; 																						 IF ID
64	Lw r2, (24)r0	;																							IF
68	Add r3,r2,r1	;
6C	Sub r4,r3,r1	;
70	J 0				;//j																						   IF ID EX ME WB
					;																								  IF