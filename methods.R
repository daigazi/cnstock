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
#股票实时价格
cnstock$methods(
        realTimePrice=function(){
                library(rvest)
                library(RCurl)
                library(XML)
                url="http://quotes.money.163.com/0"
                url=paste(url,stockNo,".html#01a02",sep="")
                web=read_html(x = url,encoding = "utf-8")
                realtimeprice=web %>% html_nodes(".bottom_line .cGreen") %>% html_text()
                return(realtimeprice)
                Sys.sleep(sleepSec)
        }
)
cnstock$trace( realTimePrice,browser )
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
                webpage=getURL(url = web,.encoding = "utf-8")
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
#市净率和市盈率图片下载
cnstock$methods(
        loadPic=function(name="历史市净率",type="pb",days=2000){
                library(RCurl)
                png_pe=c("PE","Pe","pe")
                png_pb=c("PB","Pb","pb")
                if(type %in% png_pe){
                        baseUrl="http://biz.finance.sina.com.cn/company/compare/img_syl_compare.php?stock_code="
                        appendUrl=",&limit="
                        url=paste(baseUrl,stockNo,appendUrl,days,sep="")
                }else if(type %in% png_pb){
                        baseUrl="http://biz.finance.sina.com.cn/company/compare/img_sjl_compare.php?stock_code="
                        appendUrl=",&limit="
                        url=paste(baseUrl,stockNo,appendUrl,days,sep="")
                }else{
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