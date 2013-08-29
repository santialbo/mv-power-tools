'use strict';

var pkg = require('./package.json');
var HOME = process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE;

var modules = [
  'main',
  'settings-panel',
  'shortcuts',
  'infinite-scrolling',
  'author-enhancements',
  'tags',
  'extended-reply-form',
  'live-preview',
  'media-embed',
  'wide-mode',
  'better-live',
];

var coffees = modules.map(function(m) {return 'modules/' + m + '.coffee';});
var styles = modules.map(function(m) {return 'modules/' + m + '.css';});

module.exports = function(grunt) {
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);
  
  var path = require('path'),
      fs = require('fs');

  var aws, awsPath = path.join(HOME, '.aws', 'mv-power-tools');
  if (fs.existsSync(awsPath))
    aws = grunt.file.readJSON(awsPath);
  else
    aws = { access_key: '', secret_key: '' };

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    clean: {
      dist: ['.tmp', 'dist']
    },
    coffee: {
      options: {
        join: true
      },
      dist: {
        files: {
          '.tmp/joined.user.js': ['.tmp/style.coffee'].concat(coffees),
        }
      }
    },
    concat: {
      userscript: {
        src: ['.tmp/header.user.js', '.tmp/joined.user.js'],
        dest: 'dist/mv-power-tools.user.js'
      },
      style: {
        src: styles,
        dest: '.tmp/mv-power-tools.css'
      }
    },
    aws: aws,
    aws_s3: {
      options: {
        accessKeyId: '<%= aws.access_key %>',
        secretAccessKey: '<%= aws.secret_key %>',
        bucket: 'mv-power-tools'
      },
      deploy: {
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
    includereplace: {
      style: {
        cwd: '.',
        src: 'modules/style.coffee',
        dest: '.tmp/style.coffee'
      },
      version: {
        options: {
          globals: {
            version: '<%= pkg.version %>'
          }
        },
        cwd: '.',
        src: 'header.user.js',
        dest: '.tmp/header.user.js'
      }
    },
    watch: {
      files: ['modules/*', 'header.user.js'],
      tasks: ['default']
    }
  });

  grunt.registerTask('default',[
    'clean',
    'concat:style',
    'includereplace:style',
    'coffee:dist',
    'includereplace:version',
    'concat:userscript',
  ]);

  grunt.registerTask('deploy', [
    'default',
    'aws_s3'
  ]);

};
