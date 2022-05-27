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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_CLKOUT ;GP4 CLOCKOUT HABILITADA

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
		CONTOVERFLOW      ;VÁRIÁVEL QUE CONTA A QUANTIDADE DE OVERFLOWS NO TIMER0
		VARDECREMENTO	  ;CONTA O TEMPO QUE O PIC FICARÁ OCIOSO DENTRO DO PERIODO DE 1ms.
		VAR1		  ;8 BITS MENOS SIGNIFICATIVOS DA VARIAVEL QUE ARMAZENA A QUANTIDADE DE PULSOS
		VAR2		  ;8 BITS MAIS SIGNIFICATIVOS DA VARIAVEL QUE ARMAZENA A QUANTIDADE DE PULSOS
				  ;VAR1 + VAR2 JUNTAS ARMAZENAM A QUANTIDADE DE PULSOS, POIS A MESMA É ACIMA DE 255.
		ANTERIOROSCCAL    ;ARMAZENA O VALOR ANTERIOR DE OSCCAL.
		
		

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
	
	INCF CONTOVERFLOW	;INCREMENTA O VALOR DA QUANTIDADE DE OVERFLOWS NO TIMER0
	MOVLW .7		;MOVE O VALOR 7 PARA O REG WORK (MEDINDO EM 458ms, PRECISARÁ DE 7 OVERFLOWS)
			        ; ^ OBS: 256x256(PRESCALE 1:256) * 7(OVERFLOWS) = 458.752us, EQUIVALENTE A 458 ms.
	SUBWF CONTOVERFLOW, W	;SUBTRAI O 7 DO CONTOVERFLOW
	BTFSS STATUS, Z		;FLAG INFICA SE O RESULTADO FOI 0 OU NÃO
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
	BSF GPIO, GP1		;NÃO TIVE TEMPO DE IMPLEMENTAR A SAIDA OSCILANDO, APENAS SETEI 1 CASO ESTEJA REGULADO
GOTO PISCAREGULADO		;POR MOTIVOS DE GASTRITE :/
	
	
	
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

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
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1			;ACESSA O BANCO 1
	MOVLW	B'00101000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000111'	;PRESCALE(1:256)
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'10100000'	;PERMITE INTERRUPÇÃO GLOBAL E INTERRUPÇÃO PELO OVERFLOW DO TIMER0
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	MOVLW   B'10000000'	;INICIA O OSCCAL COM A FREQUENCIA MEDIA
	MOVWF   OSCCAL		;MOVE O VALOR PARA O OSCCAL
	BANK0			;ACESSA O BANCO 0
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	BTFSS GPIO, GP5		;TESTA SE GP5 TEM NIVEL LOGICO ALTO
	GOTO $-1		;SENÃO, VOLTA A TESTAR
	INCF VAR1		;INCREMENTA A VAR1 (EXPLICAÇÃO DA VARIAVEL NO CAMPO DE VARIÁVEIS.)
	;BSF GPIO, GP0 ;TESTE
	BTFSC STATUS, C		;TESTA SE HOUVE OVERFLOW EM VAR1
	GOTO INC2	        ;CASO TENHA HAVIDO OVERFLOW, VAI PARA A LABEL INC2
	GOTO FOURDECREMENTO	;CASO NÃO, VAI PARA A LABEL FOURDECREMENTO
	
	GOTO MAIN		;VAI PARA A LABEL MAIN
	
        
INC2	INCF VAR2		;INCREMENTA A VAR2 (EXPLICAÇÃO DA VARIAVEL NO CAMPO DE VARIÁVEIS.)
	GOTO FOURDECREMENTO	;VAI PARA A LABEL FOURDECREMENTO
	
FOURDECREMENTO			;DEIXA O PIC OCIOSO POR APROX 990us POIS, 250 + 80 * 3 (O 3 É O CUSTO EM CICLOS DO GOTO E DECFSZ[LOOP])
	MOVLW .250		;250 = VALOR ESCOLHIDO PARA A VARIÁVEL DE DECREMENTO
	MOVWF VARDECREMENTO	;MOVE O VALOR DECIMAL 250 PARA O REG WORK
	DECFSZ VARDECREMENTO	;DECREMENTA VARDECREMENTO ATE 0
	GOTO $-1		;PRENDE NO LOOP ATE VARDECREMENTO ZERAR
	;BCF GPIO, GP0 ;TESTE
	MOVLW .80		;80 = VALOR ESCOLHIDO PARA A INCREMENTAÇÃO APÓS ZERAR A VARIAVEL VARDECREMENTO.
	MOVWF VARDECREMENTO     ;MOVE O VALOR DECIMAL 80 PARA O REG WORK
	DECFSZ VARDECREMENTO	;DECREMENTA VARDECREMENTO ATE 0
	GOTO $-1		;PRENDE NO LOOP ATE VARDECREMENTO ZERAR
	GOTO MAIN		;VAI PARA A LABEL MAIN PARA TESTAR NOVAMENTE
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 
	END
