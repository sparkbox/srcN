(function(w) {
  "use strict";
  return w.srcN = function() {
    var init, _createListeners, _getImgs, _getSrc, _setImg;
    _getSrc = function(img) {
      var attr, result, values, _i, _len, _ref;
      result = {
        el: img,
        srcs: {}
      };
      _ref = img.attributes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        attr = _ref[_i];
        if (attr.name.match(/src-*(0-9)*/)) {
          values = attr.nodeValue.match(/(\(.*\))*\s*([\S]*)\s*([\.\d])*x*/);
          result.srcs[attr.name] = {
            mq: values[1],
            src: values[2],
            resolution: values[3]
          };
        }
      }
      return result;
    };
    _getImgs = function() {
      return document.getElementsByTagName("img");
    };
    _setImg = function(data) {
      var key, match, value, _ref;
      match = false;
      _ref = data.srcs;
      for (key in _ref) {
        value = _ref[key];
        if (window.matchMedia(value.mq).matches) {
          console.log("Image updated");
          data.el.src = value.src;
          match = true;
        }
      }
      if (!match) {
        return data.el.src = data.srcs.src.src;
      }
    };
    _createListeners = function(data) {
      var key, value, _ref, _results;
      _ref = data.srcs;
      _results = [];
      for (key in _ref) {
        value = _ref[key];
        if (value.mq) {
          _results.push(window.matchMedia(value.mq).addListener(function() {
            console.log("" + value.mq + " triggered on " + data.el + ".");
            return _setImg(data);
          }));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };
    init = function() {
      var candidates, img, imgs, _i, _len, _results;
      imgs = _getImgs();
      _results = [];
      for (_i = 0, _len = imgs.length; _i < _len; _i++) {
        img = imgs[_i];
        candidates = _getSrc(img);
        _results.push(_createListeners(candidates));
      }
      return _results;
    };
    return {
      getSrc: _getSrc,
      init: init
    };
  };
})(window);
