'use strict';

var pkg = require('./package.json');

var modules = [
  'main',
  'settings-panel',
  'shortcuts',
  'infinite-scrolling',
  'author-enhancements',
  'tags',
  'extended-reply-form',
  'live-preview',
  'media-embeed',
  'wide-mode',
  'better-live',
]

var HOME = process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE;

var coffees = modules.map(function(m) {return 'modules/' + m + '.coffee';});
var styles = modules.map(function(m) {return 'modules/' + m + '.css';});

module.exports = function(grunt) {
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    clean: {
      dist: ['.tmp'],
    },
    coffee: {
      options: {
        join: true
      },
      debug: {
        files: {
          '.tmp/joined.user.js': ['modules/style.debug.coffee'].concat(coffees),
        }
      },
      dist: {
        files: {
          '.tmp/joined.user.js': ['modules/style.dist.coffee'].concat(coffees),
        }
      }
    },
    concat: {
      userscript: {
        src: ['header.user.js', '.tmp/joined.user.js'],
        dest: '.tmp/mv-power-tools.user.js'
      },
      css: {
        src: styles,
        dest: '.tmp/mv-power-tools.css'
      }
    },
    copy: {
      debug: {
        files: [{
          expand: true,
          cwd: '.tmp',
          src: 'mv-power-tools.{user.js,css}',
          dest: 'debug/'
        }]
      },
      dist: {
        files: [{
          expand: true,
          cwd: '.tmp',
          src: 'mv-power-tools.{user.js,css}',
          dest: 'dist/'
        }]
      }
    },
    aws: grunt.file.readJSON(HOME + '/.aws/mv-power-tools'),
    aws_s3: {
      options: {
        accessKeyId: '<%= aws.access_key %>',
        secretAccessKey: '<%= aws.secret_key %>',
        bucket: 'mv-power-tools'
      },
      prod: {
        files: [{
          expand: true,
          cwd: 'dist/',
          src: ['**'],
          dest: '<%= pkg.version %>'
        }, {
          expand: true,
          cwd: 'dist/',
          src: ['**'],
          dest: 'latest'
        }]
      }
    },
    replace: {
      version: {
        options: {
          variables: {
            'version': '<%= pkg.version %>'
          },
          prefix: '@@'
        },
        files: [{
          src: ['.tmp/mv-power-tools.user.js'],
          dest: '.tmp/mv-power-tools.user.js'
        }]
      }
    },
    watch: {
      coffee: {
        files: coffees,
        tasks: ['coffee:debug', 'concat:userscript', 'replace:version', 'copy:debug']
      },
      css: {
        files: styles,
        tasks: ['concat:css', 'copy:debug']
      }
    }
  });

  grunt.registerTask('default',[
    'clean',
    'coffee:debug',
    'concat',
    'replace:version',
    'copy:debug'
  ]);

  grunt.registerTask('deploy', [
    'clean',
    'coffee:dist',
    'concat',
    'replace:version',
    'copy:dist',
    'aws_s3'
  ]);

};
