
;************************************************
;* Beginn der globalen Daten *
;************************************************
                   AREA MyData, DATA, align = 2
Base
VariableA          DCW 0x1234
VariableB          DCW 0x4711

VariableC          DCD  0

MeinHalbwortFeld   DCW 0x22 , 0x3e , -52, 78 , 0x27 , 0x45

MeinWortFeld       DCD 0x12345678 , 0x9dca5986
                   DCD -872415232 , 1308622848
                   DCD 0x27000000
                   DCD 0x45000000

MeinTextFeld       DCB "ABab0123",0

                   EXPORT VariableA
                   EXPORT VariableB
                   EXPORT VariableC
                   EXPORT MeinHalbwortFeld
                   EXPORT MeinWortFeld
                   EXPORT MeinTextFeld

;***********************************************
;* Beginn des Programms *
;************************************************
    AREA |.text|, CODE, READONLY, ALIGN = 3
; ----- S t a r t des Hauptprogramms -----
                EXPORT main
                EXTERN initITSboard
main            PROC
                bl    initITSboard                 ; HW Initialisieren

; Laden von Konstanten in Register
                mov   r0,#0x12                      ; Anw-01 Lädt den hex-Wert 0x12 direkt in Register r0
                mov   r1,#-128                      ; Anw-02 Lädt den negativen Wert −128 direkt in Register r1
                ldr   r2,=0x12345678                ; Anw-03 Lädt die 32-Bit-Konstante 0x12345678 in das Registerr2

; Zugriff auf Variable
                ldr   r0,=VariableA                 ; Anw-04 Lädt die Speicheradresse von VariableA in r0
                ldrh  r1,[r0]                       ; Anw-05 Liest ein Halbwort aus der Adresse in r0 nach r1
                ldr   r2,[r0]                       ; Anw-06 Liest ein Wort aus der gleichen Adresse (r0) nach r2
                str   r2,[r0,#VariableC-VariableA]  ; Anw-07  Schreibt r2 an die Adresse r0 + Offset

; Zugriff auf Felder (Speicherzellen)
                ldr   r0,=MeinHalbwortFeld          ; Anw-08 Lädt die Startadresse von MeinHalbwortFeld in r0
                ldrh  r1,[r0]                       ; Anw-09 Liest das 1. Element als Halbwort in r1
                ldrh  r2,[r0,#2]                    ; Anw-10 Liest das 2. Element als Halbwort in r2
                mov   r3,#10                        ; Anw-11 Lädt den Wert 10 in r3

				ldrh  r4,[r0,r3]                    ; Anw-12 Liest Halbwort bei Adresse r0+r3 in r4
                ldrh  r5,[r0,#2]!                   ; Anw-13  Pre-Inkrement: r0 += 2, dann Halbwort aus neuer Adresse in r5 lesen
                ldrh  r6,[r0,#2]!                   ; Anw-14 dann Halbwort aus neuer Adresse in r6 lesen
                strh  r6,[r0,#2]!                   ; Anw-15 dann Halbwort aus r6 an neue Adresse schreiben

; Addition und Subtraktion von unsigned / signed Integer-Werten
                ldr  r0,=MeinWortFeld               ; Anw-16 Lädt die Startadresse MeinWortFeld in r0
                ldr  r1,[r0]                        ; Anw-17 Liest ersten 4 bytes  in r1
                ldr  r2,[r0,#4]                     ; Anw-18 Liest erstes Wort in r2
                adds r3,r1,r2                       ; Anw-19 r3 = r1 + r2; setzt Flag 

                ldr  r4,[r0,#8]                     ; Anw-20 Liest r0 +8 Bytes in r4
                ldr  r5,[r0,#12]                    ; Anw-21 Liest r0 +12 Bytes in r5
                subs r6,r4,r5                       ; Anw-22 r6 = r4 − r5; setzt Flag 
                ldr  r7,[r0,#16]                    ; Anw-23 Liest r0 +16 Bytes in r7
                ldr  r8,[r0,#20]                    ; Anw-24 Liest r0 +20 Bytes) in r8
                subs r9,r7,r8                       ; Anw-25 r9 = r7 − r8; Flag 

forever         b   forever                         ; Anw-26 Schleife 
                ENDP
                END