# shrinkage-microporosity
A simple theoretical and computational model (user subroutine) for shrinkage-microporosity in solidification of metals. 

Introduction
The model is organised in a way to utilise the Abaqus CREEP USER subroutine (or UMAT) as a platform which provides an implicit time integration scheme of creep and swelling behaviour. In this subroutine nonlinear equations will be solved at each time increment, and the variations of th effective creep strain increment <img src="http://bit.ly/2RqY9TN" align="center" border="0" alt=" \Delta  \varepsilon ^{cr} " width="37" height="17" /> (=<img src="http://bit.ly/2Roy0VD" align="center" border="0" alt=" \dot{ \varepsilon } _{e} dt" width="40" height="18" />)
