      SUBROUTINE GETROW(IV,INCON,VNPNT,NPOIN,UNKO) 
! 
! *** SUBROUTINE EXTRACTS THE APPROPRIATE DATA ROW FROM INCON 
! 
      IMPLICIT NONE 
! 
! *** DECLARE INTEGER VARIABLES 
! 
       INTEGER IV,VNPNT,NPOIN,IN 
! 
! *** DECLARE REAL VARIABLES 
! 
      REAL INCON(VNPNT,NPOIN) 
      REAL UNKO(NPOIN) 
! 
! *** LOOP OVER THE PHYSICAL SPACE NODES 
! 
      DO 100 IN=1,NPOIN 
         UNKO(IN)=INCON(IV,IN) 
  100 CONTINUE 
! 
      RETURN 
      END 
