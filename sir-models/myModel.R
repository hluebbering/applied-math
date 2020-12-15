SIR <- function(time, state, parameters) {
  par <- as.list(c(state, parameters))
  with(par, {
    dS <- -beta * I * S / N
    dI <- beta * I * S / N - gamma * I
    dR <- gamma * I
    list(c(dS, dI, dR))
  })
}
library(lubridate)

sir_start_date <- "2020-05-14"
sir_end_date <- "2020-10-20"

Infected <- c(rep(7,45), 
              rep(14.5,15),
              rep(22,15),
              rep(29,15),
              rep(21,15),
              rep(8,15),
              rep(8,15),
              rep(0,30))
Suspec <- c(rep(254,20), 
              rep(235, 45),
              rep(201, 15),
              rep(153, 15),
              rep(121, 15),
              rep(108, 15),
              rep(97, 15),
              rep(83, 30))

Day <- 1:(length(Infected))



init <- c(
  S = Suspec[1],
  I = Infected[1],
  R = 0
)

N<- 261

RSS <- function(parameters) {
  names(parameters) <- c("beta", "gamma")
  out <- ode(y = init, times = Day, func = SIR, parms = parameters)
  fit <- out[, 3]
  sum((Infected - fit)^2)
}
library(deSolve)

Opt <- optim(c(0.5, 0.5),
             RSS,
             method = "L-BFGS-B",
             lower = c(0, 0),
             upper = c(1, 1)
)

# check for convergence
Opt$message

Opt_par <- setNames(Opt$par, c("beta", "gamma"))
Opt_par



# time in days for predictions
t <- 1:260

# get the fitted values from our SIR model
fitted_cumulative_incidence <- data.frame(ode(
  y = init, times = t,
  func = SIR, parms = Opt_par
))

# add a Date column and join the observed incidence data
fitted_cumulative_incidence <- fitted_cumulative_incidence %>%
  mutate(
    Date = ymd(sir_start_date) + days(t - 1),
    Country = "Belgium",
    cumulative_incident_cases = c(Infected, rep(NA, length(t) - length(Infected)))
  )

# plot the data
fitted_cumulative_incidence %>%
  ggplot(aes(x = Date)) +
  geom_line(aes(y = I), colour = "orange") +
  geom_line(aes(y = S), colour = "pink") +
  #geom_line(aes(y = R), colour = "green") +
  #geom_point(aes(y = cumulative_incident_cases), colour = "blue") +
  scale_y_continuous(labels = scales::comma) +
  labs(y = "No. of population", title = "COVID-19 fitted vs observed cumulative incidence, Belgium") +
  scale_colour_manual(name = "", values = c(
    orange = "orange", pink = "pink",
    green = "green", blue = "blue"
  ), labels = c(
    "Susceptible",
    "Recovered", "Observed", "Infectious"
  )) +
  theme_minimal()





# plot the data
fitted_cumulative_incidence %>%
  ggplot(aes(x = Date)) +
  geom_line(aes(y = I, colour = "orange")) +
  geom_line(aes(y = S, colour = "pink")) +
  #geom_line(aes(y = R, colour = "green")) +
  #geom_point(aes(y = cumulative_incident_cases, colour = "blue")) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    y = "No. of Population",
    title = "Eyam plague SIR Model"
  ) +
  scale_colour_manual(
    name = "",
    values = c(orange = "orange", pink = "pink", blue = "blue"),
    labels = c("Infected", "Susceptible", "Recovered", "Infectious")
  ) +
  theme_minimal()
