# @description A class to manage chrome.extension's APIs
# @author shallker.wang@profero.com

class ChromeExtension

  constructor: ->

  # call = (response)->
  @sendMessage: (msg, call)->
    chrome.extension.sendMessage msg, call

  # mesg = {}
  # call = (msg)->
  @postMessage: (msg, call)->
    port = @connect()
    port.postMessage msg
    port.onMessage.addListener call

  # options = name: ''
  @connect: (options = {})->
    chrome.extension.connect options
    
  # onMessage = (request, sender, sendResponse)->
  @listenMessage: (onMessage)->
    chrome.extension.onMessage.addListener onMessage

  # onConnect = (port)=>
  @listenConnect: (onConnect)->
    chrome.extension.onConnect.addListener onConnect  
    

module.exports = ChromeExtension