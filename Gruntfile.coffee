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
        tasks: "coffee"

      jasmine:
        files: ["dist/*.js", "specs/**/*.*"]
        tasks: "jasmine"

    coffee:
      files: "dist/srcN.js": "src/srcN.coffee"

    jasmine:
      options:
        helpers: "specs/js/*Helper.js"

      core:
        src: ["dist/srcN.js"]
        options:
          specs: "specs/js/*Spec.js"


  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-jasmine"
  grunt.loadNpmTasks "grunt-notify"

  # Default task
  grunt.registerTask "default", ["coffee", "jasmine"]
