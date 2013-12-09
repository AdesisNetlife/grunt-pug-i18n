grunt = require 'grunt'

exports.jade_i18n =

  translateFile: (test) ->
    test.expect 2

    expected = grunt.file.read 'test/expected/en_US/sample.html'
    actual = grunt.file.read '.tmp/en_US/sample.html'
    test.equal expected, actual, 'should translate the template into english'

    expected = grunt.file.read 'test/expected/es_ES/sample.html'
    actual = grunt.file.read '.tmp/es_ES/sample.html'
    test.equal expected, actual, 'should translate the template into spanish'

    test.done()

  translateDir: (test) ->
    test.expect 2

    expected = grunt.file.read 'test/expected/template.en_us.html'
    actual = grunt.file.read '.tmp/template.en_us.html'
    test.equal expected, actual, 'should translate the template into english'

    expected = grunt.file.read 'test/expected/template.es_es.html'
    actual = grunt.file.read '.tmp/template.es_es.html'
    test.equal expected, actual, 'should translate the template into spanish'

    test.done()