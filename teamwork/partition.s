.section .text
.globl partition_asm
.type partition_asm, @function

partition_asm:
    pushq %rbp
    movq %rsp, %rbp

    # rdi = arr
    # rsi = low
    # rdx = high

    movl (%rdi, %rsi, 4), %ebx  # ebx = base = arr[low]

loop_start:
    cmpq %rdx, %rsi             # compare low with high
    jge end_partition           # jump to end if low >= high
    
while1_start:
    movl (%rdi, %rdx, 4), %ecx  # ecx = arr[high]
    cmpq %rsi, %rdx		        # compare high with low
	jle while1_end
    cmp %ecx, %ebx              # compare arr[high] with base
    jg while1_end
	subq $1, %rdx               # high--
	jmp while1_start

while1_end:
	movl %ecx, (%rdi, %rsi, 4)  # arr[low] = arr[high]

while2_start:
    movl (%rdi, %rsi, 4), %ecx  # ecx = arr[low]
    cmpq %rsi, %rdx		        # compare high with low
	jle while2_end
    cmp %ebx, %ecx              # compare arr[low] with base
    jg while2_end
	addq $1, %rsi               # low++
	jmp while2_start

while2_end:
	movl %ecx, (%rdi, %rdx, 4)  # arr[low] = arr[high]
    jmp loop_start

end_partition:
	movl %ebx, (%rdi, %rsi, 4)	# arr[low] = base
    movq %rsi, %rax             # return low
    popq %rbp
    ret

.section .note.GNU-stack,"",@progbits
