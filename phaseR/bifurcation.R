pdf("bifurcation_plot1.pdf")
logistic.map <- function(r, x, N, M) {
  ## from http://www.magesblog.com/2012/03/logistic-map-feigenbaum-diagram.html
  ## r: bifurcation parameter
  ## x: initial value, something greater than 0 and less than 1
  ## N: number of iterations (total)
  ## M: number of iteration points to be returned
  z <- 1:N
  z[1] <- x
  for(i in c(1:(N-1))){
    z[i+1] <- r *z[i] * (1 - z[i])
  }
  z[language=((N-M):N)]}
  
# z[c language="((N-M):N)"][/c]}

plot(logistic.map(2.6,.01,20,20), type="l")

dev.off()




pdf("bifurcation_plot2.pdf")
par(mfrow=c(2,1))
first <- logistic.map(3,.5,120,100)
second <- logistic.map(3,.5001,120,100)

plot(1:length(first), first, type="l")

lines(1:length(second),second,type="l",col="red")

first <- logistic.map(3.9,.5,120,100)

second <- logistic.map(3.9,.5001,120,100)

plot(1:length(first),first,type="l")

lines(1:length(second),second,type="l",col="red")

dev.off()



pdf("bifurcation_plot3.pdf")
n <- 400
XI <- lya <- 0
x <- seq(0,4,0.01)

for (i in 1:n) {
  xi <- logistic.map(x[i],.01,500,500)
  XI <- rbind(XI,xi)}

for (i in 1:length(x)) { 
  lya[i] <- sum(log(abs(x[i]-(2*x[i]*XI[i,]))))/length(x) 
}

plot(x,lya,ylim=c(-4,1),xlim=c(0,4),type="l",main="Lyapunov Exponents for Logistic Map")
abline(h=0, lwd=2, col="red")

# next 3 lines from http://www.magesblog.com/2012/03/logistic-map-feigenbaum-diagram.html:

my.r <- seq(0, 4, by=0.003)
Orbit <- sapply(my.r, logistic.map, x=0.1, N=1000, M=300)
r <- sort(rep(my.r, 301))
par(mfrow=c(2,1))

plot(x,lya,ylim=c(-5,1),xlim=c(0,4),type="l",main="Lyapunov Exponents for Logistic Map")
abline(h=0, col="red", lwd=2)
abline(v=3, col="blue", lwd=2)

plot(r, Orbit, pch=".", cex=0.5, main="Bifurcation Diagram for r=0 to r=4 Logistic Maps")
abline(v=3, col="blue", lwd=2)

dev.off()


