source("cnstock.R")
#加载沪深两市股票数据
cnstock$methods(
        loadStockName=function(){
                # load stock name from web
                library(rvest)
                library(RCurl)
                library(XML)
                url="http://bbs.10jqka.com.cn/codelist.html"
                web=read_html(url,encoding = "GBK")
                stockName=web  %>% html_nodes(".bbsilst_wei3 a") %>% html_text() 
                stockName=stockName[-1]
                stockName=iconv(x = stockName,from = "utf-8",to = "GBK")
                if(save){
                        if(file.exists(path)){
                                dir_path=paste(path,"/stockName.csv",sep="")      
                                write.csv(x=stockName,file=dir_path)   
                        }
                        else{
                                
                                dir.create(path = path,recursive = T)
                                dir_path=paste(path,"/stockName.csv",sep="")
                                write.csv(x=stockName,file=dir_path) 
                        }  
                }
                else{
                        return(stockName)
                }
                Sys.sleep(sleepSec)
        }
)
cnstock$trace(loadStockName,browser) #用来调试loadStockName的
stock60000$loadStockName()
#下载网易网页csv数据
cnstock$methods(
        loadCsvData=function(Csvname="主要财务指标",type="mfi"){
                library(rvest)
                library(RCurl)
                library(XML)
                #baseUrl=paste(baseUrl,stockNo,sep="")
                alltype=as.vector(urldf[,1])
                #print(type %in% alltype)
                if(type %in% alltype){
                        baseUrl=urldf[urldf$name==type,][1,2]
                        appendUrl=urldf[urldf$name==type,][1,3]  
                }else{
                        stop("type is wrong") 
                }
                url=paste(baseUrl,stockNo,appendUrl,sep="")
                if(url.exists(url)){
                        tmp=getBinaryURL(url = url,RCurlheader=RCurlheader)
                }else{
                        stop("网页不存在")
                }
                #tmp=getBinaryURL(url = url)
                dir_path=paste(path,"/",stockNo,sep="")
                if(file.exists(dir_path)){
                        note=file(paste(dir_path,"/",Csvname,".csv",sep=""),open = "wb")
                        writeBin(tmp, note)
                        close(note)
                }
                else{
                        dir.create(path = dir_path,recursive = T) 
                        note=file(paste(dir_path,"/",Csvname,".csv",sep=""),open = "wb")
                        writeBin(tmp, note)
                        close(note) 
                }
                Sys.sleep(sleepSec)
        }
)
stock60000=cnstock$new()
stock60000$loadCsvData(Csvname="主要财务指标",type="mfi")
stock60000$loadCsvData("偿还能力","pay")
stock60000$loadCsvData("盈利能力","prof")
stock60000$loadCsvData("成长能力","grow")
stock60000$loadCsvData("资产负债表","balance")
stock60000$loadCsvData("利润表","income")
stock60000$loadCsvData("现金流量表","cash")
stock60000$loadCsvData("产品比例表","product")
stock60000$loadCsvData("行业比例表","industry")
stock60000$loadCsvData("地域比例表","region")

cnstock$methods(
        stockBrand=function(){
                sh="600"
                if(grepl(stockNo,pattern=sh)){
                      brand="sh" 
                }else{
                        brand="sz"
                }
                return(brand)
        }
        )
stock60000=cnstock$new()
cnstock$trace( stockBrand,browser )
stock60000$stockBrand()
#股票实时价格
cnstock$methods(
        realTimePrice=function(){
                library(RCurl)
                url="http://hq.sinajs.cn/list="
                brand=stockBrand()
                url=paste(url,brand,stockNo,sep="")
                web=getURL(url,.encoding = "GBK",httpheader=RCurlheader)
                word=strsplit(web,split=",")
                tmp=word[[1]]
                ind=gregexpr(tmp[1],pattern="[0-9]")[[1]][1]
                stockCode=substr(tmp[1],start=ind,stop=ind+5)
                stockCompany=substr(tmp[1],start=ind+8,stop=length(tmp[1]))
                word=c(stockCode,stockCompany,tmp[c(2:length(tmp))])
#                 0：”大秦铁路”，股票名字；
#                 1：”27.55″，今日开盘价；
#                 2：”27.25″，昨日收盘价；
#                 3：”26.91″，当前价格；
#                 4：”27.55″，今日最高价；
#                 5：”26.20″，今日最低价；
#                 6：”26.91″，竞买价，即“买一”报价；
#                 7：”26.92″，竞卖价，即“卖一”报价；
#                 8：”22114263″，成交的股票数，由于股票交易以一百股为基本单位，所以在使用时，通常把该值除以一百；
#                 9：”589824680″，成交金额，单位为“元”，为了一目了然，通常以“万元”为成交金额的单位，所以通常把该值除以一万；
#                 10：”4695″，“买一”申请4695股，即47手；
#                 11：”26.91″，“买一”报价；
#                 12：”57590″，“买二”
#                 13：”26.90″，“买二”
#                 14：”14700″，“买三”
#                 15：”26.89″，“买三”
#                 16：”14300″，“买四”
#                 17：”26.88″，“买四”
#                 18：”15100″，“买五”
#                 19：”26.87″，“买五”
#                 20：”3100″，“卖一”申报3100股，即31手；
#                 21：”26.92″，“卖一”报价
#                 (22, 23), (24, 25), (26,27), (28, 29)分别为“卖二”至“卖四的情况”
#                 30：”2008-01-11″，日期；
#                 31：”15:05:32″，时间；
                var<-c( "股票代码","公司名称",
                        "今日开盘价","昨日收盘价","当前价格","今日最高价","今日最低价",
                       "竞买价","竞卖价","成交的股票数","成交金额","买一股数","买一",
                       "买二股数","买二","买三股数","买三","买四股数","买四","买五股数","买五",
                       "卖一股数","卖一","卖二股数","卖二","卖三股数","卖三","卖四股数",
                       "卖四","卖五股数","日期","时间")
                df=data.frame(var=var,value=word)
                return(df)
                Sys.sleep(sleepSec)
        }
)
stock60000=cnstock$new()
cnstock$trace( realTimePrice,browser )
cnstock$untrace( realTimePrice,browser )
stock60000$realTimePrice()

#公司简介
cnstock$methods(
        ComIntro=function(){
                library(rvest)
                library(RCurl)
                library(XML)
                #baseUrl=paste(baseUrl,stockNo,sep="")
                alltype=as.vector(urldf[,1])
                type="intro"
                if(type %in% alltype){
                        baseUrl=urldf[urldf$name==type,][1,2]
                        appendUrl=urldf[urldf$name==type,][1,3]  
                }else{
                        stop("type is wrong") 
                }
                web=paste(baseUrl,stockNo,appendUrl,sep="")
                webpage=getURL(url = web,.encoding = "utf-8",httpheader=RCurlheader)
                data=readHTMLTable(doc = webpage,header = T,colClasses = "character", trim=T, stringsAsFactors = FALSE)
                #公司基本信息
                ComIntro=data[[4]]
                colnames(ComIntro)=c("value","name","value","name")
                ComIntro=rbind(ComIntro[,c(1,2)],ComIntro[,c(3,4)])
                ComIntro=ComIntro[complete.cases(ComIntro),]
                return(ComIntro)
                Sys.sleep(sleepSec)
        }
)
stock60000=cnstock$new()
df=stock60000$ComIntro()
#图片下载
cnstock$methods(
        loadPic=function(name="历史市净率",type="pb",days=2000,ktype="daily"){
                library(RCurl)
                png_pe=c("PE","Pe","pe")
                png_pb=c("PB","Pb","pb")
                png_k=c("K","k")
                if(type %in% png_pe){
                        baseUrl=urldf[urldf$name=="pe",][1,2]
                        appendUrl=urldf[urldf$name=="pe",][1,3]
                        url=paste(baseUrl,stockNo,appendUrl,days,sep="")
                }else if(type %in% png_pb){
                        baseUrl=urldf[urldf$name=="pb",][1,2]
                        appendUrl=urldf[urldf$name=="pb",][1,3]
                        url=paste(baseUrl,stockNo,appendUrl,days,sep="")
                }else if(type  %in% png_k){
                        baseUrl=urldf[urldf$name=="k",][1,2]
                        appendUrl=urldf[urldf$name=="k",][1,3]
                        #http://image.sinajs.cn/newchart/min/n/sh000001.gif
                        stockBrandNo=stockBrand()
                        url=paste(baseUrl,ktype,appendUrl,stockBrandNo,"gif",sep="")
                }
                else{
                    stop("type should be pe or pb")    
                }       
                Pic=getBinaryURL(url = url,httpheader=RCurlheader)
                dir_path=paste(path,"/",stockNo,sep="")
                if(file.exists(dir_path)){
                        note=file(paste(dir_path,"/",name,".png",sep=""),open = "wb")
                        writeBin(Pic, note)
                        close(note)
                }
                else{
                        dir.create(path = dir_path,recursive = T) 
                        note=file(paste(dir_path,"/",name,".png",sep=""),open = "wb")
                        writeBin(Pic, note)
                        close(note) 
                }
        }        
)
stock60000=cnstock$new()
stock60000$loadPic(days=5000)
stock60000$loadPic(name="历史市盈率",type="pe",days=2000)
stock60000$loadPic(name="历史市净率",type="pb",days=2000)
stock60000$loadPic(name="月k线",type="k",ktype="monthly")
