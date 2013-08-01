'use strict';

var modules = [
  'main',
  'settings-panel',
  'shortcuts',
  'infinite-scrolling',
  'author-enhancements',
  'extended-reply-form',
  'live-preview',
  'image-embeed',
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
      dist: {
        files: {
          '.tmp/joined.user.js': coffees,
        }
      }
    },
    concat: {
      userscript: {
        src: ['header.user.js', '.tmp/joined.user.js'],
        dest: 'debug/mv-power-tools.user.js'
      },
      css: {
        src: styles,
        dest: 'debug/mv-power-tools.css'
      }
    },
    watch: {
      coffee: {
        files: coffees,
        tasks: ['coffee', 'concat:userscript']
      },
      css: {
        files: styles,
        tasks: ['concat:css']
      }
    }
  });

  grunt.registerTask('default',[
    'clean',
    'coffee',
    'concat:userscript',
    'concat:css'
  ]);

  grunt.registerTask('build', [
    'clean',
    'coffee',
    'concat'
  ]);

};
