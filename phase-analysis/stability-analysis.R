require(graphics)
library(phaseR)

pdf("phase-diagram.pdf")

problem1e <- function(t, y, parameters) {
  list(y + (-2*y/(1+y^2)))
}

problem1d <- function(t, y, parameters) {
  list(y + 4*y^2)
}

problem1e_flowField  <- flowField(
  problem1e,
  xlim = c(0, 1),
  xlab = expression(scriptstyle(x)),
  ylab = expression(dot(x)),
  ylim = c(-3, 3),
  system = "one.dim",
  add  = FALSE)

grid()

problem1e_nullclines <- nullclines(
  problem1e,
  xlim = c(0, 4),
  ylim   = c(-3, 3),
  add.legend = FALSE,
  col = c("blue", "cyan"),
  system = "one.dim")

problem1e_trajectory <- trajectory(
  problem1e,
  y0 = c(-0.5, 0.5, 1.5, 2.5,5),
  tlim   = c(0, 5),
  col = "pink",
  system = "one.dim")

problem1e_phasePortrait <- phasePortrait(
  problem1e,
  col = c("navy"),
  lwd=2,
  xlab = "x",
  ylab = "dx/dt",
  ylim = c(-2.5, 2.5))

problem1e_findEquilibrium <- findEquilibrium(
  problem1e,
  y0=1,
  system ="one.dim", 
  plot.it = FALSE)

problem1e_stability <- stability(
  problem1e, 
  ystar = 1, 
  system = "one.dim")

dev.off()
