module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-replace"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-compass"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-angular-templates"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-watch"

  # Project configuration.
  grunt.initConfig

    package: grunt.file.readJSON "package.json"
 
    compass:

      build:
        options:
          outputStyle:             "compressed"
          sassPath:                "app/assets/sass"
          cssPath:                 "public/stylesheets"
          imagesDir:               "public/images/"
          generatedImagesDir:      "public/images/sprites/"
          generatedImagesPath:     "public/images/sprites/"
          httpGeneratedImagesPath: "../images/sprites"

      debug:
        options:
          outputStyle:             "compact"
          sassPath:                "app/assets/sass"
          cssPath:                 "public/stylesheets"
          imagesDir:               "public/images/"
          generatedImagesDir:      "public/images/sprites/"
          generatedImagesPath:     "public/images/sprites/"
          httpGeneratedImagesPath: "../images/sprites"

    ngtemplates:
      templates:
        options:
          base: "tmp"
          prepend: "/"
          module:
            name: "Neon"
            define: false
        src: ["tmp/*.html", "tmp/**/*.html"],
        dest: "tmp/templates.js"

    coffee:
      compile:
        files:
          "tmp/coffee.js": [
            "app/assets/coffee/**/*.coffee"
          ]

    copy:
      assets:
        files: [
          expand: true
          src: ["app/assets/**"]
          dest: "build/"
          rename: (dest, src) ->
            dest + src.slice "app/assets/".length
        ]

    uglify:
      build:
        files:
          "public/javascripts/application.js": [
            "vendor/js/jquery-2.0.3.min.js"
            "vendor/js/angular.min.js"
            "tmp/coffee.js"
            #"tmp/templates.js"
          ]

    concat:
      debug:
        dest: "public/javascripts/application.js"
        src: [
          "vendor/js/jquery-2.0.3.js"
          "vendor/js/angular.js"
          "tmp/coffee.js"
          #"tmp/templates.js"
        ]

    clean:
      erase: ["build/**"]
      tmp: ["tmp"]

    watch:
      js:
        files: ["app/assets/coffee/**/*.coffee"]
        tasks: ["coffee", "concat:debug"]
        options:
          interrupt: true
      css:
        files: '**/*.sass',
        tasks: ["copy", "compass:debug"]
        options:
          interrupt: true
      jade:
        files: ["app/**/*.jade"]
        tasks: ["jade", "concat:debug"]
        options:
          interrupt: true
  
  # Build files for production.
  grunt.registerTask "build", [
    "clean:erase",
    #"copy",
    "compass:build",
    #"ngtemplates",
    "coffee",
    "uglify:build",
    "clean:tmp"
  ]

  # Build files for debugging.
  grunt.registerTask "debug", [
    #"copy",
    "compass:debug",
    #"ngtemplates",
    "coffee",
    "concat:debug"
  ]

  # Helper function for spawning processes
  spawn = (options, done = (->), inheritIO = true) ->
    # If inheritIO is true (default) then spawned commands will
    # print to the console. If false, spawned commands will not
    # print to the console, and instead the 'done' function will
    # be provided the output to stdout as its first argument.
    if inheritIO
      options.opts      ?= {}
      options.opts.stdio = "inherit"

    result = ""
    ps     = grunt.util.spawn options, -> done result or undefined

    ps.stdout?.setEncoding "utf8"
    ps.stdout?.on "data", (data) -> result += data

    return ps

  runDevelopment = ->
    @async()

    spawn
      grunt: true
      args: ["clean:erase"]
    , ->
      spawn
        grunt: true
        args: ["debug"]
      , ->
        spawn
          grunt: true
          args: ["watch"]

  grunt.registerTask "go", "Debugs and runs watch", ->
    runDevelopment.call this, true
