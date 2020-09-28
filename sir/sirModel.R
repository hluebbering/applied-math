library(pomp)

# Closed SIR ODE
closed.sir.ode <- Csnippet("
  DS = -Beta*S*I/N;
  DI = Beta*S*I/N-gamma*I;
  DR = gamma*I;
")

init1 <- Csnippet("
  S = N-1;
  I = 1;
  R = 0;
  ")

pomp(data=data.frame(time=1:50,data=NA),
     times="time",t0=0,
     skeleton=vectorfield(closed.sir.ode),
     rinit=init1,
     statenames=c("S","I","R"),
     paramnames=c("Beta","gamma","N")) -> closed.sir

params1 <- c(Beta=1,gamma=1/13,N=763)
x <- trajectory(closed.sir,params=params1,format="data.frame")

# PLOT S and I
library(ggplot2)
pdf("SIR.pdf")
ggplot(data=x,mapping=aes(x=time,y=I))+geom_line()
ggplot(data=x,mapping=aes(x=time,y=S))+geom_line()
ggplot(data=x,mapping=aes(x=S,y=I))+geom_path()
dev.off()

# VARY PARAMETERS AND PLOT
expand.grid(Beta=c(0.05,1,2),gamma=1/c(1,2,4,8),N=763) -> params2

x <- trajectory(closed.sir,params=t(params2),times=seq(0,50),
                format="d")

library(plyr)
mutate(params2,.id=seq_along(Beta)) -> params2
join(x,params2,by=".id") -> x

library(ggplot2)
ggplot(data=x,mapping=aes(x=time,y=I,group=.id,
                          linetype=factor(Beta),color=factor(1/gamma)))+
  geom_line()+scale_y_log10(limits=c(1e-3,NA))+
  labs(x="time (da)",color=expression("IP"==1/gamma),
       linetype=expression(beta))


# PLOT R0 RELATIONSHIP TO F
f <- seq(0,1,length=100)
R0 <- -log(1-f)/f
plot(f~R0,type='l',xlab=expression(R[0]),ylab="fraction infected",bty='l')
