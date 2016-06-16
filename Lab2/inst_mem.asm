addi $t0,$zero,3 #$t0=3
sw $t0,0($zero) #mem[0]=3
addi $t0,$t0,4  #t0=7
sw $t0,4($zero) #mem[4]=7
lw $s0,0($zero) #$s0 = 3
lw $s1,4($zero) #$s1 = 7
sw $s0,4($zero) 
lw $s1,4($zero) #$s1 = 3
addi $s1,$s1,1  #$s1 = 4
lui  $s2,9      #$s2 = 0x90000
srl  $s2,$s2,16 #$s2 = 9
slt  $s3,$s1,$s2 #$s3 = 1
ori  $s4,$zero,4 #$s4 = 4
slt  $s4,$s2,$s3 #$s4 = 0
slti $s5,$s4,5   #$s5 = 1
slti $s6,$s5,1	 #$s6 = 0
srl  $s4,$s4,2   #$s4 = 0
andi $s2,$s2,3   #$s2 = 1
add  $s0,$s0,$s1 #$s0 = 7
sub  $s1,$s1,$s2 #$s1 = 3
and  $s4,$s0,$s1 #$s4 = 3 
or   $s1,$s0,$s1 #$s1 = 7 54
beq  $s0,$zero,2 #not jump 58
beq  $s0,$s1,1   #jump   5c
addi $s0,$s0,1   #not execute 60
bne  $s0,$s1,2 	 #not jump 64
bne  $s0,$zero,1   #jump 68
addi $s0,$s0,1   #not execute 6c
j 30 #70
addi $s0,$s0,1   #not execute 74
jal 32  	 #$ra = 108 78
addi $s0,$s0,1   #not execute 7c
jr $ra            80
  