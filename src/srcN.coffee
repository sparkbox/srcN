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

    return "no src-n match"


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