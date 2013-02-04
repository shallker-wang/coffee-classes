# @description A class to manage Chrome extenion PageAction's APIs
# @author shallker.wang@profero.com

class PageAction

  constructor: ->

  @openTab: (url)->
    chrome.tabs.create url: url

  @show: (tabId)->
    chrome.pageAction.show(tabId)

  @hide: (tabId)->
    chrome.pageAction.hide(tabId)

  @setToolTip: (tip)->
    chrome.pageAction.setTitle title: String tip

  @listenClick: (listener)->
    chrome.pageAction.onClicked.addListener listener

module.exports = PageAction