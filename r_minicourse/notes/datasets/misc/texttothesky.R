#26:
##text-to-the-sky:##
text.to.the.sky<-function(TEXT="hello world",output.file="test.R",cex=4){
  TEXT<-gsub("","..",TEXT)
  plot(1,1,type="n",axes=FALSE,xlab="",ylab="")
  text(1,1,TEXT,cex=cex)
  title("text to write")
# ----------------------------------------------
  fname<-tempfile()
  bitmap(fname,"ppm",height=5,width=5)
  plot(1,1,type="n",axes=FALSE,xlab="",ylab="")
  text(1,1,TEXT,cex=cex)
  dev.off()
# ----------------------------------------------
  bild<-scan(fname,"",sep="\n")
  typ<-bild[1]
  size<-as.numeric(unlist(strsplit(bild[3]," ")))
  max.col<-bild[4]
  pixel<-bild[-(1:4)]
  pixel<-unlist(lapply(strsplit(pixel," "),function(x)as.numeric(x)))
  pixel<-matrix(pixel,ncol=3,byrow=TRUE)
  pixel<-pixel[,1]==0|pixel[,2]==0|pixel[,3]==0
  pixel<-matrix(pixel,size[1],size[2],byrow=TRUE)
  pixel<-pixel[apply(pixel,1,any),]
  pixel<-pixel[,apply(pixel,2,any)]
  x<-col(pixel); y<-nrow(pixel)+1-row(pixel)
  x<-x[pixel];y<-y[pixel]
  xy<-cbind(x,y)
  plot(x,y)
  xyt<-(xy%*%
   matrix(c(cos(-pi/4),sin(-pi/4),-sin(-pi/4),cos(-pi/4)),2,2))
  
#19:
##LAS:##
find.X.y<-function(y.hat,R.0,Rq=.3,p=5,n.add.points=40,verbose=FALSE){
 if(missing(y.hat)){
   cat("find.X.y \n-- finds matrix X and vector y",
       "   so that the fitted values and the residuals of lm(y~X)",
       "   are very similar to the inputs y.hat and R.0.","",
       "   Literature (algorithm and theory):",
       "   Leonard A. Stefanski: Residual (Sur)Realism,",
       "   The American Statistician, May 2007, Vol. 61, No. 2","",
       "   R-implementation: P. Wolf 06/2007","",
       "   Syntax:",
       "   find.X.y(y.hat,R.0,Rq=.3,p=5,n.add.points=40,verbose=FALSE)","",
       "     y.hat          desired fitted values",
       "     R.0            desired residuals",
       "     Rq             desired R^2 of data",
       "     p              desired number of matrix X",
       "     n.add.points   number of points for the sides of the frame",
       "     verbose        if TRUE some intermediate results are shown\n",
       "   Value:", 
       "     find.X.y outputs a list: matrix X and vector y\n",
       sep="\n")
   return("usage: find.X.y(y.hat,R.0)")
 }
 if((is.data.frame(y.hat)|is.matrix(y.hat))&&ncol(y.hat)==2){
   R.0<-as.vector(y.hat[,2]); y.hat<-as.vector(y.hat[,1])
 }
 
#6:
##definiere Funktion [[find.X.y.simple]]:##
find.X.y.simple<-function(y.hat,R.0,Rq=.3,p=5,max.i=20,verbose=FALSE){
  
#5:
##definition of core algorithm:##
# -- step 0 --- some initializations -----------------------------
if(!exists("p")) p<-5
if(!exists("Rq")) Rq<-0.3
if(!exists("max.i")) i<-20
if(!exists("verbose")) verbose<-TRUE
# set.seed(13)
n<-length(R.0)
# modification of input data to achieve choosen Rq value
y.hat<-sd(R.0)/sd(y.hat)*sqrt(Rq/(1-Rq))*y.hat
# -- step 1 --- set initial beta ---------------------------------
# alternative: beta.p<-rep(.3,p)
beta.0<-0; beta.p<-1:p 
# -- step 2 --- set initial j.star if not fixed yet --------------
#   j.star %in% 1:p  # alternative:  j.star<-sample(1:p,1)
if(!exists("j.star")) j.star<-p  
# -- step 3 --- generate Z with tau=sd(R.0) ----------------------
tau<-sd(R.0)
Z<-rnorm(n,sd=tau)
# -- step 4 --- generate initial matrix M with GAMMA=sd(y.hat) ---
GAMMA<-sd(y.hat)
M<-matrix(rnorm(n*p,sd=GAMMA),n,p) 
# -- step 5 --- iterate M until convergence ----------------------
P.R.0<-R.0%*%t(R.0)/(R.0%*%R.0)[1]
M.jstar.old<-M[,j.star]
for(i in 1:max.i){
  W<-cbind(1,(diag(n)-P.R.0)%*%M)
  A.M<-W%*%solve(t(W)%*%W)%*%t(W)
  SUM.beta.M.all<-M%*%beta.p
  FIRST<-( y.hat -1*beta.0 -A.M%*%Z +
           P.R.0%*%M%*%beta.p -SUM.beta.M.all)
  M[,j.star]<-1/beta.p[j.star]*(FIRST + beta.p[j.star]*M[,j.star])
  h<-M[,j.star]; h.delta.sum<-sum((h-M.jstar.old)^2)
  if(verbose) print(h.delta.sum)
  if(sum(h.delta.sum)<0.01) break
  M.jstar.old<-h
}
# -- step 6 --- calculate vector eps -----------------------------
eps<-R.0+A.M%*%Z
# -- step 7 --- calculate X and Y --------------------------------
X<-(diag(n)-P.R.0)%*%M
Y<-1*beta.0+X%*%beta.p+eps
##:definition of core algorithm##
#:5
### check
  if(verbose){
    Sys.sleep(1); pairs(X); Sys.sleep(1); res<-lm(Y~X)
    plot(res$fitted,res$resid,type="p",main="rekonstruction of data")
  }
  return(list(X=X,y=Y))
}
##:definiere Funktion [[find.X.y.simple]]##
#:6
 
#17:
##definiere Funktion [[transform.by.optimal.alpha()]]:##
transform.by.optimal.alpha<-function(x,y,n.add.points=40,verbose=FALSE){
  frame<-0.05; shift<-1+2*frame
  x.extr<-range(x); x.del<-diff(x.extr)
  x.extr<-c(x.extr[1]-frame*x.del,x.extr[2]+frame*x.del)
  y.extr<-range(y); y.del<-diff(y.extr)
  y.extr<-c(y.extr[1]-frame*y.del,y.extr[2]+frame*y.del)
  k<-n.add.points # number of additional points
  f<-function(alpha){
    if(alpha <= 1) pkt<-seq(0,1,length=k)^alpha else
      pkt<-1-seq(0,1,length=k)^(2-alpha)
    xu.pkt<-x.extr[1]+shift*x.del*pkt
    yu.pkt<-y.extr[1]+shift*y.del*pkt
    xo.pkt<-x.extr[2]-shift*x.del*pkt
    yo.pkt<-y.extr[2]-shift*y.del*pkt
    xx<-c(x,xu.pkt,rep(x.extr[2],k),xo.pkt,rep(x.extr[1],k))
    yy<-c(y,rep(y.extr[1],k),yo.pkt,rep(y.extr[2],k),yu.pkt)
    b<-summary(lm(yy~xx))$coef[2]
    if(verbose){
      cat("b:",b,"alpha:",alpha,"\n")
      plot(xx,yy,main=alpha);abline(lm(yy~xx)); Sys.sleep(.2)    
    }
    return(abs(b))
  }
  alpha<-optimize(f,lower=0,upper=2)$minimum
  if(verbose) cat("optimal alpha:",alpha,"\n")
  if(alpha <= 1) pkt<-seq(0,1,length=k)^alpha else
      pkt<-1-seq(0,1,length=k)^(2-alpha)
  xu.pkt<-x.extr[1]+shift*x.del*pkt
  yu.pkt<-y.extr[1]+shift*y.del*pkt
  xo.pkt<-x.extr[2]-shift*x.del*pkt
  yo.pkt<-y.extr[2]-shift*y.del*pkt
  xx<-c(x,xu.pkt,rep(x.extr[2],k),xo.pkt,rep(x.extr[1],k))
  yy<-c(y,rep(y.extr[1],k),yo.pkt,rep(y.extr[2],k),yu.pkt)
  return(cbind(xx,yy))
}
##:definiere Funktion [[transform.by.optimal.alpha()]]##
#:17
 xy<-transform.by.optimal.alpha(y.hat,R.0,n.add.points=n.add.points,verbose=verbose)
 y.hat<-xy[,1]; R.0<-xy[,2]; R.0<-R.0-mean(R.0)
 find.X.y.simple(y.hat,R.0,Rq=Rq,p=p,verbose=verbose)
}
##:LAS##
#:19
  plot(xyt)
  result<-find.X.y(xyt[,1],xyt[,2],Rq=.3,p=5,n.add.points=80,verbose=TRUE)
  names(result)<-c("y","X")
  dput(result,file=output.file)
  cat("file",output.file,"generated\n")
  cat("to reconstruct the text use:\n\nXy<-dget(\"",output.file,"\");",
      "y<-Xy[[2]]; X<-Xy[[1]]; result<-lm(y~X);\n",
      "plot(result$fitted,result$resid,col=\"red\")\n\n", sep="")
}
text.to.the.sky()
##:text-to-the-sky##
#:26
