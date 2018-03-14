#PULLS OECD ECONOMIC OUTLOOK FORECASTS USING SDMX
#CHRIS REDL
#14/3/2018

#Software prerequisities to run below
# first install rsdmx package. For this you need to (1) install devtools (2) run devtools::install_github("opensdmx/rsdmx") (3) run library(rsdmx)
# to use write.xlsx you need to (1) install a 64-bit version of Java if you're using the 64-bit version of R (2) install.packages(xlsx) (3) run library(xlsx)

#The example here is the estimate of the non-accelerating rate of unemployment (equilibrium unemployment rate) or NAiru
# but you can adjust to any variable in the OECD EO dataset.
#Here's how to pull just one set of forecasts for NAIRU:
# see https://cran.r-project.org/web/packages/rsdmx/vignettes/quickstart.html for help

myUrl <- "http://stats.oecd.org/restsdmx/sdmx.ashx/GetData/EO90_INTERNET/GBR.NAIRU.A/all?startTime=1990&endTime=2019"
dataset <- readSDMX(myUrl)
stats <- as.data.frame(dataset)

#Using that format, loop fo the url text string to deal with some inconsistencies 
#in the naming of the dataset by OECD, then print the dates and forecasts to an excel file

#OECD Economic outlooks from 88 to 102 use word INTERNET, 69 TO 86 use MAIN and, delightfully, 87 uses OUTLOOK87 in SDMX call

string1 = "http://stats.oecd.org/restsdmx/sdmx.ashx/GetData/EO"
string2 = "/GBR.NAIRU.A/all?startTime=1990&endTime=2019"
string3 = "_INTERNET"
string4 = "_MAIN"
string5 = "_OUTLOOK87"

firstEO=69  #first volume where NAIRU forecast is made
lastEO=102 #most recent forecast

dat = NULL
for(i in firstEO:lastEO){
  
  if(i == 87){
    myUrl<-paste(string1,i,string5,string2,sep="")
  }
  if (i <87){
    myUrl<-paste(string1,i,string4,string2,sep="")
  }
    if (i >87){
    myUrl<-paste(string1,i,string3, string2,sep="")
    }
  
  dataset <- readSDMX(myUrl)
  nairu_data<-as.data.frame(dataset)
  dat<-data.frame(nairu_data$obsTime,nairu_data$obsValue)
  sheetn<-paste("EO",i)
  write.xlsx(dat, file="oecd_nairu.xlsx",sheetName=sheetn, append=TRUE, showNA=TRUE)
}


#a nicer way to pull individual data is from the helper functions, given for reference in the case of EO. 
#However I couldn't get this to work with a variable for the string name so proceeded with the above

sdmx <- readSDMX(providerId = "OECD", resource = "data", flowRef = "EO86_MAIN",
                 key = list("GBR", "NAIRU", NULL), start = 1990, end = 2019)
test<- as.data.frame(sdmx)