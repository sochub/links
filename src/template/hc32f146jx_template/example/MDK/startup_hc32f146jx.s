;/******************************************************************************
;* Copyright (C) 2016, Huada Semiconductor Co.,Ltd All rights reserved.
;*
;* This software is owned and published by:
;* Huada Semiconductor Co.,Ltd ("HDSC").
;*
;* BY DOWNLOADING, INSTALLING OR USING THIS SOFTWARE, YOU AGREE TO BE BOUND
;* BY ALL THE TERMS AND CONDITIONS OF THIS AGREEMENT.
;*
;* This software contains source code for use with HDSC
;* components. This software is licensed by HDSC to be adapted only
;* for use in systems utilizing HDSC components. HDSC shall not be
;* responsible for misuse or illegal use of this software for devices not
;* supported herein. HDSC is providing this software "AS IS" and will
;* not be responsible for issues arising from incorrect user implementation
;* of the software.
;*
;* Disclaimer:
;* HDSC MAKES NO WARRANTY, EXPRESS OR IMPLIED, ARISING BY LAW OR OTHERWISE,
;* REGARDING THE SOFTWARE (INCLUDING ANY ACOOMPANYING WRITTEN MATERIALS),
;* ITS PERFORMANCE OR SUITABILITY FOR YOUR INTENDED USE, INCLUDING,
;* WITHOUT LIMITATION, THE IMPLIED WARRANTY OF MERCHANTABILITY, THE IMPLIED
;* WARRANTY OF FITNESS FOR A PARTICULAR PURPOSE OR USE, AND THE IMPLIED
;* WARRANTY OF NONINFRINGEMENT.
;* HDSC SHALL HAVE NO LIABILITY (WHETHER IN CONTRACT, WARRANTY, TORT,
;* NEGLIGENCE OR OTHERWISE) FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT
;* LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION,
;* LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING FROM USE OR
;* INABILITY TO USE THE SOFTWARE, INCLUDING, WITHOUT LIMITATION, ANY DIRECT,
;* INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES OR LOSS OF DATA,
;* SAVINGS OR PROFITS,
;* EVEN IF Disclaimer HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
;* YOU ASSUME ALL RESPONSIBILITIES FOR SELECTION OF THE SOFTWARE TO ACHIEVE YOUR
;* INTENDED RESULTS, AND FOR THE INSTALLATION OF, USE OF, AND RESULTS OBTAINED
;* FROM, THE SOFTWARE.
;*
;* This software may be replicated in part or whole for the licensed use,
;* with the restriction that this Disclaimer and Copyright notice must be
;* included with each copy of this software, whether used in part or whole,
;* at all times.
;*/
;/*****************************************************************************/

;/*****************************************************************************/
;/*  Startup for ARM                                                          */
;/*  Version     V1.0                                                         */
;/*  Date        2017-10-11                                                   */
;/*  Target-mcu  HC32F_M14                                                      */
;/*****************************************************************************/

; Stack Configuration
; Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>

Stack_Size      EQU     0x00000200

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; Heap Configuration
;  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
                EXPORT  __Vectors_End
                EXPORT  __Vectors_Size

__Vectors                       
                DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset        
                DCD     NMI_Handler               ; NMI
                DCD     HardFault_Handler         ; Hard Fault
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV
                DCD     SysTick_Handler           ; SysTick

                DCD     CSV_IRQHandler
                DCD     SWWDT_IRQHandler
                DCD     LVD_IRQHandler
                DCD     Dummy_Handler
                DCD     EXTI07_IRQHandler
                DCD     EXTI815_IRQHandler
                DCD     DTIM_IRQHandler
                DCD     Dummy_Handler
                DCD     Dummy_Handler
                DCD     Dummy_Handler
                DCD     Dummy_Handler
                DCD     Dummy_Handler
                DCD     Dummy_Handler
                DCD     Dummy_Handler
                DCD     Dummy_Handler
                DCD     MSC4RX_IRQHandler
                DCD     MSC4TX_IRQHandler
                DCD     MSC5RX_IRQHandler
                DCD     MSC5TX_IRQHandler
                DCD     MSC6RX_DMAC0_IRQHandler
                DCD     MSC6TX_DMAC1_IRQHandler
                DCD     Dummy_Handler
                DCD     Dummy_Handler
                DCD     Dummy_Handler
                DCD     OSC_CC_RP_IRQHandler
                DCD     ADC_IRQHandler
                DCD     VC_IRQHandler
                DCD     Dummy_Handler
                DCD     Dummy_Handler
                DCD     Dummy_Handler
                DCD     Dummy_Handler
                DCD     CTIM03_FLASH_IRQHandler

                

__Vectors_End

__Vectors_Size 	EQU     __Vectors_End - __Vectors

                AREA    |.text|, CODE, READONLY


; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
                IMPORT  SystemInit
                IMPORT  __main

               ;reset NVIC if in rom debug
                LDR     R0, =0x20000000
                LDR     R2, =0x0
                MOVS    R1, #0                 ; for warning, 
                ADD     R1, PC,#0              ; for A1609W, 
                CMP     R1, R0
                BLS     RAMCODE

              ; ram code base address. 
                ADD     R2, R0,R2
RAMCODE
              ; reset Vector table address.
                LDR     R0, =0xE000ED08 
                STR     R2, [R0]

                LDR     R0, =SystemInit
                BLX     R0
                LDR     R0, =__main
                BX      R0
                ENDP


; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
                
                
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC
                EXPORT  CSV_IRQHandler                  [WEAK]
                EXPORT  SWWDT_IRQHandler                [WEAK]
                EXPORT  LVD_IRQHandler                  [WEAK]
                EXPORT  EXTI07_IRQHandler               [WEAK]
                EXPORT  EXTI815_IRQHandler              [WEAK]
                EXPORT  DTIM_IRQHandler                 [WEAK]
                EXPORT  Dummy_Handler                   [WEAK]
                EXPORT  MSC4RX_IRQHandler               [WEAK]
                EXPORT  MSC4TX_IRQHandler               [WEAK]
                EXPORT  MSC5RX_IRQHandler               [WEAK]
                EXPORT  MSC5TX_IRQHandler               [WEAK]
                EXPORT  MSC6RX_DMAC0_IRQHandler         [WEAK]
                EXPORT  MSC6TX_DMAC1_IRQHandler         [WEAK]
                EXPORT  OSC_CC_RP_IRQHandler            [WEAK]
                EXPORT  ADC_IRQHandler                  [WEAK]
                EXPORT  VC_IRQHandler                   [WEAK]
                EXPORT  CTIM03_FLASH_IRQHandler         [WEAK]
CSV_IRQHandler
SWWDT_IRQHandler
LVD_IRQHandler
EXTI07_IRQHandler
EXTI815_IRQHandler
DTIM_IRQHandler
Dummy_Handler
MSC4RX_IRQHandler
MSC4TX_IRQHandler
MSC5RX_IRQHandler
MSC5TX_IRQHandler
MSC6RX_DMAC0_IRQHandler
MSC6TX_DMAC1_IRQHandler
OSC_CC_RP_IRQHandler
ADC_IRQHandler
VC_IRQHandler
CTIM03_FLASH_IRQHandler

                
               B .

                ENDP


                ALIGN


; User Initial Stack & Heap

                IF      :DEF:__MICROLIB

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit

                ELSE

                IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap
__user_initial_stackheap

                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + Stack_Size)
                LDR     R2, = (Heap_Mem +  Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR

                ALIGN

                ENDIF


                END
