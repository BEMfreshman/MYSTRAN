! ##################################################################################################################################

      SUBROUTINE GET_GRID_AND_COMP ( X_SET, DOF_NUM, GRIDV, COMPV )

! Gets the grid and displ component (1-6) numbers for a DOF listed in array TDOFI.

      USE PENTIUM_II_KIND, ONLY       :  BYTE, LONG, DOUBLE
      USE IOUNT1, ONLY                :  WRT_BUG, WRT_ERR, WRT_LOG, ERR, F04, F06
      USE SCONTR, ONLY                :  BLNK_SUB_NAM, FATAL_ERR, NDOFG
      USE TIMDAT, ONLY                :  TSEC
      USE SUBR_BEGEND_LEVELS, ONLY    :  GET_GRID_AND_COMP_BEGEND
      USE DOF_TABLES, ONLY            :  TDOFI

      USE GET_GRID_AND_COMP_USE_IFs

      IMPLICIT NONE

      CHARACTER(LEN=LEN(BLNK_SUB_NAM)):: SUBR_NAME = 'GET_GRID_AND_COMP'
      CHARACTER(LEN=*), INTENT(IN)    :: X_SET             ! Displ set designator (if one exists) for the col in TDOFI

      INTEGER(LONG), INTENT(IN)       :: DOF_NUM           ! DOF number in TDOF
      INTEGER(LONG), INTENT(OUT)      :: COMPV             ! Comp. num corresponding to DOF_NUM in array TDOFI, col X_SET_COL_NUM
      INTEGER(LONG), INTENT(OUT)      :: GRIDV             ! Grid num corresponding to DOF_NUM in array TDOFI, col X_SET_COL_NUM
      INTEGER(LONG)                   :: I                 ! DO loop index
      INTEGER(LONG)                   :: X_SET_COL_NUM     ! Col number, in TDOFI array, of the X-set DOF list
      INTEGER(LONG), PARAMETER        :: SUBR_BEGEND = GET_GRID_AND_COMP_BEGEND

! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9001) SUBR_NAME,TSEC
 9001    FORMAT(1X,A,' BEGN ',F10.3)
      ENDIF

! **********************************************************************************************************************************
! Initialize outputs

      GRIDV = 0
      COMPV = 0

! Calc outputs

      CALL TDOF_COL_NUM ( X_SET, X_SET_COL_NUM )
      DO I=1,NDOFG
         IF (TDOFI(I, X_SET_COL_NUM) == DOF_NUM) THEN
            GRIDV = TDOFI(I,1)
            COMPV = TDOFI(I,2)
            EXIT
         ENDIF
      ENDDO

! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9002) SUBR_NAME,TSEC
 9002    FORMAT(1X,A,' END  ',F10.3)
      ENDIF

      RETURN

! **********************************************************************************************************************************

! **********************************************************************************************************************************

      END SUBROUTINE GET_GRID_AND_COMP