module.exports = function(grunt) {
  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    less: {
      development: {
        files: {
          'build/css/style.css': 'src/less/style.less'
        }
      }
    },

    postcss: {
      options: {
        processors: [
          require('autoprefixer')()
        ]
      },
      dist: {
        src: 'build/css/style.css',
        dest: 'build/css/style.prefixed.css'
      }
    },

    concat: {
      css: {
        src: ['build/css/*.css'],
        dest: 'build/css/style.concat.css'
      },
      js: {
        src: ['src/js/**/*.js'],
        dest: 'build/js/app.concat.js'
      }
    },

    cssmin: {
      target: {
        files: {
          'build/css/style.min.css': ['build/css/style.concat.css']
        }
      }
    },

    uglify: {
      target: {
        files: {
          'build/js/app.min.js': ['build/js/app.concat.js']
        }
      }
    },

    markdown: {
      all: {
        files: [{
          expand: true,
          src: 'docs/**/*.md',
          dest: 'build/html/',
          ext: '.html'
        }]
      }
    },

    eslint: {
      target: ['src/js/**/*.js']
    },

    watch: {
      styles: {
        files: ['src/less/**/*.less'],
        tasks: ['less', 'postcss', 'concat:css', 'cssmin']
      },
      scripts: {
        files: ['src/js/**/*.js'],
        tasks: ['eslint', 'concat:js', 'uglify']
      }
    },

    clean: {
      build: ['build']
    }
  });

  grunt.registerTask('default', ['less', 'postcss', 'concat', 'cssmin', 'uglify', 'markdown']);
  grunt.registerTask('build', ['clean', 'default']);
};
