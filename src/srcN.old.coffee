"use strict"
srcN =

  syntax:
    a: /\(.*\)\s*\S*/
    b: /([\S]*),*\s(\S*)\s(\.*\dx)/
    c: /(\d*%);\s((\S*)\s(\d*))*/

  _resolutionMQ: (res) ->
    """
    (-webkit-min-device-pixel-ratio: #{res}),
    (min-resolution: #{res*96}dpi)
    """

  _getSrc: (img) ->
    result =
      el: img
      srcs: {}

    for attr in img.attributes
      if attr.name.match(/src-*(0-9)*/)
        if attr.nodeValue.match(/\(.*: .*\)\s*.*/) # ex. (min-width: 30em) images/image.jpg
          values = attr.nodeValue.match(/(\(.*\))*\s*([\S]*)\s*(\.*\d)*x*/)
          result.srcs[attr.name] =
            mq: values[1]
            src: values[2]
            resolution: values[3]
        else
          sources = attr.nodeValue.split(/,\s*/)
          for src, i in sources
            values = src.match(/(\S*)\s*([\.\d]*)x*/) #ex. images/president-large.jpg 2x
            console.log values
            result.srcs[i] =
              mq: "(min-width: 0)"
              src: values[1]
              resolution: values[2]

    return result

  _getImgs: ->
    document.getElementsByTagName "img"

  _setImg: (data) ->
    console.log "setImg"
    match = false
    for key, value of data.srcs
      if window.matchMedia( value.mq ).matches
        alert !@._checkResolution(value.resolution)
        break if value.resolution and !@._checkResolution(value.resolution)

        data.el.src = value.src
        match = true

    data.el.src = data.srcs.src.src unless match

  _categorizeImg: (img) ->
    for attr in img.attributes
      if attr.name.match(/src-*(0-9)*/)
        for syntax in @syntax
          debugger
          # if attr.match syntax
      else
        # no src-n attribute
        return false




  _createListeners: (data) =>
    for key, value of data.srcs
      if value.mq
        mq = window.matchMedia( value.mq )
        mq.addListener ->
          srcN._setImg data

        window.addEventListener( "orientationchange", ->
          srcN._setImg data
        , false )

        # srcN._setImg data

  _checkResolution: (res) ->
    matchMedia("(-webkit-min-device-pixel-ratio: #{res})").matches

  init: ->
    imgs = @._getImgs()
    for img in imgs
      syntax = @._categorizeImg img
      candidates = @._getSrc img
      @._createListeners candidates

srcN.init()


###
Example #1
http://rubular.com/r/p636zxq5SU -> syntax a
<img src-1="(max-width: 400px) pic-small.jpg"
     src-2="(max-width: 1000px) pic-medium.jpg"
     src="pic-large.jpg"
     alt="Obama talking to a soldier in hospital scrubs.">

Example #2
http://rubular.com/r/KTovJ8rUGc -> syntax b
<img src-1="pic.png, picHigh.png 2x, picLow.png .5x">

Example #3
http://rubular.com/r/E7kQXlirwe -> syntax c
<img src-1="100%; url1 400, url2 800">

Example #4
http://rubular.com/r/E7kQXlirwe -> syntax c
<img src-1="100%; pic1.png 160, pic2.png 320, pic3.png 640, pic4.png 1280, pic5.png 2560">
###