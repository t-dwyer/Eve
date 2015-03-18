	.text
	.file	"runtime.cpp"
	.globl	Augment_init
	.align	16, 0x90
	.type	Augment_init,@function
Augment_init:                           # @Augment_init
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp0:
	.cfi_def_cfa_offset 16
.Ltmp1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp2:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	cmpl	$0, init
	je	.LBB0_6
# BB#1:
	movabsq	$.L.str, %rdi
	movb	$0, %al
	callq	printf
	movabsq	$.L.str1, %rdi
	movl	-4(%rbp), %esi
	movl	%eax, -12(%rbp)         # 4-byte Spill
	movb	$0, %al
	callq	printf
	movl	-4(%rbp), %esi
	movl	%esi, num_sig
	movl	$0, -8(%rbp)
	movl	%eax, -16(%rbp)         # 4-byte Spill
.LBB0_2:                                # =>This Inner Loop Header: Depth=1
	movl	-8(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jge	.LBB0_5
# BB#3:                                 #   in Loop: Header=BB0_2 Depth=1
	movslq	-8(%rbp), %rax
	movb	$0, sig(,%rax)
	movslq	-8(%rbp), %rax
	movb	$0, sigPrime(,%rax)
# BB#4:                                 #   in Loop: Header=BB0_2 Depth=1
	movl	-8(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -8(%rbp)
	jmp	.LBB0_2
.LBB0_5:
	movb	$1, sig
	movl	$0, init
.LBB0_6:
	movb	$1, %al
	andb	$1, %al
	movzbl	%al, %eax
	addq	$16, %rsp
	popq	%rbp
	retq
.Ltmp3:
	.size	Augment_init, .Ltmp3-Augment_init
	.cfi_endproc

	.globl	Augment_sig
	.align	16, 0x90
	.type	Augment_sig,@function
Augment_sig:                            # @Augment_sig
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp4:
	.cfi_def_cfa_offset 16
.Ltmp5:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp6:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movabsq	$.L.str2, %rax
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %esi
	movslq	-4(%rbp), %rcx
	movb	sig(,%rcx), %dl
	andb	$1, %dl
	movzbl	%dl, %edx
	movq	%rax, %rdi
	movb	$0, %al
	callq	printf
	movslq	-4(%rbp), %rcx
	movb	$1, sig(,%rcx)
	movl	%eax, -8(%rbp)          # 4-byte Spill
	addq	$16, %rsp
	popq	%rbp
	retq
.Ltmp7:
	.size	Augment_sig, .Ltmp7-Augment_sig
	.cfi_endproc

	.globl	Augment_sigPrime
	.align	16, 0x90
	.type	Augment_sigPrime,@function
Augment_sigPrime:                       # @Augment_sigPrime
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp8:
	.cfi_def_cfa_offset 16
.Ltmp9:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp10:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movabsq	$.L.str3, %rax
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %esi
	movq	%rax, %rdi
	movb	$0, %al
	callq	printf
	movslq	-4(%rbp), %rdi
	movb	$1, sigPrime(,%rdi)
	movl	%eax, -8(%rbp)          # 4-byte Spill
	addq	$16, %rsp
	popq	%rbp
	retq
.Ltmp11:
	.size	Augment_sigPrime, .Ltmp11-Augment_sigPrime
	.cfi_endproc

	.globl	Augment_sigTry
	.align	16, 0x90
	.type	Augment_sigTry,@function
Augment_sigTry:                         # @Augment_sigTry
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp12:
	.cfi_def_cfa_offset 16
.Ltmp13:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp14:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movabsq	$.L.str4, %rax
	movl	%edi, -8(%rbp)
	movl	-8(%rbp), %esi
	movslq	-8(%rbp), %rcx
	movb	sig(,%rcx), %dl
	andb	$1, %dl
	movzbl	%dl, %edx
	movq	%rax, %rdi
	movb	$0, %al
	callq	printf
	movslq	-8(%rbp), %rcx
	testb	$1, sig(,%rcx)
	movl	%eax, -12(%rbp)         # 4-byte Spill
	je	.LBB3_2
# BB#1:
	movabsq	$.L.str5, %rdi
	movslq	-8(%rbp), %rax
	movb	$0, sig(,%rax)
	movslq	-8(%rbp), %rax
	movb	sig(,%rax), %cl
	andb	$1, %cl
	movzbl	%cl, %esi
	movb	$0, %al
	callq	printf
	movl	$1, -4(%rbp)
	movl	%eax, -16(%rbp)         # 4-byte Spill
	jmp	.LBB3_3
.LBB3_2:
	movl	$0, -4(%rbp)
.LBB3_3:
	movl	-4(%rbp), %eax
	addq	$16, %rsp
	popq	%rbp
	retq
.Ltmp15:
	.size	Augment_sigTry, .Ltmp15-Augment_sigTry
	.cfi_endproc

	.globl	Augment_sigDep
	.align	16, 0x90
	.type	Augment_sigDep,@function
Augment_sigDep:                         # @Augment_sigDep
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp16:
	.cfi_def_cfa_offset 16
.Ltmp17:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp18:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movabsq	$.L.str6, %rax
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %esi
	movq	%rax, %rdi
	movb	$0, %al
	callq	printf
	movslq	-4(%rbp), %rdi
	movb	sigPrime(,%rdi), %cl
	andb	$1, %cl
	movzbl	%cl, %esi
	movl	%eax, -8(%rbp)          # 4-byte Spill
	movl	%esi, %eax
	addq	$16, %rsp
	popq	%rbp
	retq
.Ltmp19:
	.size	Augment_sigDep, .Ltmp19-Augment_sigDep
	.cfi_endproc

	.globl	Augment_writeOut
	.align	16, 0x90
	.type	Augment_writeOut,@function
Augment_writeOut:                       # @Augment_writeOut
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp20:
	.cfi_def_cfa_offset 16
.Ltmp21:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp22:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	$3, %edi
	callq	Augment_sigTry
	cmpl	$0, %eax
	setne	%cl
	andb	$1, %cl
	movb	%cl, -1(%rbp)
	testb	$1, -1(%rbp)
	je	.LBB5_2
# BB#1:
	movl	$3, %edi
	callq	Augment_sigPrime
.LBB5_2:
	addq	$16, %rsp
	popq	%rbp
	retq
.Ltmp23:
	.size	Augment_writeOut, .Ltmp23-Augment_writeOut
	.cfi_endproc

	.type	init,@object            # @init
	.data
	.globl	init
	.align	4
init:
	.long	1                       # 0x1
	.size	init, 4

	.type	num_sig,@object         # @num_sig
	.bss
	.globl	num_sig
	.align	4
num_sig:
	.long	0                       # 0x0
	.size	num_sig, 4

	.type	sig,@object             # @sig
	.globl	sig
	.align	16
sig:
	.zero	100
	.size	sig, 100

	.type	sigPrime,@object        # @sigPrime
	.globl	sigPrime
	.align	16
sigPrime:
	.zero	100
	.size	sigPrime, 100

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Instrumentation initialized\n"
	.size	.L.str, 29

	.type	.L.str1,@object         # @.str1
.L.str1:
	.asciz	"Number of blocks found : %d\n"
	.size	.L.str1, 29

	.type	.L.str2,@object         # @.str2
.L.str2:
	.asciz	"Block %d has been sent a SIGNAL, status was %d is now 1\n"
	.size	.L.str2, 57

	.type	.L.str3,@object         # @.str3
.L.str3:
	.asciz	"Block %d has been sent a SIG PRIME\n"
	.size	.L.str3, 36

	.type	.L.str4,@object         # @.str4
.L.str4:
	.asciz	"Signal Check: Block %d tried, state was %d\n"
	.size	.L.str4, 44

	.type	.L.str5,@object         # @.str5
.L.str5:
	.asciz	" - Hit, setting signal to : %d \n"
	.size	.L.str5, 33

	.type	.L.str6,@object         # @.str6
.L.str6:
	.asciz	"Dependency check: Waiting on signal %d\n"
	.size	.L.str6, 40


	.ident	"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"
	.section	".note.GNU-stack","",@progbits
