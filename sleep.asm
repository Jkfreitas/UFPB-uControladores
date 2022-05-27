;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      JUNHO DE 2019                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_ON & _MCLRE_ON & _INTRC_OSC_CLKOUT 
						   ;WDT ATIVADO          SA�DA DE CLOCK EM GP4.
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES

		;NOVAS VARI�VEIS

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER�O ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00001000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS) (CONFIGURA GP0, GP1, GP2 E GP5 COMO SA�DAS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00001111'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO 0
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	MOVLW	B'00000001'	;ATIVA O TIMER1 (BIT0 = 1)
	MOVWF	T1CON	
	CLRF    PIR1		;LIMPA AS FLAGS DO REG PIR1

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	
	
MAIN		;LABEL MAIN
	CLRF GPIO	    ;LIMPA TODAS AS PORTAS PARA EVITAR ERROS DE ULTIMO ESTADO (NOS TESTES, ALGUNS LEDS COME�AVAM ACESOS).
	SLEEP		    ;COMANDO QUE FAZ O PIC ENTRAR NO MODO SLEEP.
	NOP		    ;COMANDO LOGO AP�S O PIC SAIR DO SLEEP PARA VOLTAR AO ESTADO ORIGINAL ("SE ESPREGUI�AR" ^^)
	GOTO SEQUENCIALEDS  ;COMANDO QUE DESVIA PARA A LABEL "SEQUENCIALEDS" QUE CONTEM A ATIVIDADE A SER FEITA AP�S SAIR DO SLEEP.
	
SEQUENCIALEDS	;LABEL QUE CONTEM O QUE O PIC DEVE FAZER AP�S SAIR DO SLEEP.
	
	BCF PIR1, TMR1IF	;ZERA A FLAG QUE APONTA O OVERFLOW DO TIMER 1.
	BSF GPIO, GP0		;SETA O BIT GP0 DO REG GPIO PARA ACENDER O PRIMEIRO LED.
	MOVLW .176		;VALOR CALCULADO PARA TMR1L E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1L		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1L (TIMER 1 LOW)
	MOVLW .60		;VALOR CALCULADO PARA TMR1H E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1H		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1H (TIMER 1 HIGH)
	BTFSS PIR1, TMR1IF	;TESTA A FLAG PIR1 PARA SABER SE ELA � 0 OU 1, SE FOR 0, O OVERFLOW AINDA N�O OCORREU E O TESTE � REFEITO.
	GOTO $-1		;SE FOR 1, ESSA INSTRU��O � PULADA E EXECUTADA A PR�XIMA.
	
	BCF PIR1, TMR1IF	;A FLAG QUE APONTA O OVERFLOW DO TIMER 1 � ZERADA NOVAMENTE.
	BCF GPIO, GP0		;ZERA O BIT GP0 DO REG GPIO, APAGANDO ASSIM O PRIMEIRO LED AP�S 50 mS.
	BSF GPIO, GP1		;SETA O BIT GP1 DO REG GPIO, ACENDENDO ASSIM O SEGUNDO LED.
	MOVLW .176		;VALOR CALCULADO PARA TMR1L E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1L		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1L (TIMER 1 LOW)
	MOVLW .60		;VALOR CALCULADO PARA TMR1H E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1H		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1H (TIMER 1 HIGH)
	BTFSS PIR1, TMR1IF	;TESTA A FLAG PIR1 PARA SABER SE ELA � 0 OU 1, SE FOR 0, O OVERFLOW AINDA N�O OCORREU E O TESTE � REFEITO.
	GOTO $-1		;SE FOR 1, ESSA INSTRU��O � PULADA E � EXECUTADA A PR�XIMA.
	
	BCF PIR1, TMR1IF	;A FLAG QUE APONTA O OVERFLOW DO TIMER 1 � ZERADA NOVAMENTE.
	BCF GPIO, GP1		;ZERA O BIT GP1 DO REG GPIO, APAGANDO ASSIM O SEGUNDO LED AP�S 50 mS.
	BSF GPIO, GP2		;SETA O BIT GP2 DO REG GPIO, ACENDENDO ASSIM O TERCEIRO LED.
	MOVLW .176		;VALOR CALCULADO PARA TMR1L E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1L		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1L (TIMER 1 LOW)
	MOVLW .60		;VALOR CALCULADO PARA TMR1H E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1H		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1H (TIMER 1 HIGH)
	BTFSS PIR1, TMR1IF	;TESTA A FLAG PIR1 PARA SABER SE ELA � 0 OU 1, SE FOR 0, O OVERFLOW AINDA N�O OCORREU E O TESTE � REFEITO.
	GOTO $-1		;SE FOR 1, ESSA INSTRU��O � PULADA E � EXECUTADA A PR�XIMA.
	
	BCF PIR1, TMR1IF	;A FLAG QUE APONTA O OVERFLOW DO TIMER 1 � ZERADA NOVAMENTE.
	BCF GPIO, GP2		;ZERA O BIT GP2 DO REG GPIO, APAGANDO ASSIM O TERCEIRO LED AP�S 50 mS.
	BSF GPIO, GP5		;SETA O BIT GP5 DO REG GPIO, ACENDENDO ASSIM O QUARTO LED.
	MOVLW .176		;VALOR CALCULADO PARA TMR1L E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1L		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1L (TIMER 1 LOW)
	MOVLW .60		;VALOR CALCULADO PARA TMR1H E MOVIDO PARA O REG WORK PARA QUE O OVERFLOW OCORRA EM 50mS.
	MOVWF TMR1H		;MOVE ESSE VALOR DO REG WORK PARA O FILE TMR1H (TIMER 1 HIGH)
	BTFSS PIR1, TMR1IF	;TESTA A FLAG PIR1 PARA SABER SE ELA � 0 OU 1, SE FOR 0, O OVERFLOW AINDA N�O OCORREU E O TESTE � REFEITO.
	GOTO $-1		;SE FOR 1, ESSA INSTRU��O � PULADA E � EXECUTADA A PR�XIMA.
	BCF GPIO, GP5		;O BIT GP5 DO REG GPIO � ZERADO, APAGANDO ASSIM O QUARTO LED AP�S 50mS
	
	
	GOTO MAIN		;VOLTA AO MAIN PARA ENTRAR EM SLEEP E ASSIM FICAR EM LOOP
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END



