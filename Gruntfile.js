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
].map(function(m) {return 'modules/' + m + '.coffee';});

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
          '.tmp/joined.user.js': modules,
        }
      }
    },
    concat: {
      userscript: {
        src: ['header.user.js', '.tmp/joined.user.js'],
        dest: 'debug/mv-power-tools.user.js'
      },
      css: {
        src: ['modules/*.css'],
        dest: 'debug/mv-power-tools.css'
      }
    },
    watch: {
      coffee: {
        files: ['modules/*.coffee'],
        tasks: ['coffee', 'concat:userscript']
      },
      css: {
        files: ['modules/*.css'],
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
