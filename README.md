# shrinkage-microporosity
A simple theoretical and computational model (Abaqus CREEP USER subroutine) for shrinkage-microporosity in solidification of metals. 


## Terms and Symbols
AM	        m       exponent for the plasticity term

AN	        n	      exponent for the creep term



DECRA(1)	  ∆ε^cr	  effective creep strain increment
DECRA(4)	  ((∂∆ε^cr)/∂(-σ_m ) )_(σ_e )	partial derivative of
DECRA(5)	  ((∂∆ε^cr)/(∂σ_e ))_(-σ_m )	partial derivative of ∆ε^cr with respect to σ_e
DESWA(1)	  ∆ε^sw	volumetric (or swelling) strain increment
DESWA(4)	  ((∂∆ε^sw)/∂(-σ_m ) )_(σ_e )	partial derivative of ∆ε^sw with respect to σ_m
DESWA(5)	  ((∂∆ε^sw)/∂(σ_e ) )_(〖-σ〗_m )	partial derivative of ∆ε^sw with respect to σ_e
ED0	        ε ̇_0	effective characteristic reference strain rate for the creep term
ED0L	      ε ̇_0l	characteristic reference strain rate for complete liquid material
ED0S	      ε ̇_0s	characteristic reference strain rate for complete solid material
EDP	        ε ̇_p	effective characteristic reference strain rate for the plasticity term
ENERGY	    Q	activation energy
G2	        g_2 (ρ)
G2P	        g_2p (ρ)
G3	        g_3 (ρ)
G3P	        g_3p (ρ)
GASCON	    R	universal gas constant
P	          -σ_m	pressure
QTILD	       σ_e	Mises stress
RHO	        ρ	effective porosity
RHOP	      ρ_p	porous free space fraction of total material
RHOL	      ρ_l	liquid fraction of total material
SIG0	      σ_0	characteristic reference stress for the creep term
SIGB	      σ ̅
SIGBP	      σ ̅_p
SIGP	      σ_P	characteristic reference stress for the plasticity term
T	          (N/A) 	mid-of-increment temperature
TEMP	      T	material temperature
TEMP0	      T_0	reference temperature at σ_0
TEMP1	      T_1	first liquid pore formation temperature
TEMP2	      T_2	last liquid pore formation temperature
TEMPM	      T_m	melting temperature
TEMPS	      T_s	solidus temperature
TEMPX	      (N/A) 	temperature at the end of an increment


## Introduction

The model is organised in a way to utilise the Abaqus CREEP USER subroutine (or UMAT) as a platform which provides an implicit time integration scheme of creep and swelling behaviour. In this subroutine nonlinear equations will be solved at each time increment, and the variations of th effective creep strain increment <img src="http://bit.ly/2RrDUFs" align="up" border="0" alt="\Delta   \varepsilon ^{cr} (=  \dot{ \varepsilon } _{e} dt)" width="84.8" height="15.2" /> and volumetric (or swelling) strain increment <img src="http://bit.ly/2WxPQt8" align="up" border="0" alt=" \Delta\varepsilon^{sw} (=  \dot{ \varepsilon } _{v} dt)" width="84.8" height="15.2" />
