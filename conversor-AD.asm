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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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
		
		AUX
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

	MOVF ADRESH, W	    ; Move o valor convertido para o registrador Work.
	MOVWF AUX	    ; Move o valor do Registrador Work para uma variavel auxiliar;
	BCF PIR1, ADIF	    ; Reseta a Flag de interrupção por término de conversão.
	
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
	MOVLW	B'00000110'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	MOVLW   B'00010010'	;Configurando a porta GP1 sendo analogico e escolhendo FOSC/8
	MOVWF   ANSEL 		
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'11000000'	;Ativado interrupção por periférico.
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	MOVLW   B'01000000'	;Ativado a conversão por fim de conversão.
	MOVWF   PIE1
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	MOVLW	B'00000101'	;Ativado o comparador e escolhidos o canal GP1.
	MOVWF	ADCON0
	
	
	;O CODIGO SE RESUME EM CONFIGURAR O CONVERSOR A/D USANDO ITERRUPÇÃO, DE MODO QUE 
	;A INTERRUPÇÃO ACONTECE NO FINAL DA CONVERSÃO, ONDE NA ROTINA DE INTERRUPÇÃO O VALOR
	;DE ADRESH É PASSADO PARA UMA VARIAVEL AUXILIAR QUE SERÁ SUBTRAIDA DE UMA SÉRIE DE VALORES
	;ATÉ ACHAR O INTERVALO NO QUAL A TENSÃO CORRESPONDE.
	
	;OS INTERVALOS FORAM CALCULADOS UTILIZANDO UMA REGRA DE TRÊS SIMPLES
	;COMO MOSTRADO EM SALA DE AULA.
	;COMO POR EXEMPLO 5V --> 255, ENTÃO 0.5V(VALOR MINIMO) ---> 25.
	;E ASSIM COM TODOS OS VALORES.
	
	;A VANTAGEM DE FAZER USANDO INTERRUPÇÃO É QUE:
	;O PIC NÃO FICARÁ OCIOSO A ESPERA DO FINAL DA CONVERSÃO.
	
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	
    BSF ADCON0, GO	    ;Iniciando a conversão (Respeitando o delay necessário).	
    
    MOVLW .25		    ;Move o valor 25 para o Registrador Work
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.
    GOTO DISPLAY0	    ;Caso Aux seja menor, mostra no Display o valor '0', senão, vai para a proxima comparação.
    
    MOVLW .51		    ;Move o valor 51 para o Registrador Work no formato decimal.
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.
    GOTO DISPLAY1	    ;Caso Aux seja menor, mostra no Display o valor '1', senão, vai para a proxima comparação.
    
    MOVLW .76		    ;Move o valor 76 para o Registrador Work no formato decimal.
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.	
    GOTO DISPLAY2	    ;Caso Aux seja menor, mostra no Display o valor '2', senão, vai para a proxima comparação.
    
    MOVLW .102		    ;Move o valor 102 para o Registrador Work no formato decimal.
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.
    GOTO DISPLAY3	    ;Caso Aux seja menor, mostra no Display o valor '3', senão, vai para a proxima comparação.
    
    MOVLW .127		    ;Move o valor 127 para o Registrador Work no formato decimal.	
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.	
    GOTO DISPLAY4	    ;Caso Aux seja menor, mostra no Display o valor '4', senão, vai para a proxima comparação.
    
    MOVLW .153		    ;Move o valor 153 para o Registrador Work no formato decimal.	
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.	
    GOTO DISPLAY5	    ;Caso Aux seja menor, mostra no Display o valor '5', senão, vai para a proxima comparação.
    
    MOVLW .178		    ;Move o valor 178 para o Registrador Work no formato decimal.	
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.	
    GOTO DISPLAY6	    ;Caso Aux seja menor, mostra no Display o valor '6', senão, vai para a proxima comparação.
    
    MOVLW .204		    ;Move o valor 204 para o Registrador Work no formato decimal.	
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.	
    GOTO DISPLAY7	    ;Caso Aux seja menor, mostra no Display o valor '7', senão, vai para a proxima comparação.
    
    MOVLW .229		    ;Move o valor 229 para o Registrador Work no formato decimal.
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.	
    GOTO DISPLAY8	    ;Caso Aux seja menor, mostra no Display o valor '8', senão, vai para a proxima comparação.
    
    MOVLW  .255		    ;Move o valor 255 para o Registrador Work no formato decimal.
    SUBWF AUX, W	    ;Subtrai o valor do Registrador Work da variavel auxiliar.
    BTFSS STATUS, C	    ;Verifica o Carry On pelo bit C do Registrador STATUS.
    GOTO DISPLAY9	    ;Caso Aux seja menor, mostra no Display o valor '9'.

	GOTO MAIN

DISPLAY0	BCF GPIO, GP5	    ;SETA OU ZERA AS SAÍDAS GP0,GP2,GP4,GP5
		BCF GPIO, GP4	    ;DE ACORDO COM O NUMERO QUE SE QUER EM BINÁRIO.
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



