# shrinkage-microporosity
A simple theoretical and computational model (user subroutine) for shrinkage-microporosity in solidification of metals. 


## Introduction

The model is organised in a way to utilise the Abaqus CREEP USER subroutine (or UMAT) as a platform which provides an implicit time integration scheme of creep and swelling behaviour. In this subroutine nonlinear equations will be solved at each time increment, and the variations of th effective creep strain increment <img src="http://bit.ly/2RrDUFs" align="center" border="0" alt="\Delta   \varepsilon ^{cr} (=  \dot{ \varepsilon } _{e} dt)" width="74.2" height="13.3" /> and volumetric (or swelling) strain increment <img src="http://bit.ly/2WxPQt8" align="center" border="0" alt=" \Delta\varepsilon^{sw} (=  \dot{ \varepsilon } _{v} dt)" width="74.2" height="13.3" />
