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
		COUNT ;VARIÁVEL QUE VAI ARMAZENAR A QUANTIDADE DE PULSOS POR 'BURST'

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
	MOVLW	B'00000100' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	
	MOVLW	B'00000100'	
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO.
	
	MOVLW	B'01010000'	;INTE<4>, SET. (CONFIGURA GP2 COMO INTERRUPÇÃO)|PEIE<6>, SET...
				;...(CONFIGURA INTERRUPÇÕES PERIFÉRICAS).
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES.
	
	MOVLW	B'00000001'	;TMR1IE<0>, SET. (CONFIGURA TIMER1 COMO INTERRUPÇÃO NO OVERFLOW).
	MOVWF	PIE1		;CONFIGURAÇÃO DE INTERRUPÇÕES PERIFÉRICAS.
	
	BANK0				;RETORNA PARA O BANCO 0.
	MOVLW	B'00000111'	
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	
	MOVLW	B'00000001'	;ENABLE TIMER1
	MOVWF	T1CON		;CONFIGURAÇÕES DO TIMER1
	
	MOVLW	B'00000000'	
	MOVWF	PIR1		;FLAGS DE INTERRUPÇÕES PERIFÉRICAS
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN	BANK0				;TROCA DE BANCO
	BCF PIR1, TMR1IF		;LIMPA A INTERRUPÇÃO DE TIMER1 POR OVERFLOW
	
	BANK1				;TROCA DE BANCO
	BCF OPTION_REG, INTEDG		;AMBOS OS BITS DEVEM SER LIMPOS...
	BCF INTCON, INTF		;...PARA SEREM USADOS NA SEGUNDA INTERAÇÃO DO MAIN, CASO HAJA.
	
	MOVLW .0
	MOVWF COUNT			;INICIA O COUNT COM ZERO.
	
	SLEEP				;SLEEP ATE DETECTAR UMA BORDA DE DESCIDA.
	NOP				;GARANTE A INICIAÇÃO COMPLETA DO PIC.
	
	INCF COUNT			;INCREMENTO QUE SERVE PARA CONTAR O PULSO.
	

DORME	BSF OPTION_REG, INTEDG		;CONFIGURA A INTERRUPÇÃO PARA BORDA DE SUBIDA.
	BCF INTCON, INTF		;LIMPA O INTCON PARA RESETAR A INTERRUPÇÃO
	
	MOVLW	B'11111111'	;8 BITS MAIS SIGNIFICATIVOS DO TIMER 1
	MOVWF	TMR1H
	MOVLW	B'10011011'	;8 BITS MENOS SIGNIFICATIVOS DO TIMER 1
	MOVWF	TMR1L		;TIMER1 SERÁ USADO COMO INTERRUPÇÃO NO OVERFLOW
	 
	SLEEP			;SLEEP ATE DETECTAR UMA BORDA DE SUBIDA OU OVERFLOW
	NOP			;GARANTE A INICIAÇÃO COMPLETA DO PIC.
	
	BANK0			;TROCA DE BANCO PARA LER GPIO
	BTFSS GPIO, GP2		;GP2 = 0, FIM DO BUSRT. GP2 = 1, INCREMENTA.
	GOTO SETABITS		;DIRECIONA PARA A LABEL SETABITS
	INCF COUNT		;INCREMENTA CONT
	
	BTFSC GPIO, GP2		;GP2 = 1, LOOP. GP2 = 0, SLEEP. 
	GOTO $-1
	
	GOTO DORME		;VOLTA PRO SLEEP E RECONTA.

SETABITS    ;FUNÇÃO SETABITS (IDENTIFICA O BCD QUE VAI PARA O DISPLAY)
	
    BANK0
	
    MOVLW .1		    ; MOVE O VALOR A SER COMPARADO PARA O WORK
    SUBWF COUNT		    ; SUBTRAI DE COUNT
    BTFSC STATUS, Z	    ; CHECA SE O RESULTADO DA OPERAÇÃO FOI 0
    GOTO UM		    ; SE SIM, VAI PARA A FUNÇÃO E MOSTRA NO DISPLAY O NUMERO
    ADDWF COUNT		    ; SENÃO, READICIONA O VALOR SUBTRAIDO E PARTE PARA A PROXIMA OPÇÃO DE ANÁLISE.
    
    MOVLW .2
    SUBWF COUNT
    BTFSC STATUS, Z
    GOTO DOIS
    ADDWF COUNT
    
    MOVLW .3
    SUBWF COUNT
    BTFSC STATUS, Z
    GOTO TRES
    ADDWF COUNT
    
    MOVLW .4
    SUBWF COUNT
    BTFSC STATUS, Z
    GOTO QUATRO
    ADDWF COUNT
    
    MOVLW .5
    SUBWF COUNT
    BTFSC STATUS, Z
    GOTO CINCO
    ADDWF COUNT
    
    MOVLW .6
    SUBWF COUNT
    BTFSC STATUS, Z
    GOTO SEIS
    ADDWF COUNT
    
    MOVLW .7
    SUBWF COUNT
    BTFSC STATUS, Z
    GOTO SETE
    ADDWF COUNT
    
    MOVLW .8
    SUBWF COUNT
    BTFSC STATUS, Z
    GOTO OITO
    ADDWF COUNT
    
    MOVLW .9
    SUBWF COUNT
    BTFSC STATUS, Z
    GOTO NOVE
    ADDWF COUNT
	
MOSTRADISPLAY	;MOSTRA NUMEROS NO DISPLAY
	
	ZERO	BCF GPIO, GP5	    ;SETA OU ZERA AS SAÍDAS GP0,GP1,GP4,GP5
		BCF GPIO, GP4	    ;DE ACORDO COM O NUMERO QUE SE QUER EM BINÁRIO.
		BCF GPIO, GP1
		BCF GPIO, GP0
		GOTO INICIO
	UM	BCF GPIO, GP5
		BCF GPIO, GP4
		BCF GPIO, GP1
		BSF GPIO, GP0
		GOTO INICIO
	DOIS	BCF GPIO, GP5
		BCF GPIO, GP4
		BSF GPIO, GP1
		BCF GPIO, GP0
		GOTO INICIO
	TRES	BCF GPIO, GP5
		BCF GPIO, GP4
		BSF GPIO, GP1
		BSF GPIO, GP0
		GOTO INICIO
	QUATRO	BCF GPIO, GP5
		BSF GPIO, GP4
		BCF GPIO, GP1
		BCF GPIO, GP0
		GOTO INICIO
	CINCO	BCF GPIO, GP5
		BSF GPIO, GP4
		BCF GPIO, GP1
		BSF GPIO, GP0
		GOTO INICIO
	SEIS	BCF GPIO, GP5
		BSF GPIO, GP4
		BSF GPIO, GP1
		BCF GPIO, GP0
		GOTO INICIO
	SETE	BCF GPIO, GP5
		BSF GPIO, GP4
		BSF GPIO, GP1
		BSF GPIO, GP0
		GOTO INICIO
	OITO	BSF GPIO, GP5
		BCF GPIO, GP4
		BCF GPIO, GP1
		BCF GPIO, GP0
		GOTO INICIO
	NOVE	BSF GPIO, GP5
		BCF GPIO, GP4
		BCF GPIO, GP1
		BSF GPIO, GP0
		GOTO INICIO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END


	;Olá, Professor! Gostaria de deixar claro que a iniciativa de estudar um conteudo mais
	;adiante da ementa partiu de mim em conjunto com Gabriel Formiga.
	;Estudamos juntos para as disciplinas faz uns periodos e quando eu falei da ideia pra ele
	;Ele me ajudou a entender algumas coisas e vice versa. Porem, so eu segui em frente com a ideia (: 
	;de entregar o codigo dessa maneira.
	
	;Ele está funcionando perfeitamente quando debugado, porem em testes no laboratorio
	;com o monitor, o circuito de teste estava apresentando instabilidade ate para o codigo que ele fez
	;portanto, estou confiando no debug.
	
	;Estou especificando isso por ter consciencia de que deve ser reconhecido.
	

