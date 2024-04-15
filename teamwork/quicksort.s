.section .text
.globl quicksort_asm
.type quicksort_asm, @function

quicksort_asm:
    pushq   %rbp               # 保存当前函数调用的基址指针
    movq    %rsp, %rbp         # 设置新的基址指针
    subq    $32, %rsp          # 分配32字节的栈空间用于局部变量和参数保存

    movq    %rdi, -24(%rbp)    # 将第一个参数(arr)存储到局部变量中
    movl    %esi, -28(%rbp)    # 将第二个参数(low)存储到局部变量中
    movl    %edx, -32(%rbp)    # 将第三个参数(high)存储到局部变量中

    movl    -28(%rbp), %eax    # 将low加载到eax寄存器
    cmpl    -32(%rbp), %eax    # 比较low和high
    jge     qsort_end          # 如果low >= high，则跳转到qsort_end结束函数

    # 调用partition_asm(arr, low, high)获取pivot
    movl    -32(%rbp), %edx    # 将high加载到edx寄存器
    movl    -28(%rbp), %ecx    # 将low加载到ecx寄存器
    movq    -24(%rbp), %rax    # 将arr加载到rax寄存器
    movl    %ecx, %esi         # 将low传递给esi寄存器作为第二个参数
    movq    %rax, %rdi         # 将arr传递给rdi寄存器作为第一个参数
    movl    $0, %eax           # 清零eax寄存器（用于传递额外的参数或返回值）
    call    partition_asm
    movl    %eax, -4(%rbp)     # 将返回值(pivot)存储到局部变量中

    # 递归调用quicksort_asm(arr, low, pivot - 1)
    movl    -4(%rbp), %eax     # 将pivot加载到eax寄存器
    leal    -1(%rax), %edx     # 计算pivot - 1，并存储到edx寄存器
    movl    -28(%rbp), %ecx    # 将low加载到ecx寄存器
    movq    -24(%rbp), %rax    # 将arr加载到rax寄存器
    movl    %ecx, %esi         # 将low传递给esi寄存器作为第二个参数
    movq    %rax, %rdi         # 将arr传递给rdi寄存器作为第一个参数
    call    quicksort_asm

    # 递归调用quicksort_asm(arr, pivot + 1, high)
    movl    -4(%rbp), %eax     # 将pivot加载到eax寄存器
    leal    1(%rax), %ecx      # 计算pivot + 1，并存储到ecx寄存器
    movl    -32(%rbp), %edx    # 将high加载到edx寄存器
    movq    -24(%rbp), %rax    # 将arr加载到rax寄存器
    movl    %ecx, %esi         # 将pivot + 1传递给esi寄存器作为第二个参数
    movq    %rax, %rdi         # 将arr传递给rdi寄存器作为第一个参数
    call    quicksort_asm

qsort_end:
    leave                      # 恢复栈帧并释放栈空间
    ret                        # 返回

.section .note.GNU-stack,"",@progbits
