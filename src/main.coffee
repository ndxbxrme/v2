{app, BrowserWindow, session} = require 'electron'
mainWindow = null
tests = [
  /pagead/
  /get_midroll_info/
  /moatads/
  /pubads/
  /amazon-adsystem/
  /video_ads/
]
ready = ->
  session.defaultSession.webRequest.onBeforeSendHeaders (details, cb) ->
    details.requestHeaders['User-Agent'] = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:58.0) Gecko/20100101 Firefox/58.0'
    cb
      requestHeaders: details.requestHeaders
  session.defaultSession.webRequest.onBeforeRequest (details, cb) ->
    result = false
    for test in tests
      if test.test details.url
        result = true
        break
    cb cancel: result
  mainWindow = new BrowserWindow
    width: 800
    height: 600
    alwaysOnTop: true
  mainWindow.loadURL 'https://www.youtube.com/feed/subscriptions', 
    userAgent: 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:58.0) Gecko/20100101 Firefox/58.0'

app.on 'ready', ready
app.on 'window-all-closed', ->
  process.platform is 'darwin' or app.quit()
app.on 'activate', ->
  mainWindow or ready()