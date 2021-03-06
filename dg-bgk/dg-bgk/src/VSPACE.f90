       SUBROUTINE VSPACE(RORDER,TORDER,VNPNT,&
     &                   VCORD,SUMWEIGHT) 
      IMPLICIT NONE 
! 
! *** THIS ROUTINE READS IN THE LOBATTO WEIGHTING USED FOR VSPACE 
! *** INTEGRATION AND CONSTRUCTS THE ETA AND ZETA WEIGHTINGS/COORDINATES 
! 
      INTEGER RORDER,TORDER,I,VNPNT,IETA,IZETA 
! 
      REAL ETAWEIGHT(RORDER),ZETAWEIGHT(TORDER) 
      REAL ETACHORD(RORDER),ZETACHORD(TORDER) 
      REAL WEIGHTING(2 , RORDER),VCORD(3,VNPNT) 
      REAL DELTA,GAP,SUMWEIGHT 
! 
      CHARACTER filename*80 
! 
! *** READ IN THE WEIGHTINGS 
! 
      DO 100 I=1,RORDER 
        READ(10,*) WEIGHTING(1,I),WEIGHTING(2,I) 
 100  CONTINUE
! 
! *** CONSTRUCT THE ETA AND ZETA WEIGHTINGS 
! 
      DO 200 I=1,RORDER 
        ETACHORD(I)=WEIGHTING(1,I) 
        ETAWEIGHT(I)=WEIGHTING(2,I) 
 200  CONTINUE
!
      GAP=2.0/REAL(TORDER)
      DO 300 I=1,TORDER 
        ZETACHORD(I)=-1+I*GAP 
        ZETAWEIGHT(I)=1.0
 300  CONTINUE
!	 
! *** CLOSE THE CHANNELS 
! 
      CLOSE(10) 
! 
! *** CONSTRUCT THE VSPACE COORDINATE MATRICES 
! 
      I=0 
      SUMWEIGHT=0.0
      DO 400 IETA=1,RORDER 
        DO 500 IZETA=1,TORDER 
          I=I+1 
          VCORD(1,I)=ETACHORD(IETA) 
          VCORD(2,I)=ZETACHORD(IZETA) 
          VCORD(3,I)=ETAWEIGHT(IETA)*ZETAWEIGHT(IZETA)
          SUMWEIGHT=SUMWEIGHT+VCORD(3,I) 
 500    CONTINUE 
 400  CONTINUE
      PRINT*,'SUMWEIGHT=',SUMWEIGHT
!
      RETURN 
      END 
