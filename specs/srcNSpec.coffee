describe "srcN", ->

  xit "should be able to get a list of srcN attributes", ->

    img = affix("img#idTest.classTest[src=\"srcTest\"][src-1=\"(min-width: 10em) srcTest1\"][src-2=\"(min-width: 20em) srcTest2\"]")[0]

    expect(srcN._getSrc(img)).toEqual
      el: img
      srcs:
        src:
          mq: undefined
          src: "srcTest"
          resolution: undefined
        "src-1":
          mq: "(min-width: 10em)"
          src: "srcTest1"
          resolution: undefined
        "src-2":
          mq: "(min-width: 20em)"
          src: "srcTest2"
          resolution: undefined


    expect(srcN._checkResolution(1)).toEqual true


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

      expect(srcN.mqs).toEqual [
        mq: "(max-width: 400px)"
        imgs: [
          img: img
          src: "pic-small.jpg"
        ]
      ]

    it "can parse the 'b' syntax into it's parts", ->
      srcN.mqs = []
      img = affix("img[src-1=\"pic.png, picHigh.png 2x, picLow.png .5x\"]")[0]

      expect(srcN._parse_b(img)).toEqual [
        mq: """
        (-webkit-min-device-pixel-ratio: 1),
        (min-resolution: #{1*96}dpi)
        """
        src: "pic.png"
      ,
        mq: """
        (-webkit-min-device-pixel-ratio: 2),
        (min-resolution: #{2*96}dpi)
        """
        src: "picHigh.png"
      ,
        mq: """
        (-webkit-min-device-pixel-ratio: .5),
        (min-resolution: #{.5*96}dpi)
        """
        src: "picLow.png"
      ]

    it "can add the 'b' syntax", ->
      srcN.mqs = []
      img = affix("img[src-1=\"pic.png, picHigh.png 2x, picLow.png .5x\"]")[0]
      srcN._addSyntax_b img

      expect(srcN.mqs).toEqual [
        mq: """
        (-webkit-min-device-pixel-ratio: 1),
        (min-resolution: #{1*96}dpi)
        """
        imgs: [
          img: img
          src: "pic.png"
        ]
      ,
        mq: """
        (-webkit-min-device-pixel-ratio: 2),
        (min-resolution: #{2*96}dpi)
        """
        imgs: [
          img: img
          src: "picHigh.png"
        ]
      ,
        mq: """
        (-webkit-min-device-pixel-ratio: .5),
        (min-resolution: #{.5*96}dpi)
        """
        imgs: [
          img: img
          src: "picLow.png"
        ]
      ]

    it "can parse the 'c' syntax into it's parts", ->
      srcN.mqs = []
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
      srcN.mqs = []
      img = affix("img[src-1=\"100%; pic1.png 160, pic2.png 320, pic3.png 640, pic4.png 1280, pic5.png 2560\"]")[0]
      srcN._addSyntax_c img

      expect(srcN.mqs).toEqual [
        mq: "(min-width: 160px)"
        imgs: [
          img: img
          src: "pic1.png"
        ]
      ,
        mq: "(min-width: 320px)"
        imgs: [
          img: img
          src: "pic2.png"
        ]
      ,
        mq: "(min-width: 640px)"
        imgs: [
          img: img
          src: "pic3.png"
        ]
      ,
        mq: "(min-width: 1280px)"
        imgs: [
          img: img
          src: "pic4.png"
        ]
      ,
        mq: "(min-width: 2560px)"
        imgs: [
          img: img
          src: "pic5.png"
        ]
      ]