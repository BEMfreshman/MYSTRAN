! ##################################################################################################################################
 
      SUBROUTINE BD_CBUSH0 ( CARD, LARGE_FLD_INP )
 
! Processes CBUSH Bulk Data Cards to increment LVVEC and LBUSHOFF if the CBUSH entry has a V vector or offsets
 
      USE PENTIUM_II_KIND, ONLY       :  BYTE, LONG
      USE IOUNT1, ONLY                :  WRT_LOG, F04
      USE SCONTR, ONLY                :  BLNK_SUB_NAM, JCARD_LEN, LBUSHOFF, LVVEC
      USE TIMDAT, ONLY                :  TSEC
      USE SUBR_BEGEND_LEVELS, ONLY    :  BD_CBUSH0_BEGEND
 
      USE BD_CBUSH0_USE_IFs

      IMPLICIT NONE
 
      CHARACTER(LEN=LEN(BLNK_SUB_NAM)):: SUBR_NAME = 'BD_CBUSH0'
      CHARACTER(LEN=*), INTENT(INOUT) :: CARD              ! A Bulk Data card
      CHARACTER(LEN=*), INTENT(IN)    :: LARGE_FLD_INP     ! If 'Y', CARD is large field format
      CHARACTER(LEN(CARD))            :: CHILD             ! "Child" card read in subr NEXTC, called herein
      CHARACTER( 1*BYTE)              :: FND_VVEC          ! Indicator of whether there is an actual V vec on this CBUSH card
      CHARACTER(LEN=JCARD_LEN)        :: JCARD(10)         ! The 10 fields of characters making up CARD
 
      INTEGER(LONG)                   :: J
      INTEGER(LONG)                   :: ICONT     = 0     ! Indicator of whether a cont card exists. Output from subr NEXTC
      INTEGER(LONG)                   :: IERR      = 0     ! Error indicator returned from subr NEXTC called herein
      INTEGER(LONG), PARAMETER        :: SUBR_BEGEND = BD_CBUSH0_BEGEND
 
! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9001) SUBR_NAME,TSEC
 9001    FORMAT(1X,A,' BEGN ',F10.3)
      ENDIF

! **********************************************************************************************************************************
! Make JCARD from CARD
 
      CALL MKJCARD ( SUBR_NAME, CARD, JCARD )
 
! See if there is an actual V vector (not a grid point). If so, increment LVVEC
 
      FND_VVEC = 'N' 
      DO J=1,JCARD_LEN
         IF ((JCARD(6)(J:J) == '.') .OR. (JCARD(7)(J:J) == '.') .OR. (JCARD(8)(J:J) == '.')) THEN
            FND_VVEC = 'Y'
            EXIT
         ENDIF
      ENDDO
      IF (FND_VVEC == 'Y') THEN
         LVVEC = LVVEC + 1
      ENDIF
 
! Optional Second Card - see if there are any offsets. If so, increment LBUSHOFF
 
      IF (LARGE_FLD_INP == 'N') THEN
         CALL NEXTC0  ( CARD, ICONT, IERR )
      ELSE
         CALL NEXTC20 ( CARD, ICONT, IERR, CHILD )
         CARD = CHILD
      ENDIF
      CALL MKJCARD ( SUBR_NAME, CARD, JCARD )
      LBUSHOFF = LBUSHOFF + 1                              ! Even if no cont entry need one BUSHOFF per CBUSH since S = 0.5 default
      IF (ICONT == 1) THEN
         IF (JCARD(2)(1:) /= ' ') THEN
            LBUSHOFF = LBUSHOFF + 1
         ENDIF
         IF ((JCARD(4)(1:) /= ' ') .OR. (JCARD(5)(1:) == ' ') .OR. (JCARD(6)(1:) == ' ')) THEN
            LBUSHOFF = LBUSHOFF + 1                        ! This adds one more that may not be needed
         ENDIF
      ENDIF
 
! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9002) SUBR_NAME,TSEC
 9002    FORMAT(1X,A,' END  ',F10.3)
      ENDIF

      RETURN

! **********************************************************************************************************************************
 
      END SUBROUTINE BD_CBUSH0
