	.file	"asgn1.c"								# File Name
	.text										# Beginning of Text Segment
	.section	.rodata							# Section specifying Read-only Data
	.align 8									# Aligning with 8-Byte Boundary
#---------------------------------------------------------------------------------------------------------------------------------------------
.LC0:											# Label-1 -> for format string of 1st 'printf'
	.string	"Enter the string (all lowrer case): "

.LC1:											# Label-2 -> for format string of 'scanf'
	.string	"%s"

.LC2:											# Label-3 -> for format string of 2nd 'printf'
	.string	"Length of the string: %d\n"
	.align 8									# Aligning with 8-Byte Boundary

.LC3:											# Label-4 -> for format string of 3rd 'printf'
	.string	"The string in descending order: %s\n"
#---------------------------------------------------------------------------------------------------------------------------------------------
	.text										# Starting of code
	.globl	main								# Declaring 'main' as a global name
	.type	main, @function							# 'main' being described as a function
	
main:											# Starting of 'main' function
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp									# Saving old base pointer 'rbp' in stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp								# rbp<-rsp, Setting new stack base pointer
	.cfi_def_cfa_register 6
	subq	$80, %rsp								# Allocating space for integer variable 'len' and character arrays 'str' and 'dest'
	movq	%fs:40, %rax							
	movq	%rax, -8(%rbp)							# (rbp-8)<-rsp, placing on stack
	xorl	%eax, %eax								# setting value of register 'eax' to zero or in other words clearing 'eax'
	
	#printf("Enter the string (all lowrer case): ");
	leaq	.LC0(%rip), %rdi							# rdi<-(.LC0+rip), storing 1st parameter of printf
	movl	$0, %eax								# eax<-0, clearing 'eax'
	call	printf@PLT								# Calling the 1st printf in 'main' function with 'rdi' as argument
	
	#scanf("%s", str);
	leaq	-64(%rbp), %rax							# rax<-rbp-64, rax<-&str
	movq	%rax, %rsi								# rsi<-rax
	leaq	.LC1(%rip), %rdi							# rdi<-(.LC1+rip), storing 1st parameter of scanf
	movl	$0, %eax								# eax<-0, clearing 'eax'
	call	__isoc99_scanf@PLT						# Calling scanf along with returning input string in 'eax'
	
	#len=length(str);
	leaq	-64(%rbp), %rax							# rax<-(rbp-64), 'rax' now stores the string
	movq	%rax, %rdi								# rdi<-rax, now the string is stored in 'rdi'
	call	length								# Calling the length function
	movl	%eax, -68(%rbp)							# (rbp-68)<-eax, storing the integer variable len in 'rbp-68'
	movl	-68(%rbp), %eax							# eax<-(rbp-68), storing the value of integer variable 'len' in 'eax'
	movl	%eax, %esi								# esi<-eax, storinf the value of integer variable 'len' in 'esi'
	
	#printf("Length of the string: %d\n", len);
	leaq	.LC2(%rip), %rdi							# rdi<-(.LC2+rip), storing 2nd parameter of printf
	movl	$0, %eax								# eax<-0, clearing 'eax'
	call	printf@PLT								# Calling the 2nd printf in 'main' function with 'rdi' as argument
	
	#sort(str, len, dest);
	leaq	-32(%rbp), %rdx							# rdx<-(rbp-32), storing the character array 'dest' in 'rdx'
	movl	-68(%rbp), %ecx							# ecx<-(rbp-68), storing the value of integer variable 'len' in 'ecx'
	leaq	-64(%rbp), %rax							# rax<-(ebp-64), storing the character array 'str' in 'rax'
	movl	%ecx, %esi								# esi<-ecx, storing the value of integer variable 'len' in 'eSI'
	movq	%rax, %rdi								# rdi<-rax, storing the character array 'str' in 'rdi'
	call	sort									# Calling the 'sort' function
	
	#printf("The string in descending order: %s\n", dest);
	leaq	-32(%rbp), %rax							# rax<-(rbp-32), storing the value 
	movq	%rax, %rsi								# rsi<-rax
	leaq	.LC3(%rip), %rdi							# rdi<-(.LC3+rip), storing 3rd parameter of printf
	movl	$0, %eax								# eax<-0, clearing 'eax'
	call	printf@PLT								# Calling the 3rd printf in 'main' function with 'rdi' as argument
	
	#return 0;
	movl	$0, %eax								# eax<-0, clearing 'eax', here we are storing the value which is to returned by main
	movq	-8(%rbp), %rcx							# rcx<-(rbp-8), 
	xorq	%fs:40, %rcx							# taking XOR and checking the result, if result is 0, there is no stack-overflow
	je	.L3									# jumping to .L3 if we get 0 as result in the earlier step
	call	__stack_chk_fail@PLT						# if this statement is encountered by program, it means stack-overflow has occured and hence this statement terminates the program

.L3:											# Label when there is no stack-overflow and we have to end the program
	leave
	.cfi_def_cfa 7, 8
	ret										# returning 0 from 'main'
	.cfi_endproc

.LFE0:										# Label
	.size	main, .-main							# Size of 'main'
#---------------------------------------------------------------------------------------------------------------------------------------------
	.globl	length							# Declaring 'length' as a global name
	.type	length, @function						# 'length' being described as a function	
length:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp									# Saving old base pointer 'rbp' in stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp								# rbp<-rsp, Setting new stack base pointer
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)							# (rbp-24)<-rdi, placing on stack, ie, storing character array 'str' to '(rbp-24)'
	movl	$0, -4(%rbp)							# (rbp-4)<-0, initializing the integer variable 'i' to 0
	jmp	.L5									# jumping to label 'L5'
	
.L6:											# Label 'L6', used for incrementing integer variable 'i' by 1
	addl	$1, -4(%rbp)							# (rbp-4)<-(rbp-4)+1, it translates to 'i++' in program(in the loop statement specifically)
	
.L5:											# Label for the 'for' loop
	movl	-4(%rbp), %eax							# eax<-(rbp-4), storing the integer variable 'i' in 'eax'
	movslq	%eax, %rdx							# rdx<-eax, storing the integer variable 'i' in 'rdx' 
	movq	-24(%rbp), %rax							# rax<-(rbp-24), saving the character array argument 'str' in 'rax'
	addq	%rdx, %rax								# rax<-rax+rdx, moving the character pointer in character array 'str' to the i'th position
	movzbl	(%rax), %eax						# eax<-rax, storing the i'th character in the character array 'str' in 'eax'
	testb	%al, %al								# here al is the least significant bit of eax, and the statement sets flag to 0 if al&al==0(&-bitwise AND)
	jne	.L6									# Jumping to label L6 if flag is not equal to 0, ie we have to increment 'i' by 1
	movl	-4(%rbp), %eax							# eax<-(rbp-4), storing the integer variable 'i' in 'eax'
	popq	%rbp									# Popping the top of stack and storing it in 'rbp'
	.cfi_def_cfa 7, 8
	ret										# returning the integer variable 'i' and transfer call back to return address
	.cfi_endproc
	
.LFE1:										# Label
	.size	length, .-length							# Size of 'length'
#---------------------------------------------------------------------------------------------------------------------------------------------
	.globl	sort								# Declaring 'sort' as a global name
	.type	sort, @function							# 'sort' being described as a function
sort:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp									# Saving old base pointer 'rbp' in stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp								# rbp<-rsp, Setting new stack base pointer
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)							# (rbp-24)<-rdi, placing on stack, ie, storing character array 'str' to '(rbp-24)'
	movl	%esi, -28(%rbp)							# (rbp-28)<-esi, placing on stack, ie, storing integer variable 'len' to '(rbp-28)'
	movq	%rdx, -40(%rbp)							# (rbp-40)<-rdx, placing on stack, ie, storing character array 'dest' to '(rbp-40)'
	movl	$0, -8(%rbp)							# (rbp-8)<-0, initializing the integer variable 'i' to 0
	jmp	.L9									# Jumping tomn label 'L9'

.L13:
	movl	$0, -4(%rbp)							# (rbp-4)<-0, initializing value of integer variable 'j' to 0
	jmp	.L10									# jumping to label 'L10'
	
.L12:
	movl	-8(%rbp), %eax							# eax<-(rbp-8), storing the integer variable 'i' in 'eax'
	movslq	%eax, %rdx							# rdx<-eax, storing the integer variable 'i' in 'rdx'
	movq	-24(%rbp), %rax							# rax<-(rbp-24), storing the character array 'str' in 'rax'
	addq	%rdx, %rax								# rax<-rax+rdx, moving to the i'th character in the character array 'str'
	movzbl	(%rax), %edx						# edx<-rax, storing the i'th character in the character array 'str' in 'edx'
	movl	-4(%rbp), %eax							# eax<-(rbp-4), storing the integer variable 'j' in 'eax'
	movslq	%eax, %rcx							# rcx<-eax, storing the integer variable 'j' in 'rcx'
	movq	-24(%rbp), %rax							# rax<-(rbp-24), storing the character array 'str' in 'rax'
	addq	%rcx, %rax								# rax<-rax+rcx, moving to the j'th character in the character array 'str'
	movzbl	(%rax), %eax						# eax<-rax, storing the j'th character in the character array 'str' in 'eax'
	cmpb	%al, %dl								# if(dl<al), compares 'al' and 'dl', the lower 8-bits of 'eax' and rdx' respectively, corresponds to 'if(str[i]<str[j])' in the program 
	jge	.L11									# jumping to 'L11' if the condition satisfies
	movl	-8(%rbp), %eax							# eax<-(rbp-8), storing the integer variable 'i' in 'eax'
	movslq	%eax, %rdx							# rdx<-eax, storing the integer variable 'i' in 'rdx'
	movq	-24(%rbp), %rax							# rax<-(rbp-24), storing the character array 'str' in 'rax'
	addq	%rdx, %rax								# rax<-rax+rdx, moving to the i'th character in the character array 'str'
	movzbl	(%rax), %eax						# edx<-rax, storing the i'th character in the character array 'str' in 'edx'
	movb	%al, -9(%rbp)							# (rbp-9)<-al, the lower 8-bits of 'eax' are moved to '(rbp-9)'
	movl	-4(%rbp), %eax							# eax<-(rbp-4), storing the value of integer variable 'j' in 'eax'
	movslq	%eax, %rdx							# rdx<-eax, storing the value of integer variable 'j' in 'rdx'
	movq	-24(%rbp), %rax							# rax<-(rbp-24), storing the character array 'str' in 'rax'
	addq	%rdx, %rax								# rax<-rax+rdx, moving to the j'th character in the character array 'str'
	movl	-8(%rbp), %edx							# edx<-(rbp-8), storing the integer variable 'i' in 'edx'
	movslq	%edx, %rcx							# rcx<-edx, storing the integer variable 'i' in 'rcx'
	movq	-24(%rbp), %rdx							# rdx<-(rbp-24), storing the character array 'str' in 'rdx'
	addq	%rcx, %rdx								# rdx<-rdx+rcx, moving to the i'th character in the character array 'str'
	movzbl	(%rax), %eax						# edx<-rax, storing the i'th character in the character array 'str'
	movb	%al, (%rdx)							# rdx<-al, the lower 8-bits of 'eax' are moved to '(rbp-9)'
	movl	-4(%rbp), %eax							# eax<-(rbp-4), storing the integer variable 'j' in 'eax'
	movslq	%eax, %rdx							# rdx<-eax, storing the integer variable 'j' in 'rdx'
	movq	-24(%rbp), %rax							# rax<-(rbp-24), storing the character array 'str' in 'rax'
	addq	%rax, %rdx								# rdx<-rdx+rax, moving to the j'th character in the character array 'str'
	movzbl	-9(%rbp), %eax						# eax<-(rbp-9), the lower 8-bits of 'eax' are replaced by '(rbp-9)' adn the other bits are set to 0)
	movb	%al, (%rdx)							# rdx<-al, moving the lower 8-bits of 'eax' to 'rdx'
	
.L11:											# Label 'L11', used for incrementing integer variable 'j' by 1
	addl	$1, -4(%rbp)							# (rbp-4)<-(rbp-4)+1, it translates to 'j++' in program(in the loop statement specifically)

	
.L10:
	movl	-4(%rbp), %eax							# eax<-(rbp-4), storing the value of integer variable 'j' in 'eax'
	cmpl	-28(%rbp), %eax							# this statement corresponds to 'if(j<len)', it comapres '(rbp-28)' and 'eax'
	jl	.L12									# jumping to lable 'L12' if the above condition satisfies
	addl	$1, -8(%rbp)							# (rbp-8)<-(rbp-8)+1, this statement corresponds to 'i++' in the loop in program
	
.L9:
	movl	-8(%rbp), %eax							# eax<-(rbp-8), storing value of integer variable 'i' in rbp
	cmpl	-28(%rbp), %eax							# this statement corresponds to 'if(i<len)', it comapres '(rbp-28)' and 'eax'
	jl	.L13									# jumping to lable 'L13' if the above condition satisfies
	movq	-40(%rbp), %rdx							# rdx<-(rbp-40), moving the character array 'dest' to 'rdx'
	movl	-28(%rbp), %ecx							# ecx<-(rbp-24), moving the integer variable 'len' to 'ecx'
	movq	-24(%rbp), %rax							# rax<-(rbp-24), moving the character array 'str' to 'rax'
	movl	%ecx, %esi								# esi<-ecx, moving the integer variable 'len' to 'esi'
	movq	%rax, %rdi								# rdi<-rax, moving the character array 'str' to 'rdi'
	call	reverse								# Calling the 'reverse' function
	nop										# doesn't do anything
	leave
	.cfi_def_cfa 7, 8
	ret										# returning nothing beacause 'sort' is a function of void data type and transfer control back to the return address
	.cfi_endproc
.LFE2:
	.size	sort, .-sort							# Size of 'sort'
#---------------------------------------------------------------------------------------------------------------------------------------------
	.globl	reverse							# Declaring 'reverse' as a global name
	.type	reverse, @function						# 'reverse' being described as a function
reverse:
.LFB3:
	.cfi_startproc
	endbr64
	pushq	%rbp									# Saving old base pointer (rbp) in stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp								# rbp<-rsp, Setting new stack base pointer
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)							# (rbp-24)<-rdi, placing on stack, ie, storing character array 'str' to '(rbp-24)'
	movl	%esi, -28(%rbp)							# (rbp-28)<-esi, placing on stack, ie, storing integer variable 'len' to '(rbp-28)'
	movq	%rdx, -40(%rbp)							# (rbp-40)<-rdx, placing on stack, ie, storing character array 'dest' to '(rbp-40)'
	movl	$0, -8(%rbp)							# (rbp-8)<-0, initializing the integer variable 'i' to 0
	jmp	.L15									# Jumping tomn label 'L15'

.L20:
	movl	-28(%rbp), %eax							# eax<-(rbp-28), storing value of integer variable 'len' in 'eax'
	subl	-8(%rbp), %eax							# eax<-eax-(rbp-8), now 'eax' stores the valie of 'len-i'
	subl	$1, %eax								# eax<-eax-1, now 'eax' stores the value of 'len-i-1', which is the intial value of integer variable 'j' in the inner for loop
	movl	%eax, -4(%rbp)							# (rbp-4)<-eax, storing value of integer variable 'j' in '(rbp-8)'
	nop										# doesn't do anything
	movl	-28(%rbp), %eax							# eax<-(rbp-28), storing value of integer variable 'len' in 'eax'
	movl	%eax, %edx								# edx<-eax, storing value of integer variable 'len' in 'edx'
	shrl	$31, %edx								# Bitwise right-shift of 31 bits in 'edx' is taking place in this statement
	addl	%edx, %eax								# eax<-eax+edx, 1 gets added to eax if edx was negetive else 0 gets added
	sarl	%eax									# Bitwise right-shift of 1 bit in 'eax' is taking place in this statement, ie, len/2 is now stored in 'eax'
	cmpl	%eax, -4(%rbp)							# this statement corresponds to 'if(j>=len/2)', it comapres 'eax' and '(rbp-28)'
	jl	.L18									# jumping to label 'L18' if condition satisfies					
	movl	-8(%rbp), %eax							# eax<-(rbp-8), storing value of integer value 'i' in 'eax'
	cmpl	-4(%rbp), %eax							# this statement corresponds to 'if(i==j)', it comapres 'eax' and '(rbp-4)'
	je	.L23									# jumping to label 'L23' if condition satisfies
	movl	-8(%rbp), %eax							# eax<-(rbp-8), storing value of integer value 'i' in 'eax'					
	movslq	%eax, %rdx							# rdx<-eax, storing value of integer variable 'i' in 'rdx'
	movq	-24(%rbp), %rax							# rax<-(rbp-24), storing value of character array 'str' in 'rax'
	addq	%rdx, %rax								# rax<-rax+rdx, moving to the i'th character in the character array 'str'
	movzbl	(%rax), %eax						# eax<-rax, storing the i'th character of character array 'str' in 'eax'
	movb	%al, -9(%rbp)							# (rbp-9)<-al, the lower 8-bits of 'eax' are moved to '(rbp-9)'
	movl	-4(%rbp), %eax							# eax<-(rbp-4), storing the value of integer variable 'j' in 'eax'
	movslq	%eax, %rdx							# rdx<-eax, storing the value of integer variable 'j' in 'rdx'
	movq	-24(%rbp), %rax							# rax<-(rbp-24), storing value of character array 'str' in 'rax'
	addq	%rdx, %rax								# rax<-rax+rdx, moving to the j'th character in the character array 'str'
	movl	-8(%rbp), %edx							# edx<-(rbp-8), storing the value of integer variable 'i' in 'edx'
	movslq	%edx, %rcx							# rcx<-edx, storing the value of integer variable 'i' in 'rcx'
	movq	-24(%rbp), %rdx							# rdx<-(rbp-24), storing value of character array 'str' in 'rdx'
	addq	%rcx, %rdx								# rdx<-rdx+rcx, moving to the i'th character in the character array 'str'					
	movzbl	(%rax), %eax						# eax<-rax, storing the i'th character of character array 'str' in 'eax'
	movb	%al, (%rdx)							# rdx<-al, the lower 8-bits of 'eax' are moved to 'rdx'
	movl	-4(%rbp), %eax							# eax<-(rbp-4), storing the value of integer variable 'j' in 'eax'
	movslq	%eax, %rdx							# rdx<-eax, storing the value of integer variable 'j' in 'rdx'
	movq	-24(%rbp), %rax							# rax<-(rbp-24), storing value of character array 'str' in 'rax'
	addq	%rax, %rdx								# rdx<-rdx+rax, moving to the j'th character in the character array 'str'
	movzbl	-9(%rbp), %eax						# eax<-(rbp-9), the lower 8-bits of 'eax' are replaced by '(rbp-9)' adn the other bits are set to 0)
	movb	%al, (%rdx)							# rdx<-al, moving the lower 8-bits of 'eax' to 'rdx'
	jmp	.L18									# jumping to label 'L18'

.L23:
	nop										# doesn't do anything
	
.L18:
	addl	$1, -8(%rbp)							# (rbp-8)<-(rbp-8)+1, it translates to 'i++' in program(in the loop statement specifically)

	
.L15:
	movl	-28(%rbp), %eax							# eax<-(rbp-28), storing value of integer variable 'len' in 'eax'
	movl	%eax, %edx								# edx<-eax, storing the value of integer variable 'len' in 'edx'
	shrl	$31, %edx								# Bitwise right-shift of 31 bits in 'edx' is taking place in this statement
	addl	%edx, %eax								# eax<-eax+edx, 1 gets added to eax if edx was negetive else 0 gets added
	sarl	%eax									# Bitwise right-shift of 1 bit in 'eax' is taking place in this statement, ie, len/2 is now stored in 'eax'
	cmpl	%eax, -8(%rbp)							# this statement corresponds to 'if(i<len/2)', it comapres 'eax' and '(rbp-28)'
	jl	.L20									# jumping to label 'L20' if condition satisfies
	movl	$0, -8(%rbp)							# (rbp-8)<-0, initializing 'i' with 0 for the 2nd for loop in the 'reverse' function
	jmp	.L21									# jumping to label 'L21'
	
.L22:
	movl	-8(%rbp), %eax							# eax<-(rbp-8), storing value of integer variable 'i' in 'eax'
	movslq	%eax, %rdx							# rdx<-eax, storing value of integer variable 'i' in 'rdx'
	movq	-24(%rbp), %rax							# rax<-(rbp-24), storing value of character array 'str' in 'rax'
	addq	%rdx, %rax								# rax<-rax+rdx, moving to the i'th character of the character array 'str'
	movl	-8(%rbp), %edx							# edx<-(rbp-8), storing value of the integer variable 'i' in 'edx'
	movslq	%edx, %rcx							# rcx<-edx, storing value of the integer variable 'i' in 'rcx'
	movq	-40(%rbp), %rdx							# rdx<-(rbp-40), storing character array 'dest' in 'rdx'
	addq	%rcx, %rdx								# rdx<-rdx+rcx, moving to the i'th character of the character array 'dest'
	movzbl	(%rax), %eax						# eax<-rax, storing the i'th character of character array 'str' in 'eax'
	movb	%al, (%rdx)							# rdx<-al, the lower 8-bits of 'eax' are moved to 'rdx'
	addl	$1, -8(%rbp)							# (rbp-8)<-(rbp-8)+1, this statement corresponds to 'i++' in the 2nd for loop of the 'reverse' function
	
.L21:
	movl	-8(%rbp), %eax							# eax<-(rbp-8), storing value of the integer variable 'i' in 'eax'
	cmpl	-28(%rbp), %eax							# this statement corresponds to 'if(i<len)', it comapres 'eax' and '(rbp-28)'
	jl	.L22									# jumping to label 'L22' if condition satisfies
	nop										# doesn't do anything
	nop										# doesn't do anything
	popq	%rbp									# Popping the top of stack and storing it in 'rbp'
	.cfi_def_cfa 7, 8
	ret										# returning nothing beacause 'reverse' is a function of void data type and transfer control back to the return address
	.cfi_endproc
	
.LFE3:
	.size	reverse, .-reverse						# Size of 'reverse'
#---------------------------------------------------------------------------------------------------------------------------------------------
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
	
0:
	.string	 "GNU"
	
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
	
2:
	.long	 0x3
	
3:
	.align 8
	
4:
