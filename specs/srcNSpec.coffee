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