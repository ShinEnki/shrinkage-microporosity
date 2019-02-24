C Simple Creep Model Complete Temperature Regimes
C - Composite Theory 1 & 2 i.e same stress or same strain rate in liquid & solid regions
C - Solidification Temperature Range (Liquidus & Solidus): Thermal Cal. Equilibrium
C - Pore Formation Senario (T1 & T2): 7 - Reasonable Guess

C Default commands
      SUBROUTINE Creep(DECRA,DESWA,STATEV,SERD,EC,ESW,P,QTILD,
     1 TEMP,DTEMP,PREDEF,DPRED,TIME,DTIME,CMNAME,LEXIMP,LEND,
     2 COORDS,NSTATV,NOEL,NPT,LAYER,KSPT,KSTEP,KINC)
     
      INCLUDE 'ABA_PARAM.INC'
     
      CHARACTER *80 CMNAME
    
      DIMENSION DECRA(5),DESWA(5),STATEV(*),PREDEF(*),DPRED(*),
     1 TIME(2),COORDS(*),EC(2),ESW(2)

C Define constants
       ED0S=0.320       !Reference strain rate for the solid phase
C      EDOS=0.206       !Previous Reference strain rate with 25.4mm thick beam
       ED0L=1000.0      !Reference strain rate for the liquid phase
       SIG0=6.9         !Reference stress for the creep term
       SIGP=450.0       !Reference stress for the plasticity term
C      TEMP0=1780.0     !Previous Reference temperature
       TEMP0=1750.0     !Reference temperature
C      TEMPM=1970.0     !Previous Melting/liquidus temperature
       TEMPM=1800.0     !Melting/liquidus temperature
       TEMP1=1750.0     !Tempearture at which the first liquid pore forms(50%FL)
C      TEMPD=1790.0     !Previously assumed temperature for complete-pore-close
       TEMP2=1705.0     !Replace TEMPD for complete-close of liquid channels(5%FL)
       TEMPS=1700.0     !Tempearture at which all liquid is solidified/solidus
       T=TEMP-DTEMP/2.0 !Mid-of-increment tempearture used for calcualtions
       AN=10.0          !Exponent for the creep term
       AM=100.0         !Exponent for the plasticity term
       ENERGY=300000.0  !Activation energy for creep
       GASCON=8.314     !Universal gas constant

C Define variables
       RHOP=STATEV(1)   !Porous free space fraction of total material
       
      IF (T.GE.TEMPM) THEN  !All material is liquid
       FL=1.0       !Total liquid fraction of solid+liquid
       FLF=FL       !Free liquid fraction of solid+liquid
       FLT=0.0      !Trapped liquid fraction of solid+liquid
       FLM=FL       !Free liquid fraction of matrix (solid+free liquid)
      ELSE IF ((T.LT.TEMPM).AND.(T.GT.TEMP1)) THEN  !All liquid is free
       FL=(T-TEMPS)/(TEMPM-TEMPS)       !FL now function of temperature
       FLF=FL                           !All liquid is free liquid
       FLT=0.0                          !No trapped liquid as no pores yet
       FLM=FLF                          !FLM now is basically FLF or FL
      ELSE IF ((T.LE.TEMP1).AND.(T.GT.TEMP2)) THEN  !Liquid pores begin forming
       FL=(T-TEMPS)/(TEMPM-TEMPS)       !FL still function of temperature
       FLF=FL*(T-TEMP2)/(TEMP1-TEMP2)   !FLF reduce linearly vs temperature
       FLT=FL*(TEMP1-T)/(TEMP1-TEMP2)   !FLT increases linearly vs temperature
       FLM=FLF/(1.0-FLT)                !FLM now function of FLF and FLT
      ELSE IF ((T.LE.TEMP2).AND.(T.GT.TEMPS)) THEN  !All liquid is trapped
       FL=(T-TEMPS)/(TEMPM-TEMPS)       !FL sitll function of temperature
       FLF=0.0                          !No more free liquid
       FLT=FL                           !All liquid is trapped liquid
       FLM=FLF                          !No more free liquid -> no FLM
      ELSE          !At TEMPS all liquid is now solidified
       FL=0.0       !No more liquid left = 0 fraction of liquid
       FLF=FL       !No more liquid
       FLT=FL       !No more liquid
       FLM=FL       !No more liquid
      END IF
      
       RHOL=FLT*(1.0-RHOP)      !Liquid fraction of total material
       
       RHO=RHOP+RHOL            !Effective porosity
       
       G2=((1.0-RHO)**(2.0*AN/(AN+1.0)))/(1.0+(2.0/3.0)*RHO)
       G3=(4.0/9.0)*(AN*(RHO**(-(1.0/AN))-1.0))**(2.0*AN/(AN+1.0))
       SIGB=SQRT((QTILD**2.0)/G2+((-P)**2.0)/G3)
       G2P=((1.0-RHO)**(2.0*AM/(AM+1.0)))/(1.0+(2.0/3.0)*RHO)
       G3P=(4.0/9.0)*((AM*(RHO**(-(1.0/AM))-1.0))**(2.0*AM/(AM+1.0)))
       SIGBP=SQRT((QTILD**2.0)/G2P+((-P)**2.0)/G3P)
       
C Effective creep reference strain rate as a function of liquid fraction of matrix,
C assumuing the same stress for both solid and liquid phases
       ED0=(FLM*ED0L)+((1.0-FLM)*ED0S)  !Effective creep reference strain rate
C if assuming the same strain rate for both solid and liquid phases
C      ED0=ED0S/((FLM*((ED0S/ED0L)**(1.0/AN))+(1.0-FLM))**AN)
       EDP=ED0S                         !Effective plastic reference strain rate

C Temperature flag for start/end of increment
      IF (LEND.EQ.1) THEN
       TEMPX=TEMP
      ELSE
       TEMPX=TEMP-DTEMP
      END IF

C Define integration scheme:

C Equivalent deviatoric creep strain increment and its derivative
       A1=ED0*((SIGB/SIG0)**(AN-1.0))*(QTILD/(SIG0*G2))*EXP(-(ENERGY
     1    /GASCON)*((1.0/TEMPX)-(1.0/TEMP0)))*DTIME
       A2=EDP*((SIGBP/SIGP)**(AM-1.0))*(QTILD/(SIGP*G2P))*DTIME
       DECRA(1)=A1+A2
      
      IF (LEXIMP.EQ.1) THEN
       B1=ED0*((1.0-AN)*((SIGB/SIG0)**(AN-3.0))*((-P)*QTILD)/((SIG0
     1    **3.0)*G2*G3))*EXP(-(ENERGY/GASCON)*((1.0/TEMPX)-(1.0/TEMP0)))
     2    *DTIME
       B2=EDP*((1.0-AM)*((SIGBP/SIGP)**(AM-3.0))*((-P)*QTILD)/((SIGP
     1    **3.0)*G2P*G3P))*DTIME
       DECRA(4)=B1+B2
       
       C1=ED0*((AN-1.0)*((SIGB/SIG0)**(AN-3.0))*((QTILD**2.0)/((SIG0
     1    **3.0)*(G2**2.0)))+((SIGB/SIG0)**(AN-1.0))*(1.0/(SIG0*G2)))
     2    *EXP(-(ENERGY/GASCON)*((1.0/TEMPX)-(1.0/TEMP0)))*DTIME
       C2=EDP*((AM-1.0)*((SIGBP/SIGP)**(AM-3.0))*((QTILD**2.0)/((SIGP
     1    **3.0)*(G2P**2.0)))+((SIGBP/SIGP)**(AM-1.0))*(1.0/(SIGP*G2P)))
     2    *DTIME
       DECRA(5)=C1+C2
      END IF
      
C Volumetric swelling strain increment and its derivative
       D1=ED0*((SIGB/SIG0)**(AN-1.0))*((-P)/(SIG0*G3))*EXP(-(ENERGY
     1    /GASCON)*((1.0/TEMPX)-(1.0/TEMP0)))*DTIME
       D2=EDP*((SIGBP/SIGP)**(AM-1.0))*((-P)/(SIGP*G3P))*DTIME
       DESWA(1)=D1+D2
      
      IF (LEXIMP.EQ.1) THEN
       E1=ED0*((1.0-AN)*((SIGB/SIG0)**(AN-3.0))*(((-P)**2.0)/((SIG0
     1    **3.0)*(G3**2.0)))-((SIGB/SIG0)**(AN-1.0))*(1.0/(SIG0*G3)))
     2    *EXP(-(ENERGY/GASCON)*((1.0/TEMPX)-(1.0/TEMP0)))*DTIME
       E2=EDP*((1.0-AM)*((SIGBP/SIGP)**(AM-3.0))*(((-P)**2.0)/((SIGP
     1    **3.0)*(G3P**2.0)))-((SIGBP/SIGP)**(AM-1.0))*(1.0/(SIGP*G3P)))
     2    *DTIME
       DESWA(4)=E1+E2
       
       F1=ED0*((AN-1.0)*((SIGB/SIG0)**(AN-3.0))*((-P)*QTILD)/((SIG0
     1    **3.0)*G2*G3))*EXP(-(ENERGY/GASCON)*((1.0/TEMPX)-(1.0/TEMP0)))
     2    *DTIME
       F2=EDP*((AM-1.0)*((SIGBP/SIGP)**(AM-3.0))*((-P)*QTILD)/((SIGP
     1    **3.0)*G2P*G3P))*DTIME
       DESWA(5)=F1+F2
      END IF
      
C Update state variables
      IF (LEND.EQ.1) THEN
       STATEV(1)=1.0-EXP(-ESW(2))
       IF ((TEMPX.LE.TEMP1).AND.(TEMPX.GT.TEMP2)) THEN
        STATEV(2)=FL*(TEMP1-TEMPX)/(TEMP1-TEMP2)*(1.0-RHOP)
       ELSE 
       CONTINUE
       END IF
      END IF
      
      RETURN
      END
