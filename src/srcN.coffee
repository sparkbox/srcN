"use strict"
srcN =

  mqs: []

  syntax:
    a: /\(.*\)\s*\S*/
    b: /([\S]*),*\s(\S*)\s(\.*\dx)/
    c: /(\d*%);\s((\S*)\s(\d*))*/

  _resolutionMQ: (res) ->
    """
    (-webkit-min-device-pixel-ratio: #{res}),
    (min-resolution: #{res*96}dpi)
    """

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
    @mqs.push
      mq: data.mq
      imgs: [
        img: img
        src: data.src
      ]

  _parse_a: (img) ->
    for attr in img.attributes
      if attr.name.match /src-*(0-9)*/
        split = attr.value.match /(\(.*\))\s*(\S*)/
        result =
          mq: split[1]
          src: split[2]
        return result

  _addSyntax_a: (img) ->
    @_pushSrc img, @_parse_a img

  _parse_b: (img) ->
    srcs = []
    for attr in img.attributes
      if attr.name.match /src-*(0-9)*/
        imgs = attr.value.split ", "
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
      if attr.name.match /src-*(0-9)*/
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

  init: ->
    imgs = @._getImgs()
    for img in imgs
      syntax = @._categorizeImg img

      @["_addSyntax_#{syntax}"] img
      candidates = @._getSrc img
      @._createListeners candidates

srcN.init()