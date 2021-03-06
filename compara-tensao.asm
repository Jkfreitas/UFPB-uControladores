;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA??ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSU                         *
;*                    FEVEREIRO DE 2014                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS?O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI??O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI??ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR?O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA??O DE MEM?RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI??O DE COMANDOS DE USU?RIO PARA ALTERA??O DA P?GINA DE MEM?RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM?RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM?RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI?VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI??O DOS NOMES E ENDERE?OS DE TODAS AS VARI?VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE?O INICIAL DA MEM?RIA DE
					;USU?RIO
		W_TEMP		;REGISTRADORES TEMPOR?RIOS PARA USO
		STATUS_TEMP	;JUNTO ?S INTERRUP??ES
		DADO		;ARMAZENA O DADO PARA A EEPROM

		;NOVAS VARI?VEIS

	ENDC			;FIM DO BLOCO DE MEM?RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI??O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI??O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
; INICIALIZA??O DA EEPROM, DE ACORDO COM A DESCRI??O NO ARQUIVO "Def_Rega_Formigas.inc"

;A PARTIR DO ENDERE?O ZERO DA EEPROM, DADOS EM ORDEM ALEAT?RIA
	ORG 0x2100
	DE	0X89,0X1E,0X39,0X9F,0XC2,0X0C,0XAB,0X33,0X63,0XD3,0X95,0X7B,0X38,0XD6,0X1E,0X48
	DE	0XDB,0XD8,0X86,0XFD,0XA5,0XFC,0X0C,0XBE,0X68,0X9B,0XD9,0X10,0XD8,0XEC,0X90,0X91
	DE	0XAA,0XBB,0XCC,0XDD,0XEE,0XF1,0XC9,0X77

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI??O DE TODOS OS PINOS QUE SER?O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB?M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA?DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI??O DE TODOS OS PINOS QUE SER?O UTILIZADOS COMO SA?DA
; RECOMENDAMOS TAMB?M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE?O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN?CIO DA INTERRUP??O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE?O DE DESVIO DAS INTERRUP??ES. A PRIMEIRA TAREFA ? SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA??O FUTURA

	ORG	0x04			;ENDERE?O INICIAL DA INTERRUP??O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP??O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER?O ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP??ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA?DA DA INTERRUP??O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP??O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI??O DE FUNCIONAMENTO
; E UM NOME COERENTE ?S SUAS FUN??ES.
LE_EEPROM
;LER DADO DA EEPROM, CUJO ENDERE?O ? INDICADO EM W
;DADO LIDO RETORNA EM W
	ANDLW	.127		;LIMITA ENDERE?O MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR		;INDICA O END. DE LEITURA
	BSF		EECON1,RD	;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W	;COLOCA DADO LIDO EM W
	BANK0				;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
;ESCREVE DADO (DADO) NA EEPROM, CUJO ENDERE?O ? INDICADO EM W
	ANDLW	.127		;LIMITA ENDERE?O MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF		EECON1,WREN ;HABILITA ESCRITA
	BCF		INTCON,GIE	;DESLIGA INTERRUP??ES
	MOVLW	B'01010101'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	MOVLW	B'10101010'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	BSF		EECON1,WR ;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR ;TERMINOU?
	GOTO	AGUARDA
	BSF		INTCON,GIE ;HABILITA INTERRUP??ES
	BANK0				;POSICIONA PARA BANK 0
	RETURN

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000010'     ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS) ;SETA A PORTA 1 DO TRISIO COMO ENTRADA
	MOVWF	TRISIO	
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O ;CONFIGURA PORTA GP1 COMO ANAL?GICO
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP??ES DE OPERA??O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP??ES DE INTERRUP??ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000100'	;CONFIG QUE COMPARA GP1 COM Vref E ARMAZENA O RESULTADO EM Cout
	MOVWF	CMCON		;DEFINE O MODO DE OPERA??O DO COMPARADOR ANAL?GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA??O DAS VARI?VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	; A IDEIA DO QUE FOI FEITO NO MAIN ? ESCOLHER UM VALOR PARA O VRCON QUE SER? COMPARADO COM A ENTRADA GP1
	; A ENTRADA GP1 POR SUA VEZ, TER? QUE PASSAR POR UM DIVISOR DE TENS?O, POIS O VALOR DA TENS?O DE ENTRADA 
	; ? ALTO DEMAIS PARA SER COMPARADO COM A REFERENCIA INTERNA QUE N?O CHEGA A 5V.
	; OS VALORES DOS RESITORES NO DIVISOR DE TENS?O SER? DE R1=1.8K E R2=1.3K.
	
	;*******   TABELA REAJUSTADA DEVIDO AO USO DO DIVISOR DE TENS?O EM RELA??O A TENS?O DE 0V A 5V ******;
	;----------------------------------------------------------------------------------------------------
	;       NOVO VALOR PROPORCIONAL DA TENS?O V	    	        /  VALOR MOSTRADO NO DISPLAY
	;		 V <0,20833					/	    0
	;	0,20833 (< ou = )V <0,41667				/	    1
	;	0,41667 (< ou = )V <0,62499				/	    2
	;	0,62499 (< ou = )V <0,83332				/	    3
	;	0,83332 (< ou = )V <1,04165				/	    4
	;	1,04165 (< ou = )V <1,24998				/	    5
	;	1,24998 (< ou = )V <1,45831				/	    6
	;	1,45831 (< ou = )V <1,66664				/	    7
	;	1,66664 (< ou = )V <1,87497		      	        /	    8
	;	1,87497 (< ou = )V < ou = ) 2,0833		    	/	    9
	
	;ESCOLHENDO UM VALOR PARA O VRCON, O COMPARADOR VAI COMPARAR A GP1 COM ESSE VALOR, SE FOR MENOR QUE O VALOR REFERENCIA
	;ENTENDE SE QUE A GP1 EST? DENTRO DO INTERVALO, CASO SEJA MAIOR ELE IR? COMPARAR COM O PROXIMO INTERVALO.
	
	
	BANK1
	MOVLW B'10100001' ;CONFIGURA OS BITS DO REG VRCON / BIT7 = ENABLE, BIT5 = LOW RANG, BIT<0:3> = VALOR A SER COMPARADO (0,20833 V)
	MOVWF VRCON	  ;MOVE O VALOR DO REG WORK PARA O VRCON  
	BANK0		  ;ACESSA O BANCO 1
	BTFSC CMCON, COUT ;SE O COUT=0, ELE CONTINUA ANALISANDO, SEN?O, ELE DETECTA O INTERVALO E MANDA PRO DISPLAY
	GOTO DISPLAY0	  ;PULA PARA A FUN??O QUE MOSTRA O VALOR NO DISPLAY
	
	BANK1
	MOVLW B'10100010' ;BIT7 = ENABLE, BIT5 = LOW RANG, BIT<0:3> = VALOR A SER COMPARADO (0,41667 V)
	MOVWF VRCON	  ;MOVE O VALOR DO REG WORK PARA O VRCON  
	BANK0		  ;ACESSA O BANCO 1
	BTFSC CMCON, COUT ;SE O COUT=0, ELE CONTINUA ANALISANDO, SEN?O, ELE DETECTA O INTERVALO E MANDA PRO DISPLAY
	GOTO DISPLAY1	  ;PULA PARA A FUN??O QUE MOSTRA O VALOR NO DISPLAY
	
	BANK1
	MOVLW B'10100011' ;BIT7 = ENABLE, BIT5 = LOW RANG, BIT<0:3> = VALOR A SER COMPARADO (0,62499 V)
	MOVWF VRCON	  ;MOVE O VALOR DO REG WORK PARA O VRCON  
	BANK0		  ;ACESSA O BANCO 1
	BTFSC CMCON, COUT ;SE O COUT=0, ELE CONTINUA ANALISANDO, SEN?O, ELE DETECTA O INTERVALO E MANDA PRO DISPLAY
	GOTO DISPLAY2	  ;PULA PARA A FUN??O QUE MOSTRA O VALOR NO DISPLAY
	
	BANK1
	MOVLW B'10100100' ;BIT7 = ENABLE, BIT5 = LOW RANG, BIT<0:3> = VALOR A SER COMPARADO (0,83332 V)
	MOVWF VRCON	  ;MOVE O VALOR DO REG WORK PARA O VRCON  
	BANK0		  ;ACESSA O BANCO 1
	BTFSC CMCON, COUT ;SE O COUT=0, ELE CONTINUA ANALISANDO, SEN?O, ELE DETECTA O INTERVALO E MANDA PRO DISPLAY
	GOTO DISPLAY3	  ;PULA PARA A FUN??O QUE MOSTRA O VALOR NO DISPLAY
	
	BANK1
	MOVLW B'10100101' ;BIT7 = ENABLE, BIT5 = LOW RANG, BIT<0:3> = VALOR A SER COMPARADO (1,04165 V)
	MOVWF VRCON	  ;MOVE O VALOR DO REG WORK PARA O VRCON  
	BANK0		  ;ACESSA O BANCO 1
	BTFSC CMCON, COUT ;SE O COUT=0, ELE CONTINUA ANALISANDO, SEN?O, ELE DETECTA O INTERVALO E MANDA PRO DISPLAY
	GOTO DISPLAY4	  ;PULA PARA A FUN??O QUE MOSTRA O VALOR NO DISPLAY
	
	BANK1
	MOVLW B'10100110' ;BIT7 = ENABLE, BIT5 = LOW RANG, BIT<0:3> = VALOR A SER COMPARADO (1,24998 V)
	MOVWF VRCON	  ;MOVE O VALOR DO REG WORK PARA O VRCON  
	BANK0		  ;ACESSA O BANCO 1
	BTFSC CMCON, COUT ;SE O COUT=0, ELE CONTINUA ANALISANDO, SEN?O, ELE DETECTA O INTERVALO E MANDA PRO DISPLAY
	GOTO DISPLAY5	  ;PULA PARA A FUN??O QUE MOSTRA O VALOR NO DISPLAY
	
	BANK1
	MOVLW B'10100111' ;BIT7 = ENABLE, BIT5 = LOW RANG, BIT<0:3> = VALOR A SER COMPARADO (1,45831 V)
	MOVWF VRCON	  ;MOVE O VALOR DO REG WORK PARA O VRCON  
	BANK0		  ;ACESSA O BANCO 1
	BTFSC CMCON, COUT ;SE O COUT=0, ELE CONTINUA ANALISANDO, SEN?O, ELE DETECTA O INTERVALO E MANDA PRO DISPLAY
	GOTO DISPLAY6	  ;PULA PARA A FUN??O QUE MOSTRA O VALOR NO DISPLAY
	
	BANK1
	MOVLW B'10101000' ;BIT7 = ENABLE, BIT5 = LOW RANG, BIT<0:3> = VALOR A SER COMPARADO (1,66664 V)
	MOVWF VRCON	  ;MOVE O VALOR DO REG WORK PARA O VRCON  
	BANK0		  ;ACESSA O BANCO 1
	BTFSC CMCON, COUT ;SE O COUT=0, ELE CONTINUA ANALISANDO, SEN?O, ELE DETECTA O INTERVALO E MANDA PRO DISPLAY
	GOTO DISPLAY7	  ;PULA PARA A FUN??O QUE MOSTRA O VALOR NO DISPLAY
	
	BANK1
	MOVLW B'10101001' ;BIT7 = ENABLE, BIT5 = LOW RANG, BIT<0:3> = VALOR A SER COMPARADO (1,87497 V)
	MOVWF VRCON	  ;MOVE O VALOR DO REG WORK PARA O VRCON  
	BANK0		  ;ACESSA O BANCO 1
	BTFSC CMCON, COUT ;SE O COUT=0, ELE CONTINUA ANALISANDO, SEN?O, ELE DETECTA O INTERVALO E MANDA PRO DISPLAY
	GOTO DISPLAY8	  ;PULA PARA A FUN??O QUE MOSTRA O VALOR NO DISPLAY
	
	BANK1
	MOVLW B'10101010' ;BIT7 = ENABLE, BIT5 = LOW RANG, BIT<0:3> = VALOR A SER COMPARADO (2,0833 V)
	MOVWF VRCON	  ;MOVE O VALOR DO REG WORK PARA O VRCON  
	BANK0		  ;ACESSA O BANCO 1
	BTFSC CMCON, COUT ;SE O COUT=0, ELE CONTINUA ANALISANDO, SEN?O, ELE DETECTA O INTERVALO E MANDA PRO DISPLAY
	GOTO DISPLAY9	  ;PULA PARA A FUN??O QUE MOSTRA O VALOR NO DISPLAY
	GOTO MAIN

	;ESCOLHENDO UM VALOR PARA O VRCON, O COMPARADOR VAI COMPARAR A GP1 COM ESSE VALOR, SE FOR MENOR QUE O VALOR REFERENCIA
	;ENTENDE SE QUE A GP1 EST? DENTRO DO INTERVALO, CASO SEJA MAIOR ELE IR? COMPARAR COM O PROXIMO INTERVALO
	

DISPLAY0	BCF GPIO, GP5	    ;SETA OU ZERA AS SA?DAS GP0,GP2,GP4,GP5
		BCF GPIO, GP4	    ;DE ACORDO COM O NUMERO QUE SE QUER EM BIN?RIO.
		BCF GPIO, GP2
		BCF GPIO, GP0	    ;E ASSIM SUCESSIVAMENTE NAS LABELS ABAIXO.
		GOTO MAIN
DISPLAY1	BCF GPIO, GP5
		BCF GPIO, GP4
		BCF GPIO, GP2
		BSF GPIO, GP0
		GOTO MAIN
DISPLAY2	BCF GPIO, GP5
		BCF GPIO, GP4
		BSF GPIO, GP2
		BCF GPIO, GP0
		GOTO MAIN
DISPLAY3	BCF GPIO, GP5
		BCF GPIO, GP4
		BSF GPIO, GP2
		BSF GPIO, GP0
		GOTO MAIN
DISPLAY4	BCF GPIO, GP5
		BSF GPIO, GP4
		BCF GPIO, GP2
		BCF GPIO, GP0
		GOTO MAIN
DISPLAY5	BCF GPIO, GP5
		BSF GPIO, GP4
		BCF GPIO, GP2
		BSF GPIO, GP0
		GOTO MAIN
DISPLAY6	BCF GPIO, GP5
		BSF GPIO, GP4
		BSF GPIO, GP2
		BCF GPIO, GP0
		GOTO MAIN
DISPLAY7	BCF GPIO, GP5
		BSF GPIO, GP4
		BSF GPIO, GP2
		BSF GPIO, GP0
		GOTO MAIN
DISPLAY8	BSF GPIO, GP5
		BCF GPIO, GP4
		BCF GPIO, GP2
		BCF GPIO, GP0
		GOTO MAIN
DISPLAY9	BSF GPIO, GP5
		BCF GPIO, GP4
		BCF GPIO, GP2
		BSF GPIO, GP0
		GOTO MAIN




;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END


	

