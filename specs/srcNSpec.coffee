describe "srcN", ->

  it "should expose the API", ->
    expect(typeof srcN().getSrc).toBe "function"

  it "should be able to get a list of srcN attributes", ->

    img = affix("img#idTest.classTest[src=\"srcTest\"][src-1=\"(min-width: 10em) srcTest1\"][src-2=\"(min-width: 20em) srcTest2\"]")[0]

    expect(srcN().getSrc(img)).toEqual
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