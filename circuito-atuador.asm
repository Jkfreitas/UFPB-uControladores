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
		CONTAPACOTE
		SEPARABIT

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
	BTFSC	PIR1, TMR1IF ;CHECA SE A INTERRUP��O FOI POR OVERFLOW DO TIMERO OU DO TIMER1
	GOTO	ENVIAPACOTE  ;CASO SEJA POR TIMER1, DESVIA PARA A LABELENVIAPACOTE, SEN�O ESTA INSTRU��O � PULADA
	
	MOVLW .15	    
	SUBWF AUX, W		;NESTE BLOCO TESTAMOS SE O VALOR DE AUX=15, SE SIM, GOTO IGUAL15, SENAO, GOTO DIFERENTE15
	BTFSS STATUS, Z
	GOTO DIFERENTE15
	GOTO IGUAL15
	
IGUAL15				
	BTFSS GPIO, GP0
	GOTO SETA	    ;ESTE BLOCO INDICA QUE SE PASSOU 1 SEGUNDO ENT�O O LED OPERACIONAL INVERTER� O ESTADO (PISCANDO)
	GOTO LIMPA
SETA
	BSF GPIO, GP0	    ;SETA A PORTA GP0 (LED OPERACIONAL)
	BCF INTCON, T0IF    ;LIMPA A FLAG QUE INDICA O OVERFLOW NO TIMER0
	CLRF AUX	    ;RESETA O CONTADOR AUX
	CLRF TMR0	    ;LIMPA O VALOR DO TIMER0 VOLTANDO PARA 0
	GOTO SAI_INT	    ;DESVIA A EXECU��O PARA A SA�DA DA INTERRUP��O
LIMPA
	BCF GPIO, GP0	    ;ZERA A PORTA GP0 (LED OPERACIONAL)
	BCF INTCON, T0IF    ;LIMPA A FLAG QUE INDICA O OVERFLOW NO TIMER0
	CLRF AUX            ;RESETA O CONTADOR AUX
	CLRF TMR0           ;LIMPA O VALOR DO TIMER0 VOLTANDO PARA 0
	GOTO SAI_INT        ;DESVIA A EXECU��O PARA A SA�DA DA INTERRUP��O
	
DIFERENTE15		    ;INDICA QUE AINDA NAO SE PASSOU 1SEGUNDO
	
	INCF AUX	    ;INCREMENTA O CONTADOR AUX
	BCF INTCON, T0IF    ;LIMPA A FLAG QUE INDICA O OVERFLOW NO TIMER0
	CLRF TMR0	    ;LIMPA O VALOR DO TIMER0 VOLTANDO PARA 0
	GOTO SAI_INT	    ;DESVIA A EXECU��O PARA A SA�DA DA INTERRUP��O
	
	;------- ENVIO DE PACOTES E REPASSE DE CONTROLE -------------;

	;SER�O ENVIADOS 200 PACOTES DE 25ms CADA, CONTANDO COM O INTERVALO ENTRE OS PACOTES, DEPOIS DE 200 PACOTES ENVIADOS
	;HAVER� SE PASSADO 5 SEGUNDOS, QUE � QUANDO O PIC REPASSA O CONTROLE PARA O OUTRO PIC
	;OBS: DOS 25ms, 1.2ms S�O PARA O ENVIO DOS BITS E O RESTANTE DE INTERVALO ENTRE OS PACOTES.
	;COMO S�O 1.2 PARA O ENVIO DE 11 BITS, CADA BIT TER� DURA��O DE APROX 109us.
	;A LABEL ENVIAPACOTE � RESPONSAVEL PELA EXECU��O DESTES PROCEDIMENTOS
	
	;A DECISAO DE ENVIO DE PACOTES FOI FEITA DA SEGUINTE MANEIRA:
	;PACOTE NORMAL: ENVIADO A CADA 25mS QUE SERVE DE MONITORAMENTO PARA SABER SE O OUTRO PIC NAO MORREU. HELLO)
	;PACOTE DE CONTROLE: QUANDO ENVIADO O OUTRO PIC DEVE SABER QUE � PARA ASSUMIR O CONTROLE QUANDO RECEBER.
	
	
ENVIAPACOTE	; "HELLO MONITORAMENTO"    "PACOTE NORMAL: 0 1100 0000 0 1 -> Start / D0D1D2D3 D4D5D6D7 / R / STOP"
					  
	
	MOVLW .200
	SUBWF CONTAPACOTE, W	
	BTFSC STATUS, Z	    ;NESTE BLOCO � GERENCIADO O INTERVALO E NUMERO DE PACOTES
	GOTO REPASSACONTROLE
	
	BCF GPIO, GP2	    ;NESTE BLOCO � GERENCIADO O 'START BIT'
	MOVLW .34
	MOVWF SEPARABIT			
	DECFSZ SEPARABIT
	GOTO $-1
	BSF GPIO, GP2	    ;NESTE BLOCO � GERENCIADO O 'D1'
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BSF GPIO, GP2	    ;NESTE BLOCO � GERENCIADO O 'D2'
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;NESTE BLOCO � GERENCIADO O 'D3'

	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;NESTE BLOCO � GERENCIADO O 'D4'
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;NESTE BLOCO � GERENCIADO O 'D5'
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;NESTE BLOCO � GERENCIADO O 'D6'
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;NESTE BLOCO � GERENCIADO O 'D7'
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;NESTE BLOCO � GERENCIADO O 'D8'
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;NESTE BLOCO � GERENCIADO O BIT DE REDUNDANCIA
	
	MOVLW .68
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BSF GPIO, GP2	    ;NESTE BLOCO � GERENCIADO O 'STOP BIT'
	
	INCF CONTAPACOTE    ;INCREMENTA O CONTAPACOTE 
	
	BCF PIR1, TMR1IF    ;RESETA A FLAG QUE APONTA O OVERFLOW DO TIMER1
	MOVLW B'10100011'   ;REAJUSTA OS VALORES INICIAIS DE TMR1H PARA NOVA CONTAGEM
	MOVWF TMR1H
        MOVLW B'00001000'   ;REAJUSTA OS VALORES INICIAIS DE TMR1L PARA NOVA CONTAGEM
	MOVWF TMR1L
	
	GOTO SAI_INT	    ;DESVIA PARA A SA�DA DA INTERRUP��O
	
REPASSACONTROLE ;PACOTE QUE REPASSA O CONTROLE "PACOTE CONTROLE: 0 0011 0000 0 1 -> Start / D0D1D2D3 D4D5D6D7 / R / STOP"
	BCF GPIO, GP2	    ;START BIT
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;DADO 1
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;DADO 2
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BSF GPIO, GP2	    ;DADO 3

	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BSF GPIO, GP2	    ;DADO 4
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;DADO 5
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;DADO 6
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;DADO 7
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;DADO 8
	
	MOVLW .34
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BCF GPIO, GP2	    ;REDUNDANCIA
	
	MOVLW .68
	MOVWF SEPARABIT
	DECFSZ SEPARABIT
	GOTO $-1
	BSF GPIO, GP2	    ;STOP BIT

	MOVLW .0
	MOVWF CONTAPACOTE
	BCF PIR1, TMR1IF
	MOVLW B'10100011'
	MOVWF TMR1H
        MOVLW B'00001000'
	MOVWF TMR1L
	GOTO SAI_INT
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
	MOVLW	B'00000010' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO
	
	; TRISIO: GP0<0>, LED OPERACIONAL 
	;         GP1<1>, SINAL DA BATERIA
	;	  GP2<0>, COMUNICA��O SERIAL (GP2 MUDAR� DE ESTADO PARA ATUAR COMO SA�DA E ENTRADA DA COMUNICA��O
	;	  GP3<x>, SEM FUN��O POR ENQUANTO
	;         GP4<0>, LED CONTROLE
	;         GP5<0>, LED ALARME
	
	MOVLW   B'00010010'     ;PORTAS GP GP CONFIGURADAS COMO
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000111'	;UTILIZOU SE UM PRESCALE DE 1:256, POIS 15 x 65.536 = 983.040. APROX 1 SEGUNDO.
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'11100000'	;FOI LIGADO INTERRUP��O GERAL, INTERRUP��O POR PERIFERICO (TMR1) E INTERRUP��O POR TIMER0.
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	MOVLW	B'00000001'	;ATIVADA A INTERRUP��O POR TIMER1
	MOVWF	PIE1    
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	MOVLW	B'00000101'	;CONFIGURADO PARA LIGAR O COMPARADOR E USAR GP1 COMO ENTRADA E ESTAR JUSTIFICADO PELA ESQUERDA
	MOVWF	ADCON0 
	MOVLW	B'00000001'	;ATIVADO O TIMER1 COM PRESCALE 1:1
	MOVWF	T1CON 	
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MOVLW .0
MOVWF AUX ;VARI�VEL USADA PARA SER INCREMENTADA 15X PARA QUE SE CONSIGA CONTAR APROX 1s, USANDO UM PRESCALE DE 1:256 NO TIMER0'
MOVLW .0 
MOVWF TMR0 ;VALOR INICIAL DO TIMER0 = 0.
MOVLW B'10100011' 
MOVWF TMR1H	    ;MOVE O VALOR 10100011 O TMR1H'
MOVLW B'00001000' 
MOVWF TMR1L	    ;MOVE O VALOR 00001000 O TMR1L'
MOVLW .0
MOVWF CONTAPACOTE   ;INICIA COM VALOR 0 E � INCREMENTADA A CADA PACOTE DE 1.2ms ENVIADO AT� CHEGAR EM 200 PACOTES.
MOVLW .0
MOVWF SEPARABIT	    ;INICIA EM ZERO E � USADA PARA CONTAR O TEMPO QUE LEVA PARA ENVIAR UM BIT DENTRO DE CADA PACOTE(109us)
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	
	BSF ADCON0, 1	  ; INICIA A CONVERS�O
	BTFSC ADCON0, 1   ; A CONVERS�O LEVAR� ALGUNS CICLOS DE MAQUINA, ENT�O UM LOOP � CRIADO QUE DEVE ESPERAR A CONVERS�O TERMINAR
	GOTO $-1	  ; PARA CHECAR QUAL O VALOR RESULTANTE
	MOVLW B'10111111' ; COMPARA ADRESH COM O VALOR 191, EQUIVALENTE A TENS�O 3.75V
	SUBWF ADRESH, W		
	BTFSC STATUS, C	  ; SE HOUVER CARRY O VALOR � MENOR QUE 3.75V E DEVE ACENDER O LED DE AVISO (GP5)
	BCF GPIO, GP5		
	
	MOVLW B'10111111'	; NESTE BLOCO TBM � FEITA A COMPARA��O DE ADRESH COM O VALOR 191, EQUIVALENTE A 3.75V
	SUBWF ADRESH, W		; SE HOUVER CARRY O VALOR � MENOR QUE 3.75V E DEVE ACENDER O LED DE AVISO (GP5)
	BTFSS STATUS, C		
	BSF GPIO, GP5		
	GOTO MAIN	
	
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END



