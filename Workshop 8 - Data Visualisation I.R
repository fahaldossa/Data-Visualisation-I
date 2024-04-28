#Workshop 8 
#Data Visualization

#1.Introduction
#you’ll be able to distinguish which ggplot2 tools to use to plot categorical and continuous data
#Continuous: e.g. measurements (length)
#Categorical: e.g. species and islands 

#2.The Grammar of Graphics
#The geometric objects that display our data are called 'geoms' e.g. geom_point
#Each geom has features called 'aesthetics'. These features are their positions along the x- and y-axis, their shape, size and color.
#To visualize our data we 'map' variables of our data to those aesthetics - which is why we want our data tidy 

install.packages("palmerpenguins")
library(palmerpenguins)
library(tidyverse)
library(dplyr)

View(penguins)

#We want to find a correlation between body mass and bill length
#A simple scatter plot is a good way to look at correlations between two continuous variables 
#To do this, we need to tell ggplot which data we are looking at, and which geom, variables, and aesthetics to use 

ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g))
#there seems to be a correlation, there is also a cluster that is shifted at the bottom - could those species differences?
#Lets check by mapping species to the aesthetic color of geom_point

ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g, colour = species))

#Does this cluster also correlate with the island the penguins are from? Copy and change the code above to check.
ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g, colour = island))

#We can add additional layers to our plot by specifying additional geoms - using the geom_smooth functio
ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_smooth(mapping = aes(x = bill_length_mm, y = body_mass_g)) #It helps to see a pattern

#To simplify, we can pass them to ggplot().
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point() +
  geom_smooth() 

#Secondly, we already know that our data fall into three species clusters, so fitting the curve across all three is probably not a great idea. Let’s map species again to colour

ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species)) +
  geom_smooth()

#Fix the code so that each species has its own fitted curve
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species)) +
  geom_smooth(mapping = aes(colour = species))

# or 

ggplot(data = penguins, mapping = aes(x = bill_length_mm, 
                                      y = body_mass_g, 
                                      colour = species)) +
  geom_point() +
  geom_smooth()


#Once we are happy with our plot, we can assign it to a variable (pengu_plot) and add other layers 
pengu_plot <-
  ggplot(data = penguins,
         mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(aes(colour = species))

#We can add layers to our plot
pengu_plot +
  geom_smooth()

#Produce a plot where the geom_smooth produces a linear model and removes the confidence intervals
?geom_smooth

ggplot(data = penguins,
       mapping = aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point(mapping = aes(colour = species, shape = species)) + #You can add shape under aesthetic to give each species a shape 
  geom_smooth(mapping = aes(colour = species), #we did this step so that each species would have its own line
              method = "lm", #made the linear line
              se = FALSE) #this removed the confidence level

#3. Saving plots
#We can save our plot using ggsave
#We can either give ggsave a plot variable:
ggsave(filename = "penguin_plot_1.png", plot = pengu_plot)

#OR if we don't pass it a variable, it will save the last plot we printed to screen
pengu_plot +
  geom_smooth()

ggsave("penguin_plot_2.png")

#Q.Try to change the dimensions of the plot to  200mm x 300mm png
?ggsave

ggplot(data = penguins,
       mapping = aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point(mapping = aes(colour = species, shape = species)) +
  geom_smooth(mapping = aes(colour = species),
              method = "lm",
              se = FALSE)

ggsave("penguin_plot_3.png",width=300,height=200,units="mm")

#4. Continuous versus categorical variables 
#To investigate body_mass for each species, we can use boxplots
ggplot(data = penguins,
       mapping = aes(x = species, y = body_mass_g)) +
  geom_boxplot(mapping = aes(colour = species))
#Notice how mapping species to colour in geom_boxplot() only changes the colour of the lines.

#Q. Change the code, so that it fills the boxes with colour instead of the line
ggplot(data = penguins,
       mapping = aes(x = species, y = body_mass_g)) +
  geom_boxplot(mapping = aes(fill = species))
#Because the black is the default, if we remove "color", we can get the black outlines back
#Then we use "fill" instead, giving us the wanted aes

#To determine the order of which we display our data, we can use "factors"
# Categorical variables that have a defined and known set of values, for example the three species in penguins, can be defined as factors
#Factors have "levels" which are essentially rank positions for each unique value. By default, levels are in alphanumerical order

str(penguins) 
head(penguins) #Using str() and head(), we can see which variable are factors

#Here is an example where alphabetical order would be annoying
df_days <-
  data.frame(day = c("Mon", "Tues", "Wed", "Thu"),
             counts = c(3, 8, 10, 5))
df_days$day <- as.factor(df_days$day)
str(df_days)

ggplot(data = df_days, mapping = aes(x = day, y = counts)) +
  geom_col() #Here the order in Mon, Thu, Tues, Wed

#To change the weekdays into the right order, we use 'levels'
df_days$day <- factor(df_days$day, levels = c("Mon", "Tues", "Wed", "Thu"))
str(df_days)

ggplot(data = df_days, mapping = aes(x = day, y = counts)) +
  geom_col() #Now the order is correct 

#Let’s put together a few of the things you’ve learnt so far:
#Using geom_violin, factor, and levels

penguins_2 <- penguins
penguins_2$species <- factor(penguins_2$species, levels = c("Chinstrap", "Gentoo", "Adelie")) #using levels, you can change to order 

ggplot(data = penguins_2,
       mapping = aes(x = species, y = body_mass_g)) +
       geom_violin(mapping = aes(fill = island)) 

penguins$species <- factor(penguins$species, levels = c("Adelie", "Chinstrap", "Gentoo")) #using levels, you can change to order 

#5. Statistical transformations 

#Spot the differences between geomcol and geombar - geombar does not need another variable, it will use its count as default
#coordflip - flips the axis
ggplot(data = penguins) +
  geom_bar(mapping = aes(x = species)) +
  coord_flip()

#Look at the plot below:
ggplot(data = penguins,
       mapping = aes(x = flipper_length_mm)) +
  geom_histogram(aes(fill = species), position = "identity", alpha = 0.5) #change position to "stack" for plot on right

#What is the difference? - In one they overlap, in the other they stack. To do so, they used the 'alpha' function to change the transparency (opacity 1-0)

#6. Plotting only a subset of your data: filter()
#In instances when you want to only plot a subset of your data, e.g. just 2 species of penguins, you can use the 'filter()' function in dplyr. 

penguins %>% filter(!species == "Chinstrap") %>%
  ggplot(mapping = aes(x = flipper_length_mm, y = body_mass_g)) + #we switch from the pipe operator %>% to a + sign for adding layers to ggplot()
  geom_point(mapping = aes(colour = species, shape = island)) #We also don’t need to tell ggplot() which data to use because we have piped the dataset into ggplot() already.

#filter() is extremely useful together with the function is.na() to get rid of NAs

#Q.Use is.na(sex) with filter() to reproduce the plot below, so that it only contains penguins where sex is known.
penguins %>% filter(!is.na(sex)) %>% 
  ggplot(mapping = aes(x = species, y = body_mass_g)) +
  geom_violin(mapping = aes(fill = sex)) +
  geom_jitter(mapping = aes(colour = sex))
             
?ggtitle
?geom_legend

?geom_violin

#Another very useful function is arrange(), which allows you to sort rows by values in one or more columns. 

#7. Labels
#Here we'll make a start on making our plot prettier by editing the labels 
#The function to manipulate or add labels is labs()
penguins %>%
  ggplot(mapping = aes(x = species, y = body_mass_g)) +
  geom_violin(aes(fill = sex)) +
  labs(title = "Weight distribution among penguins",
       subtitle = "Plot generated by E. Busch-Nentwich, March 2023",
       x = "Species",
       y = "Weight in g",
       caption = "Data from Palmer Penguins package\nhttps://allisonhorst.github.io/palmerpenguins/"
  )

#Changing the legend labels can't be done within labs(), becuase the legend is part of scales  
#Here we have mapped a categorical variable 'sex' to 'fill', so the function to use is 'scale_fill_discrete()'
#This function also allows you to change to colours
penguins %>%
  ggplot(mapping = aes(x = species, y = body_mass_g)) +
  geom_violin(aes(fill = sex)) +
  labs(title = "Weight distribution among penguins",
       subtitle = "Plot generated by E. Busch-Nentwich, March 2023",
       x = "Species",
       y = "Weight in g",
       caption = "Data from Palmer Penguins package\nhttps://allisonhorst.github.io/palmerpenguins/"
  ) +
  scale_fill_discrete(name = "Sex",
                      labels = c("Female", "Male", "Unknown"),
                      type = c("yellow3", "magenta4", "grey"))

#8.The big challenge
#We’re going to revisit the World Malaria Report, though this time we’re looking at modelling data. Fortunately this dataset is already tidy, so you can read it in as it is.
#Read in the modelling table (“wmr_modelling.txt”) and reproduce the following plot. You’ll have to figure out a way to order the dataframe by deaths and then convince ggplot to keep the data in that order when plotting (hint: factors are your friends!).

#Reading in file
modeltab <- read.table("wmr_modelling.txt",sep="\t",header=T)

#Filter for 2020 and reorder in deaths order
modeltab20 <- modeltab %>% filter(year == 2020) %>% arrange(deaths)

#Make countries factors in the order of deaths
deathorder20 <- modeltab20$country
modeltab20$country <- factor(modeltab20$country, levels = deathorder20)

#Plot data
ggplot(modeltab20, aes(x = country, y = deaths)) +
  geom_col() +
  coord_flip() +
  labs(title = "Malaria Deaths in 2020")
  
