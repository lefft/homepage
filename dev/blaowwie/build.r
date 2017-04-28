
library("rmarkdown")
render_site()

render("index.rmd", html_document(toc = TRUE))

rmarkdown::metadata
## okay default nav:
## 
# name: "timothy leffel -- homepage"
# output_dir: "."
# navbar:
#   title: "timothy leffel"
# left:
#   - text: "home"
# href: index.html
# - text: "about"
# href: about.html
# - text: "research"
# href: research.html
# - text: "bloggie"
# href: bloggie.html
# - text: "cv"
# href: cv.html


