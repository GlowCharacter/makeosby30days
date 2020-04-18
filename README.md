# makeosby30days
Record my learning process of the book "30日でできる! OS自作入門"

## notes for 1th day
### NASK汇编指令（NASK改变自NASM）   
DB：data byte，往文件里直接写入一个字节的指令  
RESB：reserve byte，从当前地址开始空出多少字节  
DW：data word，在汇编里word指16位  
DD：data double-word  

## notes for 2th day
### NASK汇编指令
ORG：把程序装载到内存中的指定地址
MOV AX,0; 移动，相当于AX=0
JMP:跳转指令
CMP
JE：条件跳转指令，条件满足则跳转
HLT:halt，让CPU停止动作的指令
### Makefile文件的编写
#### 文件生成规则
ipl.bin : ipl.nas Makefile  
&nbsp;
  ../z_tools/nask.exe ipl.nas ipl.bin ipl.lst  
#### 命令
img:  
&nbsp;
  ../z_tools/make.exe -r helloos.img  

## notes for 3rd day
### 汇编指令
JC：jump if carry，如果进位标志为1则跳转
JNC：jump if not carry，如果进位标志是0的话就跳转
### 问题
Q：以下指令为什么不能写成 MOV ES,0x0820  
    &nbsp;
    MOV		AX,0x0820  
    &nbsp;
		MOV		ES,AX  
A：AX是累加寄存器，ES是附加段寄存器。不能将立即数送入段寄存器，应通过通用寄存器中转。具体原因请查看：  
   &nbsp;
   https://www.zhihu.com/question/43608287

