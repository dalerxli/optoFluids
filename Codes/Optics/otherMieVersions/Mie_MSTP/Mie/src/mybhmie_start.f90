program mybhmie_start !(INPUT=TTY,OUTPUT=TTY,TAPE5=TTY)
	use mybhmie, only: scatter
	implicit none
!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!	CALLBH CALCULATES THE SIZE PARAMETER (X) AND RELATIVE
!	REFRACTIVE INDEX (REFREL) FOR A GIVEN SPHERE REFRACTIVE
!	INDEX, MEDIUM REFRACTIVE INDEX, RADIUS, AND FREE SPACE
!	WAVELENGTH. IT THEN CALLS BHMIE, THE SUBROUTINE THAT COMPUTES
!	AMPLITUDE SCATTERING MATRIX ELEMENTS AND EFFICIENCIES
!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

! Type declarations
	double precision, parameter :: PII = 4.0D0 * atan(1.0d0)  ! Obtain pi

!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!	NANG = NUMBER OF ANGLES BETWEEN 0 AND 180 DEGREES
!	MATRIX ELEMENTS CALCULATED AT NANG ANGLES
!	INCLUDING 0, AND 180 DEGREES
!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	INTEGER, PARAMETER :: NANG = 1001

	double precision :: S_ANGLES(NANG)
	COMPLEX(4) :: S1(NANG), S2(NANG), REFREL
	REAL(8) ::    RHO(NANG)
	REAL(4) :: REFMED, REFRE, REFIM, RAD, WAVEL, X
    REAL(8) :: DIST
	INTEGER :: J
! Finish type declarations
	WRITE (6,11) ! init message

! Init scattering angles
	call initParameters()
	call initScatAngles(S_ANGLES)

	WRITE (6,*) "Now running scatter subroutine"
	CALL scatter(X,REFREL,cos(S_ANGLES),S1,S2,RHO)

!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!	PRINT S1 AND S2
!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	WRITE (6,18)
	DO 356 J=1,NANG
356 WRITE (6,76) S_ANGLES(J)*180/3.14159265, S1(J), S2(J)

    !Write them to file
    OPEN(UNIT=453,file='ScatteringMatrix', access='append')
    DO 357 J = 1,NANG
357 WRITE(453,76) S_ANGLES(J)*180/3.14159265, S1(J), S2(J)
    CLOSE(453)
    
    
!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!	FORMATTING STATEMENTS:
!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
11	FORMAT (/"SPHERE SCATTERING PROGRAM"//)
18	FORMAT (//,3X,"ANGLE",20X,"S1 (RE + IM i)",29X,"S2 (RE + IM i)"//)
76	FORMAT (1X,F7.3,7X,E17.10," +",E17.10," i",7X,E17.10," +",E17.10," i")
	STOP


contains

subroutine initScatAngles (S_ANGLES)

	double precision, intent(out) :: S_ANGLES(:)

	double precision :: DANG
	integer :: J, NANG

! Finish declarations

	NANG = SIZE(S_ANGLES)
	DANG = PII / dble(NANG - 1) 
	do J = 1, NANG
		S_ANGLES(J) = dble(J-1) * DANG 
	enddo
	

end subroutine

subroutine initParameters ()
	
!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!	REFMED = (REAL) REFRACTIVE INDEX OF SURROUNDING MEDIUM
!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	REFMED = 1.0
!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!	REFRACTIVE INDEX OF SPHERE = REFRE + i*REFIM
!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	REFRE = 1.52
	REFIM = 0.0
	REFREL = CMPLX(REFRE,REFIM)/REFMED
	WRITE (6,12) REFMED, REFRE, REFIM
!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!	RADIUS (RAD) AND WAVELENGTH (WAVEL) SAME UNITS
!	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	RAD=4E-6
	WAVEL=532E-9
	DIST = 100
	DO J=1,NANG
		RHO(J) = 2.*3.14159265*DIST*REFMED/WAVEL
	ENDDO

	!RAD=0.02
	!WAVEL=0.02
	X=2.*3.14159265*RAD*REFMED/WAVEL
	WRITE (6,13) RAD,WAVEL
	WRITE (6,14) X

12	FORMAT (5X,"REFMED = ",F8.4,3X,"REFRE = ",E14.6,3X,"REFIM = ",E14.6)
13	FORMAT (5X,"SPHERE RADIUS = ",G12.6,3X,"WAVELENGTH = ", G12.6)
14	FORMAT (5X,"SIZE PARAMETER = ",F8.3/)

end subroutine initParameters

end program mybhmie_start













! EOF