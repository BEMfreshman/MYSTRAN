! ##################################################################################################################################

   MODULE MERGE_MAT_COLS_SSS_Interface

   INTERFACE

      SUBROUTINE MERGE_MAT_COLS_SSS ( MAT_A_NAME, NTERM_A, I_A, J_A, A, SYM_A, NCOL_A,                                             &

                                      MAT_B_NAME, NTERM_B, I_B, J_B, B, SYM_B, NROWS,                                              &
                                      MAT_C_NAME,          I_C, J_C, C, SYM_C )

      USE PENTIUM_II_KIND, ONLY       :  LONG, DOUBLE
      USE IOUNT1, ONLY                :  WRT_LOG, ERR, F04, F06
      USE SCONTR, ONLY                :  BLNK_SUB_NAM, FATAL_ERR
      USE TIMDAT, ONLY                :  TSEC
      USE CONSTANTS_1, ONLY           :  ZERO
      USE DEBUG_PARAMETERS, ONLY      :  DEBUG
      USE SUBR_BEGEND_LEVELS, ONLY    :  MERGE_MAT_COLS_SSS_BEGEND

      IMPLICIT NONE

      CHARACTER(LEN=*), INTENT(IN)    :: MAT_A_NAME              ! Name of matrix A
      CHARACTER(LEN=*), INTENT(IN)    :: MAT_B_NAME              ! Name of matrix B
      CHARACTER(LEN=*), INTENT(IN)    :: MAT_C_NAME              ! Name of matrix C
      CHARACTER(LEN=*), INTENT(IN)    :: SYM_A                   ! Flag for whether matrix A is stored sym (terms on and above diag)
      CHARACTER(LEN=*), INTENT(IN)    :: SYM_B                   ! Flag for whether matrix B is stored sym (terms on and above diag)
      CHARACTER(LEN=*), INTENT(IN)    :: SYM_C                   ! Flag for whether matrix C is stored sym (terms on and above diag)
      INTEGER(LONG)   , INTENT(IN)    :: NCOL_A                  ! Number of cols in matrix A
      INTEGER(LONG)   , INTENT(IN)    :: NROWS                   ! Number of rows in matrices A, B, C (needed to dim arrays below)
      INTEGER(LONG)   , INTENT(IN)    :: NTERM_A                 ! Number of nonzero terms in input matrix A
      INTEGER(LONG)   , INTENT(IN)    :: NTERM_B                 ! Number of nonzero terms in input matrix B
      INTEGER(LONG)   , INTENT(IN)    :: I_A(NROWS+1)            ! I_A(I+1) - I_A(I) = no. terms in row I of matrix A
      INTEGER(LONG)   , INTENT(IN)    :: I_B(NROWS+1)            ! I_B(I+1) - I_B(I) = no. terms in row I of matrix B
      INTEGER(LONG)   , INTENT(IN)    :: J_A(NTERM_A)            ! Col no's for nonzero terms in matrix A
      INTEGER(LONG)   , INTENT(IN)    :: J_B(NTERM_B)            ! Col no's for nonzero terms in matrix B
      INTEGER(LONG)   , INTENT(OUT)   :: I_C(NROWS+1)            ! I_C(I+1) - I_C(I) = no. terms in row I of matrix C
      INTEGER(LONG)   , INTENT(OUT)   :: J_C(NTERM_A+NTERM_B)    ! Col no's for nonzero terms in matrix C
      INTEGER(LONG)   , PARAMETER     :: SUBR_BEGEND = MERGE_MAT_COLS_SSS_BEGEND

      REAL(DOUBLE)    , INTENT(IN)    :: A(NTERM_A)              ! Nonzero terms in matrix A
      REAL(DOUBLE)    , INTENT(IN)    :: B(NTERM_B)              ! Nonzero terms in matrix B
      REAL(DOUBLE)    , INTENT(OUT)   :: C(NTERM_A+NTERM_B)      ! Nonzero terms in matrix C

      END SUBROUTINE MERGE_MAT_COLS_SSS

   END INTERFACE

   END MODULE MERGE_MAT_COLS_SSS_Interface

