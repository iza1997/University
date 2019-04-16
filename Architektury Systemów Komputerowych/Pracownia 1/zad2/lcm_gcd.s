	.text 					
	.global lcm_gcd				
	.type  lcm_gcd, @function 	

lcm_gcd:
	a = %rdi
	b = %rsi
	mov %rdi, %r8
	mov %rsi, %r9
	cmp $0, a
	je .L4
	cmp $0, b
	je .L6	
.LOOP:	cmp a, b
	jbe  .L1
	sub a, b
	jmp .LOOP
.L1:	cmp a, b
	je  .L3
	sub b, a
	jmp .LOOP
.L4:	cmp a, b
	je  .L5
	mov %r9, %rax
	xor %edx,%edx
	mov $0, %rdx
	ret
.L5:	mov $0, %rax
	mov $0, %rdx
	ret
.L6:	mov %r8, %rax
	mov %r8, %rax
	ret
.L3: 	mov %r8, %rax
	xor %edx,%edx
	div b
	imul %r9, %rax
	mov a, %rdx
	ret
	.size lcm_gcd, .-lcm_gcd
