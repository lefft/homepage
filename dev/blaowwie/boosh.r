
body {
  margin: 0px;
  max-width: 98%;
  overflow-y: scroll;
}
div {
  border-radius: 5px;
}
span {
  font-weight:bold;
}
#header {
position: absolute;
z-index: 1;
background-color: orange;
height: 70px;
width: 98%;
margin-top: -10px;
margin-bottom: 10px;
}
#name {
float:left;
margin-left: 400px;
margin-top: 10px;
padding-top: 1px;
font-size: 20px;
font-family: Verdana, sans-serif;
color: brown;
}
#contact {
position: absolute;
margin-left: 250px;
margin-top: 30px;
padding-top: -1px;
font-family: Verdana, sans-serif;
color: brown;
}








output:  
  html_document:  
  toc: true  
toc_float: true  


# Next we need to create a couple empty files inside your repository.

touch _site.yml #"YML" file that tells your website how to assemble itself
touch index.Rmd #Create the main rmd file
touch about.Rmd #Create an about file
Now open all of these files in RStudio.

# We will start by filling out the yml file. yml files, while confusing looking at first, are basically a road-map for R to know how to assemble your website.

_site.yml

name: "nicks-website"
output_dir: "."
navbar:
  title: "Nicks Website"
left:
  - text: "Home"
href: index.html
- text: "About Me"
href: about.html
# Next we will fill out the bare minimum for the .Rmd files.

index.Rmd

---
  title: "Nick's Website"
---
  
  Hello, World!
  about.Rmd

---
  title: "About Me"
---
  
  Why I am awesome. 
If you got lost at any point during this tutorial, you can download a template of these files from Lucy’s github.

# Let’s build it!
  # Okay, one last step to actually have a functioning website. We need to actually turn these separate files into a single cohesive website.

# To do this we are going to create one more file. This time just a plain r script.

touch build_site.R
build_site.R

#Set our working directory. 
#This helps avoid confusion if our working directory is 
#not our site because of other projects we were 
#working on at the time. 
setwd("/Users/Nick/personal_site")

#render your sweet site. 
rmarkdown::render_site()
# As a note, you could skip this step if you had started by creating an RStudio project, however, by doing it this way we are not dependent upon RStudio itself. This could be helpful if in the future you are doing this on a computer without RStudio. It also helps explain the process a little bit more.

# Now if everything has gone according to plan, by running the code in build_site.R you should get a bunch of unintelligible output followed by the message : Output created: index.html. If so, yay, if not, double check all the stuff above to make sure you followed it exactly. Or more likely I messed up and you should inform me.

# Now we can open it up. Open the repository with finder or whatever tool your computer uses to look at files then click on index.html and hopefully you should get something that looks like this.


# Sweet. You have now created your own personal website. First let’s push it to github and then we can get down to making it good for you.



# Like let’s say you want to make your about page more descriptive.

about.Rmd

---
  title: "About Me"
---
  
  - __Name:__ Nick
- __Ocupation:__ "Student"
- __Hobbies:__ Learning software development instead of studying for exams. 

Here is a super cool photo of me doing one of my favorite things, yawning. 

![](me_yawning.jpg)
Now just rebuild your site by running build_site.R again and open index.html again to see if it worked. Ideally now you should be able to click on your about page and see the new results!
  
  
  Oh my, that photo looks mighty large. Perhaps we want to make it smaller. We can do that, by adding a special styling file called a css file. Back to the terminal…

touch style.css
Now open this file up in R and add the following lines:
  
  style.css

img {
  width: 400px;
  display: block;
  margin: 0 auto;
}
This takes every image that appears on our site and makes them 400 pixels wide and centers them. You can change these parameters as you want. There are infinitely many ways to customize the style of a website using css. For more information try googling  how to <do something> with css and you will most likely find 10,000 ways to do it.

Now just add the following lines to your _site.yml file to apply this css to your site.

_site.yml

name: "nicks-website"
output_dir: "."
navbar:
  title: "Nicks Website"
left:
  - text: "Home"
href: index.html
- text: "About Me"
href: about.html
output:
  html_document:
  theme: flatly
css: style.css
We have done a few things here. One we have created the new output field. We have given it a theme (you can choose from any you desire here) and we have added our custom css file to the whole thing as well.

Once again, run build_site.R to checkout how things have changed.


Looking a lot better.

You are a biostatistician however, so how about we try and show that off.

Add Projects/ other links
Let’s make a page with links to your cool (open) projects.

Again we edit the _site.yml file…

_site.yml

name: "nicks-website"
output_dir: "."
navbar:
  title: "Nicks Website"
left:
  - text: "Home"
href: index.html
- text: "Projects"     ##### the new
href: projects.html  ##### stuff
- text: "About Me"
href: about.html
output:
  html_document:
  theme: flatly
css: style.css
Add another file called projects.Rmd (you know how to do this at this point).

projects.Rmd

---
  title: "Projects"
---
  
  Sometimes I like to do projects and then post them on the internet for the whole world to benefit!
  here's some examples. 

## [Data Visualization in R](http://nickstrayer.me/visualization_in_r/)

- An RMarkdown presentation on the common mistakes made in visualization and how to fix them.
- Includes a github repo for access to all the code.
- Look at how high quality my work is, hire and or collaborate with me. 

## [Statistical Plots](http://bl.ocks.org/nstrayer/37a503dd1db369a8f7e3ce21757e19ee)

- Interactive plots of things
- I can code!
Again, build the site with your build script and then take a look at what you have!


So what now?
Well first off you add, commit, and push all your new fancy changes to github.

Now you have a website that is better than 95% of people in your situation. What do you do now?

You never stop making it better! Every new project you get you do you post it to your projects page, get sick new head shots in? Add that to your about page. Customize it. For instance you may want to add a splash of personalization to your main page. Perhaps a nice chart? Ever made a plot in an RMarkdown before? You know how to do it then.

index.Rmd

---
title: "Nick's Website"
---

__Look at how cool this plot is!__

$$Y = \alpha \cdot \sin(X), \alpha = 0,0.1,0.2,...,3$$


#remove backslashes before ticks to get this to work. 
\`\`\`{r, echo = FALSE, fig.align='center'}
library(tidyverse)
cool_function <- function(x, alpha) return(sin(alpha*x))
xs <- seq(0, pi*1.5, 0.005)
ys <- cool_function(xs, 1)
results <- data_frame(xs, ys, alpha = "1")
for(alpha in seq(0,3, 0.1)){
results <- results %>% 
bind_rows(data_frame(
xs, 
ys = cool_function(xs, alpha),
alpha = as.character(alpha)
))
}

ggplot(results, aes(x = xs, y = ys, color = alpha)) + 
geom_line() + 
theme_bw() + 
theme(legend.position="none")
\`\`\`