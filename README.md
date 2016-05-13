# grunt-pug-i18n [![Build Status](https://travis-ci.org/AdesisNetlife/grunt-pug-i18n.svg)][travis] [![Downloads](https://img.shields.io/npm/dm/grunt-pug-i18n.svg)][npm]

Compile Pug (previously Jade) templates with internationalization support based on JS/JSON/YAML files using [Grunt](http://gruntjs.com)

## Getting started

This plugin is exactly the same like [grunt-contrib-pug][1], but it adds high level support
for [Pug][3] template internationalization based on JSON/YAML/JS files

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](hettp://gruntjs.com/sample-gruntfil) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```bash
$ npm install grunt-pug-i18n --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile:

```js
grunt.loadNpmTasks('grunt-pug-i18n')
```

This plugin requires Grunt `~0.4.0`

## The "pug" task

_Run this task with the `grunt pug` command._

Task targets, files and options may be specified according to the grunt [Configuring tasks](http://gruntjs.com/configuring-tasks) guide

This plugin provides a localization mechanism for Pug templates.
Since localization is done once during the build process, there is no performance hit on the application, opposed to dynamic translation on the client side


### Usage example

##### Gruntfile configuration
```js
grunt.initConfig({
  pug: {
    templates: {
      options: {
        // Pug i18n specific options
        i18n: {
          locales: 'locales/*.json',
          namespace: '$i18n'
        },
        // Pug specific options
        pretty: true
      },
      files: {
        "path/to/dest.html": ["path/to/templates/*.pug", "another/path/tmpl.pug"]
      }
    }
  }
})
```
_See [Gruntfile][5] for more configuration examples_

##### Example JSON locale file (es_ES.json)
```json
{
  "hello": {
    "world": "Hola Mundo"
  }
}
```

##### Example Pug template
```pug
body
  h1 #{$i18n.hello.world}!
  p Using locale #{$localeName}
```

### Options

Only `pug-i18n` specific options are listed below

To see all the available options available, please see [grunt-contrib-pug][2]

#### locales
Type: `string|array`

Path to localization files. Please check the examples in tests. Glob patterns can be used

`JSON`, `YAML` and `JS` formats are supported for the translation templates

#### namespace
Type: `string`
Default: `$i18n`

Namespace to expose translation keys in Pug template

#### localeExtension
Type: `boolean`
Default: `false`

Generate the HTML output files with the extension prefix with the current language.
By default it will create different folders for each language

Setting this option into `true`, the generated HTML files will look like this:
```
html/
├── view.en-en.html
└── view.es-es.html
```
... instead of:
```
html/
├── en-EN/
│   └── view.html
└── es-ES/
    └── view.html
```

See [test][4] for more examples

## Contributing

Instead of a formal styleguide, take care to maintain the existing coding style.

Add unit tests for any new or changed functionality

### Development

Clone the repository
```shell
$ git clone https://github.com/adesisnetlife/grunt-pug-i18n.git && cd grunt-pug-i18n
```

Install dependencies
```shell
$ npm install
```

Run tests
```shell
$ npm test
```

## Release History

- **1.0.0** `2016.05.10`
    - Rename to `grunt-pug-i18n`
- **0.3.4** `2015.02.18`
    - Fix error in multiple running tasks (#22, #23)
- **0.3.3** `2015.02.08`
    - Maintance release
- **0.3.2** `2015.01.02`
    - Bump grunt-contrib-jade version
- **0.3.1** `2014.12.03`
    - Fix #18
- **0.3.0** `2014.09.16`
    - Uninstall `grunt-newer`
    - Adds compatibility with external tasks like `grunt-newer`
- **0.2.1** `2014.08.04`
    - Fix #14
- **0.2.0** `2014.06.26`
    - Installs and uses `grunt-newer`
- **0.1.7** `2014.04.22`
    - Replace caret (^) with tilde (~) for grunt-contrib-jade version
- **0.1.5** `2013.01.07`
    - Fix #4
- **0.1.4** `2013.01.03`
    - Upgrade `grunt-contrib-jade` task dependency to 0.9.0
- **0.1.3** `2013.12.19`
    - Fix #2
    - Fix #3
- **0.1.2** `2013.12.11`
    - Fix locale bad formed name
- **0.1.1** `2013.12.10`
    - Minor refactor
    - Improvements: avoid possible configuration issues with output file extensions
- **0.1.0** `2013.12.09`
    - Initial release

## Contribute

Did you miss something? Open an issue or make a PR!

## Contributors

* [Tomas Aparicio](http://github.com/h2non)
* [Felix Zapata](https://github.com/felixzapata)

## License

Copyright (c) Adesis Netlife S.L

Released under MIT license

[1]: https://github.com/gruntjs/grunt-contrib-pug
[2]: https://github.com/gruntjs/grunt-contrib-pug#options
[3]: http://jade-lang.com/
[4]: https://github.com/AdesisNetlife/grunt-pug-i18n/tree/master/test
[5]: https://github.com/AdesisNetlife/grunt-pug-i18n/blob/master/Gruntfile.coffee
[travis]: https://travis-ci.org/AdesisNetlife/grunt-pug-i18n
[npm]: https://www.npmjs.org/package/grunt-pug-i18n
[dependencies]: https://gemnasium.com/AdesisNetlife/grunt-pug-i18n
