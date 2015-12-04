library("RSelenium")
checkForServer() 
startServer(args = c("-Dwebdriver.chrome.driver=C:/Users/dai_jl/chromedriver.exe"))
#打开浏览器
open_browser=remoteDriver(remoteServerAddr = "localhost" 
                          , port = 9515
                          ,browserName = "chrome")

head(open_browser$sessionInfo)
open_browser$open()
open_browser$navigate("htttp://weibo.com")
Sys.sleep(5)
user=open_browser$findElement("xpath","//input[@node-type='username']")
open_browser$getStatus()
#user$clickElement()
open_browser
#登陆部分
login=function(username="daigazi",password="03082liu58",open_browser=open_browser){
        open_browser$navigate("htttp://weibo.com")
        Sys.sleep(5)
        user=open_browser$findElement("xpath","//input[@node-type='username']")
        user$clickElement()
        user$sendkeysToElement(list(username))
        pwd=open_browser$findElement("xpath","//input[@node-type='password']")
        pwd$clickElement()
        pwd$sendkeysToElement(list(username))
        login_btn=open_browser$findElement("xpath","//input[@node-type='submitStates']")
        login_btn$clickElement()
}

login()