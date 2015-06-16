! ##################################################################################################################################
 
      SUBROUTINE JAC2D ( SSI, SSJ, XSD, YSD, WRT_BUG_THIS_TIME, JAC, JACI, DETJ )
  
! Computes Jacobian for 2D elements with 4 grid points and quadratic serendipity shape functions. Also used for an 8
! nodel element when the 4 mid side nodes are assumed to be at the middle of the sides (as with the DKQ element which
! uses mid side nodes for intermediate calculations)
 
      USE PENTIUM_II_KIND, ONLY       :  BYTE, LONG, DOUBLE
      USE IOUNT1, ONLY                :  BUG, ERR, F04, F06, WRT_BUG, WRT_ERR, WRT_LOG
      USE SCONTR, ONLY                :  BLNK_SUB_NAM, MEFE
      USE TIMDAT, ONLY                :  TSEC
      USE SUBR_BEGEND_LEVELS, ONLY    :  JACOBIAN_BEGEND
      USE CONSTANTS_1, ONLY           :  ZERO, ONE, FOUR
      USE PARAMS, ONLY                :  EPSIL
      USE MODEL_STUF, ONLY            :  EID, EMG_IFE, EMG_RFE, ERR_SUB_NAM, NUM_EMG_FATAL_ERRS, TYPE
  
      USE JAC2D_USE_IFs

      IMPLICIT NONE
 
!nnn  DLL_EXPORT JAC2D
!nnn  DLL_IMPORT OURTIM
!nnn  DLL_IMPORT MATMULT_FFF

      CHARACTER(LEN=LEN(BLNK_SUB_NAM)):: SUBR_NAME = 'JAC2D'
      CHARACTER( 1*BYTE), INTENT(IN)  :: WRT_BUG_THIS_TIME ! If 'Y' then write to BUG file if WRT_BUG array says to

      INTEGER(LONG)                   :: I,J               ! DO loop indices
      INTEGER(LONG), PARAMETER        :: SUBR_BEGEND = JACOBIAN_BEGEND
 
      REAL(DOUBLE) , INTENT(IN)       :: SSI               ! A Gauss point location
      REAL(DOUBLE) , INTENT(IN)       :: SSJ               ! A Gauss point location
      REAL(DOUBLE) , INTENT(IN)       :: XSD(4)            ! 1-D arrays of differences in x side dimensions (local)
      REAL(DOUBLE) , INTENT(IN)       :: YSD(4)            ! 1-D arrays of differences in y side dimensions (local)
      REAL(DOUBLE) , INTENT(OUT)      :: DETJ              ! Determinant of JAC
      REAL(DOUBLE) , INTENT(OUT)      :: JAC(2,2)          ! 2 x 2 Jacobian matrix
      REAL(DOUBLE) , INTENT(OUT)      :: JACI(2,2)         ! 2 x 2 inverse of JAC
      REAL(DOUBLE)                    :: EPS1              ! A small number to compare real zero
  
! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9001) SUBR_NAME,TSEC
 9001    FORMAT(1X,A,' BEGN ',F10.3)
      ENDIF

! **********************************************************************************************************************************
! Initialize outputs

      DETJ = ZERO

      DO I=1,2
         DO J=1,2
            JAC(I,J)  = ZERO
            JACI(I,J) = ZERO
         ENDDO
      ENDDO

      EPS1 = EPSIL(1)
  
      JAC(1,1) = (-(ONE - SSJ)*XSD(1) + (ONE + SSJ)*XSD(3))/FOUR
      JAC(1,2) = (-(ONE - SSJ)*YSD(1) + (ONE + SSJ)*YSD(3))/FOUR
      JAC(2,1) = ( (ONE - SSI)*XSD(4) - (ONE + SSI)*XSD(2))/FOUR
      JAC(2,2) = ( (ONE - SSI)*YSD(4) - (ONE + SSI)*YSD(2))/FOUR

      DETJ = JAC(1,1)*JAC(2,2) - JAC(1,2)*JAC(2,1)
 
      IF ((WRT_BUG_THIS_TIME == 'Y') .AND.(WRT_BUG(7) > 0)) THEN
         WRITE(BUG,1101)
         WRITE(BUG,1102)
         DO I=1,2
            WRITE(BUG,1103) (JAC(I,J),J=1,2)
         ENDDO 
         WRITE(BUG,*)
         WRITE(BUG,*)
         WRITE(BUG,1104) DETJ
         WRITE(BUG,*)
         WRITE(BUG,*)
      ENDIF

! If DETJ is not zero, continue. Else, write error and stop:
 
      IF (DETJ > EPS1) THEN
  
         JACI(1,1) =  JAC(2,2)/DETJ
         JACI(1,2) = -JAC(1,2)/DETJ
         JACI(2,1) = -JAC(2,1)/DETJ
         JACI(2,2) =  JAC(1,1)/DETJ
  
         IF ((WRT_BUG_THIS_TIME == 'Y') .AND.(WRT_BUG(7) > 0)) THEN
            WRITE(BUG,1105)
            DO I=1,2
               WRITE(BUG,1103) (JACI(I,J),J=1,2)
            ENDDO 
            WRITE(BUG,*)
         ENDIF

      ELSE

         NUM_EMG_FATAL_ERRS = NUM_EMG_FATAL_ERRS + 1
         IF (WRT_ERR > 0) THEN
            WRITE(ERR,1928) EID, TYPE, DETJ
            WRITE(F06,1928) EID, TYPE, DETJ
         ELSE
            IF (NUM_EMG_FATAL_ERRS <= MEFE) THEN
               ERR_SUB_NAM(NUM_EMG_FATAL_ERRS) = SUBR_NAME
               EMG_IFE(NUM_EMG_FATAL_ERRS,1)   = 1928
               EMG_RFE(NUM_EMG_FATAL_ERRS,1)   = DETJ
            ENDIF
         ENDIF
         RETURN

      ENDIF
  
! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9002) SUBR_NAME,TSEC
 9002    FORMAT(1X,A,' END  ',F10.3)
      ENDIF

      RETURN

! **********************************************************************************************************************************
 1928 FORMAT(' *ERROR  1928: ELEMENT ',I8,', TYPE ',A,', HAS JACOBIAN LESS THAN OR EQUAL TO ZERO ( = ',1ES8.1,'). BAD GEOMETRY')

 1101 format(51x,'Outputs fron subroutine JAC2D',/,51x,'-----------------------------',/)

 1102 FORMAT(58X,'Jacobian matrix:')

 1103 FORMAT(48X,2(1ES16.6))

 1104 FORMAT(52X,'Determinant of the Jacobian:',/,56X,1ES16.6)

 1105 FORMAT(51X,'Inverse of the Jacobian matrix:')
  

! **********************************************************************************************************************************
  
      END SUBROUTINE JAC2D
