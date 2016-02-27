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

    gruntTaskName = grunt.cli.tasks
    anotherTargetsForTask = gruntTaskName[0].split ':jade' if gruntTaskName?[0]?

    options = @options()
    options.i18n = {} unless options.i18n

    { locales, namespace, localeExtension, defaultExt, defaultLocale, localeFolders } = options.i18n

    # set default options
    namespace = '$i18n' unless namespace?
    localeExtension = no unless localeExtension
    # localeFolders = no unless localeFolders?
    defaultExt = '.html' unless defaultExt?

    if locales and locales.length
      jadeConfig = {}
      languageHasChanged = false

      grunt.file.expand(locales).forEach (filepath) =>
        pathToStoredLanguage = path.join(__dirname, 'temp', @target, path.basename(filepath))

        if grunt.file.exists pathToStoredLanguage
          # compare previous language file with the current
          currentLanguage = grunt.file.read(filepath)
          storedLanguage = grunt.file.read(pathToStoredLanguage)
          if currentLanguage == storedLanguage
            languageHasChanged = false
          else
            languageHasChanged = true
            grunt.file.copy filepath, pathToStoredLanguage
        else
          grunt.file.mkdir path.join(__dirname, 'temp', @target)
          grunt.file.copy filepath, pathToStoredLanguage

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
        opts.data.$localeName = locale

        # translate output destination for each language
        config.files = _.cloneDeep(@files).map (file) ->
          _locale = unless defaultLocale is locale then locale else ''
          # Define the locale in generated file names
          if localeExtension
            addLocaleExtensionDest file, locale, defaultExt

          # Use locale folders generation
          if localeFolders
            addLocaleFolderDest file, _locale, defaultExt

          # Use folder based language generation
          if not localeFolders and not localeExtension
            addLocaleDirnameDest file, _locale, defaultExt

          file
    else
      grunt.log.ok 'Locales files not found. Nothing to translate'

    # set the extended config object to the original Jade task
    if jadeConfig
      grunt.config.set 'contrib-jade', jadeConfig
    else
      grunt.config.set "contrib-jade.#{@target}", jadeOrigConfig

    # finally run the original Jade task
    # check if we uses external tasks like grunt-newer
    if anotherTargetsForTask?.length > 1 and not languageHasChanged
      grunt.task.run anotherTargetsForTask[0] + ':contrib-jade'
    else
      grunt.task.run 'contrib-jade'

  getExtension = (filepath) ->
    path.extname filepath

  setExtension = (ext) ->
    if ext.charAt(0) isnt '.'
      ext = '.' + ext
    ext

  s = (file) ->
    path.basename(file.src[0]).split('.').shift()

  addLocaleExtensionDest = (file, locale, outputExt) ->
    locale = locale.toLowerCase()

    if ext = getExtension file.dest
      dest = path.join path.dirname(file.dest), path.basename(file.dest, ext) + ".#{locale}"
    else
      dest = path.join file.dest, getBaseName(file) + ".#{locale}"

    if file.orig.ext
      dest += setExtension file.orig.ext
    else
      dest += setExtension outputExt

    file.dest = file.orig.dest = dest

  addLocaleFolderDest = (file, locale, outputExt) ->
    throw new TypeError 'Missing the template destination path' unless file.dest

    relative = file.dest.slice file.orig.dest.length + 1

    if ext = getExtension file.dest
      dest = path.join file.orig.dest, locale, path.dirname(relative), path.basename(relative, ext) + setExtension ext
    else
      if /(\/|\*+)$/i.test relative
        base = relative.split('/')
        dest = path.join file.orig.dest, locale, path.join.apply(null, base.slice(0, -1)), base.slice(-1).shift()
      else
        dest = path.join file.orig.dest, locale, relative

    dest = dest.replace /\.jade$/i, setExtension outputExt
    file.dest = file.orig.dest = dest

  addLocaleDirnameDest = (file, locale, outputExt) ->
    throw new TypeError 'Missing the template destination path' unless file.dest

    if ext = getExtension file.dest
      dest = path.join path.dirname(file.dest), locale, path.basename(file.dest, ext) + setExtension ext
    else
      if /(\/|\*+)$/i.test file.dest
        base = file.dest.split('/')
        dest = path.join path.join.apply(null, base.slice(0, -1)), locale, base.slice(-1).shift()
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
      grunt.fail.warn "Cannot parse file '#{filepath}': #{e.message}", 3

    data
