# grunt-jade-i18n [![Build Status](https://travis-ci.org/adesisnetlife/grunt-jade-i18n.png)](https://travis-ci.org/adesisnetlife/grunt-jade-i18n)

> Compile Jade templates (with internationalization and translation support)

## Getting started

This plugin is the same as [grunt-contrib-jade][1], but it adds high level support 
for [Jade][3] template internationalization based on JSON/YAML/JS files

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](hettp://gruntjs.com/sample-gruntfil) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-jade-i18n --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile:

```js
grunt.loadNpmTasks('grunt-jade-i18n');
```

This plugin requires Grunt `~0.4.0`

## The "jade" task

_Run this task with the `grunt jade` command._

Task targets, files and options may be specified according to the grunt [Configuring tasks](http://gruntjs.com/configuring-tasks) guide

This plugin provides a localization mechanism for Jade templates.
Since localization is done once during the build process, there is no performance hit on the application, opposed to dynamic translation on the client side


### Usage example

##### Gruntfile configuration
```js
grunt.initConfig({
  jade: {
    templates: {
      options: {
        // jade i18n specific options
        i18n: {
          locales: 'locales/*.json',
          namespace: '$18n'
        },
        // Jade specific options
        pretty: true
      },
      files: {
        "path/to/dest.html": ["path/to/templates/*.jade", "another/path/tmpl.jade"]
      }
    }
  }
})
```

##### Example JSON locate file
```json
{
  "hello": { "world": "Hola Mundo" }
}
```

##### Example Jade file
```jade
body 
  h1 #{$i18n.hello.world}!
```

### Options

Only `jade-i18n` specific options are listed below. To see all the available options available, please see [grunt-contrib-jade][2]

#### locales
Type: String|Array

Path to localization files. Please check the examples in tests. Glob patterns can be used

`JSON`, `YAML` and `JS` formats are supported for the translation templates

#### namespace
Type: String
Default: '$i18n'

Namespace to expose translation keys in Jade template

#### locateExtension
Type: Boolean
Default: false

Generate the HTML output files with the extension prefix with the current language.

By default it will create different folders for each language.
Setting this option into `true`, the generated HTML files will look like this:

```
html/
├── view.en-en.html
├── view.es-es.html
└── view.it-it.html
```

## Contributing

Instead of a formal styleguide, take care to maintain the existing coding style.

Add unit tests for any new or changed functionality

### Development

Clone the repository
```shell
$ git clone https://github.com/adesisnetlife/grunt-jade-i18n.git && cd grunt-jade-i18n
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

* 0.1.0 `2013-12-09`
  - Initial release

## To Do

Do you miss something? Open an issue or make a PR!

## Contributors

* [Tomas Aparicio](http://github.com/h2non)

## License

Copyright (c) 2013 Adesis Netlife S.L

Released under MIT license

[1]: https://github.com/gruntjs/grunt-contrib-jade
[2]: https://github.com/gruntjs/grunt-contrib-jade#options
[3]: http://jade-lang.com/
