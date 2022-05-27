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
		COUNT ;VARI�VEL QUE VAI ARMAZENAR A QUANTIDADE DE PULSOS POR 'BURST'

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
	MOVLW	B'00000100' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	
	MOVLW	B'00000100'	
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O.
	
	MOVLW	B'01010000'	;INTE<4>, SET. (CONFIGURA GP2 COMO INTERRUP��O)|PEIE<6>, SET...
				;...(CONFIGURA INTERRUP��ES PERIF�RICAS).
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES.
	
	MOVLW	B'00000001'	;TMR1IE<0>, SET. (CONFIGURA TIMER1 COMO INTERRUP��O NO OVERFLOW).
	MOVWF	PIE1		;CONFIGURA��O DE INTERRUP��ES PERIF�RICAS.
	
	BANK0				;RETORNA PARA O BANCO 0.
	MOVLW	B'00000111'	
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	
	MOVLW	B'00000001'	;ENABLE TIMER1
	MOVWF	T1CON		;CONFIGURA��ES DO TIMER1
	
	MOVLW	B'00000000'	
	MOVWF	PIR1		;FLAGS DE INTERRUP��ES PERIF�RICAS
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN	BANK0				;TROCA DE BANCO
	BCF PIR1, TMR1IF		;LIMPA A INTERRUP��O DE TIMER1 POR OVERFLOW
	
	BANK1				;TROCA DE BANCO
	BCF OPTION_REG, INTEDG		;AMBOS OS BITS DEVEM SER LIMPOS...
	BCF INTCON, INTF		;...PARA SEREM USADOS NA SEGUNDA INTERA��O DO MAIN, CASO HAJA.
	
	MOVLW .0
	MOVWF COUNT			;INICIA O COUNT COM ZERO.
	
	SLEEP				;SLEEP ATE DETECTAR UMA BORDA DE DESCIDA.
	NOP				;GARANTE A INICIA��O COMPLETA DO PIC.
	
	INCF COUNT			;INCREMENTO QUE SERVE PARA CONTAR O PULSO.
	

DORME	BSF OPTION_REG, INTEDG		;CONFIGURA A INTERRUP��O PARA BORDA DE SUBIDA.
	BCF INTCON, INTF		;LIMPA O INTCON PARA RESETAR A INTERRUP��O
	
	MOVLW	B'11111111'	;8 BITS MAIS SIGNIFICATIVOS DO TIMER 1
	MOVWF	TMR1H
	MOVLW	B'10011011'	;8 BITS MENOS SIGNIFICATIVOS DO TIMER 1
	MOVWF	TMR1L		;TIMER1 SER� USADO COMO INTERRUP��O NO OVERFLOW
	 
	SLEEP			;SLEEP ATE DETECTAR UMA BORDA DE SUBIDA OU OVERFLOW
	NOP			;GARANTE A INICIA��O COMPLETA DO PIC.
	
	BANK0			;TROCA DE BANCO PARA LER GPIO
	BTFSS GPIO, GP2		;GP2 = 0, FIM DO BUSRT. GP2 = 1, INCREMENTA.
	GOTO SETABITS		;DIRECIONA PARA A LABEL SETABITS
	INCF COUNT		;INCREMENTA CONT
	
	BTFSC GPIO, GP2		;GP2 = 1, LOOP. GP2 = 0, SLEEP. 
	GOTO $-1
	
	GOTO DORME		;VOLTA PRO SLEEP E RECONTA.

SETABITS    ;FUN��O SETABITS (IDENTIFICA O BCD QUE VAI PARA O DISPLAY)
	
    BANK0
	
    MOVLW .1		    ; MOVE O VALOR A SER COMPARADO PARA O WORK
    SUBWF COUNT		    ; SUBTRAI DE COUNT
    BTFSC STATUS, Z	    ; CHECA SE O RESULTADO DA OPERA��O FOI 0
    GOTO UM		    ; SE SIM, VAI PARA A FUN��O E MOSTRA NO DISPLAY O NUMERO
    ADDWF COUNT		    ; SEN�O, READICIONA O VALOR SUBTRAIDO E PARTE PARA A PROXIMA OP��O DE AN�LISE.
    
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
	
	ZERO	BCF GPIO, GP5	    ;SETA OU ZERA AS SA�DAS GP0,GP1,GP4,GP5
		BCF GPIO, GP4	    ;DE ACORDO COM O NUMERO QUE SE QUER EM BIN�RIO.
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


	;Ol�, Professor! Gostaria de deixar claro que a iniciativa de estudar um conteudo mais
	;adiante da ementa partiu de mim em conjunto com Gabriel Formiga.
	;Estudamos juntos para as disciplinas faz uns periodos e quando eu falei da ideia pra ele
	;Ele me ajudou a entender algumas coisas e vice versa. Porem, so eu segui em frente com a ideia (: 
	;de entregar o codigo dessa maneira.
	
	;Ele est� funcionando perfeitamente quando debugado, porem em testes no laboratorio
	;com o monitor, o circuito de teste estava apresentando instabilidade ate para o codigo que ele fez
	;portanto, estou confiando no debug.
	
	;Estou especificando isso por ter consciencia de que deve ser reconhecido.
	

