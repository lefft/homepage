#############################################
proto <- as.list(rep(0,25))  ## prototype of data row so that R allows line wraps
names(proto) <- c("y", paste("X",1:24, sep=""))   ## reasonable column names
fn <- "C:/StefanskiBilder/All_Files_run_only/George_Box_message/George_Box_Quote_data_with_phoneys_yw1w24.txt"
dat<-as.data.frame(scan(file=fn, what=proto))   ## scan reads data, as.data.frame makes them into appropriate format
correct_linmod <- lm(dat[,c(1,2,4,10,18)])         ## linear model object calculated (for these data with non-phoney cols)
summary(correct_linmod)      ## overview of linear model
## residual plots
plot(fitted.values(correct_linmod),residuals(correct_linmod))
plot(fitted.values(correct_linmod),rstandard(correct_linmod))
plot(fitted.values(correct_linmod),rstudent(correct_linmod))
############################################# 