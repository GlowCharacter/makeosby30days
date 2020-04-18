; haribote-ipl
; TAB=4

		ORG		0x7c00			; 指明程序的装载地址

; 以下的记述用于标准FAT32格式的软盘

		JMP		entry
		DB		0x90
		DB		"HARIBOTE"		; 启动区的名称可以是任意的字符串（8字节）
		DW		512				; 每个扇区（sector）的大小（必须为512字节）
		DB		1				; 簇（cluster）的大小（必须为1个扇区）
		DW		1				; FAT的起始位置（一般从第一个扇区开始）
		DB		2				; FAT的个数（必须为2）
		DW		224				; 根目录的大小（一般设成224项）
		DW		2880			; 该磁盘的大小（必须是2880扇区）
		DB		0xf0			; 磁盘的种类（必须是0xf0）
		DW		9				; FAT的长度（必须是9扇区）
		DW		18				; 1个磁道（track）有几个扇区（必须是18）
		DW		2				; 磁头数（必须是2）
		DD		0				; 不使用分区（必须是0）
		DD		2880			; 重写一次磁盘大小
		DB		0,0,0x29		; 意义不明，固定
		DD		0xffffffff		; （可能是）卷标号码
		DB		"HARIBOTEOS   "	; 磁盘的名称（11字节）
		DB		"FAT12   "		; 磁盘格式名称（8字节）
		RESB	18				; 先空出18字节

; 程序核心

entry:							; 初始化寄存器
		MOV		AX,0			; AX:累加寄存器，SP:栈指针寄存器，SI:源变址寄存器
		MOV		SS,AX			; ES:附加段寄存器，DS:数据段寄存器，SS:栈段寄存器
		MOV		SP,0x7c00
		MOV		DS,AX

; 读磁盘

		MOV		AX,0x0820
		MOV		ES,AX
		MOV 		CH,0			; 柱面0
		MOV		DH,0			; 磁头0
		MOV		CL,2			; 扇区2
readloop:		
		MOV		SI,0			; 记录失败次数的寄存器
retry:
		MOV		AH,0x02			; AH=0x02 : 读盘
		MOV		AL,1			; 1个扇区
		MOV 		BX,0
		MOV		DL,0x00			; A驱动器 
		INT		0x13			; 调用磁盘BIOS
		JNC		next			; 没出错的话跳转
		ADD		SI,1			; 往SI加1
		CMP		SI,5			; 比较SI与5
		JAE		error			; SI >= 5时，跳转到error
		MOV		AH,0x00
		MOV		DL,0x00			; A驱动器
		INT		0x13			; 重置驱动器
		JMP		retry		
next:
		MOV		AX,ES			; 把内存地址后移0x200
		ADD		AX,0x0020
		MOV		ES,AX
		ADD		CL,1
		CMP		CL,18
		JBE		readloop
	
; 我已经读完了，但是我还是不会去做，所以我会睡觉
	
fin:
		HLT						; 让CPU停止，等待指令
		JMP		fin				; 无线循环

error:
		MOV		SI,msg
putloop:
		MOV		AL,[SI]			; AL:累加寄存器底位，AH:累加寄存器高位，BX:基址寄存器
		ADD		SI,1			; 给SI加1
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; 显示一个文字
		MOV		BX,15			; 指定字符颜色
		INT		0x10			; 调用显卡BIOS
		JMP		putloop
msg:
		DB		0x0a, 0x0a		; 执行两次
		DB		"load error"
		DB		0x0a			; 换行
		DB		0

		RESB	0x7dfe-$		; 使用0x00填充，最多到0x7dfe处

		DB		0x55, 0xaa
