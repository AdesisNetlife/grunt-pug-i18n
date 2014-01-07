path = require 'path'
_ = require 'lodash'

module.exports = (grunt) ->

  try
    require 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-jade'
  catch e
    grunt.loadTasks path.join "#{__dirname}/../node_modules", 'grunt-contrib-jade', 'tasks'

  grunt.renameTask 'jade', 'contrib-jade'

  grunt.registerMultiTask 'jade', 'Compile Jade template with internalization support', ->

    jadeConfig = null
    jadeOrigConfig = grunt.config.get('jade')[@target]

    options = @options()
    options.i18n = {} unless options.i18n
    { locales, namespace, localeExtension, defaultExt } = options.i18n

    # set default options
    namespace = '$i18n' unless namespace?
    localeExtension = no unless localeExtension?
    defaultExt = '.html' unless defaultExt?

    if locales and locales.length
      jadeConfig = {}

      grunt.file.expand(locales).forEach (filepath) =>

        # get the language code
        fileExt = filepath.split('.').slice(-1)[0]
        locale = path.basename filepath, '.' + fileExt
        grunt.log.ok "Loading locale '#{locale}'"

        # create the new config as subtask for each language, based on the original task config
        jadeConfig["#{@target or @name}-#{locale}"] = config = _.cloneDeep jadeOrigConfig

        # read data from translation file
        grunt.verbose.writeln "Reading translation data: #{filepath}"

        opts = config.options = if not config.options then {} else config.options
        opts.data = opts.data() or {} if typeof opts.data is 'function'
        opts.data = {} unless _.isPlainObject opts.data
        opts.data = _.extend opts.data, readFile filepath
        opts.data[namespace] = readFile filepath

        # translate output destination for each language
        config.files = _.cloneDeep(@files).map (file) ->
          if localeExtension
            addLocaleExtensionDest file, locale, defaultExt
          else
            addLocaleDirnameDest file, locale, defaultExt
          file

    else
      grunt.log.ok 'Locales files not found. Nothing to translate'

    # set the extended config object to the original Jade task
    if jadeConfig
      grunt.config.set 'contrib-jade', jadeConfig
    else
      grunt.config.set "contrib-jade.#{@target}", jadeOrigConfig

    # finally run the original Jade task
    grunt.task.run 'contrib-jade'



  getExtension = (filepath) ->
    path.extname filepath

  setExtension = (ext) ->
    if ext.charAt(0) isnt '.'
      ext = '.' + ext
    ext

  addLocaleExtensionDest = (file, locale, outputExt) ->
    locale = locale.toLowerCase()
    getBaseName = -> path.basename(file.src[0]).split('.')[0]

    if ext = getExtension file.dest
      dest = path.join path.dirname(file.dest), path.basename(file.dest, ext) + ".#{locale}"
    else
      dest = path.join file.dest, getBaseName() + ".#{locale}"

    if file.orig.ext
      dest += setExtension file.orig.ext
    else
      dest += setExtension outputExt

    file.dest = file.orig.dest = dest

  addLocaleDirnameDest = (file, locale, outputExt) ->
    if ext = getExtension file.dest
      dest = path.join path.dirname(file.dest), locale, path.basename(file.dest, ext) + setExtension ext
    else
      if /(\/|\*+)$/i.test file.dest
        base = file.dest.split('/')
        dest = path.join path.join.apply(null, base.slice(0, -1)), locale, base.slice(-1)[0]
      else
        dest = path.join file.dest, locale

    dest = dest.replace /\.jade$/i, setExtension outputExt
    file.dest = file.orig.dest = dest

  readFile = (filepath) ->
    try
      if /(\.yaml|\.yml)$/i.test filepath
        data = grunt.file.readYAML filepath
      else if /\.js$/i.test filepath
        data = require path.resolve filepath
      else
        data = grunt.file.readJSON filepath
    catch e
      grunt.fail.warm "Cannot parse file '#{filepath}': #{e.message}", 3

    data
