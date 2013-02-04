class XHR
  xhr: {}

  url: ''
  async: true
  method: 'GET'
  headers: {}
  requests: ''
  listeners: {}
  uploadListeners: {}

  constructor: (options)->
    @name = value for name, value of options if options
    # @toFormData @requests if typeof @requests is 'object'
    @xhr = new XMLHttpRequest()

  addListener: (ev, listener)->
    @listeners[ev] = listener
  
  addUploadListener: (ev, listener)->
    @uploadListeners[ev] = listener

  addHeader: (name, value)->
    @headers[name] = value

  open: (method, url, async, listeners, uploadListeners, headers)->
    @xhr.addEventListener ev, listener for ev, listener of listeners if listeners
    @xhr.upload.addEventListener ev, listener for ev, listener of uploadListeners if uploadListeners
    @xhr.open method, url, async
    @xhr.setRequestHeader name, value for name, value of headers if headers

  send: (requests)->
    @xhr.send requests
    @xhr.responseText
    # console.log('Location', @xhr.getResponseHeader("Location") )

  toFormData: (obj)->
    data = new FormData()
    data.append name, value for name, value of obj
    data

  request: (url, requests, method)->
    url = url || @url
    method = method || @method
    requests = requests || @requests

    # xhr = @xhr
    # $('.container').html('')
    # @xhr.onreadystatechange = (a)->
      # console.log a, @
      # $('.container').append document.createTextNode "#{name}: #{value} \n <br>" for name, value of @
      # $('.container').append document.createTextNode "----------------------------"
    
    @open method, url, @async, @listeners, @uploadListeners, @headers
    # @xhr.channel.QueryInterface(Components.interfaces.nsIHttpChannel).redirectionLimit = 0;
    @send requests

  postForm: (url, requests)->
    @post url, @toFormData requests

  post: (url, requests)->
    @request url, requests, 'POST'

  get: (url, requests)->
    @request url, requests, 'GET'

module.exports = XHR