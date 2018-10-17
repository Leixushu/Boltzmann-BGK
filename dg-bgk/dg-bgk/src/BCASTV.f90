         SUBROUTINE BCASTV(VDIMN,VNLEM,VNPNT,VNXEL,VNNDE,VINTM,VCORD,& 
     &                           RV,SIZE) 
! 
! *** THIS SUBROUTINE BROADCASTS V-SPACE DATA FROM RANK 0 TO ALL OTHER PROCESSORS 
! 
      IMPLICIT NONE 
      INCLUDE 'mpif.h' 
! 
      INTEGER VDIMN,VNLEM,VNPNT,VNXEL,VNNDE,MPI_IERR 
      INTEGER VINTM(4,VNLEM) 
      INTEGER SIZE1,SIZE2 
! 
      REAL RV,SIZE(VNXEL),VCORD(VDIMN,VNPNT) 
      SIZE1=VDIMN*VNPNT 
      SIZE2=4*VNLEM 
!      	   
      CALL MPI_BCAST(VNNDE,1,MPI_INTEGER,0,MPI_COMM_WORLD,MPI_IERR) 
      CALL MPI_BCAST(RV,1,MPI_REAL,0,MPI_COMM_WORLD,MPI_IERR) 
      CALL MPI_BCAST(VINTM,SIZE2,MPI_INTEGER,0,MPI_COMM_WORLD,MPI_IERR) 
      CALL MPI_BCAST(SIZE,VNXEL,MPI_REAL,0,MPI_COMM_WORLD,MPI_IERR) 
      CALL MPI_BCAST(VCORD,SIZE1,MPI_REAL,0,MPI_COMM_WORLD,MPI_IERR) 
! 
      RETURN 
      END 
 
       
