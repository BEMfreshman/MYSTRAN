! ##################################################################################################################################

   MODULE DEALLOCATE_MODEL_STUF_Interface

   INTERFACE

      SUBROUTINE DEALLOCATE_MODEL_STUF ( NAME_IN )

 
      USE PENTIUM_II_KIND, ONLY       :  BYTE, LONG, DOUBLE
      USE IOUNT1, ONLY                :  WRT_BUG, WRT_ERR, WRT_LOG, ERR, F04, F06
      USE SCONTR, ONLY                :  BLNK_SUB_NAM, FATAL_ERR, TOT_MB_MEM_ALLOC
      USE TIMDAT, ONLY                :  TSEC
      USE CONSTANTS_1, ONLY           :  ZERO
      USE SUBR_BEGEND_LEVELS, ONLY    :  DEALLOCATE_MODEL_STUF_BEGEND

      USE MODEL_STUF, ONLY            :  AGRID, BE1, BE2, BE3, BGRID, DOFPIN, DT, KE, KED, KEM, ME, OFFDIS, OFFSET,                &
                                         PEB, PEG, PEL, PPE, PRESS, PTE, SE1, SE2, SE3, STE1, STE2, STE3, UEB, UEG, UEL, UGG,      &
                                         XEB, XEL, XGL
      USE MODEL_STUF, ONLY            :  CMASS, CONM2, PMASS, RPMASS, RCONM2
      USE MODEL_STUF, ONLY            :  CORD, RCORD, TN
      USE MODEL_STUF, ONLY            :  SEQ1, SEQ2
      USE MODEL_STUF, ONLY            :  BAROFF, BUSHOFF, EDAT, EOFF, EPNT, ESORT1, ESORT2, ETYPE, VVEC
      USE MODEL_STUF, ONLY            :  PRESS_SIDS, PDATA, PPNT, PTYPE
      USE MODEL_STUF, ONLY            :  PLOAD4_3D_DATA
      USE MODEL_STUF, ONLY            :  FORMOM_SIDS
      USE MODEL_STUF, ONLY            :  GRAV_SIDS, RFORCE_SIDS, SLOAD_SIDS
      USE MODEL_STUF, ONLY            :  GRID, RGRID
      USE MODEL_STUF, ONLY            :  GRID_ID, GRID_SEQ, INV_GRID_SEQ, MPC_IND_GRIDS
      USE MODEL_STUF, ONLY            :  MATL, RMATL, PBAR, RPBAR, PBEAM, PBUSH, RPBEAM, RPBUSH, PCOMP, RPCOMP, PELAS, RPELAS,     &
                                         PROD, RPROD, PSHEAR, RPSHEAR, PSHEL, RPSHEL, PSOLID, PUSER1, RPUSER1, PUSERIN,            &
                                         USERIN_ACT_COMPS, USERIN_ACT_GRIDS, USERIN_MAT_NAMES 
      USE MODEL_STUF, ONLY            :  MPC_SIDS, MPCSIDS, MPCADD_SIDS 
      USE MODEL_STUF, ONLY            :  SPC_SIDS, SPC1_SIDS, SPCSIDS, SPCADD_SIDS 
      USE MODEL_STUF, ONLY            :  ALL_SETS_ARRAY, ONE_SET_ARRAY, SETS_IDS, SC_ACCE, SC_DISP, SC_ELFN, SC_ELFE, SC_GPFO,     &
                                         SC_MPCF, SC_OLOA, SC_SPCF, SC_STRE, SC_STRN, LOAD_SIDS, LOAD_FACS       
      USE MODEL_STUF, ONLY            :  ELDT, ELOUT, GROUT, OELOUT, OGROUT, LABEL, SCNUM, STITLE, SUBLOD, TITLE
      USE MODEL_STUF, ONLY            :  SYS_LOAD
      USE MODEL_STUF, ONLY            :  CETEMP, CETEMP_ERR, CGTEMP, CGTEMP_ERR, ETEMP, ETEMP_INIT, GTEMP, GTEMP_INIT, TDATA, TPNT
      USE MODEL_STUF, ONLY            :  RIGID_ELEM_IDS
      USE MODEL_STUF, ONLY            :  MATANGLE, PLATEOFF, PLATETHICK
      USE MODEL_STUF, ONLY            :  GRID_ELEM_CONN_ARRAY
      USE MODEL_STUF, ONLY            :  SPCSETS, MPCSETS

      IMPLICIT NONE

      CHARACTER(LEN=*), INTENT(IN)    :: NAME_IN           ! Name of group of arrays to allocate
      CHARACTER(31*BYTE)              :: NAME              ! Specific array name used for output error message
 
      INTEGER(LONG), PARAMETER        :: SUBR_BEGEND = DEALLOCATE_MODEL_STUF_BEGEND
 
      END SUBROUTINE DEALLOCATE_MODEL_STUF

   END INTERFACE

   END MODULE DEALLOCATE_MODEL_STUF_Interface

