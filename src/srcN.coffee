((w)->
  "use strict"

  w.srcN = ->

    _getSrc = (img) ->
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


    _getImgs = ->
      document.getElementsByTagName "img"


    _setImg = (data) ->
      match = false
      for key, value of data.srcs
        if window.matchMedia( value.mq ).matches
          console.log "Image updated"
          data.el.src = value.src
          match = true

      data.el.src = data.srcs.src.src unless match


    _createListeners = (data) ->
      for key, value of data.srcs
        if value.mq
          window.matchMedia( value.mq ).addListener ->
            console.log "#{value.mq} triggered on #{data.el}."
            _setImg data


    init = ->
      imgs = _getImgs()
      for img in imgs
        candidates = _getSrc img
        _createListeners candidates

    getSrc: _getSrc
    init: init

)(window)