(function() {
  describe("srcN", function() {
    it("should expose the API", function() {
      return expect(typeof srcN().getSrc).toBe("function");
    });
    return it("should be able to get a list of srcN attributes", function() {
      var img;
      img = affix("img#idTest.classTest[src=\"srcTest\"][src-1=\"(min-width: 10em) srcTest1\"][src-2=\"(min-width: 20em) srcTest2\"]")[0];
      return expect(srcN().getSrc(img)).toEqual({
        el: img,
        srcs: {
          src: {
            mq: void 0,
            src: "srcTest",
            resolution: void 0
          },
          "src-1": {
            mq: "(min-width: 10em)",
            src: "srcTest1",
            resolution: void 0
          },
          "src-2": {
            mq: "(min-width: 20em)",
            src: "srcTest2",
            resolution: void 0
          }
        }
      });
    });
  });

}).call(this);
