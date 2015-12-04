cnstock=setRefClass("cnstock",
                  fields = list(name="character",stockNo="character",
                                industry="factor",price="numeric",
                                intro="character",RCurlheader="character",
                                urldf="data.frame",
                                #baseUrl="character",appendUrl="character",
                                sleepSec="numeric",save="logical",path="character"),
                  methods=list(
                          #构造方法
                          initialize=function(name,stockno,industry,price,intro){
                                  # 给属性增加默认值
                                  name <<- '浦发银行'
                                  stockNo <<- "600000"
                                  industry<<-factor("银行")
                                  price<<-10
                                  intro<<-"一家银行"
                                  RCurlheader<<- c(
                                          "User-Agent"="Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.6) ",
                                          "Accept"="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                                          "Accept-Language"="en-us",
                                          "Connection"="keep-alive",
                                          "Accept-Charset"="GB2312,utf-8;q=0.7,*;q=0.7"   
                                  )
                                  #baseUrl<<-"http://quotes.money.163.com/service/zycwzb_"
                                  #appendUrl<<-".html?type=report"
                                  sleepSec<<-3
                                  save <<- TRUE
                                  path <<- "data"
                                  urldf<<- data.frame(
                                   name=c("mfi","prof","pay","grow","fs","balance",
                                          "income","cash","intro","product","industry","region"),
                                   baseUrl=c(
                                         "http://quotes.money.163.com/service/zycwzb_",
                                          "http://quotes.money.163.com/service/zycwzb_",
                                          "http://quotes.money.163.com/service/zycwzb_",
                                           "http://quotes.money.163.com/service/zycwzb_",
                                          "http://quotes.money.163.com/service/cwbbzy_",
                                          "http://quotes.money.163.com/service/zcfzb_",
                                         "http://quotes.money.163.com/service/lrb_",
                                         "http://quotes.money.163.com/service/xjllb_",
                                         "http://quotes.money.163.com/f10/gszl_",
                                         "http://quotes.money.163.com/service/gszl_",
                                         "http://quotes.money.163.com/service/gszl_",
                                         "http://quotes.money.163.com/service/gszl_"),
                                    appendUrl=c(
                                            ".html?type=report",
                                            ".html?type=report&part=ylnl",
                                            ".html?type=report&part=chnl",
                                            ".html?type=report&part=cznl",
                                            ".html",".html",".html",".html",
                                            ".html#01f01",".html?type=cp",".html?type=hy",".html?type=dy"))
                          }
                          )
                  )
