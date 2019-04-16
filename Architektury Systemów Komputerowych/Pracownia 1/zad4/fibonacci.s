	.text 					
	.global fibonacci				
	.type  fibonacci, @function 	

fibonacci:
	cmp $0, %rdi
	je .L1
	cmp $1, %rdi
	je .L1
	push %rbp
	push %rdi
	dec %rdi
	call fibonacci
	mov %rax, %r8
	pop %rdi
	dec %rdi
	dec %rdi
	push %r8
	call fibonacci
	pop %r8
	pop %rbp
	add %r8, %rax
	ret

.L1:	mov %rdi, %rax
	ret


