! ##################################################################################################################################
 
      SUBROUTINE WRITE_FEMAP_GRID_VECS ( GRID_VEC, FEMAP_SET_ID, WHAT )
 
! Writes grid related vectors to FEMAP neutral file (displ, applied load, SPC and MPC forces)

      USE PENTIUM_II_KIND, ONLY       :  BYTE, LONG, DOUBLE
      USE IOUNT1, ONLY                :  WRT_BUG, WRT_ERR, WRT_LOG, ERR, F04, F06, NEU
      USE SCONTR, ONLY                :  BLNK_SUB_NAM, FATAL_ERR, NDOFG, NGRID
      USE TIMDAT, ONLY                :  TSEC
      USE CONSTANTS_1, ONLY           :  ZERO
      USE MODEL_STUF, ONLY            :  GRID_ID, INV_GRID_SEQ
      USE SUBR_BEGEND_LEVELS, ONLY    :  WRITE_FEMAP_GRID_VECS_BEGEND
 
      USE WRITE_FEMAP_GRID_VECS_USE_IFs

      IMPLICIT NONE
 
      CHARACTER(LEN=LEN(BLNK_SUB_NAM)):: SUBR_NAME = 'WRITE_FEMAP_GRID_VECS'
      CHARACTER(LEN=*), INTENT(IN)    :: WHAT              ! Indicator if GRID_VEC is DISP, OLOA, SPCF or MPCF
      CHARACTER(LEN= 3*BYTE)          :: TITLE1(4,2)       ! Titles for vectors written to NEU
      CHARACTER(LEN=20*BYTE)          :: TITLE2(2)         ! Titles for vectors written to NEU

      INTEGER(LONG), INTENT(IN)       :: FEMAP_SET_ID      ! FEMAP set ID to write out
      INTEGER(LONG)                   :: GRID_MAX          ! Grid ID where vector is max
      INTEGER(LONG)                   :: GRID_MIN          ! Grid ID where vector is min
      INTEGER(LONG)                   :: GRID_NUMS(NGRID)  ! Grid ID's in global order
      INTEGER(LONG)                   :: I                 ! DO loop index
      INTEGER(LONG)                   :: IARRAY(NGRID)     ! Original GRID_NUMS array
      INTEGER(LONG)                   :: IDOFG             ! A G-set DOF number
      INTEGER(LONG)                   :: ID(20)            ! Vector ID's for FEMAP output
      INTEGER(LONG)                   :: NUM_COMPS         ! 6 if GRID_NUM is an physical grid, 1 if an SPOINT
      INTEGER(LONG)                   :: VEC_ID_OFFSET     ! Offset in determining output vector ID
      INTEGER(LONG)                   :: VEC_ID            ! Vector ID for FEMAP output
      INTEGER(LONG), PARAMETER        :: SUBR_BEGEND = WRITE_FEMAP_GRID_VECS_BEGEND

      REAL(DOUBLE) , INTENT(IN)       :: GRID_VEC(NDOFG)   ! G-set Vector to process
      REAL(DOUBLE)                    :: TOTR_VEC(NGRID)   ! RSS of 6 rotation    components in  GRID_VEC
      REAL(DOUBLE)                    :: TOTT_VEC(NGRID)   ! RSS of 6 translation components in  GRID_VEC
      REAL(DOUBLE)                    :: T1_VEC(NGRID)     ! T1 translation component from GRID_VEC
      REAL(DOUBLE)                    :: T2_VEC(NGRID)     ! T2 translation component from GRID_VEC
      REAL(DOUBLE)                    :: T3_VEC(NGRID)     ! T3 translation component from GRID_VEC
      REAL(DOUBLE)                    :: R1_VEC(NGRID)     ! R1 rotation    component from GRID_VEC
      REAL(DOUBLE)                    :: R2_VEC(NGRID)     ! R2 rotation    component from GRID_VEC
      REAL(DOUBLE)                    :: R3_VEC(NGRID)     ! R3 rotation    component from GRID_VEC
      REAL(DOUBLE)                    :: VEC_ABS           ! Abs value in vector
      REAL(DOUBLE)                    :: VEC_MAX           ! Max value in vector
      REAL(DOUBLE)                    :: VEC_MIN           ! Min value in vector
 
! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9001) SUBR_NAME,TSEC
 9001    FORMAT(1X,A,' BEGN ',F10.3)
      ENDIF

! **********************************************************************************************************************************
      TITLE1(1,1) = 'RSS'
      TITLE1(2,1) = 'T1'
      TITLE1(3,1) = 'T2'
      TITLE1(4,1) = 'T3'
      TITLE1(1,2) = 'RSS'
      TITLE1(2,2) = 'R1'
      TITLE1(3,2) = 'R2'
      TITLE1(4,2) = 'R3'

      IF      (WHAT == 'DISP') THEN
         VEC_ID_OFFSET = 10000
         TITLE2(1) = ' translation'
         TITLE2(2) = ' rotation'
      ELSE IF (WHAT == 'OLOA') THEN
         VEC_ID_OFFSET = 20000
         TITLE2(1) = ' applied force'
         TITLE2(2) = ' applied moment'
      ELSE IF (WHAT == 'SPCF') THEN
         VEC_ID_OFFSET = 30000
         TITLE2(1) = ' SPC force'
         TITLE2(2) = ' SPC moment'
      ELSE IF (WHAT == 'MPCF') THEN
         VEC_ID_OFFSET = 40000
         TITLE2(1) = ' MPC force'
         TITLE2(2) = ' MPC moment'
      ELSE
         FATAL_ERR = FATAL_ERR + 1
         WRITE(ERR,939) SUBR_NAME, WHAT
         WRITE(F06,939) SUBR_NAME, WHAT
         CALL OUTA_HERE ( 'Y' )
      ENDIF

      IDOFG = 0
      DO I=1,NGRID

         T1_VEC(I)    = ZERO
         T2_VEC(I)    = ZERO
         T3_VEC(I)    = ZERO
         R1_VEC(I)    = ZERO
         R2_VEC(I)    = ZERO
         R3_VEC(I)    = ZERO

         GRID_NUMS(I) = GRID_ID(INV_GRID_SEQ(I))
         CALL GET_GRID_NUM_COMPS ( GRID_NUMS(I), NUM_COMPS, SUBR_NAME )

         IF (NUM_COMPS == 6) THEN
            IDOFG = IDOFG + 1   ;  T1_VEC(I)    = GRID_VEC(IDOFG)
            IDOFG = IDOFG + 1   ;  T2_VEC(I)    = GRID_VEC(IDOFG)
            IDOFG = IDOFG + 1   ;  T3_VEC(I)    = GRID_VEC(IDOFG)
            IDOFG = IDOFG + 1   ;  R1_VEC(I)    = GRID_VEC(IDOFG)
            IDOFG = IDOFG + 1   ;  R2_VEC(I)    = GRID_VEC(IDOFG)
            IDOFG = IDOFG + 1   ;  R3_VEC(I)    = GRID_VEC(IDOFG)
         ELSE
            IDOFG = IDOFG + 1   ;  T1_VEC(I)    = GRID_VEC(IDOFG)
         ENDIF

         TOTR_VEC(I)  = DSQRT( R1_VEC(I)*R1_VEC(I) + R2_VEC(I)*R2_VEC(I) + R3_VEC(I)*R3_VEC(I) )
         TOTT_VEC(I)  = DSQRT( T1_VEC(I)*T1_VEC(I) + T2_VEC(I)*T2_VEC(I) + T3_VEC(I)*T3_VEC(I) )

      ENDDO

! Write total translation vector output to FEMAP neutral file

      VEC_ID = VEC_ID_OFFSET + 1
      WRITE(NEU,1001) FEMAP_SET_ID, VEC_ID
      WRITE(NEU,1002) TITLE1(1,1), TITLE2(1)
      CALL GET_VEC_MIN_MAX_ABS ( NGRID, GRID_NUMS, TOTT_VEC, VEC_MIN, VEC_MAX, VEC_ABS, GRID_MIN, GRID_MAX )
      WRITE(NEU,1003) VEC_MIN, VEC_MAX, VEC_ABS
      ID(1) = VEC_ID + 1
      ID(2) = VEC_ID + 2
      ID(3) = VEC_ID + 3
      DO I=4,20
         ID(I) = 0
      ENDDO
      WRITE(NEU,1004) (ID(I),I= 1,10)
      WRITE(NEU,1004) (ID(I),I=11,20)
      WRITE(NEU,1005) GRID_MIN, GRID_MAX
      DO I=1,NGRID
         IARRAY(I) = GRID_NUMS(I)
      ENDDO
      CALL SORT_INT1_REAL1 ( SUBR_NAME, 'FEMAP ARRAYS: GRID_NUMS, TOTT_VEC', NGRID, IARRAY, TOTT_VEC )
      DO I=1,NGRID
         WRITE(NEU,1006) IARRAY(I), TOTT_VEC(I)
      ENDDO
      WRITE(NEU,1007)

! Write T1 translation vector output to FEMAP neutral file

      VEC_ID = VEC_ID_OFFSET + 2
      WRITE(NEU,1001) FEMAP_SET_ID, VEC_ID
      WRITE(NEU,1002) TITLE1(2,1), TITLE2(1)
      DO I=1,NGRID
         IARRAY(I) = GRID_NUMS(I)
      ENDDO
      CALL GET_VEC_MIN_MAX_ABS ( NGRID, GRID_NUMS, T1_VEC, VEC_MIN, VEC_MAX, VEC_ABS, GRID_MIN, GRID_MAX )
      WRITE(NEU,1003) VEC_MIN, VEC_MAX, VEC_ABS
      ID(1) = VEC_ID
      ID(2) = 0
      ID(3) = 0
      DO I=4,20
         ID(I) = 0
      ENDDO
      WRITE(NEU,1004) (ID(I),I= 1,10)
      WRITE(NEU,1004) (ID(I),I=11,20)
      WRITE(NEU,1005) GRID_MIN, GRID_MAX
      DO I=1,NGRID
         IARRAY(I) = GRID_NUMS(I)
      ENDDO
      CALL SORT_INT1_REAL1 ( SUBR_NAME, 'FEMAP ARRAYS: GRID_NUMS, T1_VEC', NGRID,  IARRAY, T1_VEC )
      DO I=1,NGRID
         WRITE(NEU,1006) IARRAY(I), T1_VEC(I)
      ENDDO
      WRITE(NEU,1007)

! Write T2 translation vector output to FEMAP neutral file

      VEC_ID = VEC_ID_OFFSET + 3
      WRITE(NEU,1001) FEMAP_SET_ID, VEC_ID
      WRITE(NEU,1002) TITLE1(3,1), TITLE2(1)
      CALL GET_VEC_MIN_MAX_ABS ( NGRID, GRID_NUMS, T2_VEC, VEC_MIN, VEC_MAX, VEC_ABS, GRID_MIN, GRID_MAX )
      WRITE(NEU,1003) VEC_MIN, VEC_MAX, VEC_ABS
      ID(1) = 0
      ID(2) = VEC_ID
      ID(3) = 0
      DO I=4,20
         ID(I) = 0
      ENDDO
      WRITE(NEU,1004) (ID(I),I= 1,10)
      WRITE(NEU,1004) (ID(I),I=11,20)
      WRITE(NEU,1005) GRID_MIN, GRID_MAX
      DO I=1,NGRID
         IARRAY(I) = GRID_NUMS(I)
      ENDDO
      CALL SORT_INT1_REAL1 ( SUBR_NAME, 'FEMAP ARRAYS: GRID_NUMS, T2_VEC', NGRID,  IARRAY, T2_VEC )
      DO I=1,NGRID
         WRITE(NEU,1006) IARRAY(I), T2_VEC(I)
      ENDDO
      WRITE(NEU,1007)

! Write T3 translation vector output to FEMAP neutral file

      VEC_ID = VEC_ID_OFFSET + 4
      WRITE(NEU,1001) FEMAP_SET_ID, VEC_ID
      WRITE(NEU,1002) TITLE1(4,1), TITLE2(1)
      CALL GET_VEC_MIN_MAX_ABS ( NGRID, GRID_NUMS, T3_VEC, VEC_MIN, VEC_MAX, VEC_ABS, GRID_MIN, GRID_MAX )
      WRITE(NEU,1003) VEC_MIN, VEC_MAX, VEC_ABS
      ID(2) = 0
      ID(1) = 0
      ID(3) = VEC_ID
      DO I=4,20
         ID(I) = 0
      ENDDO
      WRITE(NEU,1004) (ID(I),I= 1,10)
      WRITE(NEU,1004) (ID(I),I=11,20)
      WRITE(NEU,1005) GRID_MIN, GRID_MAX
      DO I=1,NGRID
         IARRAY(I) = GRID_NUMS(I)
      ENDDO
      CALL SORT_INT1_REAL1 ( SUBR_NAME, 'FEMAP ARRAYS: GRID_NUMS, T3_VEC', NGRID,  IARRAY, T3_VEC )
      DO I=1,NGRID
         WRITE(NEU,1006) IARRAY(I), T3_VEC(I)
      ENDDO
      WRITE(NEU,1007)

! Write total rotation vector output to FEMAP neutral file

      VEC_ID = VEC_ID_OFFSET + 5
      WRITE(NEU,1001) FEMAP_SET_ID, VEC_ID
      WRITE(NEU,1002) TITLE1(1,2), TITLE2(2)
      CALL GET_VEC_MIN_MAX_ABS ( NGRID, GRID_NUMS, TOTR_VEC, VEC_MIN, VEC_MAX, VEC_ABS, GRID_MIN, GRID_MAX )
      WRITE(NEU,1003) VEC_MIN, VEC_MAX, VEC_ABS
      ID(1) = VEC_ID + 1
      ID(2) = VEC_ID + 2
      ID(3) = VEC_ID + 3
      DO I=4,20
         ID(I) = 0
      ENDDO
      WRITE(NEU,1004) (ID(I),I= 1,10)
      WRITE(NEU,1004) (ID(I),I=11,20)
      WRITE(NEU,1005) GRID_MIN, GRID_MAX
      DO I=1,NGRID
         IARRAY(I) = GRID_NUMS(I)
      ENDDO
      CALL SORT_INT1_REAL1 ( SUBR_NAME, 'FEMAP ARRAYS: GRID_NUMS, TOTR_VEC', NGRID,  IARRAY, TOTR_VEC )
      DO I=1,NGRID
         WRITE(NEU,1006) IARRAY(I), TOTR_VEC(I)
      ENDDO
      WRITE(NEU,1007)

! Write R1 translation vector output to FEMAP neutral file

      VEC_ID = VEC_ID_OFFSET + 6
      WRITE(NEU,1001) FEMAP_SET_ID, VEC_ID
      WRITE(NEU,1002) TITLE1(2,2), TITLE2(2)
      CALL GET_VEC_MIN_MAX_ABS ( NGRID, GRID_NUMS, R1_VEC, VEC_MIN, VEC_MAX, VEC_ABS, GRID_MIN, GRID_MAX )
      WRITE(NEU,1003) VEC_MIN, VEC_MAX, VEC_ABS
      ID(1) = VEC_ID
      ID(2) = 0
      ID(3) = 0
      DO I=4,20
         ID(I) = 0
      ENDDO
      WRITE(NEU,1004) (ID(I),I= 1,10)
      WRITE(NEU,1004) (ID(I),I=11,20)
      WRITE(NEU,1005) GRID_MIN, GRID_MAX
      DO I=1,NGRID
         IARRAY(I) = GRID_NUMS(I)
      ENDDO
      CALL SORT_INT1_REAL1 ( SUBR_NAME, 'FEMAP ARRAYS: GRID_NUMS, R1_VEC', NGRID,  IARRAY, R1_VEC )
      DO I=1,NGRID
         WRITE(NEU,1006) IARRAY(I), R1_VEC(I)
      ENDDO
      WRITE(NEU,1007)

! Write R2 translation vector output to FEMAP neutral file

      VEC_ID = VEC_ID_OFFSET + 7
      WRITE(NEU,1001) FEMAP_SET_ID, VEC_ID
      WRITE(NEU,1002) TITLE1(3,2), TITLE2(2)
      CALL GET_VEC_MIN_MAX_ABS ( NGRID, GRID_NUMS, R2_VEC, VEC_MIN, VEC_MAX, VEC_ABS, GRID_MIN, GRID_MAX )
      WRITE(NEU,1003) VEC_MIN, VEC_MAX, VEC_ABS
      ID(1) = 0
      ID(2) = VEC_ID
      ID(3) = 0
      DO I=4,20
         ID(I) = 0
      ENDDO
      WRITE(NEU,1004) (ID(I),I= 1,10)
      WRITE(NEU,1004) (ID(I),I=11,20)
      WRITE(NEU,1005) GRID_MIN, GRID_MAX
      DO I=1,NGRID
         IARRAY(I) = GRID_NUMS(I)
      ENDDO
      CALL SORT_INT1_REAL1 ( SUBR_NAME, 'FEMAP ARRAYS: GRID_NUMS, R2_VEC', NGRID,  IARRAY, R2_VEC )
      DO I=1,NGRID
         WRITE(NEU,1006) IARRAY(I), R2_VEC(I)
      ENDDO
      WRITE(NEU,1007)

! Write R3 translation vector output to FEMAP neutral file

      VEC_ID = VEC_ID_OFFSET + 8
      WRITE(NEU,1001) FEMAP_SET_ID, VEC_ID
      WRITE(NEU,1002) TITLE1(4,2), TITLE2(2)
      CALL GET_VEC_MIN_MAX_ABS ( NGRID, GRID_NUMS, R3_VEC, VEC_MIN, VEC_MAX, VEC_ABS, GRID_MIN, GRID_MAX )
      WRITE(NEU,1003) VEC_MIN, VEC_MAX, VEC_ABS
      ID(2) = 0
      ID(1) = 0
      ID(3) = VEC_ID
      DO I=4,20
         ID(I) = 0
      ENDDO
      WRITE(NEU,1004) (ID(I),I= 1,10)
      WRITE(NEU,1004) (ID(I),I=11,20)
      WRITE(NEU,1005) GRID_MIN, GRID_MAX
      DO I=1,NGRID
         IARRAY(I) = GRID_NUMS(I)
      ENDDO
      CALL SORT_INT1_REAL1 ( SUBR_NAME, 'FEMAP ARRAYS: GRID_NUMS, R3_VEC', NGRID,  IARRAY, R3_VEC )
      DO I=1,NGRID
         WRITE(NEU,1006) IARRAY(I), R3_VEC(I)
      ENDDO
      WRITE(NEU,1007)

! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9002) SUBR_NAME,TSEC
 9002    FORMAT(1X,A,' END  ',F10.3)
      ENDIF

      RETURN

! **********************************************************************************************************************************
  939 FORMAT(' ERROR   939: PROGRAMMING ERROR IN SUBROUTINE ',A                                                                   &
                   ,/,14X,' WRONG VALUE = ',A,' FOR ARGUMENT "WHAT"')             

 1001 FORMAT(2(I8,','),'       1,')

 1002 FORMAT(2A)

 1003 FORMAT(3(1ES17.6,','))

 1004 FORMAT(10(I8,','))

 1005 FORMAT(2(I8,','),'       1,       7,',/,'       1,       1,       1')

 1006 FORMAT(I8,',',1ES17.6,',')

 1007 FORMAT('      -1,     0.          ,')

! **********************************************************************************************************************************
 
      END SUBROUTINE WRITE_FEMAP_GRID_VECS
