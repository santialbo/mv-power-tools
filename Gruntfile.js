'use strict';

var modules = [
  'main',
  'settings-panel',
  'shortcuts',
  'infinite-scrolling',
  'author-enhancements',
  'tags',
  'extended-reply-form',
  'live-preview',
  'image-embeed',
  'wide-mode',
  'better-live',
]

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
    watch: {
      coffee: {
        files: coffees,
        tasks: ['coffee:debug', 'concat:userscript', 'copy:debug']
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
    'copy:debug'
  ]);

  grunt.registerTask('build', [
    'clean',
    'coffee:dist',
    'concat',
    'copy:dist'
  ]);

};
