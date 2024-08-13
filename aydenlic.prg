_VFP.AutoYield = .F.
CLOSE ALL
CLEAR ALL
CLEAR
SET STATUS BAR OFF
SET SYSMENU OFF
SET TALK OFF
SET CENTURY ON
SET CENTURY TO 19 ROLLOVER 60
SET MULTILOCKS ON
SET MEMOWIDTH TO 150
SET safety OFF
ON ERROR DO kserror WITH ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )

PUBLIC licensefile

IF !FILE('accset.asi')
	CREATE TABLE accset.asi (vcp c(10),vtxcp C(10),vcnp C(10), vtxcnp C(10),acp C(10),atxcp C(10),atxcnp C(10),acnp C(10),cardinter C(10),merchantid C(20),terminalid C(35),deviceid C(10),storeno I,register I,eol D,companyid c(2))
	**SELECT accset.asi
	USE
ENDIF

USE accset.asi ALIAS accset IN 0

SELECT accset
IF RECCOUNT() = 0
	APPEND BLANK
	replace accset.eol WITH {^2025-08-31}
	replace accset.vcp WITH "2.89"
	replace accset.vtxcp WITH ".10"
	replace accset.vcnp WITH "3.49"
	replace accset.vtxcnp WITH ".15"
	replace accset.acp WITH "3.29"
	replace accset.atxcp WITH ".10"
	replace accset.acnp WITH "3.68"
	replace accset.atxcnp WITH ".30"
	replace accset.cardinter WITH "AYDEN"
	replace accset.terminalid WITH "PLACEHOLDER"
ENDIF

DO FORM ayden

READ EVENTS
UNLOCK ALL
CLEAR DLLS
CLEAR WINDOW
RELEASE ALL EXTENDED
CLOSE ALL
CLEAR ALL
QUIT

PROCEDURE KSerror
 PARAMETER MERROR, MESS, MESS2, MPROG, MLINENO, WHO, TSTAMP
 IF ERROR()=108 .OR. ERROR()=109 .OR. ERROR()=130
    KS_ERROR = "ERROR "+ALLTRIM(STR(MERROR))
    LOCAL LINE1, LINE2, LINE3, LINE4, LINE5, LINE6, LINE7
    LINE1 = "FILE/RECORD/LOCKING ERROR !"+CHR(13)+CHR(13)
    LINE2 = "Error Number : "+ALLTRIM(STR(MERROR))+CHR(13)
    LINE3 = "Error Message : "+MESS+CHR(13)
    LINE4 = "Error Code : "+MESS2+CHR(13)
    LINE5 = "Line Number : "+ALLTRIM(STR(MLINENO))+CHR(13)
    LINE6 = "Program Name : "+MPROG+CHR(13)
    LINE7 = "Current Table : "+ALIAS()
    IF CURSORGETPROP("Buffering")>1
       = TABLEREVERT(.T.)
    ENDIF
    ?? CHR(7)
    = MESSAGEBOX(LINE1+LINE2+LINE3+LINE4+LINE5+LINE6+LINE7, 064, "An Error Has Occurred !")
    RETURN
ELSE
	 KS_ERROR = "ERROR "+ALLTRIM(STR(MERROR))
	 LOCAL LINE1, LINE2, LINE3, LINE4, LINE5, LINE6
	 LINE1 = "System Error !"+CHR(13)+CHR(13)
	 LINE2 = "Error Number : "+ALLTRIM(STR(MERROR))+CHR(13)
	 LINE3 = "Error Message : "+MESS+CHR(13)
	 LINE4 = "Error Code : "+MESS2+CHR(13)
	 LINE5 = "Line Number : "+ALLTRIM(STR(MLINENO))+CHR(13)
	 LINE6 = "Program Name : "+MPROG
	 ?? CHR(7)
	 IF MESSAGEBOX(LINE1+LINE2+LINE3+LINE4+LINE5+LINE6, 021, "An Error Has Occurred !")=4
	    RETURN
	 ELSE
	    CLEAR WINDOW
	    CLOSE ALL
	    IF VERSION(2)=0
	       QUIT
	    ELSE
	       CANCEL
	    ENDIF
	 ENDIF
ENDIF
ENDPROC