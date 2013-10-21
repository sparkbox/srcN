srcN
====

src-n polyfill

## src-n Syntax:

### Example #1
  ```
    <img src-1="(max-width: 400px) pic-small.jpg"
         src-2="(max-width: 1000px) pic-medium.jpg"
         src="pic-large.jpg"
         alt="Obama talking to a soldier in hospital scrubs.">
  ```

### Example #2
  ```
    <img src-1="pic.png, picHigh.png 2x, picLow.png .5x">
  ```

### Example #3
  ```
    <img src-1="100%; url1 400, url2 800">
  ```

### Example #4
  ```
    <img src-1="100%; pic1.png 160, pic2.png 320, pic3.png 640, pic4.png 1280, pic5.png 2560">
  ```


## Resources

- http://tabatkins.github.io/specs/respimg/Overview.html
- http://lists.w3.org/Archives/Public/public-respimg/2013Sep/0064.html
- https://etherpad.mozilla.org/polyfilling-srcN


## Todo

- Write more tests
- Develop performance tests to see which files are getting downloaded on which browsers/screen sizes, etc.
  - Are there tools we could use for this?
- Run performance tests
- Find a way to implement different syntaxes
- Update the Readme with more info
- Think of other things that need to be done
- Add more images with other sources and breakpoints to the example
- Add fallback code for older browsers