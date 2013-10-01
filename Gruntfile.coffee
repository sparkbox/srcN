#global module:false
module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    watch:
      config:
        files: "Gruntfile.coffee"
        tasks: "default"

      javascript:
        files: ["src/**/*.coffee"]
        tasks: "coffee:src"

      jasmine:
        files: ["bin/*.js", "specs/**/*.*"]
        tasks: "test"

    coffee:
      src:
        options:
          bare: true
        files: "bin/srcN.js": "src/srcN.coffee"
      jasmine_specs:
        files: grunt.file.expandMapping(["specs/*.coffee"], "specs/js/", {
          rename: (destBase, destPath) ->
            destBase + destPath.replace(/\.coffee$/, ".js").replace(/specs\//, "")
        })

    jasmine:
      src: "bin/srcN.js"
      options:
        specs: "specs/js/*Spec.js"
        helpers: "specs/js/*Helper.js"
        vendor: ["specs/lib/jquery.min.js", "specs/lib/jasmine-fixture.js"]


  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-jasmine"
  grunt.loadNpmTasks "grunt-notify"

  grunt.registerTask "test", ["coffee:jasmine_specs", "jasmine"]
  grunt.registerTask "default", ["coffee:src", "test"]
