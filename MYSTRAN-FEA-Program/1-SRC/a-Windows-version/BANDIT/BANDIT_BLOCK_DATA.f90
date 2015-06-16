! ##################################################################################################################################
      BLOCK DATA BANDIT_BLOCK_DATA

! **********************************************************************************************************************************
      COMMON /ALPHA/ MA(26),NUM(10),MB(4)

      INTEGER  MA ,NUM ,MB

!              1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26
      DATA MA/'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'/

!     Alphabet key for MA array - - -

!        A - 1          N - 14
!        B - 2          O - 15
!        C - 3          P - 16
!        D - 4          Q - 17
!        E - 5          R - 18
!        F - 6          S - 19
!        G - 7          T - 20
!        H - 8          U - 21
!        I - 9          V - 22
!        J - 10         W - 23
!        K - 11         X - 24
!        L - 12         Y - 25
!        M - 13         Z - 26

      DATA NUM/'0','1','2','3','4','5','6','7','8','9'/

      DATA MB/'$',' ','+','*'/

! **********************************************************************************************************************************
! I/O files

      COMMON /IOUNIT/IOU5 ,IOU6 , IOU7 ,IOU8  ,IOU9  ,IOU10, IOU11, IOU12, IOU13, IOU14, IOU15, IOU16, IOU17, IOU18, IOU19, IOU20

      INTEGER        IOU5 ,IOU6 , IOU7 ,IOU8  ,IOU9  ,IOU10, IOU11, IOU12, IOU13, IOU14, IOU15, IOU16, IOU17, IOU18, IOU19, IOU20

! Do not set unit for input file (IOU5) - this is MYSTRAN IN1 file

      DATA                 IOU6 , IOU7 ,IOU8  , IOU9 ,IOU10, IOU11, IOU12, IOU13, IOU14, IOU15, IOU16, IOU17, IOU18, IOU19, IOU20  &
                          /1006 , 1007 ,1008  , 1009 , 1010,  1011,  1012,  1013,  1014,  1015,  1016,  1017,  1018,  1019,  1020/

! **********************************************************************************************************************************
      COMMON /A/ MAXGRD,MAXDEG,KMOD

      INTEGER  MAXGRD ,MAXDEG ,KMOD

! **********************************************************************************************************************************
! To add new B.D. element connection entries to the Bandit library, the only code changes required occur in this section of code
! by noting the following. The 4 DATA statements, VYPE, TYPE, WYPE and ME below define the BD entry and are dimensioned large enough
! for up to 160 BD entry types. Using CQUAD4K as an example:

!    (1) VYPE has the 1st letter for the BD entry (e.g. for CQUAD4K this would be 'C'   )
!    (2) TYPE has the 2nd through 5th letters     (e.g. for CQUAD4K this would be 'QUAD')
!    (3) WYPE has the 6th through 8th letters     (e.g. for CQUAD4K this would be '4K ' )
!    (4) ME is an integer that is: ME = [10*(number of elem grids) + (number of the 1st field where an elem grid is located)].
!        For example for CQUAD4K there are 4 grids and the 1st grid is in field 4 so ME = 44
!    (5) NTYPE is the actual number of BD elem connection entries (which currently is 139; see below) and must be less than the
!        dimension af arrays VYPE, TYPE, WYPE and ME (160, see below)

! For the VYPE, TYPE, WYPE and ME array DATA statements below, the values for the 1st NTYPE = 139 entries are shown and the
! 21 (for a total of 160) are blank or zero remaining. To add a new element, merely fill in the next available slot in VYPE, TYPE,
! WYPE and ME with the appropriate data as described above. At the current time the next available slot is 139+1 = 140.
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!                       MAKE SURE NTYPE IS INCREASED IF ANY MORE VALUES ARE ADDED TO VYPE, TYPE, WYPE, ME
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


! For elements which need not have all grid connections present
!      (e.g., CELAS1 or CPENTA), set   LESSOK=.TRUE.   in subroutine ELTYPE.
! For long-field cards, set LEN=2 in ELTYPE.

      COMMON /ELEM/ NTYPE, VYPE(160), TYPE(160), WYPE(160), ME(160), NELEM(160),MDIM
      
      INTEGER vype, TYPE, WYPE
      INTEGER  NTYPE  ,ME     ,NELEM  ,MDIM

      DATA MDIM/160/

! MDIM=Dimension of TYPE, WYPE, etc. Used in DOLLAR to add user-defined elements with $APPEND card.
! MDIM must exceed NTYPE to allow for the definition of new elements at execution time using $APPEND card.

      DATA NTYPE/139/

! NTYPE = Number of elements in library. Since dimension of TYPE, WYPE, and ME is larger, future expansion is provided for.

!     DATA VYPE                                                                                     &
!     /  'E'    , 'M'    , 'M'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    ,  &                    !   1 -  10
!        'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    ,  &                    !  11 -  20
!        'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    ,  &                    !  21 -  30
!        'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    ,  &                    !  31 -  40
!        'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    ,  &                    !  41 -  50
!        'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    ,  &                    !  51 -  60
!        'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    ,  &                    !  61 -  70
!        'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    ,  &                    !  71 -  80
!        'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    ,' C'    , 'C'    ,  &                    !  81 -  90
!        'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    ,  &                    !  91 - 100
!        'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    ,  &                    ! 101 - 110
!        'C'    , 'M'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    ,  &                    ! 111 - 120
!        'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'C'    , 'R'    , 'C'    ,  &                    ! 121 - 130
!        'R'    , 'C'    , 'R'    , 'C'    , 'R'    , 'C'    , 'R'    , 'C'    , 'C'    , ' '    ,  &                    ! 131 - 140
!        ' '    , ' '    , ' '    , ' '    , ' '    , ' '    , ' '    , ' '    , ' '    , ' '    ,  &                    ! 141 - 150
!        ' '    , ' '    , ' '    , ' '    , ' '    , ' '    , ' '    , ' '    , ' '    , ' '       /                    ! 151 - 160

      DATA TYPE                                                                                     &
      /  'NDDA' , 'PC  ' , 'PC* ' , 'ELAS' , 'ELAS' , 'DAMP' , 'DAMP' , 'MASS' , 'MASS' , 'ROD ' ,  &                    !   1 -  10
         'TUBE' , 'VISC' , 'DAMP' , 'DAMP' , 'ELAS' , 'ELAS' , 'MASS' , 'MASS' , 'AXIF' , 'AXIF' ,  &                    !  11 -  20
         'AXIF' , 'BAR ' , 'CONE' , 'FLUI' , 'FLUI' , 'FLUI' , 'HBDY' , 'HEXA' , 'HEXA' , 'HTTR' ,  &                    !  21 -  30
         'IS2D' , 'IS2D' , 'IS3D' , 'IS3D' , 'ONM1' , 'ONM2' , 'ONRO' , 'QDME' , 'QDME' , 'QDME' ,  &                    !  31 -  40
         'QDPL' , 'QUAD' , 'QUAD' , 'SHEA' , 'SLOT' , 'SLOT' , 'TETR' , 'TORD' , 'TRAP' , 'TRBS' ,  &                    !  41 -  50
         'TRIA' , 'TRIA' , 'TRIA' , 'TRME' , 'TRPL' , 'TWIS' , 'WEDG' , 'DUMM' , 'DUM1' , 'DUM2' ,  &                    !  51 -  60
         'DUM3' , 'DUM4' , 'DUM5' , 'DUM6' , 'DUM7' , 'DUM8' , 'DUM9' , 'TRIA' , 'TRIM' , 'DAMP' ,  &                    !  61 -  70
         'ELAS' , 'MASS' , 'DAMP' , 'ELAS' , 'MASS' , 'ONM1' , 'ONM2' , 'ONRO' , 'IHEX' , 'IHEX' ,  &                    !  71 -  80
         'IHEX' , 'TRAP' , 'TRIA' , 'QUAD' , 'TRIA' , 'QDME' , 'HEX8' , 'HEX2' , 'TRPL' , 'TRSH' ,  &                    !  81 -  90
         'RIGD' , 'RIGD' , 'RIGD' , 'BEAM' , 'FTUB' , 'HEXA' , 'PENT' , 'QUAD' , 'TRIA' , 'LOOF' ,  &                    !  91 - 100
         'LOOF' , 'LOOF' , 'BEND' , 'GAP ' , 'QUAD' , 'TRIA' , 'ELBO' , 'FHEX' , 'FHEX' , 'FTET' ,  &                    ! 101 - 110
         'FWED' , 'PCAX' , 'AABS' , 'BUSH' , 'BUSH' , 'DAMP' , 'HBDY' , 'QUAD' , 'TRIA' , 'WELD' ,  &                    ! 111 - 120
         'HACA' , 'HACB' , 'QUAD' , 'QUAD' , 'RAC2' , 'RAC3' , 'TRIA' , 'RBAR' , 'BAR ' , 'RBE1' ,  &                    ! 121 - 130
         'BE1 ' , 'RBE2' , 'BE2 ' , 'RROD' , 'ROD ' , 'RTRP' , 'TRPL' , 'QUAD' , 'TRIA' , '    ' ,  &                    ! 131 - 140
         '    ' , '    ' , '    ' , '    ' , '    ' , '    ' , '    ' , '    ' , '    ' , '    ' ,  &                    ! 141 - 150
         '    ' , '    ' , '    ' , '    ' , '    ' , '    ' , '    ' , '    ' , '    ' , '    '    /                    ! 151 - 160

! CWELD probably should not be in this list, but it was retained rather than deal with correcting all the places in the code which
! reference elements by number (e.g., rigid elements).

      DATA WYPE                                                                                     &
      /  'TA '  , '   '  , '   '  , '1  '  , '2  '  , '1  '  , '2  '  , '1  '  , '2  '  , '   '  ,  &                    !   1 -  10
         '   '  , '   '  , '3  '  , '4  '  , '3  '  , '4  '  , '3  '  , '4  '  , '2  '  , '3  '  ,  &                    !  11 -  20
         '4  '  , '   '  , 'AX '  , 'D2 '  , 'D3 '  , 'D4 '  , '   '  , '1  '  , '2  '  , 'I2 '  ,  &                    !  21 -  30
         '4  '  , '8  '  , '8  '  , '20 '  , '   '  , '   '  , 'D  '  , 'M  '  , 'M1 '  , 'M2 '  ,  &                    !  31 -  40
         'T  '  , '1  '  , '2  '  , 'R  '  , '3  '  , '4  '  , 'A  '  , 'RG '  , 'RG '  , 'C  '  ,  &                    !  41 -  50
         '1  '  , '2  '  , 'RG '  , 'M  '  , 'T  '  , 'T  '  , 'E  '  , 'Y  '  , '   '  , '   '  ,  &                    !  51 -  60
         '   '  , '   '  , '   '  , '   '  , '   '  , '   '  , '   '  , 'X6 '  , '6  '  , '4* '  ,  &                    !  61 -  70
         '4* '  , '4* '  , '2* '  , '2* '  , '2* '  , '*  '  , '*  '  , 'D* '  , '1  '  , '2  '  ,  &                    !  71 -  80
         '3  '  , 'AX '  , 'AX '  , 'TS '  , 'TS '  , 'M3 '  , '   '  , '0  '  , 'T1 '  , 'L  '  ,  &                    !  81 -  90
         '1  '  , '2  '  , 'R  '  , '   '  , 'E  '  , '   '  , 'A  '  , '4  '  , '3  '  , '3  '  ,  &                    !  91 - 100
         '6  '  , '8  '  , '   '  , '   '  , '8  '  , '6  '  , 'W  '  , '1  '  , '2  '  , 'RA '  ,  &                    ! 101 - 110
         'GE '  , '   '  , 'F  '  , '   '  , '1D '  , '5  '  , 'P  '  , 'R  '  , 'R  '  , '   '  ,  &                    ! 111 - 120
         'B  '  , 'R  '  , '   '  , 'X  '  , 'D  '  , 'D  '  , 'X  '  , '   '  , '   '  , '   '  ,  &                    ! 121 - 130
         '   '  , '   '  , '   '  , '   '  , '   '  , 'LT '  , 'T  '  , '4K '  , '3K '  , '   '  ,  &                    ! 131 - 140
         '   '  , '   '  , '   '  , '   '  , '   '  , '   '  , '   '  , '   '  , '   '  , '   '  ,  &                    ! 141 - 150
         '   '  , '   '  , '   '  , '   '  , '   '  , '   '  , '   '  , '   '  , '   '  , '   '     /                    ! 151 - 160

      DATA ME/                                                                                      &
           0    ,   0    ,   0    ,  34    ,  34    ,  34    ,  34    ,  34    ,  34    ,  24    ,  &                    !   1 -  10
          24    ,  24    ,  24    ,  24    ,  24    ,  24    ,  24    ,  24    ,  23    ,  33    ,  &                    !  11 -  20
          43    ,  24    ,  24    ,  23    ,  33    ,  43    ,  45    ,  84    ,  84    ,  34    ,  &                    !  21 -  30
          44    ,  84    ,  83    , 203    ,  13    ,  13    ,  23    ,  44    ,  44    ,  44    ,  &                    !  31 -  40
          44    ,  44    ,  44    ,  44    ,  33    ,  43    ,  44    ,  24    ,  43    ,  34    ,  &                    !  41 -  50
          34    ,  34    ,  33    ,  34    ,  34    ,  44    ,  64    , 402    ,   4    ,   4    ,  &                    !  51 -  60
           4    ,   4    ,   4    ,   4    ,   4    ,   4    ,   4    ,  64    ,  64    ,  24    ,  &                    !  61 -  70
          24    ,  24    ,  34    ,  34    ,  34    ,  13    ,  13    ,  23    ,  84    , 204    ,  &                    !  71 -  80
         324    ,  44    ,  34    ,  44    ,  34    ,  44    ,  84    , 204    ,  64    ,  64    ,  &                    !  81 -  90
          10    ,  10    ,  23    ,  24    ,  24    , 204    , 154    ,  44    ,  34    ,  34    ,  &                    !  91 - 100
          64    ,  84    ,  24    ,  24    ,  84    ,  64    ,  24    ,  84    ,  84    ,  44    ,  &                    ! 101 - 110
          64    ,   0    ,  44    ,  24    ,  24    ,  24    ,  27    ,  44    ,  34    ,  14    ,  &                    ! 111 - 120
         204    , 204    ,  94    ,  94    , 184    , 644    ,  64    ,  23    ,  23    ,  10    ,  &                    ! 121 - 130
          10    ,  10    ,  10    ,  23    ,  23    ,  33    ,  33    ,  44    ,  34    ,   0    ,  &                    ! 131 - 140
           0    ,   0    ,   0    ,   0    ,   0    ,   0    ,   0    ,   0    ,   0    ,   0    ,  &                    ! 141 - 150
           0    ,   0    ,   0    ,   0    ,   0    ,   0    ,   0    ,   0    ,   0    ,   0       /                    ! 151 - 160
 
! ME(I)=10*NCON+IFLD  (for element type I)  where
!    NCON = Number of connections per element (see subroutine ELTYPE)
!    IFLD = Field number of first connection.

      END BLOCK DATA BANDIT_BLOCK_DATA



































