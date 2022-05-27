;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      JUNHO DE 2019                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_ON & _MCLRE_ON & _INTRC_OSC_CLKOUT 
						   ;WDT ATIVADO          SAÍDA DE CLOCK EM GP4.
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES

		;NOVAS VARIÁVEIS

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÃO ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00001000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS) (CONFIGURA GP0, GP1, GP2 E GP5 COMO SAÍDAS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00001111'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO 0
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	MOVLW	B'00000001'	;ATIVA O TIMER1 (BIT0 = 1)
	MOVWF	T1CON	
	CLRF    PIR1		;LIMPA AS FLAGS DO REG PIR1

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	
	
MAIN		;LABEL MAIN
	CLRF GPIO	    ;LIMPA TODAS AS PORTAS PARA EVITAR ERROS DE ULTIMO ESTADO (NOS TESTES, ALGUNS LEDS COMEÇAVAM ACESOS).
	SLEEP		    ;COMANDO QUE FAZ O PIC ENTRAR NO MODO SLEEP.
	NOP		    ;COMANDO LOGO APÓS O PIC SAIR DO SLEEP PARA VOLTAR AO ESTADO ORIGINAL ("SE ESPREGUIÇAR" ^^)
	GOTO SEQUENCIALEDS  ;COMANDO QUE DESVIA PARA A LABEL "SEQUENCIALEDS" QUE CONTEM A ATIVIDADE A SER FEITA APÓS SAIR DO SLEEP.
	
SEQUENCIALEDS	;LABEL QUE CONTEM O QUE O PIC DEVE FAZER APÓS SAIR DO SLEEP.
	
	BCF PIR1, TMR1IF	;ZERA A FLAG QUE APONTA O OVERFLOW DO TIMER 1.
	BSF GPIO, GP0		;SETA O BIT GP0 DO REG GPIO PARA ACENDER O PRIMEIRO LED.
	MOVLW .176		;VALOR CALCULADO PARA TMR1L E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1L		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1L (TIMER 1 LOW)
	MOVLW .60		;VALOR CALCULADO PARA TMR1H E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1H		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1H (TIMER 1 HIGH)
	BTFSS PIR1, TMR1IF	;TESTA A FLAG PIR1 PARA SABER SE ELA É 0 OU 1, SE FOR 0, O OVERFLOW AINDA NÃO OCORREU E O TESTE É REFEITO.
	GOTO $-1		;SE FOR 1, ESSA INSTRUÇÃO É PULADA E EXECUTADA A PRÓXIMA.
	
	BCF PIR1, TMR1IF	;A FLAG QUE APONTA O OVERFLOW DO TIMER 1 É ZERADA NOVAMENTE.
	BCF GPIO, GP0		;ZERA O BIT GP0 DO REG GPIO, APAGANDO ASSIM O PRIMEIRO LED APÓS 50 mS.
	BSF GPIO, GP1		;SETA O BIT GP1 DO REG GPIO, ACENDENDO ASSIM O SEGUNDO LED.
	MOVLW .176		;VALOR CALCULADO PARA TMR1L E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1L		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1L (TIMER 1 LOW)
	MOVLW .60		;VALOR CALCULADO PARA TMR1H E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1H		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1H (TIMER 1 HIGH)
	BTFSS PIR1, TMR1IF	;TESTA A FLAG PIR1 PARA SABER SE ELA É 0 OU 1, SE FOR 0, O OVERFLOW AINDA NÃO OCORREU E O TESTE É REFEITO.
	GOTO $-1		;SE FOR 1, ESSA INSTRUÇÃO É PULADA E É EXECUTADA A PRÓXIMA.
	
	BCF PIR1, TMR1IF	;A FLAG QUE APONTA O OVERFLOW DO TIMER 1 É ZERADA NOVAMENTE.
	BCF GPIO, GP1		;ZERA O BIT GP1 DO REG GPIO, APAGANDO ASSIM O SEGUNDO LED APÓS 50 mS.
	BSF GPIO, GP2		;SETA O BIT GP2 DO REG GPIO, ACENDENDO ASSIM O TERCEIRO LED.
	MOVLW .176		;VALOR CALCULADO PARA TMR1L E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1L		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1L (TIMER 1 LOW)
	MOVLW .60		;VALOR CALCULADO PARA TMR1H E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1H		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1H (TIMER 1 HIGH)
	BTFSS PIR1, TMR1IF	;TESTA A FLAG PIR1 PARA SABER SE ELA É 0 OU 1, SE FOR 0, O OVERFLOW AINDA NÃO OCORREU E O TESTE É REFEITO.
	GOTO $-1		;SE FOR 1, ESSA INSTRUÇÃO É PULADA E É EXECUTADA A PRÓXIMA.
	
	BCF PIR1, TMR1IF	;A FLAG QUE APONTA O OVERFLOW DO TIMER 1 É ZERADA NOVAMENTE.
	BCF GPIO, GP2		;ZERA O BIT GP2 DO REG GPIO, APAGANDO ASSIM O TERCEIRO LED APÓS 50 mS.
	BSF GPIO, GP5		;SETA O BIT GP5 DO REG GPIO, ACENDENDO ASSIM O QUARTO LED.
	MOVLW .176		;VALOR CALCULADO PARA TMR1L E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1L		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1L (TIMER 1 LOW)
	MOVLW .60		;VALOR CALCULADO PARA TMR1H E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1H		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1H (TIMER 1 HIGH)
	BTFSS PIR1, TMR1IF	;TESTA A FLAG PIR1 PARA SABER SE ELA É 0 OU 1, SE FOR 0, O OVERFLOW AINDA NÃO OCORREU E O TESTE É REFEITO.
	GOTO $-1		;SE FOR 1, ESSA INSTRUÇÃO É PULADA E É EXECUTADA A PRÓXIMA.
	BCF GPIO, GP5		;O BIT GP5 DO REG GPIO É ZERADO, APAGANDO ASSIM O QUARTO LED APÓS 50mS
	
	
	GOTO MAIN		;VOLTA AO MAIN PARA ENTRAR EM SLEEP E ASSIM FICAR EM LOOP
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END



