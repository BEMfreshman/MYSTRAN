! ##################################################################################################################################
 
      SUBROUTINE PLANE_COORD_TRANS_21 ( THETA, T21, CALLING_SUBR )
 
! Creates a coordinate transformation matrix for a plane rotation of a vector in coordinate system 1, through an angle THETA, to
! a vector in coordinate system 2

!                             | U2 |   |  cos(THETA)  sin(THETA)  0 | | U1 |
!                             | V2 | = | -sin(THETA)  cos(THETA)  0 | | V1 |
!                             | W2 |   |      0           0       1 | | W1 |
 
      USE PENTIUM_II_KIND, ONLY       :  BYTE, LONG, DOUBLE
      USE IOUNT1, ONLY                :  F04, WRT_LOG
      USE SCONTR, ONLY                :  BLNK_SUB_NAM
      USE TIMDAT, ONLY                :  TSEC
      USE CONSTANTS_1, ONLY           :  ONE, ZERO
      USE SUBR_BEGEND_LEVELS, ONLY    :  PLANE_COORD_TRANS_21_BEGEND
      
      USE PLANE_COORD_TRANS_21_USE_IFs

      IMPLICIT NONE
 
!nnn  DLL_EXPORT PLANE_COORD_TRANS_21
!nnn  DLL_IMPORT OURTIM

      CHARACTER(LEN=LEN(BLNK_SUB_NAM)):: SUBR_NAME = 'PLANE_COORD_TRANS_21'
      CHARACTER(LEN=*), INTENT(IN)    :: CALLING_SUBR      ! Subr that called this one

      INTEGER(LONG), PARAMETER        :: SUBR_BEGEND = PLANE_COORD_TRANS_21_BEGEND

      REAL(DOUBLE), INTENT(IN)        :: THETA             ! Angle from x axis of system 1 to x axis of system 2
      REAL(DOUBLE), INTENT(OUT)       :: T21(3,3)          ! Transformation matrix which will transform a vector, U1, in coord sys
!                                                            1 to a vector, U2, in coord sys 2 (i.e. U2 = T21*U1)

      INTRINSIC                       :: DSIN, DCOS

! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9001) SUBR_NAME,TSEC
 9001    FORMAT(1X,A,' BEGN ',F10.3)
      ENDIF
 
! **********************************************************************************************************************************
! Row 1

      T21(1,1) =  DCOS( THETA )
      T21(1,2) =  DSIN( THETA )
      T21(1,3) =  ZERO

! Row 2

      T21(2,1) = -T21(1,2)
      T21(2,2) =  T21(1,1)
      T21(2,3) =  ZERO

! Row 3

      T21(3,1) =  ZERO
      T21(3,2) =  ZERO
      T21(3,3) =  ONE


! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9002) SUBR_NAME,TSEC
 9002    FORMAT(1X,A,' END  ',F10.3)
      ENDIF

      RETURN

! **********************************************************************************************************************************

! **********************************************************************************************************************************

      END SUBROUTINE PLANE_COORD_TRANS_21
