! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! The Reaction Rates File
! 
! Generated by KPP-2.2.3 symbolic chemistry Kinetics PreProcessor
!       (http://www.cs.vt.edu/~asandu/Software/KPP)
! KPP is distributed under GPL, the general public licence
!       (http://www.gnu.org/copyleft/gpl.html)
! (C) 1995-1997, V. Damian & A. Sandu, CGRER, Univ. Iowa
! (C) 1997-2005, A. Sandu, Michigan Tech, Virginia Tech
!     With important contributions from:
!        M. Damian, Villanova University, USA
!        R. Sander, Max-Planck Institute for Chemistry, Mainz, Germany
! 
! File                 : cb05cl_ae5_Rates.f90
! Time                 : Thu Feb  8 11:36:55 2018
! Working directory    : /home/Earth/mdawson/Documents/partmc-chem/partmc/test/chemistry/cb05cl_ae5
! Equation file        : cb05cl_ae5.kpp
! Output root filename : cb05cl_ae5
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



MODULE cb05cl_ae5_Rates

  USE cb05cl_ae5_Parameters
  USE cb05cl_ae5_Global
  IMPLICIT NONE

CONTAINS



! Begin Rate Law Functions from KPP_HOME/util/UserRateLaws

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!  User-defined Rate Law functions
!  Note: the default argument type for rate laws, as read from the equations file, is single precision
!        but all the internal calculations are performed in double precision
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

!~~~>  Arrhenius
   REAL(kind=dp) FUNCTION ARR( A0,B0,C0 )
      REAL A0,B0,C0      
      ARR =  DBLE(A0) * EXP(-DBLE(B0)/TEMP) * (TEMP/300.0_dp)**DBLE(C0)
   END FUNCTION ARR        

!~~~> Simplified Arrhenius, with two arguments
!~~~> Note: The argument B0 has a changed sign when compared to ARR
   REAL(kind=dp) FUNCTION ARR2( A0,B0 )
      REAL A0,B0           
      ARR2 =  DBLE(A0) * EXP( DBLE(B0)/TEMP )              
   END FUNCTION ARR2          

   REAL(kind=dp) FUNCTION EP2(A0,C0,A2,C2,A3,C3)
      REAL A0,C0,A2,C2,A3,C3
      REAL(kind=dp) K0,K2,K3            
      K0 = DBLE(A0) * EXP(-DBLE(C0)/TEMP)
      K2 = DBLE(A2) * EXP(-DBLE(C2)/TEMP)
      K3 = DBLE(A3) * EXP(-DBLE(C3)/TEMP)
      K3 = K3*CFACTOR*1.0E6_dp
      EP2 = K0 + K3/(1.0_dp+K3/K2 )
   END FUNCTION EP2

   REAL(kind=dp) FUNCTION EP3(A1,C1,A2,C2) 
      REAL A1, C1, A2, C2
      REAL(kind=dp) K1, K2      
      K1 = DBLE(A1) * EXP(-DBLE(C1)/TEMP)
      K2 = DBLE(A2) * EXP(-DBLE(C2)/TEMP)
      EP3 = K1 + K2*(1.0E6_dp*CFACTOR)
   END FUNCTION EP3 

   REAL(kind=dp) FUNCTION FALL ( A0,B0,C0,A1,B1,C1,CF)
      REAL A0,B0,C0,A1,B1,C1,CF
      REAL(kind=dp) K0, K1     
      K0 = DBLE(A0) * EXP(-DBLE(B0)/TEMP)* (TEMP/300.0_dp)**DBLE(C0)
      K1 = DBLE(A1) * EXP(-DBLE(B1)/TEMP)* (TEMP/300.0_dp)**DBLE(C1)
      K0 = K0*CFACTOR*1.0E6_dp
      K1 = K0/K1
      FALL = (K0/(1.0_dp+K1))*   &
           DBLE(CF)**(1.0_dp/(1.0_dp+(LOG10(K1))**2))
   END FUNCTION FALL

  !---------------------------------------------------------------------------

  ELEMENTAL REAL(kind=dp) FUNCTION k_3rd(temp,cair,k0_300K,n,kinf_300K,m,fc)

    INTRINSIC LOG10

    REAL(kind=dp), INTENT(IN) :: temp      ! temperature [K]
    REAL(kind=dp), INTENT(IN) :: cair      ! air concentration [molecules/cm3]
    REAL, INTENT(IN) :: k0_300K   ! low pressure limit at 300 K
    REAL, INTENT(IN) :: n         ! exponent for low pressure limit
    REAL, INTENT(IN) :: kinf_300K ! high pressure limit at 300 K
    REAL, INTENT(IN) :: m         ! exponent for high pressure limit
    REAL, INTENT(IN) :: fc        ! broadening factor (usually fc=0.6)
    REAL(kind=dp) :: zt_help, k0_T, kinf_T, k_ratio

    zt_help = 300._dp/temp
    k0_T    = k0_300K   * zt_help**(n) * cair ! k_0   at current T
    kinf_T  = kinf_300K * zt_help**(m)        ! k_inf at current T
    k_ratio = k0_T/kinf_T
    k_3rd   = k0_T/(1._dp+k_ratio)*fc**(1._dp/(1._dp+LOG10(k_ratio)**2))

  END FUNCTION k_3rd

  !---------------------------------------------------------------------------

  ELEMENTAL REAL(kind=dp) FUNCTION k_arr (k_298,tdep,temp)
    ! Arrhenius function

    REAL,     INTENT(IN) :: k_298 ! k at T = 298.15K
    REAL,     INTENT(IN) :: tdep  ! temperature dependence
    REAL(kind=dp), INTENT(IN) :: temp  ! temperature

    INTRINSIC EXP

    k_arr = k_298 * EXP(tdep*(1._dp/temp-3.3540E-3_dp)) ! 1/298.15=3.3540e-3

  END FUNCTION k_arr

!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!  End of User-defined Rate Law functions
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

! End Rate Law Functions from KPP_HOME/util/UserRateLaws


! Begin INLINED Rate Law Functions


  !---------------------------------------------------------------------------

  REAL(kind=dp) FUNCTION CMAQ_1to4(A0, B0, C0)
    REAL A0, B0, C0

!   CMAQ reaction rates have the form K = A * (T/300.0)**B * EXP(-C/T) 
!   KPP ARR reaction rates have the form K = A * (T/300.0)**C * EXP(-B/T) 
!   
!   Translation reorders B and C
    CMAQ_1to4 = ARR(A0, C0, B0)
  END FUNCTION
  
  !---------------------------------------------------------------------------

  REAL(kind=dp) FUNCTION CMAQ_5(A0, B0, C0, Kf)
    REAL A0, B0, C0
    REAL(kind=dp) K1, Kf
    K1 = CMAQ_1to4(A0, B0, C0)
    CMAQ_5 = Kf / K1
  END FUNCTION

  !---------------------------------------------------------------------------
  
  REAL(kind=dp) FUNCTION CMAQ_6(A0, B0, C0, Kf)
    REAL A0, B0, C0
    REAL(kind=dp) K1, Kf
    K1 = CMAQ_1to4(A0, B0, C0)
    CMAQ_6 = Kf * K1
  END FUNCTION

  !---------------------------------------------------------------------------
  
  REAL(kind=dp) FUNCTION CMAQ_7(A0, B0, C0)
    REAL A0, B0, C0
    REAL(kind=dp) K0
    K0 = CMAQ_1to4(A0, B0, C0)
    CMAQ_7 = K0 * (1 + .6 * PRESS * 100.)
  END FUNCTION

  !---------------------------------------------------------------------------
  
   REAL(kind=dp) FUNCTION CMAQ_8(A0, C0, A2, C2, A3, C3)
      REAL A0, C0, A2, C2, A3, C3
      REAL(kind=dp) K0, K2, K3            
      K0 = DBLE(A0) * EXP(-DBLE(C0) / TEMP)
      K2 = DBLE(A2) * EXP(-DBLE(C2) / TEMP)
      K3 = DBLE(A3) * EXP(-DBLE(C3) / TEMP)
      K3 = K3 * M
      CMAQ_8 = K0 + K3 / (1.0_dp + K3 / K2 )
   END FUNCTION CMAQ_8

  !---------------------------------------------------------------------------

   REAL(kind=dp) FUNCTION CMAQ_9(A1, C1, A2, C2) 
      REAL*8 A1, C1, A2, C2
      REAL(kind=dp) K1, K2      
      K1 = DBLE(A1) * EXP(-DBLE(C1) / TEMP)
      K2 = DBLE(A2) * EXP(-DBLE(C2) / TEMP)
      CMAQ_9 = K1 + K2 * M
   END FUNCTION CMAQ_9 

  !---------------------------------------------------------------------------

   REAL(kind=dp) FUNCTION CMAQ_10 ( A0, B0, C0, A1, B1, C1, CF, N)
      REAL A0, B0, C0, A1, B1, C1, CF, N
      REAL(kind=dp) K0, K1     
      K0 = CMAQ_1to4(A0, B0, C0)
      K1 = CMAQ_1to4(A1, B1, C1)
      K0 = K0 * M
      K1 = K0 / K1
      CMAQ_10 = (K0 / (1.0_dp + K1))*   &
           DBLE(CF)**(1.0_dp / (1.0_dp / DBLE(N) + (LOG10(K1))**2))
   END FUNCTION CMAQ_10

  !---------------------------------------------------------------------------

   REAL(kind=dp) FUNCTION OH_CO ( A0, B0, C0, A1, B1, C1, CF, N)
      REAL A0, B0, C0, A1, B1, C1, CF, N
      REAL(kind=dp) K0, K1     
      K0 = CMAQ_1to4(A0, B0, C0)
      K1 = CMAQ_1to4(A1, B1, C1)
      K0 = K0
      K1 = K0 / (K1 / M)
      OH_CO = (K0 / (1.0_dp + K1))*   &
           DBLE(CF)**(1.0_dp / (1.0_dp / DBLE(N) + (LOG10(K1))**2))
   END FUNCTION OH_CO

  !---------------------------------------------------------------------------

  REAL(kind=dp) FUNCTION TUV_J(IJ, THETA)
    USE cb05cl_ae5_Global,  only: PHOTO_RATES

    INTEGER :: IJ
    REAL(kind=dp) :: THETA

    TUV_J = PHOTO_RATES(IJ)

  END FUNCTION


! End INLINED Rate Law Functions


! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! Update_RCONST - function to update rate constants
!   Arguments :
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUBROUTINE Update_RCONST ( )




! Begin INLINED RCONST

 
 !end of USE statements 
 !
 ! start of executable statements

 REAL ZENITH
 REAL(kind=dp) :: Time2
 M = AVOGADRO * PRESS * 100 / TEMP / R ! molecules cm-3
 CFACTOR = M * 1.e-6
 N2 = 0.7808*M
 O2 = 0.2095*M
 Time2=mod(Time/(60.*60.), 24.)
 ! Assuming fixed will always contain O2
 IF (NFIX .GT. 0) THEN
    FIX(indf_O2) = O2
 ENDIF

 THETA=0.0

! End INLINED RCONST

  RCONST(1) = (TUV_J(4,THETA))
  RCONST(2) = (O2*M*CMAQ_1to4(6.0E-34,-2.4,0.0E+00))
  RCONST(3) = (CMAQ_1to4(3.0E-12,0.0E+00,1500.0))
  RCONST(4) = (CMAQ_1to4(5.6E-12,0.0E+00,-180.0))
  RCONST(5) = (CMAQ_10(2.5E-31,-1.8,0.0E+00,2.2E-11,-0.7,0.0E+00,0.6,1.0))
  RCONST(6) = (CMAQ_10(9.0E-32,-1.5,0.0E+00,3.0E-11,0.0E+00,0.0E+00,0.6,1.0))
  RCONST(7) = (CMAQ_1to4(1.2E-13,0.0E+00,2450.0))
  RCONST(8) = (TUV_J(3,THETA))
  RCONST(9) = (TUV_J(2,THETA))
  RCONST(10) = (M*CMAQ_1to4(2.1E-11,0.0E+00,-102.))
  RCONST(11) = (H2O*CMAQ_1to4(2.2E-10,0.0E+00,0.0E+00))
  RCONST(12) = (CMAQ_1to4(1.7E-12,0.0E+00,940.0))
  RCONST(13) = (CMAQ_1to4(1.0E-14,0.0E+00,490.0))
  RCONST(14) = (TUV_J(6,THETA))
  RCONST(15) = (TUV_J(5,THETA))
  RCONST(16) = (CMAQ_1to4(1.5E-11,0.0E+00,-170.0))
  RCONST(17) = (CMAQ_1to4(4.5E-14,0.0E+00,1260.0))
  RCONST(18) = (CMAQ_10(2.0E-30,-4.4,0.0E+00,1.4E-12,-0.7,0.0E+00,0.6,1.0))
  RCONST(19) = (H2O*CMAQ_1to4(2.5E-22,0.0E+00,0.0E+00))
  RCONST(20) = (H2O**2*CMAQ_1to4(1.8E-39,0.0E+00,0.0E+00))
  RCONST(21) = (CMAQ_10(1.0E-03,-3.5,11000.0,9.7E+14,0.1,11080.0,0.45,1.0))
  RCONST(22) = (O2*CMAQ_1to4(3.3E-39,0.0E+00,-530.0))
  RCONST(23) = (H2O*CMAQ_1to4(5.0E-40,0.0E+00,0.0E+00))
  RCONST(24) = (CMAQ_10(7.0E-31,-2.6,0.0E+00,3.6E-11,-0.1,0.0E+00,0.6,1.0))
  RCONST(25) = (TUV_J(12,THETA))
  RCONST(26) = (CMAQ_1to4(1.8E-11,0.0E+00,390.0))
  RCONST(27) = (CMAQ_1to4(1.0E-20,0.0E+00,0.0E+00))
  RCONST(28) = (CMAQ_10(2.0E-30,-3.0,0.0E+00,2.5E-11,0.0E+00,0.0E+00,0.6,1.0))
  RCONST(29) = (CMAQ_8(2.4E-14,-460.0,2.7E-17,-2199.0,6.5E-34,-1335.0))
  RCONST(30) = (CMAQ_1to4(3.5E-12,0.0E+00,-250.0))
  RCONST(31) = (CMAQ_10(1.8E-31,-3.2,0.0E+00,4.7E-12,0.0E+00,0.0E+00,0.6,1.0))
  RCONST(32) = (CMAQ_10(4.1E-5,0.0E+00,10650.0,4.8E15,0.0E+00,11170.0,0.6,1.0))
  RCONST(33) = (CMAQ_1to4(1.3E-12,0.0E+00,-380.0))
  RCONST(34) = (CMAQ_9(2.3D-13,-6.0D+02,1.7D-33,-1.0D+03))
  RCONST(35) = (H2O*CMAQ_9(3.22D-34,-2.8D+03,2.38D-54,-3.2D+3))
  RCONST(36) = (TUV_J(11,THETA))
  RCONST(37) = (CMAQ_1to4(2.9E-12,0.0E+00,160.0))
  RCONST(38) = (H2*CMAQ_1to4(1.1E-10,0.0E+00,0.0E+00))
  RCONST(39) = (H2*CMAQ_1to4(5.5E-12,0.0E+00,2000.))
  RCONST(40) = (CMAQ_1to4(2.2E-11,0.0E+00,-120.))
  RCONST(41) = (CMAQ_1to4(4.2E-12,0.0E+00,240.0))
  RCONST(42) = (CMAQ_10(6.9E-31,-1.0,0.0E+00,2.6E-11,0.0E+00,0.0E+00,0.6,1.0))
  RCONST(43) = (CMAQ_1to4(4.8E-11,0.0E+00,-250.))
  RCONST(44) = (CMAQ_1to4(3.0E-11,0.0E+00,-200.))
  RCONST(45) = (CMAQ_1to4(1.4E-12,0.0E+00,2000.))
  RCONST(46) = (CMAQ_1to4(1.0E-11,0.0E+00,0.0E+00))
  RCONST(47) = (CMAQ_1to4(2.2E-11,0.0E+00,0.0E+00))
  RCONST(48) = (CMAQ_1to4(3.5E-12,0.0E+00,0.0E+00))
  RCONST(49) = (CMAQ_1to4(1.0E-17,0.0E+00,0.0E+00))
  RCONST(50) = (CMAQ_1to4(8.5E-13,0.0E+00,2450.))
  RCONST(51) = (TUV_J(14,THETA))
  RCONST(52) = (TUV_J(13,THETA))
  RCONST(53) = (TUV_J(8,THETA))
  RCONST(54) = (CMAQ_1to4(2.6E-12,0.0E+00,-365.0))
  RCONST(55) = (CMAQ_1to4(2.6E-12,0.0E+00,-365.0))
  RCONST(56) = (CMAQ_1to4(7.5E-13,0.0E+00,-700.0))
  RCONST(57) = (CMAQ_1to4(7.5E-13,0.0E+00,-700.0))
  RCONST(58) = (CMAQ_1to4(6.8E-14,0.0E+00,0.0E+00))
  RCONST(59) = (CMAQ_1to4(6.8E-14,0.0E+00,0.0E+00))
  RCONST(60) = (CMAQ_1to4(6.8E-14,0.0E+00,0.0E+00))
  RCONST(61) = (CMAQ_1to4(5.9E-13,0.0E+00,360.))
  RCONST(62) = (TUV_J(91,THETA))
  RCONST(63) = (CMAQ_1to4(3.01E-12,0.0E+00,-190.0))
  RCONST(64) = (TUV_J(26,THETA))
  RCONST(65) = (CMAQ_9(1.44D-13,0.0D+00,3.43D-33,0.0D+00))
  RCONST(66) = (CMAQ_1to4(2.45E-12,0.0E+00,1775.0))
  RCONST(67) = (CMAQ_1to4(2.8E-12,0.0E+00,-300.0))
  RCONST(68) = (CMAQ_1to4(4.1E-13,0.0E+00,-750.0))
  RCONST(69) = (CMAQ_1to4(9.5E-14,0.0E+00,-390.0))
  RCONST(70) = (CMAQ_1to4(3.8E-12,0.0E+00,-200.0))
  RCONST(71) = (TUV_J(26,THETA))
  RCONST(72) = (CMAQ_1to4(7.3E-12,0.0E+00,620.0))
  RCONST(73) = (CMAQ_1to4(9.0E-12,0.0E+00,0.0E+00))
  RCONST(74) = (TUV_J(15,THETA))
  RCONST(75) = (TUV_J(16,THETA))
  RCONST(76) = (CMAQ_1to4(3.4E-11,0.0E+00,1600.0))
  RCONST(77) = (CMAQ_1to4(5.8E-16,0.0E+00,0.0E+00))
  RCONST(78) = (CMAQ_1to4(9.7E-15,0.0E+00,-625.0))
  RCONST(79) = (CMAQ_1to4(2.4E+12,0.0E+00,7000.0))
  RCONST(80) = (CMAQ_1to4(5.6E-12,0.0E+00,0.0E+00))
  RCONST(81) = (CMAQ_1to4(5.6E-15,0.0E+00,-2300.0))
  RCONST(82) = (CMAQ_1to4(4.0E-13,0.0E+00,0.0E+00))
  RCONST(83) = (CMAQ_1to4(1.8E-11,0.0E+00,1100.0))
  RCONST(84) = (CMAQ_1to4(5.6E-12,0.0E+00,-270.0))
  RCONST(85) = (CMAQ_1to4(1.4E-12,0.0E+00,1900.0))
  RCONST(86) = (TUV_J(17,THETA)) ! +TUV_J(19,THETA)) temporary change for mechanism comparison
  RCONST(87) = (CMAQ_1to4(8.1E-12,0.0E+00,-270.0))
  RCONST(88) = (CMAQ_10(2.7E-28,-7.1,0.0E+00,1.2E-11,-0.9,0.0E+00,0.3,1.0))
  RCONST(89) = (CMAQ_10(4.9E-3,0.0E+00,12100.0,5.4E16,0.0E+00,13830.0,0.3,1.0))
  RCONST(90) = (TUV_J(28,THETA))
  RCONST(91) = (CMAQ_1to4(4.3E-13,0.0E+00,-1040.0))
  RCONST(92) = (CMAQ_1to4(2.0E-12,0.0E+00,-500.0))
  RCONST(93) = (CMAQ_1to4(4.4E-13,0.0E+00,-1070.0))
  RCONST(94) = (CMAQ_1to4(2.9E-12,0.0E+00,-500.0))
  RCONST(95) = (CMAQ_1to4(4.0E-13,0.0E+00,-200.0))
  RCONST(96) = (TUV_J(26,THETA))
  RCONST(97) = (CMAQ_1to4(4.0E-13,0.0E+00,-200.0))
  RCONST(98) = (CMAQ_1to4(1.3E-11,0.0E+00,870.0))
  RCONST(99) = (CMAQ_1to4(5.1E-12,0.0E+00,-405.0))
  RCONST(100) = (CMAQ_1to4(6.5E-15,0.0E+00,0.0E+00))
  RCONST(101) = (TUV_J(20,THETA))
  RCONST(102) = (CMAQ_1to4(6.7E-12,0.0E+00,-340.0))
  RCONST(103) = (CMAQ_10(2.7E-28,-7.1,0.0E+00,1.2E-11,-0.9,0.0E+00,0.3,1.0))
  RCONST(104) = (CMAQ_10(4.9E-3,0.0E+00,12100.0,5.4E16,0.0E+00,13830.0,0.3,1.0))
  RCONST(105) = (TUV_J(28,THETA))
  RCONST(106) = (CMAQ_1to4(3.0E-13,0.0E+00,0.0E+00))
  RCONST(107) = (CMAQ_1to4(4.3E-13,0.0E+00,-1040.0))
  RCONST(108) = (CMAQ_1to4(2.0E-12,0.0E+00,-500.0))
  RCONST(109) = (CMAQ_1to4(4.4E-13,0.0E+00,-1070.))
  RCONST(110) = (CMAQ_1to4(2.9E-12,0.0E+00,-500.0))
  RCONST(111) = (CMAQ_1to4(2.9E-12,0.0E+00,-500.0))
  RCONST(112) = (CMAQ_1to4(8.1E-13,0.0E+00,0.0E+00))
  RCONST(113) = (CMAQ_1to4(1.E+15,0.0E+00,8000.))
  RCONST(114) = (CMAQ_1to4(1.6E+3,0.0E+00,0.0E+00))
  RCONST(115) = (CMAQ_1to4(1.5E-11,0.0E+00,0.0E+00))
  RCONST(116) = (CMAQ_1to4(1.E-11,0.0E+00,280.))
  RCONST(117) = (CMAQ_1to4(3.2E-11,0.0E+00,0.0E+00))
  RCONST(118) = (CMAQ_1to4(6.5E-15,0.0E+00,1900.))
  RCONST(119) = (CMAQ_1to4(7.0E-13,0.0E+00,2160.))
  RCONST(120) = (CMAQ_1to4(1.04E-11,0.0E+00,792.0))
  RCONST(121) = (CMAQ_10(1.0E-28,-0.8,0.0E+00,8.8E-12,0.0E+00,0.0E+00,0.6,1.0))
  RCONST(122) = (CMAQ_1to4(1.2E-14,0.0E+00,2630.0))
  RCONST(123) = (CMAQ_1to4(3.3E-12,0.0E+00,2880.))
  RCONST(124) = (CMAQ_1to4(2.3E-11,0.0E+00,0.0E+00))
  RCONST(125) = (CMAQ_1to4(1.0E-11,0.0E+00,-550.))
  RCONST(126) = (CMAQ_1to4(8.4E-15,0.0E+00,1100.))
  RCONST(127) = (CMAQ_1to4(9.6E-13,0.0E+00,270.))
  RCONST(128) = (CMAQ_1to4(1.8E-12,0.0E+00,-355.0))
  RCONST(129) = (CMAQ_1to4(8.1E-12,0.0E+00,0.0E+00))
  RCONST(130) = (CMAQ_1to4(4.2E+00,0.0E+00,0.0E+00))
  RCONST(131) = (CMAQ_1to4(4.1E-11,0.0E+00,0.0E+00))
  RCONST(132) = (CMAQ_1to4(2.2E-11,0.0E+00,0.0E+00))
  RCONST(133) = (CMAQ_1to4(1.4E-11,0.0E+00,0.0E+00))
  RCONST(134) = (CMAQ_1to4(5.5E-12,0.0E+00,0.0E+00))
  RCONST(135) = (9.0*TUV_J(15,THETA))
  RCONST(136) = (CMAQ_1to4(3.0E-11,0.0E+00,0.0E+00))
  RCONST(137) = (CMAQ_1to4(5.4E-17,0.0E+00,500.))
  RCONST(138) = (CMAQ_1to4(1.7E-11,0.0E+00,-116.))
  RCONST(139) = (CMAQ_1to4(1.8E-11,0.0E+00,0.0E+00))
  RCONST(140) = (TUV_J(24,THETA))
  RCONST(141) = (CMAQ_1to4(3.6E-11,0.0E+00,0.0E+00))
  RCONST(142) = (CMAQ_1to4(2.54E-11,0.0E+00,-407.6))
  RCONST(143) = (CMAQ_1to4(7.86E-15,0.0E+00,1912.0))
  RCONST(144) = (CMAQ_1to4(3.03E-12,0.0E+00,448.0))
  RCONST(145) = (CMAQ_1to4(3.36E-11,0.0E+00,0.0E+00))
  RCONST(146) = (CMAQ_1to4(7.1E-18,0.0E+00,0.0E+00))
  RCONST(147) = (CMAQ_1to4(1.0E-15,0.0E+00,0.0E+00))
  RCONST(148) = (0.0036*TUV_J(89,THETA))
  RCONST(149) = (CMAQ_1to4(3.6E-11,0.0E+00,0.0E+00))
  RCONST(150) = (CMAQ_1to4(1.5E-11,0.0E+00,-449.))
  RCONST(151) = (CMAQ_1to4(1.2E-15,0.0E+00,821.))
  RCONST(152) = (CMAQ_1to4(3.7E-12,0.0E+00,-175.))
  RCONST(153) = (CMAQ_10(3.0E-31,-3.3,0.0E+00,1.5E-12,0.0E+00,0.0E+00,0.6,1.0))
  RCONST(154) = (CMAQ_1to4(6.9E-12,0.0E+00,230.0))
  RCONST(155) = (CMAQ_1to4(8.7E-12,0.0E+00,1070.0))
  RCONST(156) = (CMAQ_1to4(1.5E-19,0.0E+00,0.0E+00))
  RCONST(157) = (TUV_J(58,THETA))
! RCONST(158) = constant rate coefficient
  RCONST(159) = (CMAQ_1to4(2.3E-11,0.0E+00,200.0))
  RCONST(160) = (CMAQ_1to4(1.63E-14,0.0E+00,0.0E+00))
  RCONST(161) = (CMAQ_1to4(6.4E-12,0.0E+00,-290.0))
  RCONST(162) = (CMAQ_1to4(2.7E-12,0.0E+00,-220.0))
  RCONST(163) = (CMAQ_1to4(5.0E-13,0.0E+00,0.0E+00))
! RCONST(164) = constant rate coefficient
  RCONST(165) = (CMAQ_1to4(6.6E-12,0.0E+00,1240.0))
  RCONST(166) = (CMAQ_1to4(5.0E-11,0.0E+00,0.0E+00))
  RCONST(167) = (CMAQ_1to4(8.3E-11,0.0E+00,100.0))
  RCONST(168) = (CMAQ_1to4(1.07E-10,0.0E+00,0.0E+00))
  RCONST(169) = (CMAQ_1to4(2.5E-10,0.0E+00,0.0E+00))
  RCONST(170) = (CMAQ_1to4(3.5E-10,0.0E+00,0.0E+00))
  RCONST(171) = (CMAQ_1to4(4.3E-10,0.0E+00,0.0E+00))
  RCONST(172) = (CMAQ_1to4(8.2E-11,0.0E+00,34.0))
  RCONST(173) = (CMAQ_1to4(7.9E-11,0.0E+00,0.0E+00))
  RCONST(174) = (CMAQ_1to4(1.3E-10,0.0E+00,0.0E+00))
  RCONST(175) = (CMAQ_1to4(5.5E-11,0.0E+00,0.0E+00))
  RCONST(176) = (CMAQ_1to4(8.2E-11,0.0E+00,-45.0))
  RCONST(177) = (CMAQ_1to4(6.58E-13,1.16,-58.0))
  RCONST(178) = (CMAQ_1to4(2.70e-12,0.0E+00,-360.0))
  RCONST(179) = (CMAQ_1to4(1.90e-13,0.0E+00,-1300.0))
  RCONST(180) = (CMAQ_1to4(2.70e-12,0.0E+00,-360.0))
  RCONST(181) = (CMAQ_1to4(1.90e-13,0.0E+00,-1300.0))
  RCONST(182) = (CMAQ_1to4(2.47e-12,0.0E+00,206.0))
  RCONST(183) = (CMAQ_1to4(2.70e-12,0.0E+00,-360.0))
  RCONST(184) = (CMAQ_1to4(1.90e-13,0.0E+00,-1300.0))
  RCONST(185) = (CMAQ_1to4(1.16E-14,0.0E+00,0.0E+00))
  RCONST(186) = (CMAQ_1to4(1.97E-10,0.0E+00,0.0E+00))
  RCONST(187) = (CMAQ_1to4(1.90E-11,0.0E+00,0.0E+00))
  RCONST(188) = (TUV_J(1,THETA))
      
END SUBROUTINE Update_RCONST

! End of Update_RCONST function
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! Update_PHOTO - function to update photolytical rate constants
!   Arguments :
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUBROUTINE Update_PHOTO ( )


   USE cb05cl_ae5_Global

      
END SUBROUTINE Update_PHOTO

! End of Update_PHOTO function
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



END MODULE cb05cl_ae5_Rates

