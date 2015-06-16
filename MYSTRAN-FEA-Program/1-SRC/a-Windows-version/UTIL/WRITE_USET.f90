! ##################################################################################################################################
      SUBROUTINE WRITE_USET

! Writes the NGRID x 6 USET table to the F06 file based on user supplied Bulk Data Param PRTUSET

      USE PENTIUM_II_KIND, ONLY       :  BYTE, LONG
      USE IOUNT1, ONLY                :  F04, F06, WRT_LOG
      USE SCONTR, ONLY                :  BLNK_SUB_NAM, MTSET, NDOFG, NGRID, NUM_USET_U1, NUM_USET_U2
      USE TIMDAT, ONLY                :  TSEC
      USE MODEL_STUF, ONLY            :  GRID, GRID_SEQ, INV_GRID_SEQ
      USE PARAMS, ONLY                :  PRTUSET
      USE SUBR_BEGEND_LEVELS, ONLY    :  WRITE_USET_BEGEND
      USE DOF_TABLES, ONLY            :  TDOF, USET, USETSTR_TABLE

      USE WRITE_USET_USE_IFs

      IMPLICIT NONE

      CHARACTER(LEN=LEN(BLNK_SUB_NAM)):: SUBR_NAME = 'WRITE_USET'

      INTEGER(LONG)                   :: I,J               ! DO loop indices
      INTEGER(LONG), PARAMETER        :: SUBR_BEGEND = WRITE_USET_BEGEND

! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9001) SUBR_NAME,TSEC
 9001    FORMAT(1X,A,' BEGN ',F10.3)
      ENDIF

! **********************************************************************************************************************************
! Write the USET table

      IF (PRTUSET > 0) THEN

         WRITE(F06,56)
         WRITE(F06,57)

i_do:    DO I=1,NGRID
            IF ((USET(I,1)(1:1) == 'U') .OR. (USET(I,2)(1:1) == 'U') .OR. (USET(I,3)(1:1) == 'U') .OR.                             &
               (USET(I,4)(1:1) == 'U') .OR. (USET(I,5)(1:1) == 'U') .OR. (USET(I,6)(1:1) == 'U')) THEN
               WRITE(F06,58) GRID(I,1), (USET(I,J),J = 1,MTSET)
            ELSE 
               CYCLE i_do
            ENDIF
         ENDDO i_do
         WRITE(F06,'(//)')

      ENDIF

! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9002) SUBR_NAME,TSEC
 9002    FORMAT(1X,A,' END  ',F10.3)
      ENDIF

      RETURN

! **********************************************************************************************************************************
   56 FORMAT(50X,'DEGREES OF FREEDOM DEFINED ON USET BULK DATA ENTRIES'                                                            &
          ,/,50X,'----------------------------------------------------',/)

   57 FORMAT(42x,'     Grid       T1       T2       T3       R1       R2       R3',/)

   58 FORMAT(42X,I9,32767(7X,A2))

! **********************************************************************************************************************************

      END SUBROUTINE WRITE_USET
