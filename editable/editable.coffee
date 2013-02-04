# @dependencies jQuery, Bootstrap Popover
# @author shallker.wang@profero.com

class Edit

  ele: null
  clone: null

  data:
    type: 'text'
    mode: 'inline'
    classes: ''
    value: ''
    options: ''

  constructor: (@ele)->
    # @ele = $(@ele)
    @initialize()
    @edit()

  initialize: ->
    @data.value = $(@ele).text()
    @applyDatas @ele
    @replicate @ele
    switch @data.type
      when 'text' then @generateInput()
      when 'select' then @generateSelect()
      else return

  change: (value)->
    $(@ele).text(value).trigger('change')

  compare: (value)->
    @change value if value != @data.value

  onInputBlur: (blur)=>
    blur.stopPropagation()
    return if @ended
    @compare $(blur.target).val()
    @end()

  onINputChange: (change)=>
    change.stopPropagation()

  onInputKeyup: (keyup)=>
    switch keyup.keyCode
      when 13 then $(keyup.target).trigger('blur')
      when 27 then @end()
      else return

  onSelectChange: (change)=>
    change.stopPropagation()
    return if @ended
    @compare $(change.target).val()
    @end()

  generateInput: ->
    @eleInput = $(@generateInputHtml())
    @inputHtml = $(@generateRowHtml()).append(@eleInput)
    @eleInput.blur @onInputBlur
    @eleInput.change @onINputChange
    @eleInput.keyup @onInputKeyup

  generateSelect: ->
    @eleInput = $(@generateSelectHtml())
    @inputHtml = $(@generateRowHtml()).append(@eleInput)
    @eleInput.change @onSelectChange
    @eleInput.blur @onInputBlur

  generateRowHtml: ->
    '<div class="row-fluid"></div>'

  generateInputHtml: ->
    """
    <input class="span12" type="text" value="#{@data.value}">
    """

  generateSelectHtml: ->
    """
    <select class="span12">
      #{@generateOptionHtml()}
    </select>
    """

  generateOptionHtml: ->
    html = ''
    values = @data.options.split '|'
    for value in values
      if value == @data.value
        html += "<option value='#{value}' selected>#{value}</option>"
      else
        html += "<option value='#{value}'>#{value}</option>"
    html

  selectInput: (input)->
    $(input).focus().select()

  edit: ->
    console.log 'edit'

  end: ->
    console.log 'end'
    @reset()
    @ended = true

  reset: ->
    $(@clone).remove()
    $(@ele).show()

  replicate: (ele)->
    $(ele).after $(ele).clone()
    $(ele).hide()
    @clone = $(ele).next().get(0)

  applyDatas: (ele)->
    datas = @getEleDatas ele
    @data[name] = value for name, value of datas

  getEleDatas: (ele)->
    prefix = 'data-'
    attributes = @getElePrefixAttributes ele, prefix
    result = {}
    result[name.substring prefix.length] = value for name, value of attributes
    result

  getEleAttributes: (ele)->
    result = {}
    result[attr.name] = attr.value for attr in ele.attributes
    result

  getElePrefixAttributes: (ele, prefix)->
    attributes = @getEleAttributes ele
    for name, value of attributes
      delete attributes[name] if (name.indexOf prefix) isnt 0
    attributes

class EditInline extends Edit

  constructor: (@ele)->
    super

  edit: ->
    console.log 'inline.edit'

class EditPopover extends Edit

  data:
    type: 'text'
    classes: ''
    value: ''
    options: ''
    placement:'top'
    title: ''

  constructor: (@ele)->
    super

  edit: ->
    console.log 'popover.edit'
    @applyPopover @clone
    @selectInput @eleInput
    # console.log @eleInput

  end: ->
    console.log 'popover.end'
    @destroyPopover()
    @reset()
    @ended = true

  applyPopover: ->
    $(@clone).popover(
      html: true
      title: @data.title
      content: @inputHtml
      placement: @data.placement
      trigger: 'manual'
    ).popover('show')

  destroyPopover:->
    $(@clone).popover('destroy')


class Editable

  @enabled: false
  @initialized: false
  @selector: '.editable'

  @init: ->
    @delegate()
    @initialized = true

  @enable: (@selector)->
    @init() if not @initialized
    @enabled = true

  @disable: ->
    @enabled = false

  @delegate: ->
    $(document).delegate @selector, 'click', @onClick

  @onClick: (click)=>
    return if not @enabled
    click.preventDefault()
    click.stopPropagation()
    ele = click.target
    switch $(ele).attr('data-mode')
      when 'inline' then new EditInline ele
      when 'popover' then new EditPopover ele
      else return

jQuery -> Editable.enable()