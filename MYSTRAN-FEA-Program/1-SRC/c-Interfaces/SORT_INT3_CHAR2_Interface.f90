! ##################################################################################################################################

   MODULE SORT_INT3_CHAR2_Interface

   INTERFACE

      SUBROUTINE SORT_INT3_CHAR2 ( CALLING_SUBR, MESSAG, NSIZE, IARRAY1, IARRAY2, IARRAY3, CARRAY1, CARRAY2 )

                                    
      USE PENTIUM_II_KIND, ONLY       :  BYTE, LONG, DOUBLE
      USE IOUNT1, ONLY                :  WRT_BUG, WRT_ERR, WRT_LOG, ERR, F04, F06
      USE SCONTR, ONLY                :  BLNK_SUB_NAM, FATAL_ERR
      USE PARAMS, ONLY                :  SORT_MAX
      USE TIMDAT, ONLY                :  TSEC
      USE SUBR_BEGEND_LEVELS, ONLY    :  SORT_INT3_CHAR2_BEGEND
 
      IMPLICIT NONE
 
      CHARACTER(LEN=*), INTENT(IN)    :: CALLING_SUBR      ! Subr that called this subr
      INTEGER(LONG), INTENT(IN)       :: NSIZE             ! No. rows in arrays IARRAY, RARRAY
      CHARACTER(LEN=*), INTENT(INOUT) :: CARRAY1(NSIZE)    ! Character array
      CHARACTER(LEN=*), INTENT(INOUT) :: CARRAY2(NSIZE)    ! Character array
      CHARACTER(LEN=LEN(CARRAY1))     :: CDUM1             ! Dummy values in CARRAY1 used when switching CARRAY1 rows during sort.
      CHARACTER(LEN=LEN(CARRAY2))     :: CDUM2             ! Dummy values in CARRAY2 used when switching CARRAY2 rows during sort.
      CHARACTER(LEN=*), INTENT(IN)    :: MESSAG            ! Message to be written out if this subr fails to sort

      INTEGER(LONG), INTENT(INOUT)    :: IARRAY1(NSIZE)    ! Integer array
      INTEGER(LONG), INTENT(INOUT)    :: IARRAY2(NSIZE)    ! Integer array
      INTEGER(LONG), INTENT(INOUT)    :: IARRAY3(NSIZE)    ! Integer array
      INTEGER(LONG)                   :: IDUM1,IDUM2,IDUM3 ! Dummy values in IARRAY used when switching IARRAY rows during sort. 
      INTEGER(LONG)                   :: JCT               ! Shell sort parameter returned from subroutine SORTLEN.
      INTEGER(LONG)                   :: SORTPK            ! Intermediate variable used in setting a DO loop range.
      INTEGER(LONG), PARAMETER        :: SUBR_BEGEND = SORT_INT3_CHAR2_BEGEND

      END SUBROUTINE SORT_INT3_CHAR2

   END INTERFACE

   END MODULE SORT_INT3_CHAR2_Interface

