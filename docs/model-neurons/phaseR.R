library(kableExtra)
library(deSolve)
library(graphics)
library(mathjaxr)
library(captioner)
library(latex2exp)
library(phaseR)
library(knitr)
library(nat)
library(rmarkdown)

# Non-linear systems can exhibit a type of behavior known as a limit cycle. 
# If there is only one steady-state solution, and if the steady-state solution is unstable, 
# a limit cycle will occur. 


## Define Sigmoid Population Functions
se <- function(x){
  ae=1.3
  theta_e=4
  1/(1+exp(-ae*(x-theta_e)))
}

si <- function(x){
  ai=2
  theta_i= 3.7
  1/(1+exp(-ai*(x-theta_i)))
}


## Define Wilson Cowan Equation
WilsonCowan2 <- function(t, y, parameters) {
  # couplings
  c1 = 16
  c2 = 12
  c3 = 15
  c4 = 3
  
  # Refractory periods
  rE = 1
  rI = 1
  
  # external inputs
  P = 1.25
  Q = 0
  
  ki=0.825
  ke=0.88
  I <- y[1]
  E <- y[2]
  dy <- c(
    -I + (ki - rI * I) * si(c3 * E - c4 * I + Q),
    -E + (ke - rE * E) * se(c1 * E - c2 * I + P))
  list(dy)
}


## PhaseR Nullclines
example4_flowField  <- flowField(WilsonCowan2,
                                 xlim = c(-0.01, .425),
                                 ylim = c(0, .5),
                                 add  = FALSE,
                                 ylab = TeX("$E$"),
                                 xlab= TeX("$I$"),
                                 frac=1)
grid()
example4_nullclines <- nullclines(WilsonCowan2,
                                  xlim = c(-0.01, .425),
                                  ylim = c(0, .5),
                                  lty = 2, lwd = 2,
                                  col=c("lightseagreen","aquamarine4"))


## PhaseR PhasePlane Analysis

example4_flowField  <- flowField(WilsonCowan2,
                                 xlim = c(-0.01, .425),
                                 ylim = c(0, .5),
                                 add  = FALSE,
                                 ylab = TeX("$E$"),
                                 xlab= TeX("$I$"),
                                 frac=1)
grid()
example4_nullclines <- nullclines(WilsonCowan2,
                                  xlim = c(-0.01, .425),
                                  ylim = c(0, .5),
                                  lty = 2, lwd = 2,
                                  col=c("lightseagreen","aquamarine4"))

y0 <- matrix(c(0.1,0.3,
               0,0,
               0.1,0.2), 3, 2, byrow = TRUE)
example4_trajectory <- trajectory(WilsonCowan2,
                                  y0   = y0,
                                  pch=16,
                                  tlim = c(0, 100),
                                  col="black",
                                  add=T, ylab=TeX("$E, I$"), xlab=TeX("$t$"))
grid()


### The phase plane analysis illustrates a bounded steady-state solution 
### that is classified as unstable; this is a typical feature 
## of a limit cycle.

### i. Trajectories near the equilibrium point are pushed further away from the equilibrium.
### ii. Trajectories far from the equilibrium point move closer toward the equilibrium.



## Numerical Solution 

example4_solution <- numericalSolution(WilsonCowan2,
                                       y0 = c(0.0, 0.1),
                                       type = "two",
                                       col=c("cornflowerblue", "aquamarine4"),
                                       add.legend = T,
                                       xlab = TeX("$t$"),
                                       ylab = c(TeX("$I$"), TeX("$E$")),
                                       add.grid = F,
                                       tlim = c(0,20),
                                       lwd=2,
                                       ylim=c(0,0.3),
                                       xlim=c(0,18))
