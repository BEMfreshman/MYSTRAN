! ##################################################################################################################################
 
      SUBROUTINE WRITE_INTEGER_VEC ( ARRAY_DESCR, INT_VEC, NROWS )
 
! Writes an integer vector to F06 in a format that has 10 terms across the page (repeated until vector is completely written)

      USE PENTIUM_II_KIND, ONLY       :  BYTE, LONG
      USE IOUNT1, ONLY                :  WRT_BUG, WRT_ERR, WRT_LOG, F04, F06
      USE SCONTR, ONLY                :  BLNK_SUB_NAM
      USE TIMDAT, ONLY                :  TSEC
      USE SUBR_BEGEND_LEVELS, ONLY    :  WRITE_MATRIX_BY_COLS_BEGEND
 
      USE WRITE_VECTOR_USE_IFs

      IMPLICIT NONE
 
      CHARACTER(LEN=LEN(BLNK_SUB_NAM)):: SUBR_NAME = 'WRITE_INTEGER_VEC'
      CHARACTER(LEN=*), INTENT(IN)    :: ARRAY_DESCR       ! Character descriptor of the integer array to be printed
      CHARACTER(131*BYTE)             :: HEADER            ! MAT_DESCRIPTOR centered in a line of output

      INTEGER(LONG), INTENT(IN)       :: NROWS             ! Number of rows in matrix MATOUT
      INTEGER(LONG), INTENT(IN)       :: INT_VEC(NROWS)    ! Integer vector to write out
      INTEGER(LONG)                   :: I,J               ! DO loop indices
      INTEGER(LONG)                   :: INT_VEC_LINE(10)  ! 10 members of INT_VEC
      INTEGER(LONG)                   :: NUM_LEFT          ! Count of the number of rows of INT_VEC left to write out
      INTEGER(LONG)                   :: PAD               ! Number of spaces to pad in HEADER to center MAT_DESCRIPTOR
      INTEGER(LONG), PARAMETER        :: SUBR_BEGEND = WRITE_MATRIX_BY_COLS_BEGEND

      INTRINSIC                       :: LEN

! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9001) SUBR_NAME,TSEC
 9001    FORMAT(1X,A,' BEGN ',F10.3)
      ENDIF

! **********************************************************************************************************************************
      PAD = (132 - LEN(ARRAY_DESCR))/2
      HEADER(1:) = ' '
      HEADER(PAD+1:) = ARRAY_DESCR
      WRITE(F06,101) HEADER

      NUM_LEFT = NROWS
      DO I=1,NROWS,10
         IF (NUM_LEFT >= 10) THEN
            DO J=1,10
               INT_VEC_LINE(J) = INT_VEC(I+J-1)
            ENDDO
            WRITE(F06,103) (INT_VEC_LINE(J),J=1,10)
         ELSE
            DO J=1,NUM_LEFT
               INT_VEC_LINE(J) = INT_VEC(I+J-1)
            ENDDO
            WRITE(F06,103) (INT_VEC_LINE(J),J=1,NUM_LEFT)
         ENDIF
         NUM_LEFT = NUM_LEFT - 10
      ENDDO
      WRITE(F06,*)

! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9002) SUBR_NAME,TSEC
 9002    FORMAT(1X,A,' END  ',F10.3)
      ENDIF

      RETURN

! **********************************************************************************************************************************
  101 FORMAT(1X,/,1X,A,/)

  103 FORMAT(16X,10(I10))

! **********************************************************************************************************************************
 
      END SUBROUTINE WRITE_INTEGER_VEC
