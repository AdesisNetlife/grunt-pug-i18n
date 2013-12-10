module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    clean: ['.tmp', 'tasks/*.js', 'test/**/*.js']

    coffeelint:
      tasks: 'tasks/*.coffee'
      test: 'test/*.coffee'
      grunt: 'Gruntfile.coffee'
      options:
        max_line_length:
          value: 120
          level: 'warn'
        no_trailing_whitespace:
          level: 'warn'
        no_tabs:
          level: 'error'
        indentation:
          value: 2
          level: 'error'

    coffee:
      tasks:
        files:
          'tasks/i18n.js': 'tasks/i18n.coffee'
      options:
        bare: true

    jade:
      translateDir:
        options:
          i18n:
            locales: 'test/locales/*'
          pretty: true
        files:
          '.tmp/sample.jade': 'test/fixtures/directory/*.jade'

      translateFile:
        options:
          i18n:
            locales: [ 'test/locales/*' ]
            namespace: '$t'
            locateExtension: true
          client: false
          pretty: true

        files: [
          expand: true
          ext: '.html'
          cwd: 'test/fixtures/file'
          src: [ '*.jade' ]
          dest: '.tmp/'
        ]

    nodeunit:
      tests: ['test/*_test.coffee']

  grunt.loadTasks 'tasks'

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'

  grunt.registerTask 'default', ['clean', 'coffeelint', 'coffee']
  grunt.registerTask 'test', ['clean', 'coffeelint', 'coffee', 'jade', 'nodeunit']
