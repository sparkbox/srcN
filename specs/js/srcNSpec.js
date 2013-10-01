(function() {
  describe("srcN", function() {
    it("should expose the API", function() {
      return expect(typeof srcN().getSrc).toBe("function");
    });
    return it("should be able to get a list of srcN attributes", function() {
      var $img;
      $img = affix("img#idTest.classTest[src=\"srcTest\"][src1=\"(min-width: 10em) srcTest1\"][src2=\"(min-width: 20em) srcTest2\"]");
      return expect(srcN().getSrc($img[0])).toEqual({
        src: "srcTest",
        src1: "(min-width: 10em) srcTest1",
        src2: "(min-width: 20em) srcTest2"
      });
    });
  });

}).call(this);
