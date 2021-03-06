      SUBROUTINE GETBOU(NBOUN,NBNOR,NELEM_PP,BSIDO,IEL,&
     &              RSIDO,IP1,RHS,IN1,IN2,UX,UY,ALPHA,& 
     &     ETA,VNPNT,IV,DISNF,UMEAN,CINF,rv,RANK,VCORD,RORDER,TORDER,&
     &     R,M,VSPACE_FIRST,VSPACE_LAST)
! 
      IMPLICIT NONE 
      INCLUDE 'mpif.h'
! 
! *** CLARE VARIABLES 
! 
      INTEGER ISB,NBOUN,IET,IEL,IN,NELEM_PP,IP1,IV 
      INTEGER JN,INDEX,IP1T,IN1,IN2,NBNOR 
      INTEGER BSIDO(6,NBOUN),VNPNT,RORDER,TORDER 
      INTEGER I,NELX,NELY,CN1,CN2,CN3,CN4,RANK,MPI_IERR 
      INTEGER I1,I2,IETA,IZETA
      INTEGER VSPACE_FIRST,VSPACE_LAST
      REAL DISNF(3,VSPACE_FIRST:VSPACE_LAST,NELEM_PP) 
! 
      REAL ALEN,ANX,ANY,UX,UY,QUO 
      REAL RSIDO(NBNOR,NBOUN) 
      REAL MMAT(2,2),CM,ALPHA,TEST,R 
      REAL TEMP,VCORD(3,VNPNT) 
      REAL Tin,Pin,ETAref,ZETAref,ETATEST,ZETATEST 
      REAL NA,M,PI,U0,V0,BETA,UDASH,VDASH 
      REAL CINF(4),RV,DIFFETA,DIFFZETA
      REAL ZETATEST1,ZETATEST2,ZETADIFF1,ZETADIFF2 
      REAL CXR,CYR,CT1,CT2,FRACX,FRACY
      REAL Rf11,Rf21,Rf12,Rf22 
      REAL UNSID(2),FXSI(2),FYSI(2),FN(2),UNK1,UNK2,COO 
      REAL RHS(1,3,NELEM_PP),RHSI(2)
      REAL UMEAN(NELEM_PP),ETA(NBOUN) 
      REAL RHO,CO,C1,C2,SPEED,Rf1,Rf2,Mf,Mw,RT,THETA 
! 
      DATA MMAT/2.0,1.0,1.0,2.0/ 
      PARAMETER (NA=6.022E+26,PI=3.1416) 
      COO=0.0
! 
! *** DEAL WITH BOUNDARY SIDES 
! 
! *** FIND THE BOUNDARY SIDE IN BOUNDARY SIDE CONNECTIVITY MATRIX, BSIDO 
! 
      DO 303 ISB=1,NBOUN 
      IET=BSIDO(3,ISB) 
      IP1T=BSIDO(1,ISB) 
      IF ((IEL.EQ.IET).AND.(IP1.EQ.IP1T)) GOTO 304 
  303 CONTINUE 
  304 CONTINUE 
      ALEN=(1./6.)*RSIDO(3,ISB) 
      ANX=RSIDO(1,ISB) 
      ANY=RSIDO(2,ISB) 
      INDEX=BSIDO(4,ISB)
      TEMP=BSIDO(5,ISB)
!        TEMP = 300
!      ALPHA=REAL(BSIDO(6,ISB))*1e-2
!  
! *** PICK OUT THE APPROPRIATE UNKNOWNS FROM UNKNO FOR THE LHS ELEMENT 
! 
      UNK1=DISNF(IN1,IV,IEL) 
      UNK2=DISNF(IN2,IV,IEL) 
! 
! *** PUT SIDE UNKNOWNS INTO VECTOR TO SEND TO GET FLU TO GET FLUXES 
! 
        UNSID(1)=UNK1-UMEAN(IEL) 
        UNSID(2)=UNK2-UMEAN(IEL)
! 
! *** GET THE FLUXES 
! 
      CALL GETFLU(2,UNSID,FXSI,FYSI,UX,UY) 
! 
! *** MULTIPLY THE BOUNDARY FLUXES BY THE APPROPRIATE NORMALS TO 
! *** CONVERT THEM TO NORMAL FLUXES 
! 
      FN(1)=ANX*FXSI(1)+ANY*FYSI(1) 
      FN(2)=ANX*FXSI(2)+ANY*FYSI(2) 
! 
! *** SCALAR PRODUCT OF VELCOCITY WITH BOUNDARY NORMAL TO DETERMINE DIRECTION 
! 
       TEST=UX*ANX+UY*ANY 
! 
! *** IF INFLOW:----------------------------------------------------------------------- 
! 
       IF(INDEX.EQ.1)THEN
 !     Tin=CINF(1) 
 !     Pin=CINF(2)*(10**5) 
 !     U0=CINF(3) 
 !     V0=CINF(4)
! *** ENSURE INFLOW CONDITIONS HAVE BEEN SPECIFIED! 
 ! IF((Tin.EQ.0.0).AND.(Pin.EQ.0.0).AND.(U0.EQ.0.0).AND.& 
 !    &							(V0.EQ.0.0))THEN 
 !     PRINT*,'INFLOW CONDITIONS HAVE NOT BEEN SPECIFIED!' 
 !     PRINT*,'MUST RESTART PROGRAM AND SPECIFY' 
 !     PRINT*,'PROGRAM HAS BEEN STOPPED' 
 !     STOP 
 !     ENDIF 
 !     RHO=Pin/(R*Tin) 
 !     BETA=SQRT(RHO/(2*Pin)) 
 !     CO=(RHO*NA)/M 
 !     C1=(BETA**2)/PI 
 !     UDASH=UX-U0 
 !     VDASH=UY-V0 
 !     C2=(UDASH**2+VDASH**2)
 !     UNSID(1)=CO*C1*EXP(-(BETA**2)*C2) 
 !     UNSID(2)=CO*C1*EXP(-(BETA**2)*C2) 
 ! DISNF(IN1,IV,IEL)=UNSID(1)
 ! DISNF(IN2,IV,IEL)=UNSID(2)
! 
! *** GET THE FLUXES 
! 
 !      CALL GETFLU(2,UNSID,FXSI,FYSI,UX,UY) 
! 
! *** MULTIPLY THE BOUNDARY FLUXES BY THE APPROPRIATE NORMALS TO 
! *** CONVERT THEM TO NORMAL FLUXES
! 
 !     FN(1)=ANX*FXSI(1)+ANY*FYSI(1) 
 !     FN(2)=ANX*FXSI(2)+ANY*FYSI(2)     
 !            CALL RFILLV(RHSI,2,0.0) 
 !         DO 701 IN=1,2 
 !         DO 702 JN=1,2 
 !           CM=FN(JN)*MMAT(IN,JN)*ALEN 
 !           RHSI(IN)=RHSI(IN)-CM 
 !702  CONTINUE 
 !701  CONTINUE 
! 
! *** UPDATE THE NODAL VALUES 
!
 !    IF(TEST.GT.0.0)THEN	!FLUX IS OUT OF THE DOMAIN 
 !       RHS(1,IN1,IEL)=RHS(1,IN1,IEL)+RHSI(1) 
 !           RHS(1,IN2,IEL)=RHS(1,IN2,IEL)+RHSI(2) 
 !    ELSE
 !       RHS(1,IN1,IEL)=RHS(1,IN1,IEL)+RHSI(1) 
 !           RHS(1,IN2,IEL)=RHS(1,IN2,IEL)+RHSI(2)
 !   ENDIF 
!
! *** IF OUTFLOW:--------------------------------------------------------------------------- 
! 
      ELSEIF(INDEX.EQ.2)THEN
! 
          CALL RFILLV(RHSI,2,COO) 
          DO 501 IN=1,2 
          DO 502 JN=1,2 
            CM=FN(JN)*MMAT(IN,JN)*ALEN 
            RHSI(IN)=RHSI(IN)-CM 
 502  CONTINUE 
 501  CONTINUE 
! 
! *** UPDATE THE NODAL VALUES 
! 
! 
! *** IF FLUX IS OUT OF THE DOMAIN 
! 
        IF(TEST.GT.0.0)THEN 
! 
            RHS(1,IN1,IEL)=RHS(1,IN1,IEL)+RHSI(1) 
            RHS(1,IN2,IEL)=RHS(1,IN2,IEL)+RHSI(2) 
! 
            ELSE 
! 
! *** ELSE IF FLUX IS INTO THE DOMAIN (USE THE BOUNDARY VALUE OF nf TO AS AN INCOMING FLUX) 
! 
            RHS(1,IN1,IEL)=RHS(1,IN1,IEL)+RHSI(1) 
            RHS(1,IN2,IEL)=RHS(1,IN2,IEL)+RHSI(2)
            ENDIF 
! 
! *** WALL BOUNDARY:------------------------------------------------------------------------ 
! 
      ELSE
! *** IF FLUX IS INTO THE WALL THEN
        IF(TEST.GE.0.0)THEN 
! 
          CALL RFILLV(RHSI,2,COO) 
          DO 301 IN=1,2 
          DO 302 JN=1,2 
            CM=FN(JN)*MMAT(IN,JN)*ALEN 
            RHSI(IN)=RHSI(IN)-CM 
 302  CONTINUE 
 301  CONTINUE 
! 
! *** UPDATE THE NODAL VALUES 
! 
            RHS(1,IN1,IEL)=RHS(1,IN1,IEL)+RHSI(1) 
            RHS(1,IN2,IEL)=RHS(1,IN2,IEL)+RHSI(2) 
! *** ELSE IF FLUX IS AWAY FROM THE WALL THEN 
        ELSEIF(TEST.LE.0.0)THEN 
          SPEED=SQRT(UX*UX+UY*UY) 
          Mw=EXP(-(SPEED*SPEED)/(2*R*REAL(TEMP))) 
          Mf=Mw*ETA(ISB) 
! 
! *** EVALUATE THE REFLECTED nf 
! 
! *** GET THE REFLECTED COORDINATE 
! 
          CXR=UX+ABS(2*TEST)*ANX 
          CYR=UY+ABS(2*TEST)*ANY
!
! *** EVALUATE r AND THETA FOR THE REFLECTED COORDINATE
!
        RT=SQRT(CXR*CXR+CYR*CYR)
        QUO=ABS(CXR/RT)
        THETA=ABS(ACOS(QUO))
        IF(CXR.LT.0.0)THETA=PI-THETA
        IF(CYR.LT.0.0)THETA=-THETA
!
! *** EVALUATE ETAref AND ZETref (THE REFLECTED ETA AND ZETA VALUE)
!
        ETAref=((2*RT)/RV)-1
        IF(ETAref.GT.1.0)ETAref=1.0
        ZETAref=THETA/PI
!
! *** INTERPOLATE THE nf VALUE AT THIS NEW REFLECTED COORDINATE
!
! *** SCROLL THROUGH THE ETA COORDS IN VCORD
!	
        DO 801 IETA=1,RORDER 
        ETATEST=VCORD(1,1+(IETA-1)*(RORDER-1))
        DIFFETA=ABS(ETAref-ETATEST)
        IF(DIFFETA.LT.0.0001)GOTO 802
 801  CONTINUE
 802  CONTINUE
        DO 803 IZETA=1,TORDER-1
        ZETATEST1=VCORD(2,IZETA)
        ZETATEST2=VCORD(2,IZETA+1)
        ZETADIFF1=ZETATEST2-ZETATEST1
        ZETADIFF2=ZETAref-ZETATEST1
        IF((ZETAref.GE.ZETATEST1).AND.(ZETAref.LE.ZETATEST2))GOTO 804
 803  CONTINUE
        ZETADIFF1=VCORD(2,1)-(-1)
        ZETADIFF2=ZETAref-(-1)
        I1=(IETA-1)*TORDER
        I2=(IETA-2)*TORDER+1
        GOTO 805
 804  CONTINUE
        I1=(IETA-2)*TORDER+IZETA
        I2=(IETA-2)*TORDER+IZETA+1
 805  CONTINUE
        Rf11=DISNF(IN1,I1,IEL)
        Rf12=DISNF(IN1,I2,IEL)
        Rf1=(ZETADIFF2*Rf11+ZETADIFF1*Rf12)/(ZETADIFF1+ZETADIFF2)
        Rf21=DISNF(IN2,I1,IEL)
        Rf22=DISNF(IN2,I2,IEL)
        Rf2=(ZETADIFF2*Rf21+ZETADIFF1*Rf22)/(ZETADIFF1+ZETADIFF2)
!
! *** CONSTRUCT THE COMBINED REFLECTED nf AND STORE IN UNSID
!
      UNSID(1)=(1-ALPHA)*Rf1+ALPHA*Mf 
      UNSID(2)=(1-ALPHA)*Rf2+ALPHA*Mf 
! 
! *** GET THE FLUXES 
! 
      CALL GETFLU(2,UNSID,FXSI,FYSI,UX,UY)
! 
! *** MULTIPLY THE BOUNDARY FLUXES BY THE APPROPRIATE NORMALS TO 
! *** CONVERT THEM TO NORMAL FLUXES AND DETERMINE FLUX DIRECTION 
! 
      FN(1)=ANX*FXSI(1)+ANY*FYSI(1) 
      FN(2)=ANX*FXSI(2)+ANY*FYSI(2) 
! 
! *** INITIALISE RHSI 
! 
         CALL RFILLV(RHSI,2,COO) 
          DO 401 IN=1,2 
          DO 402 JN=1,2 
            CM=FN(JN)*MMAT(IN,JN)*ALEN 
            RHSI(IN)=RHSI(IN)-CM 
 402  CONTINUE 
 401  CONTINUE 
! 
! *** UPDATE THE NODAL VALUES 
! 
            RHS(1,IN1,IEL)=RHS(1,IN1,IEL)+RHSI(1) 
            RHS(1,IN2,IEL)=RHS(1,IN2,IEL)+RHSI(2) 
      ENDIF 
!         
      ENDIF 
! 
       RETURN 
       END 
