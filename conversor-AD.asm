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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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
		
		AUX
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

	MOVF ADRESH, W	    ; Move o valor convertido para o registrador Work.
	MOVWF AUX	    ; Move o valor do Registrador Work para uma variavel auxiliar;
	BCF PIR1, ADIF	    ; Reseta a Flag de interrup��o por t�rmino de convers�o.
	
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
	MOVLW	B'00000110'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	MOVLW   B'00010010'	;Configurando a porta GP1 sendo analogico e escolhendo FOSC/8
	MOVWF   ANSEL 		
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'11000000'	;Ativado interrup��o por perif�rico.
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	MOVLW   B'01000000'	;Ativado a convers�o por fim de convers�o.
	MOVWF   PIE1
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	MOVLW	B'00000101'	;Ativado o comparador e escolhidos o canal GP1.
	MOVWF	ADCON0
	
	
	;O CODIGO SE RESUME EM CONFIGURAR O CONVERSOR A/D USANDO ITERRUP��O, DE MODO QUE 
	;A INTERRUP��O ACONTECE NO FINAL DA CONVERS�O, ONDE NA ROTINA DE INTERRUP��O O VALOR
	;DE ADRESH � PASSADO PARA UMA VARIAVEL AUXILIAR QUE SER� SUBTRAIDA DE UMA S�RIE DE VALORES
	;AT� ACHAR O INTERVALO NO QUAL A TENS�O CORRESPONDE.
	
	;OS INTERVALOS FORAM CALCULADOS UTILIZANDO UMA REGRA DE TR�S SIMPLES
	;COMO MOSTRADO EM SALA DE AULA.
	;COMO POR EXEMPLO 5V --> 255, ENT�O 0.5V(VALOR MINIMO) ---> 25.
	;E ASSIM COM TODOS OS VALORES.
	
	;A VANTAGEM DE FAZER USANDO INTERRUP��O � QUE:
	;O PIC N�O FICAR� OCIOSO A ESPERA DO FINAL DA CONVERS�O.
	
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	
    BSF ADCON0, GO	    ;Iniciando a convers�o (Respeitando o delay necess�rio).	
    
    MOVLW .25		    ;Move o valor 25 para o Registrador Work
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.
    GOTO DISPLAY0	    ;Caso Aux seja menor, mostra no Display o valor '0', sen�o, vai para a proxima compara��o.
    
    MOVLW .51		    ;Move o valor 51 para o Registrador Work no formato decimal.
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.
    GOTO DISPLAY1	    ;Caso Aux seja menor, mostra no Display o valor '1', sen�o, vai para a proxima compara��o.
    
    MOVLW .76		    ;Move o valor 76 para o Registrador Work no formato decimal.
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.	
    GOTO DISPLAY2	    ;Caso Aux seja menor, mostra no Display o valor '2', sen�o, vai para a proxima compara��o.
    
    MOVLW .102		    ;Move o valor 102 para o Registrador Work no formato decimal.
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.
    GOTO DISPLAY3	    ;Caso Aux seja menor, mostra no Display o valor '3', sen�o, vai para a proxima compara��o.
    
    MOVLW .127		    ;Move o valor 127 para o Registrador Work no formato decimal.	
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.	
    GOTO DISPLAY4	    ;Caso Aux seja menor, mostra no Display o valor '4', sen�o, vai para a proxima compara��o.
    
    MOVLW .153		    ;Move o valor 153 para o Registrador Work no formato decimal.	
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.	
    GOTO DISPLAY5	    ;Caso Aux seja menor, mostra no Display o valor '5', sen�o, vai para a proxima compara��o.
    
    MOVLW .178		    ;Move o valor 178 para o Registrador Work no formato decimal.	
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.	
    GOTO DISPLAY6	    ;Caso Aux seja menor, mostra no Display o valor '6', sen�o, vai para a proxima compara��o.
    
    MOVLW .204		    ;Move o valor 204 para o Registrador Work no formato decimal.	
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.	
    GOTO DISPLAY7	    ;Caso Aux seja menor, mostra no Display o valor '7', sen�o, vai para a proxima compara��o.
    
    MOVLW .229		    ;Move o valor 229 para o Registrador Work no formato decimal.
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.	
    GOTO DISPLAY8	    ;Caso Aux seja menor, mostra no Display o valor '8', sen�o, vai para a proxima compara��o.
    
    MOVLW  .255		    ;Move o valor 255 para o Registrador Work no formato decimal.
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.
    GOTO DISPLAY9	    ;Caso Aux seja menor, mostra no Display o valor '9'.

	GOTO MAIN

DISPLAY0	BCF GPIO, GP5	    ;SETA OU ZERA AS SA�DAS GP0,GP2,GP4,GP5
		BCF GPIO, GP4	    ;DE ACORDO COM O NUMERO QUE SE QUER EM BIN�RIO.
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



