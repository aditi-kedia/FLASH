	.file	"flash2.c"
	.text
.Ltext0:
	.file 0 "/home/prajas/C_C++/Systems Programming/Final Project/FLASH" "flash2.c"
	.globl	fBackground
	.bss
	.align 4
	.type	fBackground, @object
	.size	fBackground, 4
fBackground:
	.zero	4
	.globl	ec
	.align 4
	.type	ec, @object
	.size	ec, 4
ec:
	.zero	4
	.globl	environment
	.align 8
	.type	environment, @object
	.size	environment, 8
environment:
	.zero	8
	.globl	hostName
	.align 8
	.type	hostName, @object
	.size	hostName, 8
hostName:
	.zero	8
	.globl	environmentVariables
	.align 8
	.type	environmentVariables, @object
	.size	environmentVariables, 8
environmentVariables:
	.zero	8
	.globl	retVal
	.align 4
	.type	retVal, @object
	.size	retVal, 4
retVal:
	.zero	4
	.section	.rodata
	.align 8
.LC0:
	.string	"\033[32m\033[1m%s@%s\033[0m:\033[34m\033[1m%s\033[0m\033[0m$ "
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.file 1 "flash2.c"
	.loc 1 92 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$1472, %rsp
	movl	%edi, -1460(%rbp)
	movq	%rsi, -1472(%rbp)
	.loc 1 92 1
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 95 5
	movl	$0, %eax
	call	CreateEnvironment
	.loc 1 99 9
	leaq	-1440(%rbp), %rax
	movq	%rax, %rdi
	call	uname@PLT
	.loc 1 99 8
	testl	%eax, %eax
	jne	.L10
	.loc 1 100 18
	leaq	-1440(%rbp), %rax
	addq	$65, %rax
	movq	%rax, hostName(%rip)
	jmp	.L4
.L10:
	.loc 1 104 9
	nop
.L2:
.L4:
	.loc 1 105 28
	movq	-1456(%rbp), %rax
	movl	$1024, %esi
	movq	%rax, %rdi
	call	getcwd@PLT
	movq	%rax, -1456(%rbp)
	.loc 1 106 12
	cmpq	$0, -1456(%rbp)
	jne	.L3
	.loc 1 107 13
	jmp	.L4
.L3:
	.loc 1 108 16
	call	getlogin@PLT
	movq	%rax, -1448(%rbp)
	.loc 1 110 9
	movq	hostName(%rip), %rdx
	movq	-1456(%rbp), %rcx
	movq	-1448(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	.loc 1 111 9
	movq	stdin(%rip), %rdx
	leaq	-1040(%rbp), %rax
	movl	$1024, %esi
	movq	%rax, %rdi
	call	fgets@PLT
	.loc 1 112 22
	leaq	-1040(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	.loc 1 112 43
	subq	$1, %rax
	.loc 1 112 48
	movb	$0, -1040(%rbp,%rax)
	.loc 1 113 14
	leaq	-1040(%rbp), %rax
	movq	%rax, %rdi
	call	ProcessCommandLine
	.loc 1 113 12
	movl	%eax, ec(%rip)
	.loc 1 114 16
	movl	ec(%rip), %eax
	.loc 1 114 12
	cmpl	$-2, %eax
	je	.L11
	.loc 1 104 9
	jmp	.L4
.L11:
	.loc 1 115 13
	nop
	movl	$0, %eax
	.loc 1 118 1
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L8
	call	__stack_chk_fail@PLT
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.section	.rodata
.LC1:
	.string	"PATH"
	.text
	.globl	CreateEnvironment
	.type	CreateEnvironment, @function
CreateEnvironment:
.LFB7:
	.loc 1 121 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	.loc 1 122 19
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	getenv@PLT
	.loc 1 122 17
	movq	%rax, environment(%rip)
	.loc 1 123 49
	movl	$128, %edi
	call	malloc@PLT
	.loc 1 123 26
	movq	%rax, environmentVariables(%rip)
	.loc 1 124 26
	movq	environmentVariables(%rip), %rax
	.loc 1 124 38
	movl	$15, 124(%rax)
	.loc 1 125 26
	movq	environmentVariables(%rip), %rax
	.loc 1 125 46
	movl	$0, 120(%rax)
	.loc 1 127 1
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	CreateEnvironment, .-CreateEnvironment
	.section	.rodata
.LC2:
	.string	"[^,]+ *|(\"[^\"]*\")"
	.text
	.globl	ProcessCommandLine
	.type	ProcessCommandLine, @function
ProcessCommandLine:
.LFB8:
	.loc 1 131 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	.loc 1 131 1
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 133 17
	leaq	.LC2(%rip), %rax
	movq	%rax, -16(%rbp)
	.loc 1 134 28
	movq	-16(%rbp), %rdx
	leaq	-32(%rbp), %rsi
	movq	-56(%rbp), %rax
	movl	$0, %ecx
	movq	%rax, %rdi
	call	TokenizeString
	movl	%eax, -40(%rbp)
	.loc 1 135 8
	cmpl	$0, -40(%rbp)
	jns	.L14
	.loc 1 136 16
	movl	-40(%rbp), %eax
	jmp	.L13
.L14:
.LBB2:
	.loc 1 137 14
	movl	$0, -44(%rbp)
	.loc 1 137 5
	jmp	.L16
.L21:
.LBB3:
	.loc 1 140 54
	movq	-32(%rbp), %rdx
	movl	-44(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	.loc 1 140 29
	movq	(%rax), %rax
	leaq	-24(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	ProcessPipes
	movl	%eax, -36(%rbp)
	.loc 1 141 12
	cmpl	$0, -36(%rbp)
	jns	.L17
	.loc 1 142 20
	movl	-36(%rbp), %eax
	jmp	.L13
.L17:
	.loc 1 143 17
	cmpl	$1, -36(%rbp)
	jne	.L19
	.loc 1 145 18
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	ProcessSingleCommand
	.loc 1 145 16
	movl	%eax, ec(%rip)
	.loc 1 146 20
	movl	ec(%rip), %eax
	.loc 1 146 16
	cmpl	$-2, %eax
	jne	.L20
	.loc 1 147 24
	movl	$-2, %eax
	jmp	.L13
.L19:
	.loc 1 151 18
	movq	-24(%rbp), %rax
	movl	-36(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	ProcessMultiplePipes
	.loc 1 151 16
	movl	%eax, ec(%rip)
.L20:
.LBE3:
	.loc 1 137 45 discriminator 1
	addl	$1, -44(%rbp)
.L16:
	.loc 1 137 23 discriminator 1
	movl	-44(%rbp), %eax
	cmpl	-40(%rbp), %eax
	jl	.L21
.L13:
.LBE2:
	.loc 1 154 1
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L23
	call	__stack_chk_fail@PLT
.L23:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	ProcessCommandLine, .-ProcessCommandLine
	.globl	ProcessMultiplePipes
	.type	ProcessMultiplePipes, @function
ProcessMultiplePipes:
.LFB9:
	.loc 1 158 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	.loc 1 159 61
	movl	-44(%rbp), %eax
	addl	$1, %eax
	cltq
	.loc 1 159 39
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -16(%rbp)
.LBB4:
	.loc 1 160 14
	movl	$0, -20(%rbp)
	.loc 1 160 5
	jmp	.L25
.L28:
.LBB5:
	.loc 1 162 64
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 162 33
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	PreprocessCommandsForPipe
	movq	%rax, -8(%rbp)
	.loc 1 163 12
	cmpq	$0, -8(%rbp)
	jne	.L26
	.loc 1 165 13
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	.loc 1 166 20
	movl	$-1, %eax
	jmp	.L24
.L26:
	.loc 1 170 25 discriminator 2
	movl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-16(%rbp), %rax
	addq	%rax, %rdx
	.loc 1 170 29 discriminator 2
	movq	-8(%rbp), %rax
	movq	%rax, (%rdx)
.LBE5:
	.loc 1 160 42 discriminator 2
	addl	$1, -20(%rbp)
.L25:
	.loc 1 160 23 discriminator 1
	movl	-20(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L28
.LBE4:
	.loc 1 173 17
	movl	-44(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 173 33
	movq	$0, (%rax)
	.loc 1 175 5
	movl	-44(%rbp), %edx
	movq	-16(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	PipedExecution
.L24:
	.loc 1 176 1
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	ProcessMultiplePipes, .-ProcessMultiplePipes
	.section	.rodata
.LC3:
	.string	"fork"
.LC4:
	.string	"exited with error code"
.LC5:
	.string	"The process with pid"
.LC6:
	.string	"%s: %d %s - %d\n"
.LC7:
	.string	"signalled with signal code"
.LC8:
	.string	"was core dumped"
.LC9:
	.string	"%s: %d %s\n"
	.text
	.globl	PipedExecution
	.type	PipedExecution, @function
PipedExecution:
.LFB10:
	.loc 1 179 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$1088, %rsp
	movq	%rdi, -1080(%rbp)
	movl	%esi, -1084(%rbp)
	.loc 1 179 1
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 182 6
	movl	$0, -1064(%rbp)
	.loc 1 184 8
	jmp	.L30
.L43:
	.loc 1 185 3
	leaq	-1048(%rbp), %rax
	movq	%rax, %rdi
	call	pipe@PLT
	.loc 1 186 14
	call	fork@PLT
	movl	%eax, -1060(%rbp)
	.loc 1 186 6
	cmpl	$-1, -1060(%rbp)
	jne	.L31
	.loc 1 187 4
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	.loc 1 188 18
	call	__errno_location@PLT
	.loc 1 188 13
	movl	(%rax), %eax
	movl	%eax, %edi
	call	exit@PLT
.L31:
	.loc 1 190 11
	cmpl	$0, -1060(%rbp)
	jne	.L32
	.loc 1 191 4
	movl	-1064(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	dup2@PLT
	.loc 1 192 26
	movq	-1080(%rbp), %rax
	addq	$8, %rax
	.loc 1 192 8
	movq	(%rax), %rax
	.loc 1 192 7
	testq	%rax, %rax
	je	.L33
	.loc 1 193 5
	movl	-1044(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	dup2@PLT
.L33:
	.loc 1 195 4
	movl	-1048(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	.loc 1 196 4
	movq	-1080(%rbp), %rax
	movq	(%rax), %rdx
	.loc 1 196 11
	movq	-1080(%rbp), %rax
	movq	(%rax), %rax
	.loc 1 196 4
	movq	(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	execv@PLT
	.loc 1 197 9
	call	__errno_location@PLT
	.loc 1 197 4
	movl	(%rax), %eax
	movl	%eax, %edi
	call	exit@PLT
.L32:
.LBB6:
	.loc 1 204 35
	movq	-1080(%rbp), %rax
	addq	$8, %rax
	.loc 1 204 17
	movq	(%rax), %rax
	.loc 1 204 16
	testq	%rax, %rax
	jne	.L34
.LBB7:
	.loc 1 206 25
	leaq	-1068(%rbp), %rcx
	movl	-1060(%rbp), %eax
	movl	$2, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	waitpid@PLT
	movl	%eax, -1056(%rbp)
	.loc 1 207 20
	cmpl	$-1, -1056(%rbp)
	jne	.L35
	.loc 1 208 28
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L44
.L35:
	.loc 1 212 25
	movl	-1068(%rbp), %eax
	andl	$127, %eax
	.loc 1 212 24
	testl	%eax, %eax
	jne	.L37
	.loc 1 214 34
	movl	-1068(%rbp), %eax
	sarl	$8, %eax
	movzbl	%al, %eax
	.loc 1 214 32
	movl	%eax, retVal(%rip)
	.loc 1 215 36
	movl	retVal(%rip), %eax
	.loc 1 215 28
	testl	%eax, %eax
	jne	.L38
	.loc 1 216 36
	movl	$0, %eax
	jmp	.L44
.L38:
	.loc 1 217 25
	movl	retVal(%rip), %edx
	movl	-1060(%rbp), %ecx
	leaq	-1040(%rbp), %rax
	subq	$8, %rsp
	pushq	%rdx
	leaq	.LC4(%rip), %r9
	movl	%ecx, %r8d
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC6(%rip), %rdx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	addq	$16, %rsp
	.loc 1 218 25
	leaq	-1040(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	leaq	-1040(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	write@PLT
	.loc 1 219 32
	movl	$0, %eax
	jmp	.L44
.L37:
	.loc 1 221 30
	movl	-1068(%rbp), %eax
	andl	$127, %eax
	addl	$1, %eax
	sarb	%al
	.loc 1 221 29
	testb	%al, %al
	jle	.L39
	.loc 1 223 32
	movl	$-6, retVal(%rip)
	.loc 1 224 38
	movl	-1068(%rbp), %eax
	.loc 1 224 36
	andl	$127, %eax
	movl	%eax, -1052(%rbp)
	.loc 1 225 25
	movl	-1060(%rbp), %ecx
	leaq	-1040(%rbp), %rax
	subq	$8, %rsp
	movl	-1052(%rbp), %edx
	pushq	%rdx
	leaq	.LC7(%rip), %r9
	movl	%ecx, %r8d
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC6(%rip), %rdx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	addq	$16, %rsp
	.loc 1 226 25
	leaq	-1040(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	leaq	-1040(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	write@PLT
	.loc 1 227 32
	movl	$0, %eax
	jmp	.L44
.L39:
	.loc 1 229 30
	movl	-1068(%rbp), %eax
	andl	$128, %eax
	.loc 1 229 29
	testl	%eax, %eax
	je	.L40
	.loc 1 231 32
	movl	$-7, retVal(%rip)
	.loc 1 232 25
	movl	-1060(%rbp), %edx
	leaq	-1040(%rbp), %rax
	leaq	.LC8(%rip), %r9
	movl	%edx, %r8d
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC9(%rip), %rdx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	.loc 1 233 32
	movl	$0, %eax
	jmp	.L44
.L40:
	.loc 1 236 17
	movl	-1044(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	.loc 1 237 21
	movl	-1048(%rbp), %eax
	movl	%eax, -1064(%rbp)
	.loc 1 238 32
	addq	$8, -1080(%rbp)
.LBE7:
	jmp	.L30
.L34:
	.loc 1 242 17
	movl	$0, %edi
	call	wait@PLT
	.loc 1 243 17
	movl	-1044(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	.loc 1 244 21
	movl	-1048(%rbp), %eax
	movl	%eax, -1064(%rbp)
	.loc 1 245 32
	addq	$8, -1080(%rbp)
.L30:
.LBE6:
	.loc 1 184 9
	movq	-1080(%rbp), %rax
	movq	(%rax), %rax
	.loc 1 184 26
	testq	%rax, %rax
	jne	.L43
	.loc 1 249 12
	movl	$0, %eax
.L44:
	.loc 1 250 1 discriminator 1
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L45
	.loc 1 250 1 is_stmt 0
	call	__stack_chk_fail@PLT
.L45:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	PipedExecution, .-PipedExecution
	.section	.rodata
.LC10:
	.string	"(([^ ]+([\\] )*)+)|(\"[^\"]*\")"
.LC11:
	.string	"exit"
	.align 8
.LC12:
	.string	"\nCannot exit while attempting to pipe.\n"
.LC13:
	.string	"cd"
	.align 8
.LC14:
	.string	"\nCannot change directory while attempting to pipe.\n"
.LC15:
	.string	"#"
	.align 8
.LC16:
	.string	"\nUnexpected pipe symbol while attempting to run in background\n"
	.text
	.globl	PreprocessCommandsForPipe
	.type	PreprocessCommandsForPipe, @function
PreprocessCommandsForPipe:
.LFB11:
	.loc 1 252 1 is_stmt 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	.loc 1 252 1
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 254 11
	leaq	.LC10(%rip), %rax
	movq	%rax, -16(%rbp)
	.loc 1 255 28
	movq	-16(%rbp), %rdx
	leaq	-24(%rbp), %rsi
	movq	-40(%rbp), %rax
	movl	$1, %ecx
	movq	%rax, %rdi
	call	TokenizeString
	movl	%eax, -28(%rbp)
	.loc 1 256 8
	cmpl	$0, -28(%rbp)
	jns	.L47
	.loc 1 258 16
	movl	$0, %eax
	jmp	.L52
.L47:
	.loc 1 260 8
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	leaq	.LC11(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 260 7
	testl	%eax, %eax
	jne	.L49
	.loc 1 260 45 discriminator 1
	cmpl	$1, -28(%rbp)
	jne	.L49
	.loc 1 262 9
	leaq	.LC12(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	.loc 1 263 16
	movl	$0, %eax
	jmp	.L52
.L49:
	.loc 1 265 14
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	leaq	.LC13(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 265 13
	testl	%eax, %eax
	jne	.L50
	.loc 1 265 49 discriminator 1
	cmpl	$2, -28(%rbp)
	jne	.L50
	.loc 1 267 9
	leaq	.LC14(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	.loc 1 268 16
	movl	$0, %eax
	jmp	.L52
.L50:
	.loc 1 270 32
	movq	-24(%rbp), %rax
	movl	$24, %esi
	movq	%rax, %rdi
	call	realloc@PLT
	.loc 1 270 20
	movq	%rax, -24(%rbp)
	.loc 1 271 19
	movq	-24(%rbp), %rdx
	movl	-28(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	.loc 1 271 38
	movq	$0, (%rax)
	.loc 1 273 22
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	GetEnvPath
	.loc 1 273 20
	movq	%rax, -24(%rbp)
	.loc 1 275 30
	movq	-24(%rbp), %rdx
	movl	-28(%rbp), %eax
	cltq
	salq	$3, %rax
	subq	$8, %rax
	addq	%rdx, %rax
	.loc 1 275 9
	movq	(%rax), %rax
	leaq	.LC15(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 275 8
	testl	%eax, %eax
	jne	.L51
	.loc 1 277 9
	leaq	.LC16(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	.loc 1 278 16
	movl	$0, %eax
	jmp	.L52
.L51:
	.loc 1 280 12
	movq	-24(%rbp), %rax
.L52:
	.loc 1 281 1 discriminator 1
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L53
	.loc 1 281 1 is_stmt 0
	call	__stack_chk_fail@PLT
.L53:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	PreprocessCommandsForPipe, .-PreprocessCommandsForPipe
	.section	.rodata
	.align 8
.LC17:
	.string	"(([^ ]+([\\] )*)+)|(\"[^\"]*\")|([^ ]+=((([^ ]+([\\] )*)+)|(\"[^\"]*\")))"
.LC18:
	.string	"set"
.LC19:
	.string	"get"
	.text
	.globl	ProcessSingleCommand
	.type	ProcessSingleCommand, @function
ProcessSingleCommand:
.LFB12:
	.loc 1 285 1 is_stmt 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$1088, %rsp
	movq	%rdi, -1080(%rbp)
	.loc 1 285 1
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 287 11
	leaq	.LC17(%rip), %rax
	movq	%rax, -1048(%rbp)
	.loc 1 288 28
	movq	-1048(%rbp), %rdx
	leaq	-1056(%rbp), %rsi
	movq	-1080(%rbp), %rax
	movl	$1, %ecx
	movq	%rax, %rdi
	call	TokenizeString
	movl	%eax, -1068(%rbp)
	.loc 1 289 8
	cmpl	$0, -1068(%rbp)
	jns	.L55
	.loc 1 290 16
	movl	-1068(%rbp), %eax
	jmp	.L69
.L55:
	.loc 1 291 13
	cmpl	$0, -1068(%rbp)
	jne	.L57
	.loc 1 292 16
	movl	$-1, %eax
	jmp	.L69
.L57:
	.loc 1 293 8
	movq	-1056(%rbp), %rax
	movq	(%rax), %rax
	leaq	.LC11(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 293 7
	testl	%eax, %eax
	jne	.L58
	.loc 1 293 45 discriminator 1
	cmpl	$1, -1068(%rbp)
	jne	.L58
	.loc 1 294 16
	movl	$-2, %eax
	jmp	.L69
.L58:
	.loc 1 295 14
	movq	-1056(%rbp), %rax
	movq	(%rax), %rax
	leaq	.LC18(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 295 13
	testl	%eax, %eax
	jne	.L59
	.loc 1 297 12
	cmpl	$2, -1068(%rbp)
	jne	.L60
	.loc 1 299 55
	movq	-1056(%rbp), %rax
	addq	$8, %rax
	.loc 1 299 18
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	SetEnvironmentVariable
	.loc 1 299 16
	movl	%eax, ec(%rip)
	.loc 1 300 20
	movl	ec(%rip), %eax
	jmp	.L69
.L60:
	.loc 1 303 20
	movl	$-4, %eax
	jmp	.L69
.L59:
	.loc 1 305 14
	movq	-1056(%rbp), %rax
	movq	(%rax), %rax
	leaq	.LC19(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 305 13
	testl	%eax, %eax
	jne	.L61
	.loc 1 307 12
	cmpl	$2, -1068(%rbp)
	jne	.L62
	.loc 1 309 55
	movq	-1056(%rbp), %rax
	addq	$8, %rax
	.loc 1 309 18
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	GetEnvironmentVariable
	.loc 1 309 16
	movl	%eax, ec(%rip)
	.loc 1 310 20
	movl	ec(%rip), %eax
	jmp	.L69
.L62:
	.loc 1 313 20
	movl	$-4, %eax
	jmp	.L69
.L61:
	.loc 1 315 14
	movq	-1056(%rbp), %rax
	movq	(%rax), %rax
	leaq	.LC13(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 315 13
	testl	%eax, %eax
	jne	.L63
	.loc 1 315 49 discriminator 1
	cmpl	$2, -1068(%rbp)
	jne	.L63
.LBB8:
	.loc 1 319 42
	movq	-1056(%rbp), %rax
	addq	$8, %rax
	.loc 1 319 22
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	chdir@PLT
	movl	%eax, -1064(%rbp)
	.loc 1 321 12
	cmpl	$-1, -1064(%rbp)
	jne	.L64
	.loc 1 323 20
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L69
.L64:
	.loc 1 325 16
	movl	$0, %eax
	jmp	.L69
.L63:
.LBE8:
	.loc 1 327 32
	movq	-1056(%rbp), %rax
	movl	$24, %esi
	movq	%rax, %rdi
	call	realloc@PLT
	.loc 1 327 20
	movq	%rax, -1056(%rbp)
	.loc 1 328 19
	movq	-1056(%rbp), %rdx
	movl	-1068(%rbp), %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	.loc 1 328 38
	movq	$0, (%rax)
	.loc 1 330 22
	movq	-1056(%rbp), %rax
	movq	%rax, %rdi
	call	GetEnvPath
	.loc 1 330 20
	movq	%rax, -1056(%rbp)
	.loc 1 332 30
	movq	-1056(%rbp), %rdx
	movl	-1068(%rbp), %eax
	cltq
	salq	$3, %rax
	subq	$8, %rax
	addq	%rdx, %rax
	.loc 1 332 9
	movq	(%rax), %rax
	leaq	.LC15(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 332 8
	testl	%eax, %eax
	jne	.L66
	.loc 1 334 23
	movq	-1056(%rbp), %rdx
	movl	-1068(%rbp), %eax
	cltq
	salq	$3, %rax
	subq	$8, %rax
	addq	%rdx, %rax
	.loc 1 334 46
	movq	$0, (%rax)
	.loc 1 335 9
	movq	-1056(%rbp), %rax
	movl	-1068(%rbp), %edx
	movl	%edx, %esi
	movq	%rax, %rdi
	call	ExecuteCommandInBackground
	jmp	.L67
.L66:
.LBB9:
	.loc 1 341 27
	movl	-1068(%rbp), %eax
	leal	1(%rax), %edx
	movq	-1056(%rbp), %rax
	leaq	-1072(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	ExecuteCommandInForeground
	movl	%eax, -1060(%rbp)
	.loc 1 342 12
	cmpl	$0, -1060(%rbp)
	je	.L67
	.loc 1 344 20
	movl	-1060(%rbp), %eax
	jmp	.L69
.L67:
.LBE9:
	.loc 1 348 12
	movl	$0, %eax
.L69:
	.loc 1 349 1 discriminator 2
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L70
	.loc 1 349 1 is_stmt 0
	call	__stack_chk_fail@PLT
.L70:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	ProcessSingleCommand, .-ProcessSingleCommand
	.section	.rodata
.LC20:
	.string	"[^|]+ *"
	.text
	.globl	ProcessPipes
	.type	ProcessPipes, @function
ProcessPipes:
.LFB13:
	.loc 1 353 1 is_stmt 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	.loc 1 354 17
	leaq	.LC20(%rip), %rax
	movq	%rax, -8(%rbp)
	.loc 1 355 25
	movq	-8(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rax
	movl	$0, %ecx
	movq	%rax, %rdi
	call	TokenizeString
	movl	%eax, -12(%rbp)
	.loc 1 356 8
	cmpl	$0, -12(%rbp)
	jns	.L72
	.loc 1 357 16
	movl	-12(%rbp), %eax
	jmp	.L71
.L72:
.L71:
	.loc 1 358 1
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	ProcessPipes, .-ProcessPipes
	.section	.rodata
.LC21:
	.string	"%.*s"
.LC22:
	.string	" "
	.text
	.globl	TokenizeString
	.type	TokenizeString, @function
TokenizeString:
.LFB14:
	.loc 1 368 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$160, %rsp
	movq	%rdi, -136(%rbp)
	movq	%rsi, -144(%rbp)
	movq	%rdx, -152(%rbp)
	movl	%ecx, -156(%rbp)
	.loc 1 368 1
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 371 17
	movq	-136(%rbp), %rax
	movq	%rax, -104(%rbp)
	.loc 1 375 9
	movl	$0, -124(%rbp)
	.loc 1 377 9
	movq	-152(%rbp), %rcx
	leaq	-80(%rbp), %rax
	movl	$5, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	regcomp@PLT
	.loc 1 377 8
	testl	%eax, %eax
	je	.L75
	.loc 1 378 16
	movl	$-1, %eax
	jmp	.L85
.L75:
	.loc 1 380 30
	movl	$8, %edi
	call	malloc@PLT
	movq	%rax, -96(%rbp)
.LBB10:
	.loc 1 381 14
	movl	$0, -120(%rbp)
.L84:
.LBB11:
	.loc 1 382 13
	leaq	-16(%rbp), %rdx
	movq	-104(%rbp), %rsi
	leaq	-80(%rbp), %rax
	movl	$0, %r8d
	movq	%rdx, %rcx
	movl	$1, %edx
	movq	%rax, %rdi
	call	regexec@PLT
	.loc 1 382 12
	testl	%eax, %eax
	jne	.L88
	.loc 1 384 18
	addl	$1, -124(%rbp)
	.loc 1 385 27
	movl	-124(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-96(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	realloc@PLT
	movq	%rax, -96(%rbp)
	.loc 1 387 24
	movl	-16(%rbp), %eax
	movl	%eax, %edx
	.loc 1 387 36
	movq	-104(%rbp), %rax
	subq	-136(%rbp), %rax
	.loc 1 387 31
	addl	%edx, %eax
	.loc 1 387 13
	movl	%eax, -116(%rbp)
	.loc 1 388 24
	movl	-12(%rbp), %eax
	.loc 1 388 42
	movl	-16(%rbp), %edx
	.loc 1 388 13
	subl	%edx, %eax
	movl	%eax, -112(%rbp)
	.loc 1 389 30
	movl	-16(%rbp), %eax
	.loc 1 389 13
	addl	$1, %eax
	movl	%eax, -108(%rbp)
	.loc 1 391 30
	movl	-112(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -88(%rbp)
	.loc 1 392 55
	movl	-16(%rbp), %eax
	movslq	%eax, %rdx
	.loc 1 392 9
	movq	-104(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-112(%rbp), %edx
	movq	-88(%rbp), %rax
	movq	%rcx, %r8
	movl	%edx, %ecx
	leaq	.LC21(%rip), %rdx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	.loc 1 393 16
	movq	-88(%rbp), %rax
	movzbl	(%rax), %eax
	.loc 1 393 12
	cmpb	$34, %al
	jne	.L79
	.loc 1 395 17
	addq	$1, -88(%rbp)
	.loc 1 396 17
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	.loc 1 396 16
	leaq	-1(%rax), %rdx
	movq	-88(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 396 34
	movb	$0, (%rax)
.L79:
	.loc 1 398 12
	cmpl	$0, -156(%rbp)
	je	.L80
	.loc 1 399 13
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	RemoveEscapeSpace
.L80:
	.loc 1 400 16
	movq	-88(%rbp), %rax
	movzbl	(%rax), %eax
	.loc 1 400 12
	cmpb	$32, %al
	jne	.L81
	.loc 1 400 30 discriminator 1
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	.loc 1 400 27 discriminator 1
	cmpq	$1, %rax
	jne	.L81
	.loc 1 402 23 discriminator 2
	subl	$1, -124(%rbp)
	.loc 1 403 27 discriminator 2
	movl	-12(%rbp), %eax
	cltq
	.loc 1 403 15 discriminator 2
	addq	%rax, -104(%rbp)
	.loc 1 404 13 discriminator 2
	jmp	.L82
.L81:
	.loc 1 406 12
	leaq	.LC22(%rip), %rax
	cmpq	%rax, -88(%rbp)
	je	.L83
	.loc 1 407 18
	movl	-124(%rbp), %eax
	cltq
	salq	$3, %rax
	leaq	-8(%rax), %rdx
	movq	-96(%rbp), %rax
	addq	%rax, %rdx
	.loc 1 407 34
	movq	-88(%rbp), %rax
	movq	%rax, (%rdx)
.L83:
	.loc 1 409 23
	movl	-12(%rbp), %eax
	cltq
	.loc 1 409 11
	addq	%rax, -104(%rbp)
.L82:
.LBE11:
	.loc 1 381 24
	addl	$1, -120(%rbp)
	.loc 1 381 28
	jmp	.L84
.L88:
.LBB12:
	.loc 1 383 13
	nop
.LBE12:
.LBE10:
	.loc 1 411 10
	movq	-144(%rbp), %rax
	movq	-96(%rbp), %rdx
	movq	%rdx, (%rax)
	.loc 1 412 12
	movl	-124(%rbp), %eax
.L85:
	.loc 1 413 1 discriminator 1
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L86
	.loc 1 413 1 is_stmt 0
	call	__stack_chk_fail@PLT
.L86:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	TokenizeString, .-TokenizeString
	.section	.rodata
.LC23:
	.string	":"
.LC24:
	.string	"%s/%s"
	.text
	.globl	GetEnvPath
	.type	GetEnvPath, @function
GetEnvPath:
.LFB15:
	.loc 1 416 1 is_stmt 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$88, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rdi, -120(%rbp)
	.loc 1 416 1
	movq	%fs:40, %rax
	movq	%rax, -56(%rbp)
	xorl	%eax, %eax
	.loc 1 417 8
	movq	-120(%rbp), %rax
	movq	(%rax), %rax
	movl	$47, %esi
	movq	%rax, %rdi
	call	strchr@PLT
	.loc 1 417 7
	testq	%rax, %rax
	je	.L90
	.loc 1 419 16
	movq	-120(%rbp), %rax
	jmp	.L91
.L90:
.LBB13:
	.loc 1 422 5
	movq	%rsp, %rax
	movq	%rax, %rbx
	.loc 1 423 15
	movq	-120(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -88(%rbp)
	.loc 1 424 13
	movl	$0, -104(%rbp)
	.loc 1 426 22
	movq	environment(%rip), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	.loc 1 426 14
	subq	$1, %rdx
	movq	%rdx, -80(%rbp)
	movq	%rax, %r14
	movl	$0, %r15d
	movq	%rax, %r12
	movl	$0, %r13d
	movl	$16, %edx
	subq	$1, %rdx
	addq	%rdx, %rax
	movl	$16, %ecx
	movl	$0, %edx
	divq	%rcx
	imulq	$16, %rax, %rax
	movq	%rax, %rcx
	andq	$-4096, %rcx
	movq	%rsp, %rdx
	subq	%rcx, %rdx
.L92:
	cmpq	%rdx, %rsp
	je	.L93
	subq	$4096, %rsp
	orq	$0, 4088(%rsp)
	jmp	.L92
.L93:
	movq	%rax, %rdx
	andl	$4095, %edx
	subq	%rdx, %rsp
	movq	%rax, %rdx
	andl	$4095, %edx
	testq	%rdx, %rdx
	je	.L94
	andl	$4095, %eax
	subq	$8, %rax
	addq	%rsp, %rax
	orq	$0, (%rax)
.L94:
	movq	%rsp, %rax
	addq	$0, %rax
	movq	%rax, -72(%rbp)
	.loc 1 427 9
	movq	environment(%rip), %rdx
	movq	-72(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy@PLT
	.loc 1 428 17
	movq	-72(%rbp), %rax
	leaq	.LC23(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strtok@PLT
	movq	%rax, -96(%rbp)
	.loc 1 429 14
	jmp	.L95
.L98:
.LBB14:
	.loc 1 431 33
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	.loc 1 431 47
	movl	%eax, %r12d
	.loc 1 431 49
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	.loc 1 431 47
	addl	%r12d, %eax
	.loc 1 431 65
	addl	$2, %eax
	.loc 1 431 17
	movl	%eax, -100(%rbp)
	.loc 1 432 43
	movl	-100(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -64(%rbp)
	.loc 1 433 13
	movl	-100(%rbp), %eax
	movslq	%eax, %rsi
	movq	-88(%rbp), %rcx
	movq	-96(%rbp), %rdx
	movq	-64(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	leaq	.LC24(%rip), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	.loc 1 434 17
	movq	-64(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	access@PLT
	.loc 1 434 16
	testl	%eax, %eax
	jne	.L96
	.loc 1 436 23
	movl	$1, -104(%rbp)
	.loc 1 437 28
	movq	-120(%rbp), %rax
	movq	-64(%rbp), %rdx
	movq	%rdx, (%rax)
	.loc 1 438 24
	movq	-120(%rbp), %rax
	jmp	.L97
.L96:
	.loc 1 440 21
	leaq	.LC23(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	strtok@PLT
	movq	%rax, -96(%rbp)
.L95:
.LBE14:
	.loc 1 429 20
	cmpq	$0, -96(%rbp)
	jne	.L98
	.loc 1 442 16
	movq	-120(%rbp), %rax
.L97:
	movq	%rbx, %rsp
.L91:
.LBE13:
	.loc 1 444 1 discriminator 1
	movq	-56(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L99
	.loc 1 444 1 is_stmt 0
	call	__stack_chk_fail@PLT
.L99:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	GetEnvPath, .-GetEnvPath
	.globl	RemoveEscapeSpace
	.type	RemoveEscapeSpace, @function
RemoveEscapeSpace:
.LFB16:
	.loc 1 447 1 is_stmt 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	.loc 1 449 12
	movl	$0, -8(%rbp)
	.loc 1 449 19
	movl	$0, -4(%rbp)
	.loc 1 449 5
	jmp	.L101
.L103:
	.loc 1 450 16
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	.loc 1 450 12
	cmpb	$92, %al
	jne	.L102
	.loc 1 450 34 discriminator 1
	movl	-8(%rbp), %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	.loc 1 450 28 discriminator 1
	cmpb	$32, %al
	jne	.L102
	.loc 1 451 14
	addl	$1, -8(%rbp)
.L102:
	.loc 1 453 21 discriminator 2
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 453 12 discriminator 2
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	.loc 1 453 21 discriminator 2
	movzbl	(%rax), %eax
	.loc 1 453 16 discriminator 2
	movb	%al, (%rdx)
	.loc 1 449 41 discriminator 2
	addl	$1, -8(%rbp)
	.loc 1 449 46 discriminator 2
	addl	$1, -4(%rbp)
.L101:
	.loc 1 449 27 discriminator 1
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	.loc 1 449 31 discriminator 1
	testb	%al, %al
	jne	.L103
	.loc 1 455 8
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 455 12
	movb	$0, (%rax)
	.loc 1 456 1
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	RemoveEscapeSpace, .-RemoveEscapeSpace
	.section	.rodata
	.align 8
.LC25:
	.string	"Could not find any such command: %s\n"
	.text
	.globl	ExecuteCommandInBackground
	.type	ExecuteCommandInBackground, @function
ExecuteCommandInBackground:
.LFB17:
	.loc 1 460 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	.loc 1 460 1
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 461 15
	call	fork@PLT
	movl	%eax, -20(%rbp)
	.loc 1 462 8
	cmpl	$-1, -20(%rbp)
	jne	.L105
	.loc 1 463 16
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L106
.L105:
	.loc 1 464 13
	cmpl	$0, -20(%rbp)
	jne	.L107
.LBB15:
	.loc 1 466 13
	movl	$1, -32(%rbp)
	.loc 1 467 13
	movl	$0, -28(%rbp)
	.loc 1 468 13
	movl	$2, -24(%rbp)
	.loc 1 469 21
	movl	-44(%rbp), %edi
	leaq	-24(%rbp), %rcx
	leaq	-28(%rbp), %rdx
	leaq	-32(%rbp), %rsi
	movq	-40(%rbp), %rax
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	RedirectionCheck
	movq	%rax, -40(%rbp)
	.loc 1 471 19
	movl	-32(%rbp), %eax
	.loc 1 471 12
	cmpl	$1, %eax
	je	.L108
	.loc 1 473 17
	movl	-32(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	dup2@PLT
	.loc 1 473 16
	cmpl	$-1, %eax
	jne	.L108
	.loc 1 475 24
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L106
.L108:
	.loc 1 478 18
	movl	-28(%rbp), %eax
	.loc 1 478 12
	testl	%eax, %eax
	je	.L110
	.loc 1 480 17
	movl	-28(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	dup2@PLT
	.loc 1 480 16
	cmpl	$-1, %eax
	jne	.L110
	.loc 1 482 24
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L106
.L110:
	.loc 1 485 19
	movl	-24(%rbp), %eax
	.loc 1 485 12
	cmpl	$2, %eax
	je	.L111
	.loc 1 487 17
	movl	-24(%rbp), %eax
	movl	$2, %esi
	movl	%eax, %edi
	call	dup2@PLT
	.loc 1 487 16
	cmpl	$-1, %eax
	jne	.L111
	.loc 1 489 24
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L106
.L111:
	.loc 1 493 12
	cmpq	$0, -40(%rbp)
	jne	.L112
	.loc 1 494 20
	movl	$-3, %eax
	jmp	.L106
.L112:
	.loc 1 496 15
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	.loc 1 497 14
	movq	-40(%rbp), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	execv@PLT
	.loc 1 497 12
	movl	%eax, ec(%rip)
	.loc 1 498 9
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC25(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	.loc 1 499 14
	call	__errno_location@PLT
	.loc 1 499 9
	movl	(%rax), %eax
	movl	%eax, %edi
	call	exit@PLT
.L107:
.LBE15:
	.loc 1 503 16
	movl	$0, %eax
.L106:
	.loc 1 505 1 discriminator 1
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L113
	.loc 1 505 1 is_stmt 0
	call	__stack_chk_fail@PLT
.L113:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	ExecuteCommandInBackground, .-ExecuteCommandInBackground
	.globl	ExecuteCommandInForeground
	.type	ExecuteCommandInForeground, @function
ExecuteCommandInForeground:
.LFB18:
	.loc 1 508 1 is_stmt 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$1104, %rsp
	movq	%rdi, -1080(%rbp)
	movq	%rsi, -1088(%rbp)
	movl	%edx, -1092(%rbp)
	.loc 1 508 1
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 509 15
	call	fork@PLT
	movl	%eax, -1060(%rbp)
	.loc 1 510 8
	cmpl	$-1, -1060(%rbp)
	jne	.L115
	.loc 1 511 16
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L116
.L115:
	.loc 1 512 13
	cmpl	$0, -1060(%rbp)
	jne	.L117
.LBB16:
	.loc 1 514 13
	movl	$1, -1072(%rbp)
	.loc 1 515 13
	movl	$0, -1068(%rbp)
	.loc 1 516 13
	movl	$2, -1064(%rbp)
	.loc 1 517 21
	movl	-1092(%rbp), %edi
	leaq	-1064(%rbp), %rcx
	leaq	-1068(%rbp), %rdx
	leaq	-1072(%rbp), %rsi
	movq	-1080(%rbp), %rax
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	RedirectionCheck
	movq	%rax, -1080(%rbp)
	.loc 1 519 19
	movl	-1072(%rbp), %eax
	.loc 1 519 12
	cmpl	$1, %eax
	je	.L118
	.loc 1 521 17
	movl	-1072(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	dup2@PLT
	.loc 1 521 16
	cmpl	$-1, %eax
	jne	.L118
	.loc 1 523 24
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L116
.L118:
	.loc 1 526 18
	movl	-1068(%rbp), %eax
	.loc 1 526 12
	testl	%eax, %eax
	je	.L120
	.loc 1 528 17
	movl	-1072(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	dup2@PLT
	.loc 1 528 16
	cmpl	$-1, %eax
	jne	.L120
	.loc 1 530 24
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L116
.L120:
	.loc 1 533 19
	movl	-1064(%rbp), %eax
	.loc 1 533 12
	cmpl	$2, %eax
	je	.L121
	.loc 1 535 17
	movl	-1072(%rbp), %eax
	movl	$2, %esi
	movl	%eax, %edi
	call	dup2@PLT
	.loc 1 535 16
	cmpl	$-1, %eax
	jne	.L121
	.loc 1 537 24
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L116
.L121:
	.loc 1 541 12
	cmpq	$0, -1080(%rbp)
	jne	.L122
	.loc 1 542 20
	movl	$-3, %eax
	jmp	.L116
.L122:
	.loc 1 543 15
	movq	-1080(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -1048(%rbp)
	.loc 1 544 14
	movq	-1080(%rbp), %rdx
	movq	-1048(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	execv@PLT
	.loc 1 544 12
	movl	%eax, ec(%rip)
	.loc 1 545 9
	movq	-1048(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC25(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	.loc 1 546 14
	call	__errno_location@PLT
	.loc 1 546 9
	movl	(%rax), %eax
	movl	%eax, %edi
	call	exit@PLT
.L117:
.LBE16:
.LBB17:
	.loc 1 553 17
	leaq	-1064(%rbp), %rcx
	movl	-1060(%rbp), %eax
	movl	$2, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	waitpid@PLT
	movl	%eax, -1056(%rbp)
	.loc 1 554 12
	cmpl	$-1, -1056(%rbp)
	jne	.L123
	.loc 1 555 20
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L116
.L123:
	.loc 1 559 17
	movl	-1064(%rbp), %eax
	andl	$127, %eax
	.loc 1 559 16
	testl	%eax, %eax
	jne	.L125
	.loc 1 561 26
	movl	-1064(%rbp), %eax
	sarl	$8, %eax
	movzbl	%al, %eax
	.loc 1 561 24
	movl	%eax, retVal(%rip)
	.loc 1 562 28
	movl	retVal(%rip), %eax
	.loc 1 562 20
	testl	%eax, %eax
	jne	.L126
	.loc 1 563 28
	movl	$0, %eax
	jmp	.L116
.L126:
	.loc 1 564 17
	movl	retVal(%rip), %edx
	movl	-1060(%rbp), %ecx
	leaq	-1040(%rbp), %rax
	subq	$8, %rsp
	pushq	%rdx
	leaq	.LC4(%rip), %r9
	movl	%ecx, %r8d
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC6(%rip), %rdx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	addq	$16, %rsp
	.loc 1 565 17
	leaq	-1040(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	leaq	-1040(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	write@PLT
	.loc 1 566 24
	movl	$0, %eax
	jmp	.L116
.L125:
	.loc 1 568 22
	movl	-1064(%rbp), %eax
	andl	$127, %eax
	addl	$1, %eax
	sarb	%al
	.loc 1 568 21
	testb	%al, %al
	jle	.L127
	.loc 1 570 24
	movl	$-6, retVal(%rip)
	.loc 1 571 30
	movl	-1064(%rbp), %eax
	.loc 1 571 28
	andl	$127, %eax
	movl	%eax, -1052(%rbp)
	.loc 1 572 17
	movl	-1060(%rbp), %ecx
	leaq	-1040(%rbp), %rax
	subq	$8, %rsp
	movl	-1052(%rbp), %edx
	pushq	%rdx
	leaq	.LC7(%rip), %r9
	movl	%ecx, %r8d
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC6(%rip), %rdx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	addq	$16, %rsp
	.loc 1 573 17
	leaq	-1040(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	leaq	-1040(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	write@PLT
	.loc 1 574 24
	movl	$0, %eax
	jmp	.L116
.L127:
	.loc 1 576 22
	movl	-1064(%rbp), %eax
	andl	$128, %eax
	.loc 1 576 21
	testl	%eax, %eax
	je	.L128
	.loc 1 578 24
	movl	$-7, retVal(%rip)
	.loc 1 579 17
	movl	-1060(%rbp), %edx
	leaq	-1040(%rbp), %rax
	leaq	.LC8(%rip), %r9
	movl	%edx, %r8d
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC9(%rip), %rdx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	.loc 1 580 24
	movl	$0, %eax
	jmp	.L116
.L128:
	.loc 1 583 16
	movl	$0, %eax
.L116:
.LBE17:
	.loc 1 585 1 discriminator 1
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L129
	.loc 1 585 1 is_stmt 0
	call	__stack_chk_fail@PLT
.L129:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	ExecuteCommandInForeground, .-ExecuteCommandInForeground
	.section	.rodata
.LC26:
	.string	"\n%s: %d %s - %d\n"
.LC27:
	.string	"\n%s: %d %s\n"
	.text
	.globl	PipeExecutables
	.type	PipeExecutables, @function
PipeExecutables:
.LFB19:
	.loc 1 596 1 is_stmt 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$1120, %rsp
	movq	%rdi, -1112(%rbp)
	.loc 1 596 1
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 597 12
	movq	-1112(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -1080(%rbp)
	.loc 1 598 12
	movq	-1112(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -1072(%rbp)
	.loc 1 599 11
	movq	-1072(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -1064(%rbp)
	.loc 1 600 11
	movq	-1080(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -1056(%rbp)
	.loc 1 602 10
	leaq	-1048(%rbp), %rax
	movq	%rax, %rdi
	call	pipe@PLT
	.loc 1 602 8
	movl	%eax, ec(%rip)
	.loc 1 603 12
	movl	ec(%rip), %eax
	.loc 1 603 8
	cmpl	$-1, %eax
	jne	.L131
	.loc 1 604 16
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L147
.L131:
	.loc 1 606 16
	call	fork@PLT
	movl	%eax, -1100(%rbp)
	.loc 1 607 8
	cmpl	$-1, -1100(%rbp)
	jne	.L133
	.loc 1 608 16
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L147
.L133:
	.loc 1 609 13
	cmpl	$0, -1100(%rbp)
	jne	.L134
	.loc 1 611 14
	movl	-1048(%rbp), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	dup2@PLT
	.loc 1 611 12
	movl	%eax, ec(%rip)
	.loc 1 612 16
	movl	ec(%rip), %eax
	.loc 1 612 12
	cmpl	$-1, %eax
	jne	.L135
	.loc 1 613 20
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L147
.L135:
	.loc 1 615 14
	movl	-1044(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	.loc 1 615 12
	movl	%eax, ec(%rip)
	.loc 1 616 16
	movl	ec(%rip), %eax
	.loc 1 616 12
	cmpl	$-1, %eax
	jne	.L136
	.loc 1 617 20
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L147
.L136:
	.loc 1 619 14
	movq	-1072(%rbp), %rdx
	movq	-1064(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	execv@PLT
	.loc 1 619 12
	movl	%eax, ec(%rip)
	.loc 1 621 14
	call	__errno_location@PLT
	.loc 1 621 9
	movl	(%rax), %eax
	movl	%eax, %edi
	call	exit@PLT
.L134:
.LBB18:
	.loc 1 626 20
	call	fork@PLT
	movl	%eax, -1096(%rbp)
	.loc 1 627 12
	cmpl	$-1, -1096(%rbp)
	jne	.L137
	.loc 1 628 20
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L147
.L137:
	.loc 1 629 17
	cmpl	$0, -1096(%rbp)
	jne	.L138
	.loc 1 631 18
	movl	-1044(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	dup2@PLT
	.loc 1 631 16
	movl	%eax, ec(%rip)
	.loc 1 632 20
	movl	ec(%rip), %eax
	.loc 1 632 16
	cmpl	$-1, %eax
	jne	.L139
	.loc 1 633 24
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L147
.L139:
	.loc 1 635 18
	movl	-1048(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	.loc 1 635 16
	movl	%eax, ec(%rip)
	.loc 1 636 20
	movl	ec(%rip), %eax
	.loc 1 636 16
	cmpl	$-1, %eax
	jne	.L140
	.loc 1 637 24
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L147
.L140:
	.loc 1 639 18
	movq	-1080(%rbp), %rdx
	movq	-1056(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	execv@PLT
	.loc 1 639 16
	movl	%eax, ec(%rip)
	.loc 1 640 18
	call	__errno_location@PLT
	.loc 1 640 13
	movl	(%rax), %eax
	movl	%eax, %edi
	call	exit@PLT
.L138:
.LBB19:
	.loc 1 644 13
	movl	-1048(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	.loc 1 645 13
	movl	-1044(%rbp), %eax
	movl	%eax, %edi
	call	close@PLT
	.loc 1 646 17
	movl	$0, -1092(%rbp)
	.loc 1 650 21
	leaq	-1104(%rbp), %rcx
	movl	-1096(%rbp), %eax
	movl	$2, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	waitpid@PLT
	movl	%eax, -1088(%rbp)
	.loc 1 651 16
	cmpl	$-1, -1088(%rbp)
	jne	.L141
	.loc 1 652 24
	call	__errno_location@PLT
	movl	(%rax), %eax
	jmp	.L147
.L141:
	.loc 1 656 21
	movl	-1104(%rbp), %eax
	andl	$127, %eax
	.loc 1 656 20
	testl	%eax, %eax
	jne	.L143
	.loc 1 658 30
	movl	-1104(%rbp), %eax
	sarl	$8, %eax
	.loc 1 658 28
	andl	$255, %eax
	movl	%eax, -1092(%rbp)
	.loc 1 659 24
	cmpl	$0, -1092(%rbp)
	jne	.L144
	.loc 1 660 32
	movl	$0, %eax
	jmp	.L147
.L144:
	.loc 1 661 21
	movl	-1096(%rbp), %ecx
	leaq	-1040(%rbp), %rax
	subq	$8, %rsp
	movl	-1092(%rbp), %edx
	pushq	%rdx
	leaq	.LC4(%rip), %r9
	movl	%ecx, %r8d
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC26(%rip), %rdx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	addq	$16, %rsp
	.loc 1 662 21
	leaq	-1040(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	leaq	-1040(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	write@PLT
	.loc 1 663 28
	movl	$0, %eax
	jmp	.L147
.L143:
	.loc 1 665 26
	movl	-1104(%rbp), %eax
	andl	$127, %eax
	addl	$1, %eax
	sarb	%al
	.loc 1 665 25
	testb	%al, %al
	jle	.L145
	.loc 1 667 34
	movl	-1104(%rbp), %eax
	.loc 1 667 32
	andl	$127, %eax
	movl	%eax, -1084(%rbp)
	.loc 1 668 21
	movl	-1096(%rbp), %ecx
	leaq	-1040(%rbp), %rax
	subq	$8, %rsp
	movl	-1084(%rbp), %edx
	pushq	%rdx
	leaq	.LC7(%rip), %r9
	movl	%ecx, %r8d
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC26(%rip), %rdx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	addq	$16, %rsp
	.loc 1 669 21
	leaq	-1040(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movq	%rax, %rdx
	leaq	-1040(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	write@PLT
	.loc 1 670 28
	movl	$0, %eax
	jmp	.L147
.L145:
	.loc 1 672 26
	movl	-1104(%rbp), %eax
	andl	$128, %eax
	.loc 1 672 25
	testl	%eax, %eax
	je	.L146
	.loc 1 674 21
	movl	-1096(%rbp), %edx
	leaq	-1040(%rbp), %rax
	leaq	.LC8(%rip), %r9
	movl	%edx, %r8d
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rcx
	leaq	.LC27(%rip), %rdx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	.loc 1 675 28
	movl	$0, %eax
	jmp	.L147
.L146:
	.loc 1 678 20
	movl	$0, %eax
.L147:
.LBE19:
.LBE18:
	.loc 1 681 1 discriminator 2
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L148
	.loc 1 681 1 is_stmt 0
	call	__stack_chk_fail@PLT
.L148:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	PipeExecutables, .-PipeExecutables
	.section	.rodata
.LC28:
	.string	">"
	.align 8
.LC29:
	.string	"Syntax error: please mention path to redirect to"
.LC30:
	.string	">>"
.LC31:
	.string	"<"
.LC32:
	.string	"<<"
.LC33:
	.string	"2>"
.LC34:
	.string	"2>>"
	.text
	.globl	RedirectionCheck
	.type	RedirectionCheck, @function
RedirectionCheck:
.LFB20:
	.loc 1 684 1 is_stmt 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movq	%rcx, -48(%rbp)
	movl	%r8d, -52(%rbp)
	.loc 1 685 39
	movl	-52(%rbp), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	.loc 1 686 9
	movl	$0, -16(%rbp)
.LBB20:
	.loc 1 688 14
	movl	$0, -12(%rbp)
	.loc 1 688 5
	jmp	.L150
.L164:
	.loc 1 690 29
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 690 13
	movq	(%rax), %rax
	leaq	.LC28(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 690 12
	testl	%eax, %eax
	jne	.L151
	.loc 1 692 19
	movl	-12(%rbp), %eax
	addl	$1, %eax
	.loc 1 692 16
	cmpl	%eax, -52(%rbp)
	jle	.L152
	.loc 1 694 40
	movl	-12(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 694 26
	movq	(%rax), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	.loc 1 694 24
	movq	-32(%rbp), %rdx
	movl	%eax, (%rdx)
	.loc 1 695 19
	addl	$2, -12(%rbp)
	jmp	.L150
.L152:
	.loc 1 699 17
	leaq	.LC29(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	.loc 1 700 24
	movl	$0, %eax
	jmp	.L153
.L151:
	.loc 1 703 34
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 703 18
	movq	(%rax), %rax
	leaq	.LC30(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 703 17
	testl	%eax, %eax
	jne	.L154
	.loc 1 705 19
	movl	-12(%rbp), %eax
	addl	$1, %eax
	.loc 1 705 16
	cmpl	%eax, -52(%rbp)
	jle	.L155
	.loc 1 707 40
	movl	-12(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 707 26
	movq	(%rax), %rax
	movl	$1025, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	.loc 1 707 24
	movq	-32(%rbp), %rdx
	movl	%eax, (%rdx)
	.loc 1 708 19
	addl	$2, -12(%rbp)
	jmp	.L150
.L155:
	.loc 1 712 17
	leaq	.LC29(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	.loc 1 713 24
	movl	$0, %eax
	jmp	.L153
.L154:
	.loc 1 716 34
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 716 18
	movq	(%rax), %rax
	leaq	.LC31(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 716 17
	testl	%eax, %eax
	jne	.L156
	.loc 1 718 19
	movl	-12(%rbp), %eax
	addl	$1, %eax
	.loc 1 718 16
	cmpl	%eax, -52(%rbp)
	jle	.L157
	.loc 1 720 39
	movl	-12(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 720 25
	movq	(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	.loc 1 720 23
	movq	-40(%rbp), %rdx
	movl	%eax, (%rdx)
	.loc 1 721 19
	addl	$2, -12(%rbp)
	jmp	.L150
.L157:
	.loc 1 725 17
	leaq	.LC29(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	.loc 1 726 24
	movl	$0, %eax
	jmp	.L153
.L156:
	.loc 1 729 34
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 729 18
	movq	(%rax), %rax
	leaq	.LC32(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 729 17
	testl	%eax, %eax
	jne	.L158
	.loc 1 731 19
	movl	-12(%rbp), %eax
	addl	$1, %eax
	.loc 1 731 16
	cmpl	%eax, -52(%rbp)
	jle	.L159
	.loc 1 733 39
	movl	-12(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 733 25
	movq	(%rax), %rax
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	.loc 1 733 23
	movq	-40(%rbp), %rdx
	movl	%eax, (%rdx)
	.loc 1 734 19
	addl	$2, -12(%rbp)
	jmp	.L150
.L159:
	.loc 1 738 17
	leaq	.LC29(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	.loc 1 739 24
	movl	$0, %eax
	jmp	.L153
.L158:
	.loc 1 742 34
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 742 18
	movq	(%rax), %rax
	leaq	.LC33(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 742 17
	testl	%eax, %eax
	jne	.L160
	.loc 1 744 19
	movl	-12(%rbp), %eax
	addl	$1, %eax
	.loc 1 744 16
	cmpl	%eax, -52(%rbp)
	jle	.L161
	.loc 1 746 40
	movl	-12(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 746 26
	movq	(%rax), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	.loc 1 746 24
	movq	-48(%rbp), %rdx
	movl	%eax, (%rdx)
	.loc 1 747 19
	addl	$2, -12(%rbp)
	jmp	.L150
.L161:
	.loc 1 751 17
	leaq	.LC29(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	.loc 1 752 24
	movl	$0, %eax
	jmp	.L153
.L160:
	.loc 1 755 34
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 755 18
	movq	(%rax), %rax
	leaq	.LC34(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 755 17
	testl	%eax, %eax
	jne	.L162
	.loc 1 757 19
	movl	-12(%rbp), %eax
	addl	$1, %eax
	.loc 1 757 16
	cmpl	%eax, -52(%rbp)
	jle	.L163
	.loc 1 759 40
	movl	-12(%rbp), %eax
	cltq
	addq	$1, %rax
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 759 26
	movq	(%rax), %rax
	movl	$1025, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	open@PLT
	.loc 1 759 24
	movq	-48(%rbp), %rdx
	movl	%eax, (%rdx)
	.loc 1 760 19
	addl	$2, -12(%rbp)
	jmp	.L150
.L163:
	.loc 1 764 17
	leaq	.LC29(%rip), %rax
	movq	%rax, %rdi
	call	perror@PLT
	.loc 1 765 24
	movl	$0, %eax
	jmp	.L153
.L162:
	.loc 1 770 42
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 770 27
	movl	-16(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-8(%rbp), %rdx
	addq	%rcx, %rdx
	.loc 1 770 42
	movq	(%rax), %rax
	.loc 1 770 31
	movq	%rax, (%rdx)
	.loc 1 771 14
	addl	$1, -12(%rbp)
	.loc 1 772 14
	addl	$1, -16(%rbp)
.L150:
	.loc 1 688 43 discriminator 1
	movl	-52(%rbp), %eax
	subl	$1, %eax
	.loc 1 688 23 discriminator 1
	cmpl	%eax, -12(%rbp)
	jl	.L164
.LBE20:
	.loc 1 775 19
	movl	-16(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	.loc 1 775 23
	movq	$0, (%rax)
	.loc 1 776 12
	movq	-8(%rbp), %rax
.L153:
	.loc 1 777 1
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	RedirectionCheck, .-RedirectionCheck
	.section	.rodata
.LC35:
	.string	"?"
.LC36:
	.string	"%d\n"
.LC37:
	.string	"\n%s\n"
	.text
	.globl	GetEnvironmentVariable
	.type	GetEnvironmentVariable, @function
GetEnvironmentVariable:
.LFB21:
	.loc 1 780 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	.loc 1 781 9
	movq	-24(%rbp), %rax
	leaq	.LC35(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 781 8
	testl	%eax, %eax
	jne	.L166
	.loc 1 782 9
	movl	retVal(%rip), %eax
	movl	%eax, %esi
	leaq	.LC36(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L167
.L166:
	.loc 1 783 14
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	CheckKey
	.loc 1 783 13
	testl	%eax, %eax
	je	.L167
.LBB21:
	.loc 1 785 23
	movq	environmentVariables(%rip), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	search
	movq	%rax, -8(%rbp)
	.loc 1 786 12
	cmpq	$0, -8(%rbp)
	je	.L167
	.loc 1 788 13
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC37(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
.L167:
.LBE21:
	.loc 1 791 1
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	GetEnvironmentVariable, .-GetEnvironmentVariable
	.section	.rodata
.LC38:
	.string	"[^=]+|\"*[^\"]\"* "
	.text
	.globl	SetEnvironmentVariable
	.type	SetEnvironmentVariable, @function
SetEnvironmentVariable:
.LFB22:
	.loc 1 793 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	.loc 1 793 1
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	.loc 1 794 11
	leaq	.LC38(%rip), %rax
	movq	%rax, -32(%rbp)
	.loc 1 796 26
	movq	-32(%rbp), %rdx
	leaq	-40(%rbp), %rsi
	movq	-56(%rbp), %rax
	movl	$0, %ecx
	movq	%rax, %rdi
	call	TokenizeString
	movl	%eax, -44(%rbp)
	.loc 1 797 8
	cmpl	$2, -44(%rbp)
	je	.L169
	.loc 1 798 16
	movl	$-5, %eax
	jmp	.L173
.L169:
.LBB22:
	.loc 1 801 27
	movq	-40(%rbp), %rax
	.loc 1 801 15
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	.loc 1 802 15
	movq	-40(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -16(%rbp)
	.loc 1 803 13
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	.loc 1 803 12
	cmpq	$240, %rax
	ja	.L171
	.loc 1 803 37 discriminator 1
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	CheckKey
	.loc 1 803 33 discriminator 1
	testl	%eax, %eax
	jne	.L172
.L171:
	.loc 1 804 20
	movl	$-5, %eax
	jmp	.L173
.L172:
	.loc 1 805 9
	movq	environmentVariables(%rip), %rax
	movq	-16(%rbp), %rdx
	movq	-24(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	insert
	.loc 1 806 16
	movl	$0, %eax
.L173:
.LBE22:
	.loc 1 808 1 discriminator 1
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L174
	.loc 1 808 1 is_stmt 0
	call	__stack_chk_fail@PLT
.L174:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE22:
	.size	SetEnvironmentVariable, .-SetEnvironmentVariable
	.globl	CheckKey
	.type	CheckKey, @function
CheckKey:
.LFB23:
	.loc 1 811 1 is_stmt 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -40(%rbp)
.LBB23:
	.loc 1 812 14
	movl	$0, -20(%rbp)
	.loc 1 812 5
	jmp	.L176
.L180:
	.loc 1 814 16
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	.loc 1 814 12
	cmpb	$64, %al
	jle	.L177
	.loc 1 814 42 discriminator 1
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	.loc 1 814 36 discriminator 1
	cmpb	$90, %al
	jle	.L178
.L177:
	.loc 1 815 20
	movl	$0, %eax
	jmp	.L179
.L178:
	.loc 1 812 39 discriminator 2
	addl	$1, -20(%rbp)
.L176:
	.loc 1 812 23 discriminator 1
	movl	-20(%rbp), %eax
	movslq	%eax, %rbx
	.loc 1 812 25 discriminator 1
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	.loc 1 812 23 discriminator 1
	cmpq	%rax, %rbx
	jb	.L180
.LBE23:
	.loc 1 817 12
	movl	$1, %eax
.L179:
	.loc 1 818 1
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE23:
	.size	CheckKey, .-CheckKey
	.globl	setNode
	.type	setNode, @function
setNode:
.LFB24:
	.loc 1 821 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	.loc 1 822 15
	movq	-8(%rbp), %rax
	movq	-16(%rbp), %rdx
	movq	%rdx, (%rax)
	.loc 1 823 17
	movq	-8(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, 8(%rax)
	.loc 1 824 16
	movq	-8(%rbp), %rax
	movq	$0, 16(%rax)
	.loc 1 825 5
	nop
	.loc 1 826 1
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE24:
	.size	setNode, .-setNode
	.globl	hashFunction
	.type	hashFunction, @function
hashFunction:
.LFB25:
	.loc 1 839 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	.loc 1 841 9
	movl	$0, -32(%rbp)
	.loc 1 841 18
	movl	$31, -28(%rbp)
.LBB24:
	.loc 1 842 14
	movl	$0, -24(%rbp)
	.loc 1 842 5
	jmp	.L184
.L185:
	.loc 1 847 25 discriminator 3
	movq	-40(%rbp), %rax
	movl	124(%rax), %ecx
	.loc 1 847 21 discriminator 3
	movl	-32(%rbp), %eax
	cltd
	idivl	%ecx
	movl	%edx, %esi
	.loc 1 848 28 discriminator 3
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	.loc 1 848 20 discriminator 3
	movsbl	%al, %eax
	.loc 1 848 33 discriminator 3
	imull	-28(%rbp), %eax
	.loc 1 848 47 discriminator 3
	movq	-40(%rbp), %rdx
	movl	124(%rdx), %ecx
	.loc 1 848 43 discriminator 3
	cltd
	idivl	%ecx
	movl	%edx, %eax
	.loc 1 848 16 discriminator 3
	leal	(%rsi,%rax), %edx
	.loc 1 849 19 discriminator 3
	movq	-40(%rbp), %rax
	movl	124(%rax), %ecx
	.loc 1 847 13 discriminator 3
	movl	%edx, %eax
	cltd
	idivl	%ecx
	movl	%edx, -32(%rbp)
	.loc 1 854 27 discriminator 3
	movl	-28(%rbp), %edx
	movslq	%edx, %rax
	imulq	$-2147418109, %rax, %rax
	shrq	$32, %rax
	addl	%edx, %eax
	sarl	$14, %eax
	movl	%edx, %ecx
	sarl	$31, %ecx
	subl	%ecx, %eax
	movl	%eax, %ecx
	sall	$15, %ecx
	subl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	.loc 1 855 19 discriminator 3
	movl	%eax, %edx
	sall	$5, %edx
	subl	%eax, %edx
	.loc 1 854 16 discriminator 3
	movslq	%edx, %rax
	imulq	$-2147418109, %rax, %rax
	shrq	$32, %rax
	addl	%edx, %eax
	sarl	$14, %eax
	movl	%edx, %ecx
	sarl	$31, %ecx
	subl	%ecx, %eax
	movl	%eax, -28(%rbp)
	movl	-28(%rbp), %ecx
	movl	%ecx, %eax
	sall	$15, %eax
	subl	%ecx, %eax
	subl	%eax, %edx
	movl	%edx, -28(%rbp)
	.loc 1 842 39 discriminator 3
	addl	$1, -24(%rbp)
.L184:
	.loc 1 842 23 discriminator 1
	movl	-24(%rbp), %eax
	movslq	%eax, %rbx
	.loc 1 842 25 discriminator 1
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	.loc 1 842 23 discriminator 1
	cmpq	%rax, %rbx
	jb	.L185
.LBE24:
	.loc 1 859 17
	movl	-32(%rbp), %eax
	movl	%eax, -20(%rbp)
	.loc 1 860 12
	movl	-20(%rbp), %eax
	.loc 1 861 1
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE25:
	.size	hashFunction, .-hashFunction
	.globl	insert
	.type	insert, @function
insert:
.LFB26:
	.loc 1 864 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	.loc 1 868 23
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	hashFunction
	movl	%eax, -12(%rbp)
	.loc 1 869 42
	movl	$24, %edi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	.loc 1 875 5
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	setNode
	.loc 1 878 22
	movq	-24(%rbp), %rax
	movl	-12(%rbp), %edx
	movslq	%edx, %rdx
	movq	(%rax,%rdx,8), %rax
	.loc 1 878 8
	testq	%rax, %rax
	jne	.L188
	.loc 1 879 36
	movq	-24(%rbp), %rax
	movl	-12(%rbp), %edx
	movslq	%edx, %rdx
	movq	-8(%rbp), %rcx
	movq	%rcx, (%rax,%rdx,8)
	.loc 1 892 5
	jmp	.L187
.L188:
	.loc 1 889 38
	movq	-24(%rbp), %rax
	movl	-12(%rbp), %edx
	movslq	%edx, %rdx
	movq	(%rax,%rdx,8), %rdx
	.loc 1 889 23
	movq	-8(%rbp), %rax
	movq	%rdx, 16(%rax)
	.loc 1 890 36
	movq	-24(%rbp), %rax
	movl	-12(%rbp), %edx
	movslq	%edx, %rdx
	movq	-8(%rbp), %rcx
	movq	%rcx, (%rax,%rdx,8)
	.loc 1 892 5
	nop
.L187:
	.loc 1 893 1
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE26:
	.size	insert, .-insert
	.globl	delete
	.type	delete, @function
delete:
.LFB27:
	.loc 1 896 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	.loc 1 900 23
	movq	-48(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	hashFunction
	movl	%eax, -20(%rbp)
	.loc 1 902 18
	movq	$0, -16(%rbp)
	.loc 1 907 18
	movq	-40(%rbp), %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rdx
	movq	(%rax,%rdx,8), %rax
	movq	%rax, -8(%rbp)
	.loc 1 909 11
	jmp	.L192
.L197:
	.loc 1 913 33
	movq	-8(%rbp), %rax
	movq	(%rax), %rdx
	.loc 1 913 13
	movq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 913 12
	testl	%eax, %eax
	jne	.L193
	.loc 1 917 42
	movq	-40(%rbp), %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rdx
	movq	(%rax,%rdx,8), %rax
	.loc 1 917 16
	cmpq	%rax, -8(%rbp)
	jne	.L194
	.loc 1 918 54
	movq	-8(%rbp), %rax
	movq	16(%rax), %rcx
	.loc 1 918 44
	movq	-40(%rbp), %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rdx
	movq	%rcx, (%rax,%rdx,8)
	jmp	.L195
.L194:
	.loc 1 923 42
	movq	-8(%rbp), %rax
	movq	16(%rax), %rdx
	.loc 1 923 32
	movq	-16(%rbp), %rax
	movq	%rdx, 16(%rax)
.L195:
	.loc 1 925 13
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	.loc 1 926 13
	jmp	.L196
.L193:
	.loc 1 928 18
	movq	-8(%rbp), %rax
	movq	%rax, -16(%rbp)
	.loc 1 929 18
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -8(%rbp)
.L192:
	.loc 1 909 21
	cmpq	$0, -8(%rbp)
	jne	.L197
.L196:
	.loc 1 931 5
	nop
	.loc 1 932 1
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE27:
	.size	delete, .-delete
	.section	.rodata
.LC39:
	.string	"Oops! No data found."
	.text
	.globl	search
	.type	search, @function
search:
.LFB28:
	.loc 1 935 1
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	.loc 1 939 23
	movq	-48(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	hashFunction
	movl	%eax, -20(%rbp)
	.loc 1 943 18
	movq	-40(%rbp), %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rdx
	movq	(%rax,%rdx,8), %rax
	movq	%rax, -16(%rbp)
	.loc 1 944 11
	jmp	.L200
.L203:
	.loc 1 947 30
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	.loc 1 947 13
	movq	-48(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	.loc 1 947 12
	testl	%eax, %eax
	jne	.L201
	.loc 1 948 30
	movq	-16(%rbp), %rax
	movq	8(%rax), %rax
	jmp	.L202
.L201:
	.loc 1 950 20
	movq	-16(%rbp), %rax
	movq	16(%rax), %rax
	movq	%rax, -16(%rbp)
.L200:
	.loc 1 944 23
	cmpq	$0, -16(%rbp)
	jne	.L203
	.loc 1 955 30
	movl	$25, %edi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	.loc 1 956 15
	leaq	.LC39(%rip), %rax
	movq	%rax, -8(%rbp)
	.loc 1 957 12
	movq	-8(%rbp), %rax
.L202:
	.loc 1 958 1
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE28:
	.size	search, .-search
.Letext0:
	.file 2 "/usr/lib/gcc/x86_64-linux-gnu/11/include/stddef.h"
	.file 3 "/usr/include/x86_64-linux-gnu/bits/types.h"
	.file 4 "/usr/include/x86_64-linux-gnu/bits/types/struct_FILE.h"
	.file 5 "/usr/include/x86_64-linux-gnu/bits/types/FILE.h"
	.file 6 "/usr/include/stdio.h"
	.file 7 "/usr/include/x86_64-linux-gnu/sys/types.h"
	.file 8 "/usr/include/regex.h"
	.file 9 "/usr/include/x86_64-linux-gnu/sys/utsname.h"
	.file 10 "/usr/include/fcntl.h"
	.file 11 "/usr/include/unistd.h"
	.file 12 "/usr/include/string.h"
	.file 13 "/usr/include/stdlib.h"
	.file 14 "/usr/include/x86_64-linux-gnu/sys/wait.h"
	.file 15 "/usr/include/errno.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x1619
	.value	0x5
	.byte	0x1
	.byte	0x8
	.long	.Ldebug_abbrev0
	.uleb128 0x23
	.long	.LASF210
	.byte	0x1d
	.long	.LASF0
	.long	.LASF1
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0xc
	.long	.LASF9
	.byte	0x2
	.byte	0xd1
	.byte	0x17
	.long	0x3a
	.uleb128 0xd
	.byte	0x8
	.byte	0x7
	.long	.LASF2
	.uleb128 0xd
	.byte	0x4
	.byte	0x7
	.long	.LASF3
	.uleb128 0x24
	.byte	0x8
	.uleb128 0xd
	.byte	0x1
	.byte	0x8
	.long	.LASF4
	.uleb128 0xd
	.byte	0x2
	.byte	0x7
	.long	.LASF5
	.uleb128 0xd
	.byte	0x1
	.byte	0x6
	.long	.LASF6
	.uleb128 0xd
	.byte	0x2
	.byte	0x5
	.long	.LASF7
	.uleb128 0x25
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0xd
	.byte	0x8
	.byte	0x5
	.long	.LASF8
	.uleb128 0xc
	.long	.LASF10
	.byte	0x3
	.byte	0x98
	.byte	0x19
	.long	0x6d
	.uleb128 0xc
	.long	.LASF11
	.byte	0x3
	.byte	0x99
	.byte	0x1b
	.long	0x6d
	.uleb128 0xc
	.long	.LASF12
	.byte	0x3
	.byte	0x9a
	.byte	0x19
	.long	0x66
	.uleb128 0xf
	.long	0x66
	.long	0xa8
	.uleb128 0x13
	.long	0x3a
	.byte	0x1
	.byte	0
	.uleb128 0xc
	.long	.LASF13
	.byte	0x3
	.byte	0xc2
	.byte	0x1b
	.long	0x6d
	.uleb128 0x4
	.long	0xc3
	.uleb128 0x14
	.long	0xb4
	.uleb128 0x17
	.long	0xb4
	.uleb128 0xd
	.byte	0x1
	.byte	0x6
	.long	.LASF14
	.uleb128 0x17
	.long	0xc3
	.uleb128 0x1a
	.long	.LASF54
	.byte	0xd8
	.byte	0x4
	.byte	0x31
	.long	0x255
	.uleb128 0x3
	.long	.LASF15
	.byte	0x4
	.byte	0x33
	.byte	0x7
	.long	0x66
	.byte	0
	.uleb128 0x3
	.long	.LASF16
	.byte	0x4
	.byte	0x36
	.byte	0x9
	.long	0xb4
	.byte	0x8
	.uleb128 0x3
	.long	.LASF17
	.byte	0x4
	.byte	0x37
	.byte	0x9
	.long	0xb4
	.byte	0x10
	.uleb128 0x3
	.long	.LASF18
	.byte	0x4
	.byte	0x38
	.byte	0x9
	.long	0xb4
	.byte	0x18
	.uleb128 0x3
	.long	.LASF19
	.byte	0x4
	.byte	0x39
	.byte	0x9
	.long	0xb4
	.byte	0x20
	.uleb128 0x3
	.long	.LASF20
	.byte	0x4
	.byte	0x3a
	.byte	0x9
	.long	0xb4
	.byte	0x28
	.uleb128 0x3
	.long	.LASF21
	.byte	0x4
	.byte	0x3b
	.byte	0x9
	.long	0xb4
	.byte	0x30
	.uleb128 0x3
	.long	.LASF22
	.byte	0x4
	.byte	0x3c
	.byte	0x9
	.long	0xb4
	.byte	0x38
	.uleb128 0x3
	.long	.LASF23
	.byte	0x4
	.byte	0x3d
	.byte	0x9
	.long	0xb4
	.byte	0x40
	.uleb128 0x3
	.long	.LASF24
	.byte	0x4
	.byte	0x40
	.byte	0x9
	.long	0xb4
	.byte	0x48
	.uleb128 0x3
	.long	.LASF25
	.byte	0x4
	.byte	0x41
	.byte	0x9
	.long	0xb4
	.byte	0x50
	.uleb128 0x3
	.long	.LASF26
	.byte	0x4
	.byte	0x42
	.byte	0x9
	.long	0xb4
	.byte	0x58
	.uleb128 0x3
	.long	.LASF27
	.byte	0x4
	.byte	0x44
	.byte	0x16
	.long	0x26e
	.byte	0x60
	.uleb128 0x3
	.long	.LASF28
	.byte	0x4
	.byte	0x46
	.byte	0x14
	.long	0x273
	.byte	0x68
	.uleb128 0x3
	.long	.LASF29
	.byte	0x4
	.byte	0x48
	.byte	0x7
	.long	0x66
	.byte	0x70
	.uleb128 0x3
	.long	.LASF30
	.byte	0x4
	.byte	0x49
	.byte	0x7
	.long	0x66
	.byte	0x74
	.uleb128 0x3
	.long	.LASF31
	.byte	0x4
	.byte	0x4a
	.byte	0xb
	.long	0x74
	.byte	0x78
	.uleb128 0x3
	.long	.LASF32
	.byte	0x4
	.byte	0x4d
	.byte	0x12
	.long	0x51
	.byte	0x80
	.uleb128 0x3
	.long	.LASF33
	.byte	0x4
	.byte	0x4e
	.byte	0xf
	.long	0x58
	.byte	0x82
	.uleb128 0x3
	.long	.LASF34
	.byte	0x4
	.byte	0x4f
	.byte	0x8
	.long	0x278
	.byte	0x83
	.uleb128 0x3
	.long	.LASF35
	.byte	0x4
	.byte	0x51
	.byte	0xf
	.long	0x288
	.byte	0x88
	.uleb128 0x3
	.long	.LASF36
	.byte	0x4
	.byte	0x59
	.byte	0xd
	.long	0x80
	.byte	0x90
	.uleb128 0x3
	.long	.LASF37
	.byte	0x4
	.byte	0x5b
	.byte	0x17
	.long	0x292
	.byte	0x98
	.uleb128 0x3
	.long	.LASF38
	.byte	0x4
	.byte	0x5c
	.byte	0x19
	.long	0x29c
	.byte	0xa0
	.uleb128 0x3
	.long	.LASF39
	.byte	0x4
	.byte	0x5d
	.byte	0x14
	.long	0x273
	.byte	0xa8
	.uleb128 0x3
	.long	.LASF40
	.byte	0x4
	.byte	0x5e
	.byte	0x9
	.long	0x48
	.byte	0xb0
	.uleb128 0x3
	.long	.LASF41
	.byte	0x4
	.byte	0x5f
	.byte	0xa
	.long	0x2e
	.byte	0xb8
	.uleb128 0x3
	.long	.LASF42
	.byte	0x4
	.byte	0x60
	.byte	0x7
	.long	0x66
	.byte	0xc0
	.uleb128 0x3
	.long	.LASF43
	.byte	0x4
	.byte	0x62
	.byte	0x8
	.long	0x2a1
	.byte	0xc4
	.byte	0
	.uleb128 0xc
	.long	.LASF44
	.byte	0x5
	.byte	0x7
	.byte	0x19
	.long	0xcf
	.uleb128 0x26
	.long	.LASF211
	.byte	0x4
	.byte	0x2b
	.byte	0xe
	.uleb128 0x18
	.long	.LASF45
	.uleb128 0x4
	.long	0x269
	.uleb128 0x4
	.long	0xcf
	.uleb128 0xf
	.long	0xc3
	.long	0x288
	.uleb128 0x13
	.long	0x3a
	.byte	0
	.byte	0
	.uleb128 0x4
	.long	0x261
	.uleb128 0x18
	.long	.LASF46
	.uleb128 0x4
	.long	0x28d
	.uleb128 0x18
	.long	.LASF47
	.uleb128 0x4
	.long	0x297
	.uleb128 0xf
	.long	0xc3
	.long	0x2b1
	.uleb128 0x13
	.long	0x3a
	.byte	0x13
	.byte	0
	.uleb128 0xc
	.long	.LASF48
	.byte	0x6
	.byte	0x4d
	.byte	0x13
	.long	0xa8
	.uleb128 0x27
	.long	.LASF83
	.byte	0x6
	.byte	0x8f
	.byte	0xe
	.long	0x2c9
	.uleb128 0x4
	.long	0x255
	.uleb128 0x14
	.long	0x2c9
	.uleb128 0xd
	.byte	0x8
	.byte	0x5
	.long	.LASF49
	.uleb128 0xc
	.long	.LASF50
	.byte	0x7
	.byte	0x61
	.byte	0x11
	.long	0x8c
	.uleb128 0xd
	.byte	0x8
	.byte	0x7
	.long	.LASF51
	.uleb128 0x4
	.long	0x2f2
	.uleb128 0x28
	.uleb128 0x4
	.long	0xca
	.uleb128 0x14
	.long	0x2f3
	.uleb128 0x17
	.long	0x2f3
	.uleb128 0xc
	.long	.LASF52
	.byte	0x8
	.byte	0x38
	.byte	0x1b
	.long	0x3a
	.uleb128 0xc
	.long	.LASF53
	.byte	0x8
	.byte	0x48
	.byte	0x1b
	.long	0x3a
	.uleb128 0x29
	.long	.LASF55
	.byte	0x40
	.byte	0x8
	.value	0x19d
	.byte	0x8
	.long	0x3e6
	.uleb128 0xe
	.long	.LASF56
	.value	0x1a1
	.byte	0x14
	.long	0x3eb
	.byte	0
	.uleb128 0xe
	.long	.LASF57
	.value	0x1a4
	.byte	0x14
	.long	0x302
	.byte	0x8
	.uleb128 0xe
	.long	.LASF58
	.value	0x1a7
	.byte	0x14
	.long	0x302
	.byte	0x10
	.uleb128 0xe
	.long	.LASF59
	.value	0x1aa
	.byte	0x10
	.long	0x30e
	.byte	0x18
	.uleb128 0xe
	.long	.LASF60
	.value	0x1af
	.byte	0x9
	.long	0xb4
	.byte	0x20
	.uleb128 0xe
	.long	.LASF61
	.value	0x1b5
	.byte	0x17
	.long	0x3f0
	.byte	0x28
	.uleb128 0xe
	.long	.LASF62
	.value	0x1b8
	.byte	0xa
	.long	0x2e
	.byte	0x30
	.uleb128 0x11
	.long	.LASF63
	.value	0x1be
	.long	0x41
	.byte	0x1
	.value	0x1c0
	.uleb128 0x11
	.long	.LASF64
	.value	0x1c9
	.long	0x41
	.byte	0x2
	.value	0x1c1
	.uleb128 0x11
	.long	.LASF65
	.value	0x1cd
	.long	0x41
	.byte	0x1
	.value	0x1c3
	.uleb128 0x11
	.long	.LASF66
	.value	0x1d1
	.long	0x41
	.byte	0x1
	.value	0x1c4
	.uleb128 0x11
	.long	.LASF67
	.value	0x1d5
	.long	0x41
	.byte	0x1
	.value	0x1c5
	.uleb128 0x11
	.long	.LASF68
	.value	0x1d8
	.long	0x41
	.byte	0x1
	.value	0x1c6
	.uleb128 0x11
	.long	.LASF69
	.value	0x1db
	.long	0x41
	.byte	0x1
	.value	0x1c7
	.byte	0
	.uleb128 0x18
	.long	.LASF70
	.uleb128 0x4
	.long	0x3e6
	.uleb128 0x4
	.long	0x4a
	.uleb128 0x1b
	.long	.LASF71
	.value	0x1de
	.byte	0x22
	.long	0x31a
	.uleb128 0x17
	.long	0x3f5
	.uleb128 0x1b
	.long	.LASF72
	.value	0x1ea
	.byte	0xd
	.long	0x66
	.uleb128 0x2a
	.byte	0x8
	.byte	0x8
	.value	0x205
	.byte	0x9
	.long	0x437
	.uleb128 0xe
	.long	.LASF73
	.value	0x207
	.byte	0xc
	.long	0x406
	.byte	0
	.uleb128 0xe
	.long	.LASF74
	.value	0x208
	.byte	0xc
	.long	0x406
	.byte	0x4
	.byte	0
	.uleb128 0x1b
	.long	.LASF75
	.value	0x209
	.byte	0x3
	.long	0x412
	.uleb128 0x4
	.long	0xb4
	.uleb128 0x2b
	.long	.LASF76
	.value	0x186
	.byte	0x9
	.byte	0x30
	.byte	0x8
	.long	0x4a3
	.uleb128 0x3
	.long	.LASF77
	.byte	0x9
	.byte	0x33
	.byte	0xa
	.long	0x4a3
	.byte	0
	.uleb128 0x3
	.long	.LASF78
	.byte	0x9
	.byte	0x36
	.byte	0xa
	.long	0x4a3
	.byte	0x41
	.uleb128 0x3
	.long	.LASF79
	.byte	0x9
	.byte	0x39
	.byte	0xa
	.long	0x4a3
	.byte	0x82
	.uleb128 0x3
	.long	.LASF80
	.byte	0x9
	.byte	0x3b
	.byte	0xa
	.long	0x4a3
	.byte	0xc3
	.uleb128 0x1d
	.long	.LASF81
	.byte	0x3e
	.long	0x4a3
	.value	0x104
	.uleb128 0x1d
	.long	.LASF82
	.byte	0x45
	.long	0x4a3
	.value	0x145
	.byte	0
	.uleb128 0xf
	.long	0xc3
	.long	0x4b3
	.uleb128 0x13
	.long	0x3a
	.byte	0x40
	.byte	0
	.uleb128 0x16
	.long	.LASF84
	.byte	0x2d
	.byte	0x5
	.long	0x66
	.uleb128 0x9
	.byte	0x3
	.quad	fBackground
	.uleb128 0x2c
	.string	"ec"
	.byte	0x1
	.byte	0x2e
	.byte	0x5
	.long	0x66
	.uleb128 0x9
	.byte	0x3
	.quad	ec
	.uleb128 0x1a
	.long	.LASF85
	.byte	0x80
	.byte	0x1
	.byte	0x31
	.long	0x511
	.uleb128 0x3
	.long	.LASF85
	.byte	0x1
	.byte	0x32
	.byte	0x12
	.long	0x511
	.byte	0
	.uleb128 0x3
	.long	.LASF86
	.byte	0x1
	.byte	0x33
	.byte	0x9
	.long	0x66
	.byte	0x78
	.uleb128 0x3
	.long	.LASF87
	.byte	0x1
	.byte	0x33
	.byte	0x1b
	.long	0x66
	.byte	0x7c
	.byte	0
	.uleb128 0xf
	.long	0x521
	.long	0x521
	.uleb128 0x13
	.long	0x3a
	.byte	0xe
	.byte	0
	.uleb128 0x4
	.long	0x526
	.uleb128 0x1a
	.long	.LASF88
	.byte	0x18
	.byte	0x1
	.byte	0x36
	.long	0x55a
	.uleb128 0x2d
	.string	"key"
	.byte	0x1
	.byte	0x37
	.byte	0xb
	.long	0xb4
	.byte	0
	.uleb128 0x3
	.long	.LASF89
	.byte	0x1
	.byte	0x38
	.byte	0xb
	.long	0xb4
	.byte	0x8
	.uleb128 0x3
	.long	.LASF90
	.byte	0x1
	.byte	0x39
	.byte	0x12
	.long	0x521
	.byte	0x10
	.byte	0
	.uleb128 0x16
	.long	.LASF91
	.byte	0x48
	.byte	0x8
	.long	0xb4
	.uleb128 0x9
	.byte	0x3
	.quad	environment
	.uleb128 0x16
	.long	.LASF92
	.byte	0x4b
	.byte	0x7
	.long	0xb4
	.uleb128 0x9
	.byte	0x3
	.quad	hostName
	.uleb128 0x16
	.long	.LASF93
	.byte	0x56
	.byte	0x13
	.long	0x599
	.uleb128 0x9
	.byte	0x3
	.quad	environmentVariables
	.uleb128 0x4
	.long	0x4dd
	.uleb128 0x16
	.long	.LASF94
	.byte	0x58
	.byte	0x5
	.long	0x66
	.uleb128 0x9
	.byte	0x3
	.quad	retVal
	.uleb128 0x12
	.long	.LASF95
	.byte	0xa
	.byte	0xb5
	.byte	0xc
	.long	0x66
	.long	0x5cf
	.uleb128 0x2
	.long	0x2f3
	.uleb128 0x2
	.long	0x66
	.uleb128 0x1c
	.byte	0
	.uleb128 0x7
	.long	.LASF96
	.byte	0xb
	.value	0x11f
	.byte	0xc
	.long	0x66
	.long	0x5eb
	.uleb128 0x2
	.long	0x2f3
	.uleb128 0x2
	.long	0x66
	.byte	0
	.uleb128 0x7
	.long	.LASF97
	.byte	0xc
	.value	0x164
	.byte	0xe
	.long	0xb4
	.long	0x607
	.uleb128 0x2
	.long	0xb9
	.uleb128 0x2
	.long	0x2f8
	.byte	0
	.uleb128 0x12
	.long	.LASF98
	.byte	0xc
	.byte	0x8d
	.byte	0xe
	.long	0xb4
	.long	0x622
	.uleb128 0x2
	.long	0xb4
	.uleb128 0x2
	.long	0x2f3
	.byte	0
	.uleb128 0x12
	.long	.LASF99
	.byte	0xc
	.byte	0xf6
	.byte	0xe
	.long	0xb4
	.long	0x63d
	.uleb128 0x2
	.long	0x2f3
	.uleb128 0x2
	.long	0x66
	.byte	0
	.uleb128 0x7
	.long	.LASF100
	.byte	0x8
	.value	0x2a7
	.byte	0xc
	.long	0x66
	.long	0x668
	.uleb128 0x2
	.long	0x66d
	.uleb128 0x2
	.long	0x2f8
	.uleb128 0x2
	.long	0x2e
	.uleb128 0x2
	.long	0x677
	.uleb128 0x2
	.long	0x66
	.byte	0
	.uleb128 0x4
	.long	0x401
	.uleb128 0x14
	.long	0x668
	.uleb128 0x4
	.long	0x437
	.uleb128 0x14
	.long	0x672
	.uleb128 0x7
	.long	.LASF101
	.byte	0x8
	.value	0x2a3
	.byte	0xc
	.long	0x66
	.long	0x69d
	.uleb128 0x2
	.long	0x6a2
	.uleb128 0x2
	.long	0x2f8
	.uleb128 0x2
	.long	0x66
	.byte	0
	.uleb128 0x4
	.long	0x3f5
	.uleb128 0x14
	.long	0x69d
	.uleb128 0x7
	.long	.LASF102
	.byte	0xb
	.value	0x205
	.byte	0xc
	.long	0x66
	.long	0x6be
	.uleb128 0x2
	.long	0x2f3
	.byte	0
	.uleb128 0x7
	.long	.LASF103
	.byte	0xd
	.value	0x227
	.byte	0xe
	.long	0x48
	.long	0x6da
	.uleb128 0x2
	.long	0x48
	.uleb128 0x2
	.long	0x2e
	.byte	0
	.uleb128 0x12
	.long	.LASF104
	.byte	0xc
	.byte	0x9c
	.byte	0xc
	.long	0x66
	.long	0x6f5
	.uleb128 0x2
	.long	0x2f3
	.uleb128 0x2
	.long	0x2f3
	.byte	0
	.uleb128 0x12
	.long	.LASF105
	.byte	0xe
	.byte	0x58
	.byte	0x10
	.long	0x8c
	.long	0x70b
	.uleb128 0x2
	.long	0x70b
	.byte	0
	.uleb128 0x4
	.long	0x66
	.uleb128 0x7
	.long	.LASF106
	.byte	0xb
	.value	0x17a
	.byte	0x10
	.long	0x2b1
	.long	0x731
	.uleb128 0x2
	.long	0x66
	.uleb128 0x2
	.long	0x2ed
	.uleb128 0x2
	.long	0x2e
	.byte	0
	.uleb128 0x7
	.long	.LASF107
	.byte	0x6
	.value	0x17a
	.byte	0xc
	.long	0x66
	.long	0x753
	.uleb128 0x2
	.long	0xb4
	.uleb128 0x2
	.long	0x2e
	.uleb128 0x2
	.long	0x2f3
	.uleb128 0x1c
	.byte	0
	.uleb128 0x12
	.long	.LASF108
	.byte	0xe
	.byte	0x6f
	.byte	0x10
	.long	0x8c
	.long	0x773
	.uleb128 0x2
	.long	0x8c
	.uleb128 0x2
	.long	0x70b
	.uleb128 0x2
	.long	0x66
	.byte	0
	.uleb128 0x7
	.long	.LASF109
	.byte	0xb
	.value	0x248
	.byte	0xc
	.long	0x66
	.long	0x78f
	.uleb128 0x2
	.long	0x2f3
	.uleb128 0x2
	.long	0x78f
	.byte	0
	.uleb128 0x4
	.long	0xbe
	.uleb128 0x7
	.long	.LASF110
	.byte	0xb
	.value	0x166
	.byte	0xc
	.long	0x66
	.long	0x7ab
	.uleb128 0x2
	.long	0x66
	.byte	0
	.uleb128 0x7
	.long	.LASF111
	.byte	0xb
	.value	0x22b
	.byte	0xc
	.long	0x66
	.long	0x7c7
	.uleb128 0x2
	.long	0x66
	.uleb128 0x2
	.long	0x66
	.byte	0
	.uleb128 0x2e
	.long	.LASF112
	.byte	0xd
	.value	0x270
	.byte	0xd
	.long	0x7da
	.uleb128 0x2
	.long	0x66
	.byte	0
	.uleb128 0x2f
	.long	.LASF113
	.byte	0xf
	.byte	0x25
	.byte	0xd
	.long	0x70b
	.uleb128 0x1e
	.long	.LASF116
	.byte	0x6
	.value	0x324
	.long	0x7f8
	.uleb128 0x2
	.long	0x2f3
	.byte	0
	.uleb128 0x1f
	.long	.LASF114
	.value	0x30a
	.byte	0x10
	.long	0x8c
	.uleb128 0x7
	.long	.LASF115
	.byte	0xb
	.value	0x1b5
	.byte	0xc
	.long	0x66
	.long	0x81b
	.uleb128 0x2
	.long	0x70b
	.byte	0
	.uleb128 0x1e
	.long	.LASF117
	.byte	0xd
	.value	0x22b
	.long	0x82d
	.uleb128 0x2
	.long	0x48
	.byte	0
	.uleb128 0x7
	.long	.LASF118
	.byte	0xd
	.value	0x21c
	.byte	0xe
	.long	0x48
	.long	0x844
	.uleb128 0x2
	.long	0x2e
	.byte	0
	.uleb128 0x7
	.long	.LASF119
	.byte	0xd
	.value	0x281
	.byte	0xe
	.long	0xb4
	.long	0x85b
	.uleb128 0x2
	.long	0x2f3
	.byte	0
	.uleb128 0x7
	.long	.LASF120
	.byte	0xc
	.value	0x197
	.byte	0xf
	.long	0x2e
	.long	0x872
	.uleb128 0x2
	.long	0x2f3
	.byte	0
	.uleb128 0x7
	.long	.LASF121
	.byte	0x6
	.value	0x250
	.byte	0xe
	.long	0xb4
	.long	0x893
	.uleb128 0x2
	.long	0xb9
	.uleb128 0x2
	.long	0x66
	.uleb128 0x2
	.long	0x2ce
	.byte	0
	.uleb128 0x7
	.long	.LASF122
	.byte	0x6
	.value	0x164
	.byte	0xc
	.long	0x66
	.long	0x8ab
	.uleb128 0x2
	.long	0x2f3
	.uleb128 0x1c
	.byte	0
	.uleb128 0x1f
	.long	.LASF123
	.value	0x371
	.byte	0xe
	.long	0xb4
	.uleb128 0x7
	.long	.LASF124
	.byte	0xb
	.value	0x213
	.byte	0xe
	.long	0xb4
	.long	0x8d3
	.uleb128 0x2
	.long	0xb4
	.uleb128 0x2
	.long	0x2e
	.byte	0
	.uleb128 0x12
	.long	.LASF125
	.byte	0x9
	.byte	0x51
	.byte	0xc
	.long	0x66
	.long	0x8e9
	.uleb128 0x2
	.long	0x8e9
	.byte	0
	.uleb128 0x4
	.long	0x448
	.uleb128 0xb
	.long	.LASF134
	.value	0x3a6
	.byte	0x7
	.long	0xb4
	.quad	.LFB28
	.quad	.LFE28-.LFB28
	.uleb128 0x1
	.byte	0x9c
	.long	0x95b
	.uleb128 0xa
	.string	"mp"
	.value	0x3a6
	.byte	0x20
	.long	0x599
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0xa
	.string	"key"
	.value	0x3a6
	.byte	0x2a
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x1
	.long	.LASF126
	.value	0x3ab
	.byte	0x9
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x1
	.long	.LASF127
	.value	0x3af
	.byte	0x12
	.long	0x521
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x1
	.long	.LASF128
	.value	0x3bb
	.byte	0xb
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x20
	.long	.LASF131
	.value	0x37f
	.quad	.LFB27
	.quad	.LFE27-.LFB27
	.uleb128 0x1
	.byte	0x9c
	.long	0x9c3
	.uleb128 0xa
	.string	"mp"
	.value	0x37f
	.byte	0x20
	.long	0x599
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0xa
	.string	"key"
	.value	0x37f
	.byte	0x2a
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x1
	.long	.LASF126
	.value	0x384
	.byte	0x9
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x1
	.long	.LASF129
	.value	0x386
	.byte	0x12
	.long	0x521
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x1
	.long	.LASF130
	.value	0x38b
	.byte	0x12
	.long	0x521
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x20
	.long	.LASF132
	.value	0x35f
	.quad	.LFB26
	.quad	.LFE26-.LFB26
	.uleb128 0x1
	.byte	0x9c
	.long	0xa2b
	.uleb128 0xa
	.string	"mp"
	.value	0x35f
	.byte	0x1f
	.long	0x599
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0xa
	.string	"key"
	.value	0x35f
	.byte	0x29
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x5
	.long	.LASF89
	.value	0x35f
	.byte	0x34
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x1
	.long	.LASF126
	.value	0x364
	.byte	0x9
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.uleb128 0x1
	.long	.LASF133
	.value	0x365
	.byte	0x12
	.long	0x521
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0xb
	.long	.LASF135
	.value	0x346
	.byte	0x5
	.long	0x66
	.quad	.LFB25
	.quad	.LFE25-.LFB25
	.uleb128 0x1
	.byte	0x9c
	.long	0xab7
	.uleb128 0xa
	.string	"mp"
	.value	0x346
	.byte	0x24
	.long	0x599
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0xa
	.string	"key"
	.value	0x346
	.byte	0x2e
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x1
	.long	.LASF126
	.value	0x348
	.byte	0x9
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x8
	.string	"sum"
	.value	0x349
	.byte	0x9
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x1
	.long	.LASF136
	.value	0x349
	.byte	0x12
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x6
	.quad	.LBB24
	.quad	.LBE24-.LBB24
	.uleb128 0x8
	.string	"i"
	.value	0x34a
	.byte	0xe
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.byte	0
	.byte	0
	.uleb128 0x21
	.long	.LASF137
	.value	0x334
	.quad	.LFB24
	.quad	.LFE24-.LFB24
	.uleb128 0x1
	.byte	0x9c
	.long	0xb02
	.uleb128 0x5
	.long	.LASF138
	.value	0x334
	.byte	0x1b
	.long	0x521
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0xa
	.string	"key"
	.value	0x334
	.byte	0x27
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x5
	.long	.LASF89
	.value	0x334
	.byte	0x32
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.byte	0
	.uleb128 0xb
	.long	.LASF139
	.value	0x32a
	.byte	0x5
	.long	0x66
	.quad	.LFB23
	.quad	.LFE23-.LFB23
	.uleb128 0x1
	.byte	0x9c
	.long	0xb53
	.uleb128 0xa
	.string	"key"
	.value	0x32a
	.byte	0x14
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x6
	.quad	.LBB23
	.quad	.LBE23-.LBB23
	.uleb128 0x8
	.string	"i"
	.value	0x32c
	.byte	0xe
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.byte	0
	.byte	0
	.uleb128 0xb
	.long	.LASF140
	.value	0x318
	.byte	0x5
	.long	0x66
	.quad	.LFB22
	.quad	.LFE22-.LFB22
	.uleb128 0x1
	.byte	0x9c
	.long	0xbe3
	.uleb128 0x5
	.long	.LASF141
	.value	0x318
	.byte	0x22
	.long	0xb4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -72
	.uleb128 0x1
	.long	.LASF142
	.value	0x31a
	.byte	0xb
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x1
	.long	.LASF143
	.value	0x31b
	.byte	0xc
	.long	0x443
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x1
	.long	.LASF144
	.value	0x31c
	.byte	0x9
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -60
	.uleb128 0x6
	.quad	.LBB22
	.quad	.LBE22-.LBB22
	.uleb128 0x8
	.string	"key"
	.value	0x321
	.byte	0xf
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x1
	.long	.LASF89
	.value	0x322
	.byte	0xf
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.byte	0
	.byte	0
	.uleb128 0xb
	.long	.LASF145
	.value	0x30b
	.byte	0x5
	.long	0x66
	.quad	.LFB21
	.quad	.LFE21-.LFB21
	.uleb128 0x1
	.byte	0x9c
	.long	0xc36
	.uleb128 0x5
	.long	.LASF146
	.value	0x30b
	.byte	0x22
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x6
	.quad	.LBB21
	.quad	.LBE21-.LBB21
	.uleb128 0x1
	.long	.LASF89
	.value	0x311
	.byte	0xf
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.uleb128 0xb
	.long	.LASF147
	.value	0x2ab
	.byte	0x8
	.long	0x443
	.quad	.LFB20
	.quad	.LFE20-.LFB20
	.uleb128 0x1
	.byte	0x9c
	.long	0xce0
	.uleb128 0x5
	.long	.LASF148
	.value	0x2ab
	.byte	0x20
	.long	0x443
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x5
	.long	.LASF149
	.value	0x2ab
	.byte	0x30
	.long	0x70b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x5
	.long	.LASF150
	.value	0x2ab
	.byte	0x3c
	.long	0x70b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x5
	.long	.LASF151
	.value	0x2ab
	.byte	0x47
	.long	0x70b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x5
	.long	.LASF152
	.value	0x2ab
	.byte	0x52
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -68
	.uleb128 0x1
	.long	.LASF153
	.value	0x2ad
	.byte	0xc
	.long	0x443
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x8
	.string	"j"
	.value	0x2ae
	.byte	0x9
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x6
	.quad	.LBB20
	.quad	.LBE20-.LBB20
	.uleb128 0x8
	.string	"i"
	.value	0x2b0
	.byte	0xe
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.byte	0
	.byte	0
	.uleb128 0xb
	.long	.LASF154
	.value	0x253
	.byte	0x1
	.long	0x66
	.quad	.LFB19
	.quad	.LFE19-.LFB19
	.uleb128 0x1
	.byte	0x9c
	.long	0xdf4
	.uleb128 0x5
	.long	.LASF155
	.value	0x253
	.byte	0x19
	.long	0xdf4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1128
	.uleb128 0x1
	.long	.LASF156
	.value	0x255
	.byte	0xc
	.long	0x443
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1096
	.uleb128 0x1
	.long	.LASF157
	.value	0x256
	.byte	0xc
	.long	0x443
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1088
	.uleb128 0x1
	.long	.LASF158
	.value	0x257
	.byte	0xb
	.long	0xb4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1080
	.uleb128 0x1
	.long	.LASF159
	.value	0x258
	.byte	0xb
	.long	0xb4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1072
	.uleb128 0x8
	.string	"fd"
	.value	0x259
	.byte	0x9
	.long	0x98
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1064
	.uleb128 0x1
	.long	.LASF160
	.value	0x25e
	.byte	0x9
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1116
	.uleb128 0x6
	.quad	.LBB18
	.quad	.LBE18-.LBB18
	.uleb128 0x1
	.long	.LASF161
	.value	0x272
	.byte	0xd
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1112
	.uleb128 0x6
	.quad	.LBB19
	.quad	.LBE19-.LBB19
	.uleb128 0x1
	.long	.LASF94
	.value	0x286
	.byte	0x11
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1108
	.uleb128 0x1
	.long	.LASF162
	.value	0x287
	.byte	0x12
	.long	0xdf9
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1056
	.uleb128 0x1
	.long	.LASF163
	.value	0x288
	.byte	0x11
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1100
	.uleb128 0x1
	.long	.LASF164
	.value	0x289
	.byte	0x11
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1120
	.uleb128 0x8
	.string	"w"
	.value	0x28a
	.byte	0x11
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1104
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x4
	.long	0x443
	.uleb128 0xf
	.long	0xc3
	.long	0xe0a
	.uleb128 0x30
	.long	0x3a
	.value	0x3ff
	.byte	0
	.uleb128 0xb
	.long	.LASF165
	.value	0x1fb
	.byte	0x1
	.long	0x66
	.quad	.LFB18
	.quad	.LFE18-.LFB18
	.uleb128 0x1
	.byte	0x9c
	.long	0xf13
	.uleb128 0x5
	.long	.LASF148
	.value	0x1fb
	.byte	0x23
	.long	0x443
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1096
	.uleb128 0x5
	.long	.LASF166
	.value	0x1fb
	.byte	0x33
	.long	0x70b
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1104
	.uleb128 0x5
	.long	.LASF152
	.value	0x1fb
	.byte	0x44
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1108
	.uleb128 0x8
	.string	"pid"
	.value	0x1fd
	.byte	0x9
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1076
	.uleb128 0x22
	.quad	.LBB16
	.quad	.LBE16-.LBB16
	.long	0xec2
	.uleb128 0x1
	.long	.LASF149
	.value	0x202
	.byte	0xd
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1088
	.uleb128 0x1
	.long	.LASF150
	.value	0x203
	.byte	0xd
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1084
	.uleb128 0x1
	.long	.LASF151
	.value	0x204
	.byte	0xd
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1080
	.uleb128 0x1
	.long	.LASF167
	.value	0x21f
	.byte	0xf
	.long	0xb4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1064
	.byte	0
	.uleb128 0x6
	.quad	.LBB17
	.quad	.LBE17-.LBB17
	.uleb128 0x1
	.long	.LASF162
	.value	0x226
	.byte	0xe
	.long	0xdf9
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1056
	.uleb128 0x1
	.long	.LASF163
	.value	0x227
	.byte	0xd
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1068
	.uleb128 0x1
	.long	.LASF164
	.value	0x228
	.byte	0xd
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1080
	.uleb128 0x8
	.string	"w"
	.value	0x229
	.byte	0xd
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1072
	.byte	0
	.byte	0
	.uleb128 0xb
	.long	.LASF168
	.value	0x1cb
	.byte	0x1
	.long	0x66
	.quad	.LFB17
	.quad	.LFE17-.LFB17
	.uleb128 0x1
	.byte	0x9c
	.long	0xfb1
	.uleb128 0x5
	.long	.LASF148
	.value	0x1cb
	.byte	0x23
	.long	0x443
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x5
	.long	.LASF152
	.value	0x1cb
	.byte	0x32
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -60
	.uleb128 0x8
	.string	"pid"
	.value	0x1cd
	.byte	0x9
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x6
	.quad	.LBB15
	.quad	.LBE15-.LBB15
	.uleb128 0x1
	.long	.LASF149
	.value	0x1d2
	.byte	0xd
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x1
	.long	.LASF150
	.value	0x1d3
	.byte	0xd
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.uleb128 0x1
	.long	.LASF151
	.value	0x1d4
	.byte	0xd
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x1
	.long	.LASF167
	.value	0x1f0
	.byte	0xf
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.byte	0
	.byte	0
	.uleb128 0x21
	.long	.LASF169
	.value	0x1be
	.quad	.LFB16
	.quad	.LFE16-.LFB16
	.uleb128 0x1
	.byte	0x9c
	.long	0xff8
	.uleb128 0xa
	.string	"str"
	.value	0x1be
	.byte	0x1e
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x8
	.string	"i"
	.value	0x1c0
	.byte	0x9
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x8
	.string	"j"
	.value	0x1c0
	.byte	0xc
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0xb
	.long	.LASF170
	.value	0x19f
	.byte	0x9
	.long	0x443
	.quad	.LFB15
	.quad	.LFE15-.LFB15
	.uleb128 0x1
	.byte	0x9c
	.long	0x10bd
	.uleb128 0x5
	.long	.LASF171
	.value	0x19f
	.byte	0x1b
	.long	0x443
	.uleb128 0x3
	.byte	0x91
	.sleb128 -136
	.uleb128 0x6
	.quad	.LBB13
	.quad	.LBE13-.LBB13
	.uleb128 0x1
	.long	.LASF172
	.value	0x1a7
	.byte	0xf
	.long	0xb4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -104
	.uleb128 0x1
	.long	.LASF173
	.value	0x1a8
	.byte	0xd
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -120
	.uleb128 0x1
	.long	.LASF174
	.value	0x1a9
	.byte	0xf
	.long	0xb4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -112
	.uleb128 0x31
	.long	.LASF212
	.byte	0x1
	.value	0x1a9
	.byte	0x17
	.long	0xb4
	.uleb128 0x1
	.long	.LASF175
	.value	0x1aa
	.byte	0xe
	.long	0x10bd
	.uleb128 0x4
	.byte	0x91
	.sleb128 -88
	.byte	0x6
	.uleb128 0x6
	.quad	.LBB14
	.quad	.LBE14-.LBB14
	.uleb128 0x1
	.long	.LASF176
	.value	0x1af
	.byte	0x11
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -116
	.uleb128 0x1
	.long	.LASF177
	.value	0x1b0
	.byte	0x13
	.long	0xb4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xf
	.long	0xc3
	.long	0x10d1
	.uleb128 0x32
	.long	0x3a
	.uleb128 0x4
	.byte	0x91
	.sleb128 -96
	.byte	0x6
	.byte	0
	.uleb128 0xb
	.long	.LASF178
	.value	0x16f
	.byte	0x1
	.long	0x66
	.quad	.LFB14
	.quad	.LFE14-.LFB14
	.uleb128 0x1
	.byte	0x9c
	.long	0x11e6
	.uleb128 0xa
	.string	"str"
	.value	0x16f
	.byte	0x22
	.long	0x2fd
	.uleb128 0x3
	.byte	0x91
	.sleb128 -152
	.uleb128 0xa
	.string	"arr"
	.value	0x16f
	.byte	0x2f
	.long	0xdf4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -160
	.uleb128 0xa
	.string	"re"
	.value	0x16f
	.byte	0x40
	.long	0x2f3
	.uleb128 0x3
	.byte	0x91
	.sleb128 -168
	.uleb128 0x5
	.long	.LASF179
	.value	0x16f
	.byte	0x48
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -172
	.uleb128 0x8
	.string	"s"
	.value	0x173
	.byte	0x11
	.long	0x2f3
	.uleb128 0x3
	.byte	0x91
	.sleb128 -120
	.uleb128 0x1
	.long	.LASF142
	.value	0x174
	.byte	0x11
	.long	0x3f5
	.uleb128 0x3
	.byte	0x91
	.sleb128 -96
	.uleb128 0x1
	.long	.LASF180
	.value	0x175
	.byte	0x11
	.long	0x11e6
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x8
	.string	"off"
	.value	0x176
	.byte	0x11
	.long	0x406
	.uleb128 0x3
	.byte	0x91
	.sleb128 -132
	.uleb128 0x8
	.string	"len"
	.value	0x176
	.byte	0x16
	.long	0x406
	.uleb128 0x3
	.byte	0x91
	.sleb128 -128
	.uleb128 0x1
	.long	.LASF181
	.value	0x177
	.byte	0x9
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -140
	.uleb128 0x1
	.long	.LASF182
	.value	0x17c
	.byte	0xc
	.long	0x443
	.uleb128 0x3
	.byte	0x91
	.sleb128 -112
	.uleb128 0x6
	.quad	.LBB10
	.quad	.LBE10-.LBB10
	.uleb128 0x8
	.string	"i"
	.value	0x17d
	.byte	0xe
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -136
	.uleb128 0x33
	.long	.LLRL0
	.uleb128 0x1
	.long	.LASF183
	.value	0x185
	.byte	0xd
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -124
	.uleb128 0x8
	.string	"buf"
	.value	0x187
	.byte	0xf
	.long	0xb4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -104
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xf
	.long	0x437
	.long	0x11f6
	.uleb128 0x13
	.long	0x3a
	.byte	0
	.byte	0
	.uleb128 0xb
	.long	.LASF184
	.value	0x160
	.byte	0x1
	.long	0x66
	.quad	.LFB13
	.quad	.LFE13-.LFB13
	.uleb128 0x1
	.byte	0x9c
	.long	0x1255
	.uleb128 0x5
	.long	.LASF172
	.value	0x160
	.byte	0x14
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x5
	.long	.LASF185
	.value	0x160
	.byte	0x25
	.long	0xdf4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x1
	.long	.LASF186
	.value	0x162
	.byte	0x11
	.long	0x2f3
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x1
	.long	.LASF187
	.value	0x163
	.byte	0x9
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -28
	.byte	0
	.uleb128 0xb
	.long	.LASF188
	.value	0x11c
	.byte	0x1
	.long	0x66
	.quad	.LFB12
	.quad	.LFE12-.LFB12
	.uleb128 0x1
	.byte	0x9c
	.long	0x1320
	.uleb128 0x5
	.long	.LASF172
	.value	0x11c
	.byte	0x1c
	.long	0xb4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1096
	.uleb128 0x1
	.long	.LASF189
	.value	0x11e
	.byte	0xc
	.long	0x443
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1072
	.uleb128 0x1
	.long	.LASF190
	.value	0x11f
	.byte	0xb
	.long	0xb4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1064
	.uleb128 0x1
	.long	.LASF191
	.value	0x120
	.byte	0x9
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1084
	.uleb128 0x22
	.quad	.LBB8
	.quad	.LBE8-.LBB8
	.long	0x12ed
	.uleb128 0x1
	.long	.LASF192
	.value	0x13d
	.byte	0xe
	.long	0xdf9
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1056
	.uleb128 0x1
	.long	.LASF143
	.value	0x13f
	.byte	0xd
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1080
	.byte	0
	.uleb128 0x6
	.quad	.LBB9
	.quad	.LBE9-.LBB9
	.uleb128 0x1
	.long	.LASF193
	.value	0x153
	.byte	0xd
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1088
	.uleb128 0x1
	.long	.LASF166
	.value	0x155
	.byte	0xd
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1076
	.byte	0
	.byte	0
	.uleb128 0x19
	.long	.LASF194
	.byte	0xfb
	.byte	0x8
	.long	0x443
	.quad	.LFB11
	.quad	.LFE11-.LFB11
	.uleb128 0x1
	.byte	0x9c
	.long	0x137a
	.uleb128 0x10
	.long	.LASF172
	.byte	0xfb
	.byte	0x28
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x9
	.long	.LASF189
	.byte	0xfd
	.byte	0xc
	.long	0x443
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x9
	.long	.LASF190
	.byte	0xfe
	.byte	0xb
	.long	0xb4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x9
	.long	.LASF191
	.byte	0xff
	.byte	0x9
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -44
	.byte	0
	.uleb128 0x19
	.long	.LASF195
	.byte	0xb2
	.byte	0x5
	.long	0x66
	.quad	.LFB10
	.quad	.LFE10-.LFB10
	.uleb128 0x1
	.byte	0x9c
	.long	0x1444
	.uleb128 0x10
	.long	.LASF196
	.byte	0xb2
	.byte	0x1c
	.long	0xdf4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1096
	.uleb128 0x10
	.long	.LASF187
	.byte	0xb2
	.byte	0x31
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1100
	.uleb128 0x15
	.string	"fd"
	.byte	0xb4
	.byte	0x9
	.long	0x98
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1064
	.uleb128 0x15
	.string	"pid"
	.byte	0xb5
	.byte	0x8
	.long	0x2da
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1076
	.uleb128 0x15
	.string	"fdd"
	.byte	0xb6
	.byte	0x6
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1080
	.uleb128 0x6
	.quad	.LBB6
	.quad	.LBE6-.LBB6
	.uleb128 0x9
	.long	.LASF162
	.byte	0xc9
	.byte	0x12
	.long	0xdf9
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1056
	.uleb128 0x9
	.long	.LASF163
	.byte	0xca
	.byte	0x11
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1068
	.uleb128 0x9
	.long	.LASF164
	.byte	0xcb
	.byte	0x11
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1084
	.uleb128 0x6
	.quad	.LBB7
	.quad	.LBE7-.LBB7
	.uleb128 0x15
	.string	"w"
	.byte	0xce
	.byte	0x15
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1072
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x19
	.long	.LASF197
	.byte	0x9d
	.byte	0x1
	.long	0x66
	.quad	.LFB9
	.quad	.LFE9-.LFB9
	.uleb128 0x1
	.byte	0x9c
	.long	0x14ce
	.uleb128 0x10
	.long	.LASF198
	.byte	0x9d
	.byte	0x1d
	.long	0x443
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x10
	.long	.LASF187
	.byte	0x9d
	.byte	0x28
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -60
	.uleb128 0x9
	.long	.LASF155
	.byte	0x9f
	.byte	0xd
	.long	0xdf4
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x6
	.quad	.LBB4
	.quad	.LBE4-.LBB4
	.uleb128 0x15
	.string	"i"
	.byte	0xa0
	.byte	0xe
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -36
	.uleb128 0x6
	.quad	.LBB5
	.quad	.LBE5-.LBB5
	.uleb128 0x9
	.long	.LASF189
	.byte	0xa2
	.byte	0x10
	.long	0x443
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x19
	.long	.LASF199
	.byte	0x82
	.byte	0x1
	.long	0x66
	.quad	.LFB8
	.quad	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.long	0x1575
	.uleb128 0x10
	.long	.LASF200
	.byte	0x82
	.byte	0x1a
	.long	0xb4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -72
	.uleb128 0x9
	.long	.LASF201
	.byte	0x84
	.byte	0xc
	.long	0x443
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x9
	.long	.LASF202
	.byte	0x85
	.byte	0x11
	.long	0x2f3
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x9
	.long	.LASF191
	.byte	0x86
	.byte	0x9
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x6
	.quad	.LBB2
	.quad	.LBE2-.LBB2
	.uleb128 0x15
	.string	"i"
	.byte	0x89
	.byte	0xe
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -60
	.uleb128 0x6
	.quad	.LBB3
	.quad	.LBE3-.LBB3
	.uleb128 0x9
	.long	.LASF198
	.byte	0x8b
	.byte	0x10
	.long	0x443
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x9
	.long	.LASF187
	.byte	0x8c
	.byte	0xd
	.long	0x66
	.uleb128 0x2
	.byte	0x91
	.sleb128 -52
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x34
	.long	.LASF213
	.byte	0x1
	.byte	0x78
	.byte	0x5
	.long	0x66
	.quad	.LFB7
	.quad	.LFE7-.LFB7
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x35
	.long	.LASF203
	.byte	0x1
	.byte	0x5b
	.byte	0x1
	.long	0x66
	.quad	.LFB6
	.quad	.LFE6-.LFB6
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x10
	.long	.LASF204
	.byte	0x5b
	.byte	0xa
	.long	0x66
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1476
	.uleb128 0x10
	.long	.LASF205
	.byte	0x5b
	.byte	0x16
	.long	0x443
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1488
	.uleb128 0x9
	.long	.LASF206
	.byte	0x5d
	.byte	0xb
	.long	0xb4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1472
	.uleb128 0x9
	.long	.LASF207
	.byte	0x5e
	.byte	0xb
	.long	0xb4
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1464
	.uleb128 0x9
	.long	.LASF208
	.byte	0x60
	.byte	0xa
	.long	0xdf9
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1056
	.uleb128 0x9
	.long	.LASF209
	.byte	0x61
	.byte	0x14
	.long	0x448
	.uleb128 0x3
	.byte	0x91
	.sleb128 -1456
	.uleb128 0x36
	.long	.LASF214
	.byte	0x1
	.byte	0x68
	.byte	0x9
	.quad	.L2
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 12
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0xd
	.uleb128 0xb
	.uleb128 0x6b
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x37
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x13
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x1d
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 9
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 10
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 13
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 11
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x20
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 6
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x21
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 6
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x22
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x23
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x1f
	.uleb128 0x1b
	.uleb128 0x1f
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x24
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x25
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x26
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x27
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x28
	.uleb128 0x26
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x29
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2a
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2b
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0x5
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2c
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2d
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x2e
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x87
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2f
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x30
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0x5
	.byte	0
	.byte	0
	.uleb128 0x31
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x32
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x33
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x34
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x35
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x36
	.uleb128 0xa
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x2c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x8
	.byte	0
	.value	0
	.value	0
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_rnglists,"",@progbits
.Ldebug_ranges0:
	.long	.Ldebug_ranges3-.Ldebug_ranges2
.Ldebug_ranges2:
	.value	0x5
	.byte	0x8
	.byte	0
	.long	0
.LLRL0:
	.byte	0x4
	.uleb128 .LBB11-.Ltext0
	.uleb128 .LBE11-.Ltext0
	.byte	0x4
	.uleb128 .LBB12-.Ltext0
	.uleb128 .LBE12-.Ltext0
	.byte	0
.Ldebug_ranges3:
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF122:
	.string	"printf"
.LASF10:
	.string	"__off_t"
.LASF87:
	.string	"capacity"
.LASF16:
	.string	"_IO_read_ptr"
.LASF28:
	.string	"_chain"
.LASF153:
	.string	"finalArguments"
.LASF84:
	.string	"fBackground"
.LASF104:
	.string	"strcmp"
.LASF9:
	.string	"size_t"
.LASF90:
	.string	"next"
.LASF133:
	.string	"newNode"
.LASF34:
	.string	"_shortbuf"
.LASF93:
	.string	"environmentVariables"
.LASF157:
	.string	"consumerArguments"
.LASF48:
	.string	"ssize_t"
.LASF56:
	.string	"__buffer"
.LASF168:
	.string	"ExecuteCommandInBackground"
.LASF210:
	.string	"GNU C17 11.4.0 -mtune=generic -march=x86-64 -g -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection"
.LASF167:
	.string	"path"
.LASF22:
	.string	"_IO_buf_base"
.LASF86:
	.string	"numberOfElements"
.LASF115:
	.string	"pipe"
.LASF144:
	.string	"numberOfTokens"
.LASF117:
	.string	"free"
.LASF37:
	.string	"_codecvt"
.LASF63:
	.string	"__can_be_null"
.LASF49:
	.string	"long long int"
.LASF6:
	.string	"signed char"
.LASF111:
	.string	"dup2"
.LASF79:
	.string	"release"
.LASF110:
	.string	"close"
.LASF66:
	.string	"__no_sub"
.LASF51:
	.string	"long long unsigned int"
.LASF170:
	.string	"GetEnvPath"
.LASF195:
	.string	"PipedExecution"
.LASF29:
	.string	"_fileno"
.LASF88:
	.string	"Node"
.LASF17:
	.string	"_IO_read_end"
.LASF102:
	.string	"chdir"
.LASF125:
	.string	"uname"
.LASF69:
	.string	"__newline_anchor"
.LASF131:
	.string	"delete"
.LASF8:
	.string	"long int"
.LASF202:
	.string	"commaRegEx"
.LASF97:
	.string	"strtok"
.LASF15:
	.string	"_flags"
.LASF13:
	.string	"__ssize_t"
.LASF23:
	.string	"_IO_buf_end"
.LASF46:
	.string	"_IO_codecvt"
.LASF142:
	.string	"regex"
.LASF194:
	.string	"PreprocessCommandsForPipe"
.LASF59:
	.string	"__syntax"
.LASF31:
	.string	"_old_offset"
.LASF162:
	.string	"buffer"
.LASF71:
	.string	"regex_t"
.LASF203:
	.string	"main"
.LASF187:
	.string	"numberOfPipes"
.LASF182:
	.string	"array"
.LASF5:
	.string	"short unsigned int"
.LASF151:
	.string	"errfd"
.LASF60:
	.string	"__fastmap"
.LASF82:
	.string	"__domainname"
.LASF64:
	.string	"__regs_allocated"
.LASF127:
	.string	"bucketHead"
.LASF152:
	.string	"numberOfArguments"
.LASF89:
	.string	"value"
.LASF45:
	.string	"_IO_marker"
.LASF132:
	.string	"insert"
.LASF201:
	.string	"commandArray"
.LASF3:
	.string	"unsigned int"
.LASF40:
	.string	"_freeres_buf"
.LASF120:
	.string	"strlen"
.LASF172:
	.string	"command"
.LASF128:
	.string	"errorMssg"
.LASF2:
	.string	"long unsigned int"
.LASF158:
	.string	"consumerExecutablePath"
.LASF126:
	.string	"bucketIndex"
.LASF20:
	.string	"_IO_write_ptr"
.LASF99:
	.string	"strchr"
.LASF108:
	.string	"waitpid"
.LASF193:
	.string	"processReturnValue"
.LASF114:
	.string	"fork"
.LASF81:
	.string	"machine"
.LASF148:
	.string	"arguments"
.LASF163:
	.string	"signalCode"
.LASF156:
	.string	"generatorArguments"
.LASF199:
	.string	"ProcessCommandLine"
.LASF24:
	.string	"_IO_save_base"
.LASF83:
	.string	"stdin"
.LASF53:
	.string	"reg_syntax_t"
.LASF123:
	.string	"getlogin"
.LASF191:
	.string	"numberOfCommands"
.LASF98:
	.string	"strcpy"
.LASF35:
	.string	"_lock"
.LASF159:
	.string	"generatorExecutablePath"
.LASF145:
	.string	"GetEnvironmentVariable"
.LASF30:
	.string	"_flags2"
.LASF42:
	.string	"_mode"
.LASF121:
	.string	"fgets"
.LASF192:
	.string	"currentWorkingDirectory"
.LASF197:
	.string	"ProcessMultiplePipes"
.LASF38:
	.string	"_wide_data"
.LASF106:
	.string	"write"
.LASF119:
	.string	"getenv"
.LASF80:
	.string	"version"
.LASF100:
	.string	"regexec"
.LASF178:
	.string	"TokenizeString"
.LASF36:
	.string	"_offset"
.LASF95:
	.string	"open"
.LASF160:
	.string	"pidc"
.LASF161:
	.string	"pidg"
.LASF94:
	.string	"retVal"
.LASF176:
	.string	"commandLength"
.LASF200:
	.string	"commandLine"
.LASF11:
	.string	"__off64_t"
.LASF198:
	.string	"pipes"
.LASF211:
	.string	"_IO_lock_t"
.LASF54:
	.string	"_IO_FILE"
.LASF134:
	.string	"search"
.LASF91:
	.string	"environment"
.LASF141:
	.string	"setCommand"
.LASF58:
	.string	"__used"
.LASF171:
	.string	"options"
.LASF73:
	.string	"rm_so"
.LASF186:
	.string	"pipingRegex"
.LASF155:
	.string	"pipeCommands"
.LASF140:
	.string	"SetEnvironmentVariable"
.LASF174:
	.string	"token"
.LASF212:
	.string	"saveptr"
.LASF27:
	.string	"_markers"
.LASF180:
	.string	"pmatch"
.LASF207:
	.string	"user"
.LASF96:
	.string	"access"
.LASF189:
	.string	"commandOptions"
.LASF4:
	.string	"unsigned char"
.LASF150:
	.string	"infd"
.LASF138:
	.string	"node"
.LASF76:
	.string	"utsname"
.LASF147:
	.string	"RedirectionCheck"
.LASF12:
	.string	"__pid_t"
.LASF61:
	.string	"__translate"
.LASF209:
	.string	"info"
.LASF72:
	.string	"regoff_t"
.LASF47:
	.string	"_IO_wide_data"
.LASF65:
	.string	"__fastmap_accurate"
.LASF169:
	.string	"RemoveEscapeSpace"
.LASF33:
	.string	"_vtable_offset"
.LASF85:
	.string	"HashTable"
.LASF118:
	.string	"malloc"
.LASF44:
	.string	"FILE"
.LASF112:
	.string	"exit"
.LASF214:
	.string	"RESTART"
.LASF92:
	.string	"hostName"
.LASF109:
	.string	"execv"
.LASF137:
	.string	"setNode"
.LASF154:
	.string	"PipeExecutables"
.LASF74:
	.string	"rm_eo"
.LASF184:
	.string	"ProcessPipes"
.LASF14:
	.string	"char"
.LASF129:
	.string	"prevNode"
.LASF188:
	.string	"ProcessSingleCommand"
.LASF190:
	.string	"spaceRegEx"
.LASF70:
	.string	"re_dfa_t"
.LASF7:
	.string	"short int"
.LASF55:
	.string	"re_pattern_buffer"
.LASF204:
	.string	"argc"
.LASF105:
	.string	"wait"
.LASF113:
	.string	"__errno_location"
.LASF75:
	.string	"regmatch_t"
.LASF206:
	.string	"workingDirectory"
.LASF32:
	.string	"_cur_column"
.LASF18:
	.string	"_IO_read_base"
.LASF26:
	.string	"_IO_save_end"
.LASF68:
	.string	"__not_eol"
.LASF77:
	.string	"sysname"
.LASF146:
	.string	"getCommand"
.LASF177:
	.string	"fullCommmand"
.LASF41:
	.string	"__pad5"
.LASF107:
	.string	"snprintf"
.LASF165:
	.string	"ExecuteCommandInForeground"
.LASF21:
	.string	"_IO_write_end"
.LASF173:
	.string	"found"
.LASF43:
	.string	"_unused2"
.LASF196:
	.string	"pipeCommandList"
.LASF185:
	.string	"outputSplit"
.LASF124:
	.string	"getcwd"
.LASF179:
	.string	"removeSpace"
.LASF175:
	.string	"envPath"
.LASF136:
	.string	"factor"
.LASF25:
	.string	"_IO_backup_base"
.LASF67:
	.string	"__not_bol"
.LASF52:
	.string	"__re_long_size_t"
.LASF78:
	.string	"nodename"
.LASF130:
	.string	"currNode"
.LASF116:
	.string	"perror"
.LASF101:
	.string	"regcomp"
.LASF135:
	.string	"hashFunction"
.LASF213:
	.string	"CreateEnvironment"
.LASF50:
	.string	"pid_t"
.LASF39:
	.string	"_freeres_list"
.LASF164:
	.string	"wstatusg"
.LASF103:
	.string	"realloc"
.LASF183:
	.string	"start"
.LASF139:
	.string	"CheckKey"
.LASF205:
	.string	"argv"
.LASF19:
	.string	"_IO_write_base"
.LASF166:
	.string	"returnValue"
.LASF143:
	.string	"result"
.LASF149:
	.string	"outfd"
.LASF208:
	.string	"inputCommand"
.LASF181:
	.string	"arraySize"
.LASF62:
	.string	"re_nsub"
.LASF57:
	.string	"__allocated"
	.section	.debug_line_str,"MS",@progbits,1
.LASF0:
	.string	"flash2.c"
.LASF1:
	.string	"/home/prajas/C_C++/Systems Programming/Final Project/FLASH"
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
