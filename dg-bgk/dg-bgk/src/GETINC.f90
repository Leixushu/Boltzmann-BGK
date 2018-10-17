      SUBROUTINE GETINC(NNODE,MMAT,RHS,DELUN, NELEM_PP,RESIDUAL,& 
     &         maxNELEM_PP,VNPNT,DISNF,UMEAN,NFO,MU,IV,DTE,&
     &         VSPACE_FIRST,VSPACE_LAST) 
! 
      INTEGER NELEM_PP,NNODE,IV,VNPNT 
      INTEGER VSPACE_FIRST,VSPACE_LAST
      REAL RHS(1,3,NELEM_PP),DELUN(1,3,NELEM_PP) 
      REAL MMAT(NNODE,maxNELEM_PP) 
      REAL RESIDUAL(VSPACE_FIRST:VSPACE_LAST)
      REAL RESIDUAL1(VSPACE_FIRST:VSPACE_LAST)
      REAL COLL,NF,DTE
      REAL UMEAN(NELEM_PP),NFO(NNODE,NELEM_PP) 
      REAL MU(NNODE,NELEM_PP)
      REAL DISNF(3,VSPACE_FIRST:VSPACE_LAST,NELEM_PP) 
! 

! 
! *** CALCULATES THE INCREMENTS DELUN 
! 
      RESIDUAL(IV)=0.0 
! 
! *** LOOP OVER EACH ELEMEMT 
! 
      DO 1000 IE=1,NELEM_PP 
! 
! *** LOOP OVER EACH NODE WITHIN THE ELEMENT 
!      
        DO 2000 IN=1,NNODE      
! ***   COMPUTE THE HALFTIMESTEP BGK COLLISION TERM
!
!       NF=DISNF(IN,IV,IE)-UMEAN(IE)
        NF=DISNF(IN,IV,IE)
        COLL=MU(IN,IE)*(NFO(IN,IE)-NF)
!	    FIND THE MAX INCREMENT 
        RESIDUAL1(IV)=MMAT(IN,IE)*RHS(1,IN,IE)+COLL*DTE 
        IF(ABS(RESIDUAL1(IV)).GT.ABS(RESIDUAL(IV)))THEN
          RESIDUAL(IV)=RESIDUAL1(IV)
        ENDIF
        DELUN(1,IN,IE)=DELUN(1,IN,IE)+MMAT(IN,IE)*RHS(1,IN,IE)+COLL*DTE 
 2000   CONTINUE 
 1000 CONTINUE
! 
      RETURN 
      END 