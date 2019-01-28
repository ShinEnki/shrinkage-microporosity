# shrinkage-microporosity
A simple theoretical and computational model (user subroutine) for shrinkage-microporosity in metal. 

Introduction
The model is organised in a way to utilise the Abaqus CREEP USER subroutine (or UMAT) as a platform which provides an implicit time integration scheme of creep and swelling behaviour. In this subroutine nonlinear equations will be solved at each time increment, and the variations of th effective creep strain increment !(http://latex.codecogs.com/gif.latex?%5CDelta%5Cvarepsilon%5E%7Bcr%7D%28%3D%20%5Cdot%7B%5Cvarepsilon%20%7D_%7Be%7Ddt%29)
