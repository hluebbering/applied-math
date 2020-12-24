library(natverse)

## A Single Neuron. 
## Dendrites are branched extensions (red to green dots) 
## that can produce electrochemical simulations. 
## The synapses distributed throughout the tree transmit electrical 
## signals to the dendrites.


data("Cell07PNs")
xdata <- data("Cell07PNs", col="pink")
head(xdata)

plot(Cell07PNs[[1]], main=" ", cex=2)

ex.cs1 <- expression(plain("red nodes: branch points"),  paste("green nodes: end points"), paste("purple node: the soma"))  
legend(195,80, ex.cs1, pch = 24, cex = 1, pt.bg = c("indianred1", "green", "purple"), title="Type of Nodes", title.col = "honeydew3")


## Dendrite Unique Morphology

library(RColorBrewer)
jBrewColors <- brewer.pal(n=5 , name = "PuBuGn")

##  Multiple Neurons
plot(Cell07PNs[[1]], WithText=TRUE, col = "navy", lwd = 1, add=F, main=" ")
plot(Cell07PNs[2:6], col = jBrewColors, lwd = 1, add=T)

