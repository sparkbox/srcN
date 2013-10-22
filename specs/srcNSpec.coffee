describe "srcN", ->

  describe "determining the syntax for an img tag", ->

    it """
      can categorize
      <img src-1="(max-width: 400px) pic-small.jpg"
           src-2="(max-width: 1000px) pic-medium.jpg"
           src="pic-large.jpg">
      as syntax `a`
      """, ->

      img = affix("img[src-1=\"(max-width: 400px) pic-small.jpg\"][src-2=\"(max-width: 1000px) pic-medium.jpg\"][src=\"pic-large.jpg\"]")[0]

      expect(srcN._categorizeImg(img)).toBe 'a'

    it """
      can categorize
      <img src-1="pic.png, picHigh.png 2x, picLow.png .5x">
      as syntax `b`
      """, ->

      img = affix("img[src-1=\"pic.png, picHigh.png 2x, picLow.png .5x\"]")[0]

      expect(srcN._categorizeImg(img)).toBe 'b'

    it """
      can categorize
      <img src-1="100%; pic1.png 160, pic2.png 320, pic3.png 640, pic4.png 1280, pic5.png 2560">
      as syntax `c`
      """, ->

      img = affix("img[src-1=\"100%; pic1.png 160, pic2.png 320, pic3.png 640, pic4.png 1280, pic5.png 2560\"]")[0]

      expect(srcN._categorizeImg(img)).toBe 'c'

  describe "adding srcs to array", ->

    it "can parse the 'a' syntax into it's parts", ->
      img = affix("img[src-1=\"(max-width: 400px) pic-small.jpg\"]")[0]
      expect(srcN._parse_a(img)).toEqual
        mq: "(max-width: 400px)"
        src: "pic-small.jpg"

    it "can add the 'a' syntax", ->
      img = affix("img[src-1=\"(max-width: 400px) pic-small.jpg\"]")[0]
      srcN._addSyntax_a img

      expect(srcN.mqs).toEqual
        "(max-width: 400px)": [
          img: img
          src: "pic-small.jpg"
        ]

    it "can parse the 'b' syntax into it's parts", ->
      srcN.mqs = {}
      img = affix("img[src-1=\"pic.png, picHigh.png 2x, picLow.png .5x\"]")[0]

      expect(srcN._parse_b(img)).toEqual [
        mq: "(-webkit-min-device-pixel-ratio: 1), (min-resolution: 96dpi)"
        src: "pic.png"
       ,
        mq: "(-webkit-min-device-pixel-ratio: 2), (min-resolution: 192dpi)"
        src: "picHigh.png"
       ,
        mq: "(-webkit-min-device-pixel-ratio: .5), (min-resolution: 48dpi)"
        src: "picLow.png"
      ]

    it "can add the 'b' syntax", ->
      srcN.mqs = {}
      img = affix("img[src-1=\"pic.png, picHigh.png 2x, picLow.png .5x\"]")[0]
      srcN._addSyntax_b img

      expect(srcN.mqs).toEqual
        "(-webkit-min-device-pixel-ratio: 1), (min-resolution: 96dpi)": [
          img: img
          src: "pic.png"
        ]
        ,
        "(-webkit-min-device-pixel-ratio: 2), (min-resolution: 192dpi)": [
          img: img
          src: "picHigh.png"
        ]
        ,
        "(-webkit-min-device-pixel-ratio: .5), (min-resolution: 48dpi)": [
          img: img
          src: "picLow.png"
        ]

    it "can parse the 'c' syntax into it's parts", ->
      srcN.mqs = {}
      img = affix("img[src-1=\"100%; pic1.png 160, pic2.png 320, pic3.png 640, pic4.png 1280, pic5.png 2560\"]")[0]

      expect(srcN._parse_c(img)).toEqual [
        mq: "(min-width: 160px)"
        src: "pic1.png"
      ,
        mq: "(min-width: 320px)"
        src: "pic2.png"
      ,
        mq: "(min-width: 640px)"
        src: "pic3.png"
      ,
        mq: "(min-width: 1280px)"
        src: "pic4.png"
      ,
        mq: "(min-width: 2560px)"
        src: "pic5.png"
      ]

    it "can add the 'c' syntax", ->
      srcN.mqs = {}
      img = affix("img[src-1=\"100%; pic1.png 160, pic2.png 320, pic3.png 640, pic4.png 1280, pic5.png 2560\"]")[0]
      srcN._addSyntax_c img

      expect(srcN.mqs).toEqual
        "(min-width: 160px)": [
          img: img
          src: "pic1.png"
        ]
        ,
        "(min-width: 320px)": [
          img: img
          src: "pic2.png"
        ]
        ,
        "(min-width: 640px)": [
          img: img
          src: "pic3.png"
        ]
        ,
        "(min-width: 1280px)": [
          img: img
          src: "pic4.png"
        ]
        ,
        "(min-width: 2560px)": [
          img: img
          src: "pic5.png"
        ]

    it "can add multiple images to one mq", ->
      srcN.mqs = {}
      img_1 = affix("img[src-1=\"(max-width: 400px) pic-1.jpg\"]")[0]
      img_2 = affix("img[src-1=\"(max-width: 400px) pic-2.jpg\"]")[0]
      srcN._addSyntax_a img_1
      srcN._addSyntax_a img_2

      expect(srcN.mqs).toEqual
        "(max-width: 400px)": [
          img: img_1
          src: "pic-1.jpg"
        ,
          img: img_2
          src: "pic-2.jpg"
        ]

  describe "adding mediaquery listeners", ->

    it "should add "