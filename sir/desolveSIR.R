library(deSolve)
SIR.model <- function(t, b, g){
  require(deSolve)
  init <- c(S=1-1e-6,I=1e-6,R=0)
  parameters <- c(bet=b,gamm=g)
  time <- seq(0,t, by=t/(2*length(1:t)))
  eqn <- function(time,state,parameters){
    with(as.list(c(state,parameters)),{
      dS <- -bet*S*I
      dI <- bet*S*I-gamm*I
      dR <- gamm*I
      return(list(c(dS,dI,dR)))})}
  out<-ode(y=init,times=time,eqn,parms=parameters)
  out.df<-as.data.frame(out)
  
  require(ggplot2)
  mytheme4 <- theme_bw() +
    theme(text=element_text(colour="black")) +
    theme(panel.grid = element_line(colour = "#c9d0d9")) +
    theme(panel.background = element_rect(fill = "#f9fafb"))
  
  theme_set(mytheme4)
  #title <- bquote("SIR Model: Basic")
  subtit <- bquote(list(beta==.(parameters[1]),~gamma==.(parameters[2])))
  res<-ggplot(out.df,aes(x=time))+
    ggtitle(bquote(atop(bold(.(title)),atop(bold(.(subtit))))))+
    geom_line(aes(y=S,colour="Susceptible"))+
    geom_line(aes(y=I,colour="Infected"))+
    #geom_line(aes(y=R,colour="Recovered"))+
    ylab(label="Proportion")+
    xlab(label="t")+
    
    theme(legend.justification=c(1,0), legend.position=c(1,0.5))+
    theme(legend.title=element_text(size=10,face="bold"),
          legend.background = element_rect(fill='white',
                                           size=0.5,linetype="solid"),
          legend.text=element_text(size=10),
          legend.key=element_rect(colour="#f5fefe",
                                  fill='white',
                                  size=0.25,
                                  linetype="solid"))+
    scale_colour_manual(breaks=c("Susceptible","Infected"), values=c("#328176","#ff70cd","darkgreen"))
  print(res)
  ggsave(plot=res,
         filename=paste0("SIRplot_","time",t,"beta",b,"gamma",g,".pdf"),
         width=8,height=6,dpi=180)
  getwd()}
  