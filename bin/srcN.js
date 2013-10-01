(function(w) {
  "use strict";
  return w.srcN = function() {
    var init, _createListener, _getImgs, _getSrc, _setImg;
    _getSrc = function(img) {
      var attr, attrs, values, _i, _len, _ref;
      attrs = {};
      _ref = img.attributes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        attr = _ref[_i];
        if (attr.name.match(/src(0-9)*/)) {
          values = attr.nodeValue.match(/(\(.*\))*\s*(.*)/);
          attrs[attr.name] = {
            mq: values[1],
            src: values[2]
          };
        }
      }
      return attrs;
    };
    _getImgs = function() {
      return document.getElementsByTagName("img");
    };
    _setImg = function(img, src) {
      return img.src = src;
    };
    _createListener = function(img, data) {
      if (data.mq) {
        return window.matchMedia(data.mq).addListener(function() {
          console.log("Setting image to " + data.src + " for " + data.mq);
          return _setImg(img, data.src);
        });
      }
    };
    init = function() {
      var img, imgs, key, srcs, value, _i, _len, _results;
      imgs = _getImgs();
      _results = [];
      for (_i = 0, _len = imgs.length; _i < _len; _i++) {
        img = imgs[_i];
        srcs = _getSrc(img);
        _results.push((function() {
          var _results1;
          _results1 = [];
          for (key in srcs) {
            value = srcs[key];
            _results1.push(_createListener(img, value));
          }
          return _results1;
        })());
      }
      return _results;
    };
    return {
      getSrc: _getSrc,
      init: init
    };
  };
})(window);
