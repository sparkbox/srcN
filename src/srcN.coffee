((w)->
  "use strict"

  w.srcN = ->

    _getSrc = (img) ->
      attrs = {}

      for attr in img.attributes
        if attr.name.match(/src(0-9)*/)
          values = attr.nodeValue.match(/(\(.*\))*\s*(.*)/)
          attrs[attr.name] =
            mq: values[1]
            src: values[2]

      return attrs

    _getImgs = ->
      document.getElementsByTagName "img"

    _setImg = (img, src) ->
      img.src = src

    _createListener = (img, data) ->
      if data.mq
        window.matchMedia( data.mq ).addListener ->
          console.log "Setting image to #{data.src} for #{data.mq}"
          _setImg img, data.src

    init = ->
      imgs = _getImgs()
      for img in imgs
        srcs = _getSrc img

        for key, value of srcs
          _createListener img, value

    getSrc: _getSrc
    init: init

)(window)