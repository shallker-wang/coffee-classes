# Browser Action
# @description A class to manage Chrome extenion BrowserAction's APIs
# @author shallker.wang@profero.com

class BrowserAction

  constructor: ->

  @openTab: (url)->
    chrome.tabs.create url: url

  @setBadgeTip: (tip)->
    chrome.browserAction.setBadgeText text: String tip

  @clearBadgeTip: ->
    @setBadgeTip ''

  @setToolTip: (tip)->
    chrome.browserAction.setTitle title: String tip

  @listenClick: (listener)->
    chrome.browserAction.onClicked.addListener listener

module.exports = BrowserAction
