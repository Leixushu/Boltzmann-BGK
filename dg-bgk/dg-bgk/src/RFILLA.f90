  SUBROUTINE RFILLA(NAME,A,B,C,VAL) 
! 
	  IMPLICIT NONE 
! 
	  INTEGER A,B,C, I ,J,K 
      REAL VAL 
      REAL NAME(A,B,C) 
! 
	  DO 2000 K=1,C 
      	DO 2001 J=1,B 
        	DO 2002 I=1,A 
            NAME(I,J,K)=VAL 
 2002 CONTINUE 
 2001 CONTINUE 
 2000 CONTINUE 
! 
	  RETURN 
! 
	  END 
