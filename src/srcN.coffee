"use strict"
srcN =

  _getSrc: (img) ->
    result =
      el: img
      srcs: {}

    for attr in img.attributes
      if attr.name.match(/src-*(0-9)*/)
        values = attr.nodeValue.match(/(\(.*\))*\s*([\S]*)\s*([\.\d])*x*/)
        result.srcs[attr.name] =
          mq: values[1]
          src: values[2]
          resolution: values[3]

    return result


  _getImgs: ->
    document.getElementsByTagName "img"


  _setImg: (data) ->
    console.log "setImg"
    match = false
    for key, value of data.srcs
      if window.matchMedia( value.mq ).matches
        return if value.resolution and !@._checkResolution(value.resolution)

        data.el.src = value.src
        match = true

    data.el.src = data.srcs.src.src unless match


  _createListeners: (data) =>
    for key, value of data.srcs
      if value.mq
        mq = window.matchMedia( value.mq )
        mq.addListener ->
          srcN._setImg data

        window.addEventListener( "orientationchange", ->
          srcN._setImg data
        , false )

        srcN._setImg data

  _checkResolution: (res) ->
    matchMedia("(-webkit-min-device-pixel-ratio: #{res})").matches

  init: ->
    imgs = @._getImgs()
    for img in imgs
      candidates = @._getSrc img
      @._createListeners candidates

srcN.init()