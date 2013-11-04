"use strict"
srcN =

  mqs: {}

  syntax:
    a: /\(.*\)\s*\S*/
    b: /([\S]*),*\s(\S*)\s(\.*\dx)/
    c: /(\d*%);\s((\S*)\s(\d*))*/

  _sortResolutionMQs: (imgs) ->
    imgs.sort (a, b) ->

      res_a = a.match(/^(\S*)\s*(\.*\d)*x*$/)[2] or 1
      res_b = b.match(/^(\S*)\s*(\.*\d)*x*$/)[2] or 1

      if res_a > res_b 
        1
      else
        -1


  _resolutionMQ: (res) ->
    "(-webkit-min-device-pixel-ratio: #{res}), (min-resolution: #{res*96}dpi)"

  _checkResolution: (res) ->
    matchMedia("(-webkit-min-device-pixel-ratio: #{res})").matches

  _getImgs: ->
    document.getElementsByTagName "img"

  _categorizeImg: (img) ->
    for attr in img.attributes
      if attr.name.match /src-*(0-9)*/
        for key of @syntax
          if attr.value.match @syntax[key]
            return key

  _pushSrc: (img, data) ->
    item =
      img: img
      src: data.src

    @mqs["#{data.mq}"] = [] unless @mqs["#{data.mq}"]
    @mqs["#{data.mq}"].push item

  _parse_a: (img) ->
    srcs = []
    for attr in img.attributes
      if attr.name.match /src-\d/
        split = attr.value.match /(\(.*\))\s*(\S*)/
        result =
          mq: split[1]
          src: split[2]
        srcs.push result
    return srcs

  _addSyntax_a: (img) ->
    srcs = @_parse_a img
    for item in srcs
      @_pushSrc img, item

  _parse_b: (img) ->
    srcs = []
    for attr in img.attributes
      if attr.name.match /src-\d/
        imgs = @_sortResolutionMQs(attr.value.split ", ")
        for item in imgs
          split = item.match /^(\S*)\s*(\.*\d)*x*$/
          res = if split[2]
            split[2]
          else
            1

          srcs.push
            mq: @_resolutionMQ res
            src: split[1]
    return srcs

  _addSyntax_b: (img) ->
    srcs = @_parse_b img
    for item in srcs
      @_pushSrc img, item

  _parse_c: (img) ->
    srcs = []
    for attr in img.attributes
      if attr.name.match /src-\d/
        imgs = attr.value.match(/\d*%; (.*)/)[1].split ", "
        for item in imgs
          split = item.match /^(\S*)\s(\d*)$/

          srcs.push
            mq: "(min-width: #{split[2]}px)"
            src: split[1]
    return srcs

  _addSyntax_c: (img) ->
    srcs = @_parse_c img
    for item in srcs
      @_pushSrc img, item

  _createListeners: ->
    for key of @mqs
      mq = window.matchMedia key
      mq.addListener ->
        srcN._setImgs()

      window.addEventListener( "orientationchange", =>
        srcN._setImgs()
      , false )

    srcN._setImgs()

  _setImgs: ->
    for mq of @mqs
      if matchMedia(mq).matches
        for item of @mqs[mq]
          @_setImg @mqs[mq][item]

  _setImg: (data) ->
    # Trigger some sort of event here (user defineaable via jQuery or other libray?)
    console.log "Setting src for #{data.img.id} to #{data.src}"
    data.img.src = data.src

  init: ->
    imgs = @_getImgs()
    for img in imgs
      syntax = @_categorizeImg img
      @["_addSyntax_#{syntax}"] img

    @_createListeners()

srcN.init()