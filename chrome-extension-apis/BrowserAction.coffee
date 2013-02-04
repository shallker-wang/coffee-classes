# @description A class to manage Chrome extenion BrowserAction's APIs
# @author shallker.wang@profero.com

class BrowserAction

  constructor: ->

  @openTab: (url)->
    chrome.tabs.create url: url

  @setBadge: (text)->
    chrome.browserAction.setBadgeText text: String text

  @clearBadge: ->
    @setBadge ''

  # onGet = (text)->
  @getBadge: (onGet)->
    chrome.browserAction.getBadgeText {}, onGet

  # onGet = (text)->
  @getTabBadge: (tid, onGet)->
    chrome.browserAction.getBadgeText tabId: tid, onGet

  @setTitle: (text)->
    chrome.browserAction.setTitle title: String text

  @listenClick: (listener)->
    chrome.browserAction.onClicked.addListener listener

module.exports = BrowserAction