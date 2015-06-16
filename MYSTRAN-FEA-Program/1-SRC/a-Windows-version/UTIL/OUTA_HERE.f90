! ##################################################################################################################################

      SUBROUTINE OUTA_HERE ( WRITE_TO_L1A ) 
 
! Routine called when MYSTRAN has to stop due to some error. Writes data to file LINK1A, writes error message and stops
 
      USE PENTIUM_II_KIND, ONLY       :  BYTE, LONG, DOUBLE

      USE IOUNT1, ONLY                :  BUGOUT, F04, F06FIL, SC1, WRT_LOG,                                                        &
                                         BUGSTAT, BUGSTAT_OLD, ERRSTAT, ERRSTAT_OLD, F04STAT, F04STAT_OLD, L1ASTAT 

      USE SCONTR, ONLY                :  BLNK_SUB_NAM, FATAL_ERR, LINKNO, WARN_ERR 
      USE TIMDAT, ONLY                :  TSEC
      USE PARAMS, ONLY                :  SUPWARN
      USE SUBR_BEGEND_LEVELS, ONLY    :  OUTA_HERE_BEGEND
 
      USE OUTA_HERE_USE_IFs

      IMPLICIT NONE
 
      LOGICAL                         :: FILE_OPND         ! Output from INQUIRE intrinsic function         

      CHARACTER(LEN=LEN(BLNK_SUB_NAM)):: SUBR_NAME = 'OUTA_HERE'
      CHARACTER( 1*BYTE), INTENT(IN)  :: WRITE_TO_L1A      ! Y/N indicator of whether to call subr WRITE_L1A
      CHARACTER( 8*BYTE)              :: CLOSE_STAT        ! What to do with file when it is closed

      INTEGER(LONG), PARAMETER        :: SUBR_BEGEND = OUTA_HERE_BEGEND

! **********************************************************************************************************************************
      INQUIRE(UNIT=F04,OPENED=FILE_OPND)
      IF (FILE_OPND) THEN
         IF (WRT_LOG >= SUBR_BEGEND) THEN
            CALL OURTIM
 9001       FORMAT(1X,A,' BEGN ',F10.3)
         ENDIF
      ENDIF

! Write data to LINK1A, if we are in LINK1

      IF (WRITE_TO_L1A == 'Y') THEN

         IF (FATAL_ERR > 0) THEN                           ! Check fatal error flag and write message
            WRITE(SC1,9992) FATAL_ERR
         ENDIF

         IF (WARN_ERR > 0) THEN                            ! Check warning flag and write message
            IF (SUPWARN == 'Y') THEN
               WRITE(SC1,9994) WARN_ERR
            ELSE
               WRITE(SC1,9993) WARN_ERR
            ENDIF
         ENDIF

         WRITE(SC1,9999)
         CALL WRITE_FILNAM ( F06FIL, SC1, 1 )

            CLOSE_STAT = L1ASTAT
            CALL WRITE_L1A ( CLOSE_STAT, 'N', 'N' )

! Set close status for output files

         IF (BUGOUT == 'Y') THEN
            BUGSTAT = 'KEEP'
         ELSE
            IF (BUGSTAT_OLD == 'KEEP    ') THEN
               BUGSTAT = 'KEEP'
            ELSE
               BUGSTAT = 'DELETE'
            ENDIF
         ENDIF

         IF ((FATAL_ERR > 0) .OR. (WARN_ERR > 0)) THEN
            ERRSTAT = 'KEEP'
         ELSE
            IF (ERRSTAT_OLD == 'KEEP    ') THEN
               ERRSTAT = 'KEEP'
            ELSE
               ERRSTAT = 'DELETE'
            ENDIF
         ENDIF

         IF (WRT_LOG > 0) THEN
            F04STAT = 'KEEP'
         ELSE
            IF (F04STAT_OLD == 'KEEP    ') THEN
               F04STAT = 'KEEP'
            ELSE
               F04STAT = 'DELETE'
            ENDIF
         ENDIF

      ELSE

         WRITE(SC1,9999)
         CALL WRITE_FILNAM ( F06FIL, SC1, 1 )

      ENDIF

      CALL CLOSE_OUTFILES ( BUGSTAT, ERRSTAT, F04STAT )

      STOP

! **********************************************************************************************************************************
 9992 FORMAT(' CHECK F06 OUTPUT FILE FOR ',I8,' FATAL MESSAGE(S)')

 9993 FORMAT(' CHECK F06 OUTPUT FILE FOR ',I8,' WARNING MESSAGE(S)')

 9994 FORMAT(' CHECK ERR OUTPUT FILE FOR ',I8,' WARNING MESSAGE(S)')

 9999 FORMAT(' Processing terminated. Check for error messages in output file:')

! **********************************************************************************************************************************
 
      END SUBROUTINE OUTA_HERE
