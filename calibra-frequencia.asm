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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_CLKOUT ;GP4 CLOCKOUT HABILITADA

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
		CONTOVERFLOW      ;V�RI�VEL QUE CONTA A QUANTIDADE DE OVERFLOWS NO TIMER0
		VARDECREMENTO	  ;CONTA O TEMPO QUE O PIC FICAR� OCIOSO DENTRO DO PERIODO DE 1ms.
		VAR1		  ;8 BITS MENOS SIGNIFICATIVOS DA VARIAVEL QUE ARMAZENA A QUANTIDADE DE PULSOS
		VAR2		  ;8 BITS MAIS SIGNIFICATIVOS DA VARIAVEL QUE ARMAZENA A QUANTIDADE DE PULSOS
				  ;VAR1 + VAR2 JUNTAS ARMAZENAM A QUANTIDADE DE PULSOS, POIS A MESMA � ACIMA DE 255.
		ANTERIOROSCCAL    ;ARMAZENA O VALOR ANTERIOR DE OSCCAL.
		
		

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
	
	INCF CONTOVERFLOW	;INCREMENTA O VALOR DA QUANTIDADE DE OVERFLOWS NO TIMER0
	MOVLW .7		;MOVE O VALOR 7 PARA O REG WORK (MEDINDO EM 458ms, PRECISAR� DE 7 OVERFLOWS)
			        ; ^ OBS: 256x256(PRESCALE 1:256) * 7(OVERFLOWS) = 458.752us, EQUIVALENTE A 458 ms.
	SUBWF CONTOVERFLOW, W	;SUBTRAI O 7 DO CONTOVERFLOW
	BTFSS STATUS, Z		;FLAG INFICA SE O RESULTADO FOI 0 OU N�O
	GOTO SAI_INT		;SE A FLAG FOR 0 (RESULTADO DA SUB FOR DIFERENTE DE 0), VOLTA PRO CODIGO PARA CONTAR
	
REGULA_OSCCAL			;LABEL QUE REGULA O OSCCAL DE ACORDO COM A FREQUENCIA CAPTURADA
	
	MOVLW .1
	SUBWF VAR2, W

	BTFSC STATUS, Z
        GOTO (TESTA_VAR1)
				    
	MOVLW .1
	SUBWF VAR2, W
        BTFSC STATUS, C

        GOTO DECOSCCAL
	GOTO INCOSCCAL
	
TESTA_VAR1		    ;TESTA A VARIAVEL 1 E COMPARA 
	
	MOVLW .202		;458 - 256(BITS) = 202  
	SUBWF VAR1, W
	
	BTFSC STATUS, Z
	GOTO PISCAREGULADO      
	MOVLW .202
	SUBWF VAR1 , W
	BTFSC STATUS, C
	GOTO DECOSCCAL
	GOTO INCOSCCAL

INCOSCCAL
	
	MOVF ANTERIOROSCCAL
	SUBWF OSCCAL, W
	BTFSC STATUS, Z
	GOTO PISCAREGULADO
	
	MOVF OSCCAL		    ;METODO QUE INCREMENTA E DECREMENTA O OSCCAL..
	MOVWF ANTERIOROSCCAL	    ;..QUANDO O OSSCAAL INCREMENTA OU DECREMENTA, A VARIAVEL ANTERIOROSCCAL..
				    ;..RECEBE O VALOR ANTERIOR DE OSCCAL, DE MODO QUE QUANDO ELA INCREMENTAR OU DECREMENTAR..
	MOVLW .4		    ;.. DE VOLTA E AMBAS FOREM IGUAIS, O PIC CONSIDERA A FREQUENCIA REGULADA
	ADDWF OSCCAL		    
	
	;BANK0
	BCF GPIO, GP2
	BSF GPIO, GP0
	
GOTO SAI_INT


DECOSCCAL			;LABEL QUE TESTA E DECREMENTA O OSCCALCASO A FREQUENCIA ESTEJA ACIMA DA REFERENCIA
	
	MOVF ANTERIOROSCCAL	;FUNCIONA DO MESMO JEITO EXPLICADO NA LABEL INCOSCCAL
	SUBWF OSCCAL, W
	BTFSC STATUS, Z
	GOTO PISCAREGULADO
	
	MOVF OSCCAL
	MOVWF ANTERIOROSCCAL
	
	MOVLW .4
	SUBWF OSCCAL
	
	BCF GPIO, GP0
	BSF GPIO, GP2
	
GOTO SAI_INT
	
PISCAREGULADO
	;BANK0
	BSF GPIO, GP1		;N�O TIVE TEMPO DE IMPLEMENTAR A SAIDA OSCILANDO, APENAS SETEI 1 CASO ESTEJA REGULADO
GOTO PISCAREGULADO		;POR MOTIVOS DE GASTRITE :/
	
	
	
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	BANK1
	BCF INTCON, T0IF
	BANK0
	MOVLW B'00000000'
	MOVWF TMR0
	
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
	BANK1			;ACESSA O BANCO 1
	MOVLW	B'00101000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000111'	;PRESCALE(1:256)
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'10100000'	;PERMITE INTERRUP��O GLOBAL E INTERRUP��O PELO OVERFLOW DO TIMER0
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	MOVLW   B'10000000'	;INICIA O OSCCAL COM A FREQUENCIA MEDIA
	MOVWF   OSCCAL		;MOVE O VALOR PARA O OSCCAL
	BANK0			;ACESSA O BANCO 0
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	BTFSS GPIO, GP5		;TESTA SE GP5 TEM NIVEL LOGICO ALTO
	GOTO $-1		;SEN�O, VOLTA A TESTAR
	INCF VAR1		;INCREMENTA A VAR1 (EXPLICA��O DA VARIAVEL NO CAMPO DE VARI�VEIS.)
	;BSF GPIO, GP0 ;TESTE
	BTFSC STATUS, C		;TESTA SE HOUVE OVERFLOW EM VAR1
	GOTO INC2	        ;CASO TENHA HAVIDO OVERFLOW, VAI PARA A LABEL INC2
	GOTO FOURDECREMENTO	;CASO N�O, VAI PARA A LABEL FOURDECREMENTO
	
	GOTO MAIN		;VAI PARA A LABEL MAIN
	
        
INC2	INCF VAR2		;INCREMENTA A VAR2 (EXPLICA��O DA VARIAVEL NO CAMPO DE VARI�VEIS.)
	GOTO FOURDECREMENTO	;VAI PARA A LABEL FOURDECREMENTO
	
FOURDECREMENTO			;DEIXA O PIC OCIOSO POR APROX 990us POIS, 250 + 80 * 3 (O 3 � O CUSTO EM CICLOS DO GOTO E DECFSZ[LOOP])
	MOVLW .250		;250 = VALOR ESCOLHIDO PARA A VARI�VEL DE DECREMENTO
	MOVWF VARDECREMENTO	;MOVE O VALOR DECIMAL 250 PARA O REG WORK
	DECFSZ VARDECREMENTO	;DECREMENTA VARDECREMENTO ATE 0
	GOTO $-1		;PRENDE NO LOOP ATE VARDECREMENTO ZERAR
	;BCF GPIO, GP0 ;TESTE
	MOVLW .80		;80 = VALOR ESCOLHIDO PARA A INCREMENTA��O AP�S ZERAR A VARIAVEL VARDECREMENTO.
	MOVWF VARDECREMENTO     ;MOVE O VALOR DECIMAL 80 PARA O REG WORK
	DECFSZ VARDECREMENTO	;DECREMENTA VARDECREMENTO ATE 0
	GOTO $-1		;PRENDE NO LOOP ATE VARDECREMENTO ZERAR
	GOTO MAIN		;VAI PARA A LABEL MAIN PARA TESTAR NOVAMENTE
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 
	END
