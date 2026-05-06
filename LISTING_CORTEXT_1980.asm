01000       ORG     4300H
01010       ;       CORTEX
01020       ;       ======
01030       ;       ****
01040       
01050       
01070       ;
01080       ;       PROGRAMME DE TRAITEMENT DE TEXTE SUR TRS 80 ET IBM 82
01090       ;
01100       ;       COMPOSITION, REDACTION DE TEXTE
01110       ;       **
01120 
01130       ;       --- 1310 ---
01140 
01150       ;       SAISIE
01160       ;
01170       ;       ENTREE : TOUS LES PARAMETRES ET BUFFERS SONT INITIALISES
01180       ;
01190       ;       SORTIE : BUFFER TEXTE SAISIE ENREGISTRE SUR CASSETTE
01200       ;                ET ESCAPE EDITION
01210       ;
01220       ;
01230 DAFF    DEFS    2           ; DEBUT AFFICHAGE DU BUFFER KM
01240 PCURS   DEFS    1
01250 DEBUT   DEFM    'DEBUT DE'
01260         DEFM    ' TEXTE '
01270         DEFB    03H
01280 FIN     DEFM    ' FIN DE'
01290         DEFM    ' TEXTE '
01300         DEFB    03H
01310       ;       ----
01320       
01330       ;       INITIALISATION DES PARAMETRES
01340       ;
01350 INIT    LD      HL,4000H    ; ADRESSE DE DEBUT DU BUFFER
01360         LD      (ABUF),HL   ; ABUF : ADRESSE DEBUT BUFFER
01370         LD      (PBUF),HL   ; PBUF : POINTEUR DE SAISIE
01380         LD      (CBUF),HL   ; CBUF : POINTEUR AFFICHAGE
01390         LD      HL,0
01400         LD      (PCURS),HL  ; RESET POSITION CURSEUR
01410         LD      A,20H       ; ESPACE
01420         LD      (CAR),A     ; CARACTERE COURANT
01430         CALL    CLS         ; EFFACEMENT ECRAN
01440         
01450       ;       AFFICHAGE ENTETE
01460       ;
01470         LD      HL,DEBUT
01480         CALL    1C90H       ; ROUTINE AFFICHAGE MESSAGE
01490         LD      HL,4000H
01500         CALL    DISP        ; PREMIER AFFICHAGE
01510 
01520       ;       BOUCLE PRINCIPALE DE SAISIE
01530       ;
01540 L1      CALL    002BH       ; SCAN CLAVIER TRS-80
01550         OR      A
01560         JR      Z,L1        ; ATTENTE TOUCHE
01570         CP      1FH         ; TEST SI CARACTERE SPECIAL
01580         JR      C,SPEC      ; SAUT SI < 32
01590         CP      7FH         ; TEST SI > 127
01600         JR      NC,L1       ; IGNORE SI HORS LIMITES
01960       EX      DE,HL       ; ECHANGE REGISTRES
01970       SBC     HL,DE       ; SOUSTRACTION AVEC CARRY
01980       LD      A,0
01990       CP      H
02000       JR      NZ,L19YM    ; BRANCH. SI RESULT > 255
02010       LD      C,L
02020       LD      A,63
02030       CP      C
02040       JP      NC,FSS
02050 L19YM   LD      A,C
02060       LD      (PCURS),A   ; POSIT. RELAT. CURSEUR
02070       LD      A,(CAR)
02080       ENDM
02090 DEPAFF  MACRO               ; CARRY EN SORTIE SI NON DEPASSEMENT
02100       LD      (CBUF),HL
02110       LD      DE,447      ; OFFSET ECRAN
02120       LD      (CAR),A
02130       LD      HL,(ADECR)
02140       CALL    1C90H
02150       ENDM
02160 SCROLL  MACRO               ; DEPASSEMENT AFFICHAGE
02170       LD      HL,(ABUF)     ; TRANSFERT BUF EN DEB. ECRAN
02180       LD      DE,(PBUF)
02190       CALL    1C90H
02200       JR      C,SC#$YM      ; CONTINUITE
02210 L2210 LD      A,(HL)
02220       CP      03H         ; TEST FIN DE TEXTE
02230       JR      Z,L2260
02240       INC     HL
02250       JP      L2210
02260       LD      (PBUF),HL
02270       RET
02280 ; --- FIN DU CORRECTIF ---
02290       ;       ----
02300       
02310       ;       ROUTINES DE GESTION ECRAN
02320       ;
02330 CLS     PUSH    AF          ; EFFACEMENT ECRAN TRS-80
02340         PUSH    BC
02350         PUSH    HL
02360         LD      HL,3C00H    ; DEBUT MEMOIRE VIDEO
02370         LD      BC,400H     ; 1024 CARACTERES
02380 CLS1    LD      (HL),20H    ; ESPACE
02390         INC     HL
02400         DEC     BC
02410         LD      A,B
02420         OR      C
02430         JR      NZ,CLS1
02440         POP     HL
02450         POP     BC
02460         POP     AF
02470         RET
02480 
02490 DISP    PUSH    AF          ; AFFICHAGE BUFFER
02500         PUSH    BC
02510         PUSH    DE
02520         PUSH    HL
02530         LD      DE,3C00H    ; DESTINATION ECRAN
02540         LD      BC,3C0H     ; TAILLE FENETRE
02550         LDIR                ; TRANSFERT BLOC
02560 MASC    DEFB    08H         ; MASQUE DEBUT
02570         LD      HL,(FBUF)   ; FIN DU BUFFER SAISIE
02580         LD      (PBUF),HL
02590         LD      HL,4000H    ; DEBUT BUFFER
02600 INI       LD      (HL), 40H   ; Remplit le buffer avec des espaces
02610           INC     HL          ; Adresse suivante
02620           LD      A, H        ; Test du poids fort de l'adresse
02630           CP      7FH         ; Limite à 32K (7FFFH)
02640           JR      C, INI      ; BOUCLE : Tans que HL < 7FFFH on efface
02650           LD      HL, BUF     ; Une fois fini, on pointe au début
02660           LD      (ABUF), HL  ; Initialise début de texte
02670           LD      (PBUF), HL  ; Initialise fin de texte (vide au départ)
02680           LD      (CBUF), HL  ; Fenêtre d'affichage au début
02690           RET                 ; Retour au menu
02700         LD      DE,(ABUF)
02710         OR      A
02720         SBC     HL,DE
02730         RET      Z          ; DEBUT BUFFER ATTEINT
02740         LD      HL,(PBUF)
02750         DEC     HL
02760         LD      (PBUF),HL
02770         LD      (HL),20H    ; EFFACE CARACTERE
02780         CALL    DISP
02790         RET
02800
02810 ENTER   LD      HL,(PBUF)   ; ROUTINE TOUCHE ENTREE
02820         LD      (HL),0DH    ; CODE CARRIAGE RETURN
02830         INC     HL
02840         LD      (PBUF),HL
02850         CALL    DISP
02860         RET
02870 
02880 TAB     LD      A,20H       ; ROUTINE TABULATION (ESPACES)
02890         LD      B,8         ; 8 ESPACES PAR TAB
02900 TAB1    CALL    WRITE       ; ECRITURE CARACTERE
02910         DJNZ    TAB1
02920         RET
02930 
02940 CDROIT  LD      HL,(PBUF)   ; CURSEUR DROITE
02950         LD      A,(HL)
02960         CP      03H         ; TEST FIN DE TEXTE
02970         RET     Z
02980         INC     HL
02990         LD      (PBUF),HL
03000         CALL    DISP
03010         RET
03020 
03030 CGAUCH  LD      HL,(PBUF)   ; CURSEUR GAUCHE
03040         LD      DE,(ABUF)
03050         OR      A
03060         SBC     HL,DE
03070         RET     Z          ; DEBUT ATTEINT
03080         LD      HL,(PBUF)
03090         DEC     HL
03100         LD      (PBUF),HL
03110         LD      (PBUF),HL   ; MISE A JOUR POINTEUR
03120         CALL    DISP
03130         RET
03140 
03150 CHAUT   LD      HL,(PBUF)   ; CURSEUR HAUT (-64)
03160         LD      DE,40       ; VALEUR D'UNE LIGNE TRS-80
03170         OR      A
03180         SBC     HL,DE
03190         LD      DE,(ABUF)
03200         PUSH    HL
03210         SBC     HL,DE
03220         POP     HL
03230         RET     C           ; LIMITE HAUTE ATTEINTE
03240         LD      (PBUF),HL
03250         CALL    DISP
03260         RET
03270 
03280 CBAS    LD      HL,(PBUF)   ; CURSEUR BAS (+64)
03290         LD      DE,40
03300         ADD     HL,DE
03310         LD      (PBUF),HL
03320         CALL    DISP
03330         RET
03340 
03350 ;       --- ROUTINE D'ECRITURE ---
03360 
03370 WRITE   LD      (CAR),A     ; STOCKAGE CARACTERE
03380         LD      HL,(PBUF)
03390         LD      (HL),A      ; ECRITURE DANS LE BUFFER
03400         INC     HL          ; AVANCE POINTEUR
03410         LD      A,(HL)      ; TEST FIN DE TEXTE
03420         CP      03H         ; CODE ETX
03430         JR      NZ,W1
03440         LD      (HL),20H    ; EFFACE FIN
03450         INC     HL
03460         LD      (HL),03H    ; REPOUSSE FIN
03470         DEC     HL
03480 W1      LD      (PBUF),HL   ; MAJ POINTEUR
03490         CALL    DISP        ; REAFFICHAGE
03500         RET
03510 
03520 ;       --- ROUTINES D'EDITION ---
03530 
03540 EDITION CALL    CLS         ; EFFACE ECRAN
03550         LD      HL,TITRE    ; "MODE EDITION"
03560         CALL    1C90H
03570 E1      CALL    002BH       ; SCAN CLAVIER
03580         OR      A
03590         JR      Z,E1
03600         CP      'L'         ; LOUPE / LIST
03610         JP      Z,LIST
03620         CP      'S'         ; SAUVEGARDE
03630         JP      Z,SAVE
03640         CP      'C'         ; CHARGEMENT
03650         JP      Z,LOAD
03660         CP      'R'         ; RETOUR SAISIE
03670         JP      Z,L1
03680         CP      'N'         ; NEW
03690         JP      Z,INIT
03700         JR      E1          ; ATTENTE
; --- ROUTINE DE LISTING (Touche 'L') ---
03700 LIST      CALL    01C9H       ; Efface l'écran (CLS)
03710           LD      HL, (CBUF)  ; Prend le pointeur de fenêtre
03720           CALL    DISP        ; Affiche une page de texte
03730 L_KEY     CALL    002BH       ; Attend une touche (ROM TRS-80)
03740           CP      1DH         ; Touche flèche DROITE ?
03750           JR      Z, L_BAS    ; Si oui, descend d'une ligne
03760           CP      1CH         ; Touche flèche GAUCHE ?
03770           JR      Z, L_HAUT   ; Si oui, monte d'une ligne
03780           CP      01H         ; Touche BREAK ?
03790           JP      Z, EDITION  ; Si oui, retour au menu
03800           JR      L_KEY       ; Sinon, on attend encore
03810 L_BAS     LD      HL, (CBUF)  ; Routine pour descendre
03820           CALL    NEXT_L      ; Cherche ligne suivante
03830           LD      (CBUF), HL
03840           JR      LIST
03850 L_HAUT    LD      HL, (CBUF)  ; Routine pour monter
03860           CALL    PREV_L      ; Cherche ligne précédente
03870           LD      (CBUF), HL
03880           JR      LIST
03890 
03900 SAVE    LD      HL,MSGS     ; "SAVE CASSETTE"
03910         CALL    1C90H
03920         LD      HL,(ABUF)
03930         LD      DE,(PBUF)
03940         OR      A
03950         SBC     HL,DE
03960         LD      B,H
03970         LD      C,L         ; LONGUEUR DANS BC
03980         LD      HL,(ABUF)
03990         CALL    0212H       ; ROUTINE CASSETTE TRS-80
04000         JP      E1
04010 LOAD    LD      HL,MSGL     ; "LOAD CASSETTE"
04020         CALL    1C90H
04030         LD      HL,(ABUF)
04040         CALL    0212H       ; LECTURE CASSETTE TRS-80
04050         LD      (PBUF),HL   ; FIN DU CHARGEMENT
04060         JP      E1
04070 
04080 ;       --- MESSAGES ET CONSTANTES ***---
04090 
04100 TITRE   DEFM    'CORTEX - MODE EDITION'
04110         DEFB    03H
04120 MSGS    DEFM    'SAUVEGARDE SUR CASSETTE'
04130         DEFB    03H
04140 MSGL    DEFM    'CHARGEMENT DEPUIS CASSETTE'
04150         DEFB    03H
04160 
04170 ;       --- ROUTINE D'AFFICHAGE TRS-80 ---
04180 
04190 DISP    PUSH    AF
04200         PUSH    BC
04210         PUSH    DE
04220         PUSH    HL
04230         LD      HL,(CBUF)   ; DEBUT FENETRE
04240         LD      DE,3C00H    ; ECRAN TRS-80
04250         LD      B,16        ; 16 LIGNES
04260 D1      LD      C,64        ; 64 CARACTERES
04270 D2      LD      A,(HL)
04280         CP      03H         ; FIN DE TEXTE ?
04290         JR      Z,D3
04300         LD      (DE),A      ; AFFICHAGE
04310 FS1     INC     DE
04320         INC     HL
04330         DEC     BC
04340         LD      A,B
04350         OR      C
04360         JR      NZ,D2
04370 D3      POP     HL
04380         POP     DE
04390         POP     BC
04400         POP     AF
04410         RET
04420 
04430 ;       --- ROUTINES DE CALCULS ---
04440 
04450 ADEC    PUSH    HL          ; CALCUL ADRESSE ECRAN
04460         LD      HL,(PCURS)
04470         LD      A,L
04480         LD      L,H
04490         LD      H,0
04500         ADD     HL,HL       ; * 2
04510         ADD     HL,HL       ; * 4
04520         ADD     HL,HL       ; * 8
04530         ADD     HL,HL       ; * 16
04540         ADD     HL,HL       ; * 32
04550         ADD     HL,HL       ; * 64 (TAILLE LIGNE TRS)
04560         LD      DE,3C00H
04570         ADD     HL,DE
04580         LD      E,A
04590         LD      D,0
04600         ADD     HL,DE
04610         RET
04620 
04630 ;       --- ROUTINE DE RECHERCHE ---
04640 
04650 SEARCH  LD      HL,(ABUF)   ; DEBUT DU TEXTE
04660 S1      LD      A,(HL)
04670         CP      03H         ; FIN ?
04680         RET     Z
04690         LD      DE,BUF1     ; MOT RECHERCHE
04700         CALL    COMP        ; COMPARAISON
04710         JR      Z,S2        ; TROUVE !
04720         INC     HL
04730         JR      S1
04740 S2      LD      (PBUF),HL   ; POSITIONNE CURSEUR
04750         CALL    DISP
04760         RET
04770 
04780 COMP    PUSH    HL
04790 C1      LD      A,(DE)
04800         OR      A           ; FIN MOT ?
04810         JR      Z,C2
04820         CP      (HL)
04830         JR      NZ,C3
04840         INC     HL
04850         INC     DE
04860         JR      C1
04870 C2      XOR     A           ; ZERO SI OK
04880         POP     HL
04890         RET
04900 C3      LD      A,1         ; NON ZERO
04910         POP     HL
04920         RET
04930 
04940 ;       --- GESTION DES BLOCS ---
04950 
04960 BMOV    LD      HL,(BDEB)   ; DEPLACEMENT DE BLOC
04970         LD      DE,(BFIN)
04980         LD      BC,(BDEST)
04990         ; (Logique de transfert mémoire ici)
05000         RET
05010 
05020 ;       --- VARIABLES SYSTEME ---
05030 
05040 ABUF    DEFS    2           ; ADRESSE DEBUT BUFFER
05050 PBUF    DEFS    2           ; POINTEUR SAISIE (CURSEUR)
05060 CBUF    DEFS    2           ; POINTEUR AFFICHAGE
05070 FBUF    DEFS    2           ; FIN DU BUFFER
05080 PCURS   DEFS    1           ; POSITION CURSEUR ECRAN
05090 CAR     DEFS    1           ; CARACTERE COURANT
05100 BDEB    DEFS    2           ; DEBUT BLOC
05110 BFIN    DEFS    2           ; FIN BLOC
05120 BDEST   DEFS    2           ; DESTINATION BLOC
05130 
05140 ;       --- PARAMETRES TRS-80 ---
05150 
05160 CLAVIER EQU     002BH       ; SCAN TOUCHE
05170 VIDEO   EQU     3C00H       ; MEMOIRE ECRAN
05180 MESSAGE EQU     1C90H       ; PRINT STRING
05190 CASSET  EQU     0212H       ; I/O TAPE
05200 BUF1    DEFS    16          ; BUFFER RECHERCHE
05210 ;       --- ROUTINES D'IMPRESSION (IBM 82) ---
05220 
05230 PRINT   LD      HL,(ABUF)   ; DEBUT TEXTE
05240 P1      LD      A,(HL)
05250         CP      03H         ; FIN ?
05260         RET     Z
05270         CALL    OUTP        ; SORTIE VERS IMPRIMANTE
05280         INC     HL
05290         JR      P1
05300 
05310 OUTP    PUSH    AF          ; SAUVEGARDE CARACTERE
05320 O1      IN      A,(0FEH)    ; STATUS IMPRIMANTE
05330         BIT     0,A         ; PRET ?
05340         JR      Z,O1
05350         POP     AF
05360         OUT     (0FFH),A    ; ENVOI CARACTERE
05370         RET
05380 
05390 ;       --- GESTION DES TABULATIONS ---
05400 
05410 PTAB    LD      A,09H       ; CODE TAB
05420         CALL    OUTP
05430         RET
05440 
05450 ;       --- ROUTINES DE FORMATAGE ---
05460 
05470 FORM    CALL    CLS
05480         LD      HL,MSGF     ; "FORMATAGE"
05490         CALL    1C90H
05500 F1      CALL    002BH
05510         OR      A
05520         JR      Z,F1
05530         CP      'G'         ; GAUCHE
05540         JR      NZ,F2
05550         CALL    MARG
05560         JR      F1
05570 F2      CP      'D'         ; DROITE
05580         JR      NZ,F3
05590         CALL    MARD
05600         JR      F1
05610 F3      CP      01H         ; BREAK
05620         JP      Z,E1
05630         JR      F1
05640 
05650 ;       --- DEFINITION DES MARGES ---
05660 
05670 MARG    LD      HL,MSGMG    ; "MARGE GAUCHE"
05680         CALL    1C90H
05690         CALL    INPUT       ; SAISIE VALEUR
05700         LD      (MGAU),A
05710         RET
05720 
05730 MARD    LD      HL,MSGM D   ; "MARGE DROITE"
05740         CALL    1C90H
05750         CALL    INPUT
05760         LD      (MDRO),A
05770         RET
05780 
05790 ;       --- ROUTINE D'ENTREE DE VALEURS ---
05800 
05810 INPUT   LD      A,0
05820         LD      B,0
05830 I1      CALL    002BH
05840         OR      A
05850         JR      Z,I1
05860         CP      0DH         ; ENTER
05870         RET     Z
05880         SUB     30H         ; CONVERSION ASCII-HEX
05890         LD      C,A
05900         LD      A,B
05910         ADD     A,A         ; * 2
05920         LD      B,A
05930         ADD     A,A         ; * 4
05940         ADD     A,A         ; * 8
05950         ADD     A,B         ; * 10
05960         ADD     A,C
05970         LD      B,A
05980         JR      I1
05990 
06000 ;       --- ROUTINES D'INSERTION ---
06010 
06020 INSERT  LD      HL,(PBUF)   ; POSITION ACTUELLE
06030         LD      DE,(FBUF)   ; FIN DU TEXTE
06040         OR      A
06050         SBC     HL,DE       ; CALCUL TAILLE A DEPLACER
06060         PUSH    HL
06070         POP     BC
06080         LD      HL,(FBUF)
06090         LD      DE,HL
06100         INC     DE          ; DECALE D'UN CARACTERE
06110         LDDR                ; TRANSFERT VERS LE HAUT
06120         LD      HL,(FBUF)
06130         INC     HL
06140         LD      (FBUF),HL
06150         RET
06160 
06170 ;       --- ROUTINES DE SUPPRESSION ---
06180 
06190 DELETE  LD      HL,(PBUF)
06200         LD      DE,HL
06210         INC     HL          ; CARACTERE SUIVANT
06220         LD      (PBUF),HL
06230         ; ... (Logique de décalage vers le bas)
06240         RET
06250 
06260 ;       --- CONSTANTES DE FORMATAGE ---
06270 
06280 MGAU    DEFB    10          ; DEFAUT 10
06290 MDRO    DEFB    70          ; DEFAUT 70
06300 MSGF    DEFM    'FORMATAGE DU TEXTE'
06310         DEFB    03H
06320 MSGMG   DEFM    'VALEUR MARGE GAUCHE :'
06330         DEFB    03H
06340 MSGM D  DEFM    'VALEUR MARGE DROITE :'
06350         DEFB    03H
06360 
06370 ;       --- SAUT VERS PAGE 19 ---
06380 
06390 ADRE1   DEFS    2           ; ADRESSE TEMPORAIRE
06400 STACK   DEFS    32          ; PILE LOCALE
06410 TOP     EQU     $
06420 
06430 ;       --- DEBUT PROGRAMME PRINCIPAL ---
06440 
06450 START   LD      SP,TOP      ; INITIALISATION PILE
06460         CALL    INIT        ; RAZ PARAMETRES
06470         JP      L1          ; BOUCLE DE SAISIE
06480 
06490 ;       --- GESTION DES ERREURS CASSETTE ---
06500 
06510 ERREUR  LD      HL,MSGERR   ; "ERREUR CASSETTE"
06520         CALL    1C90H
06530         JP      E1
06540 MSGERR  DEFM    'ERREUR DE LECTURE'
06550         DEFB    03H
06560 
06570 ;       --- ROUTINES COMPLEMENTAIRES ---
06580 
06590 CLRBUF  LD      HL,(ABUF)
06600         LD      BC,4000H    ; LONGUEUR MAX
06610 CBUF1   LD      (HL),0
06620         INC     HL
06630         DEC     BC
06640         LD      A,B
06650         OR      C
06660         JR      NZ,CBUF1
06670         RET
06680 ;       --- GESTION DE LA PILE ET TAMPONS ---
06690 
06700 STACK   DEFS    32          ; RESERVE 32 BYTES POUR LA PILE
06710 TOP     EQU     $           ; HAUT DE LA PILE
06720 
06730 ;       --- INITIALISATION DU SYSTEME ---
06740 
06750 START   LD      SP,TOP      ; POINTEUR DE PILE
06760         CALL    CLS         ; NETTOYAGE ECRAN
06770         LD      HL,TITRE
06780         CALL    1C90H       ; AFFICHAGE VERSION
06790         CALL    INIT        ; RESET PARAMETRES
06800         JP      L1          ; VERS BOUCLE SAISIE
06810 
06820 ;       --- SOUS-ROUTINES DE DEPLACEMENT ---
06830 
06840 DEPLA   LD      HL,(PBUF)   ; SOURCE
06850         LD      DE,(PBUF)
06860         INC     DE          ; DESTINATION (DECALAGE)
06870         LD      BC,(FBUF)   ; CALCUL TAILLE
06880         OR      A
06890         SBC     HL,BC
06900         PUSH    HL
06910         POP     BC
06920         LD      HL,(FBUF)
06930         LDDR                ; TRANSFERT MEMOIRE
06940         RET
06950 
06960 ;       --- CONFIGURATION IMPRIMANTE ---
06970 
06980 INST    LD      A,0         ; INIT IBM 82
06990         OUT     (0FEH),A
07000         RET
07010 
07020 ;       --- ZONE DE TRAVAIL ---
07030 
07040 ADECR   DEFS    2           ; ADRESSE ECRAN CALCULER
07050 MARG    DEFB    0           ; MARGE COURANTE
07060 FLAG    DEFB    0           ; INDICATEUR ETAT
07070 
07080 ;       --- DEBUT DE LA ZONE TEXTE (BUFFER) ---
07090 
07100         ORG     5000H       ; LE TEXTE COMMENCE ICI
07110 BUF     DEFM    ' '         ; PREMIER ESPACE **
07120         DEFB    03H         ; FIN DE BUFFER INITIALE
07130 
07140 ;       --- TABLES DE TRADUCTION / CARACTERES ---
07150 
07160 TABC    DEFB    14H, 01H, 17H, 05H, 12H, 14H, 19H, 15H
07170         DEFB    09H, 0FH, 10H, 01H, 13H, 04H, 06H, 07H
07180         DEFB    08H, 09H, 0AH, 0BH, 0CH, 0DH, 0EH, 0FH
07190 
07200 ;       --- ROUTINES DE CONVERSION ---
07210 
07220 CONV    PUSH    AF
07230         LD      HL,TABC     ; TABLE DE CONVERSION
07240         LD      D,0
07250         LD      E,A
07260         ADD     HL,DE
07270         LD      A,(HL)      ; RECUPERE CARACTERE TRADUIT
07280         POP     HL
07290         RET
07300 
07310 ;       --- GESTION DES ESPACES ET SAUTS ---
07320 
07330 SPACE   LD      A,20H       ; ESPACE ASCII
07340         CALL    WRITE
07350         RET
07360 
07370 CRLF    LD      A,0DH       ; RETOUR CHARIOT
07380         CALL    WRITE
07390         LD      A,0AH       ; SAUT DE LIGNE
07400         CALL    WRITE
07410         RET
07420 
07430 ;       --- ZONE DE TEST FIN DE TEXTE ---
07440 
07450 TESTF   LD      A,(HL)
07460         CP      03H
07470         RET
07480 
07490 ;       --- REPRISE PROGRAMME (PARTIE 2) ---
07500 
07510         ORG     4B00H       ; NOUVELLE SECTION MEMOIRE
07520 
07530 REPR    CALL    CLS
07540         LD      HL,MSG1
07550         CALL    1C90H
07560         JP      E1
07570 
07580 MSG1    DEFM    'REPRISE DU TRAITEMENT'
07590         DEFB    03H
07600 ;       (FIN DE PAGE / SECTION)
08000 ;       --- NOUVELLE ENTREE NUMEROTATION ---
08190         DEFB    40H,41H,42H,43H,44H,45H,46H,47H
08200         DEFB    48H,49H,4AH,4BH,4CH,4DH,4EH,4FH
08210         DEFB    50H,51H,52H,53H,54H,55H,56H,57H
08220         DEFB    58H,59H,5AH,5BH,5CH,5DH,5EH,5FH
08230         DEFB    60H,61H,62H,63H,64H,65H,66H,67H
08240         DEFB    68H,69H,6AH,6BH,6CH,6DH,6EH,6FH
08250         DEFB    70H,71H,72H,73H,74H,75H,76H,77H
08260         DEFB    78H,79H,7AH,7BH,7CH,7DH,7EH,7FH
08270         DEFB    80H,81H,82H,83H,84H,85H,86H,87H
08280         DEFB    88H,89H,8AH,8BH,8CH,8DH,8EH,8FH
08290         DEFB    90H,91H,92H,93H,94H,95H,96H,97H
08300         DEFB    98H,99H,9AH,9BH,9CH,9DH,9EH,9FH
08310         DEFB    A0H,A1H,A2H,A3H,A4H,A5H,A6H,A7H
08320         DEFB    A8H,A9H,AAH,ABH,ACH,ADH,AEH,AFH
08330         DEFB    B0H,B1H,B2H,B3H,B4H,B5H,B6H,B7H
08340         DEFB    B8H,B9H,BAH,BBH,BCH,BDH,BEH,BFH
08350         DEFB    C0H,C1H,C2H,C3H,C4H,C5H,C6H,C7H
08360         DEFB    C8H,C9H,CAH,CBH,CCH,CDH,CEH,CFH
08370         DEFB    D0H,D1H,D2H,D3H,D4H,D5H,D6H,D7H
08380         DEFB    D8H,D9H,DAH,DBH,DCH,DDH,DEH,DFH
08390         DEFB    E0H,E1H,E2H,E3H,E4H,E5H,E6H,E7H
08400         DEFB    E8H,E9H,EAH,EBH,ECH,EDH,EEH,EFH
08410         DEFB    F0H,F1H,F2H,F3H,F4H,F5H,F6H,F7H
08420         DEFB    F8H,F9H,FAH,FBH,FCH,FDH,FEH,FFH
08500 ; --- ZONES DE RESERVATION MEMOIRE FINALES ---
08510 BUF     DEFS    4000
08600 BUFT    DEFS    4000
08700 FBUF    EQU     $
09000         END     START