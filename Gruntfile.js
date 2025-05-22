module.exports = function(grunt) {
  // Carrega automaticamente todas as tarefas do Grunt declaradas nas devDependencies
  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    // LESS → CSS
    less: {
      development: {
        files: {
          'build/css/style.css': 'src/less/style.less' // Certifique-se de que este caminho exista
        }
      }
    },

    // Prefixos automáticos para CSS
    autoprefixer: {
      single_file: {
        src: 'build/css/style.css',
        dest: 'build/css/style.prefixed.css'
      }
    },

    // Concatenação de arquivos
    concat: {
      css: {
        src: ['build/css/*.css'],
        dest: 'build/css/style.concat.css'
      },
      js: {
        src: ['src/js/**/*.js'], // ajuste conforme sua estrutura
        dest: 'build/js/app.concat.js'
      }
    },

    // Minificação de CSS
    cssmin: {
      target: {
        files: {
          'build/css/style.min.css': ['build/css/style.concat.css']
        }
      }
    },

    // Minificação de JavaScript
    uglify: {
      target: {
        files: {
          'build/js/app.min.js': ['build/js/app.concat.js']
        }
      }
    },

    // Markdown para HTML (se aplicável)
    markdown: {
      all: {
        files: [
          {
            expand: true,
            src: 'docs/**/*.md',
            dest: 'build/html/',
            ext: '.html'
          }
        ]
      }
    },

    // Lint de JavaScript com ESLint
    eslint: {
      target: ['src/js/**/*.js']
    },

    // Observador de mudanças
    watch: {
      styles: {
        files: ['src/less/**/*.less'],
        tasks: ['less', 'autoprefixer', 'concat:css', 'cssmin']
      },
      scripts: {
        files: ['src/js/**/*.js'],
        tasks: ['eslint', 'concat:js', 'uglify']
      }
    },

    // Limpa a pasta de build
    clean: {
      build: ['build']
    }
  });

  // Tarefa padrão
  grunt.registerTask('default', ['less', 'autoprefixer', 'concat', 'cssmin', 'uglify', 'markdown']);

  // Tarefa de build
  grunt.registerTask('build', ['clean', 'default']);
};
