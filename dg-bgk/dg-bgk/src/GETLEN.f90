      SUBROUTINE GETLEN(NNODE,NELEM,RELEN,NGEOM,GEOME)                   
! 
      REAL GEOME(NGEOM,NELEM) 
      REAL RELEN(NELEM),DIST(3) 
! 
! *** COMPUTE THE ELEMENT LENGTHS 
! 
      C10 =1.0 
! 
      DO 2000 IE=1,NELEM 
      DO 1000 IN=1,NNODE 
      ANX=GEOME(IN,IE) 
      IK=IN+NNODE 
      ANY=GEOME(IK,IE) 
      DIST(IN)=C10/SQRT(ANX*ANX+ANY*ANY) 
 1000 CONTINUE 
      RELEN(IE)=MIN(DIST(1),DIST(2),DIST(3)) 
 2000 CONTINUE 
! 
      RETURN 
      END 
