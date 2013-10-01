describe "srcN", ->

  it "should expose the API", ->
    expect(typeof srcN().getSrc).toBe "function"

  it "should be able to get a list of srcN attributes", ->

    $img = affix("img#idTest.classTest[src=\"srcTest\"][src1=\"(min-width: 10em) srcTest1\"][src2=\"(min-width: 20em) srcTest2\"]")

    expect(srcN().getSrc($img[0])).toEqual
      src: "srcTest"
      src1: "(min-width: 10em) srcTest1"
      src2: "(min-width: 20em) srcTest2"