module.exports = function(grunt) {

    // Project configuration
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        // LESS compilation
        less: {
            development: {
                options: {
                    compress: false
                },
                files: {
                    'build/css/style.css': 'src/less/style.less'
                }
            }
        },

        // Autoprefix CSS
        autoprefixer: {
            options: {
                browsers: ['last 2 versions', 'ie 9']
            },
            single_file: {
                src: 'build/css/style.css',
                dest: 'build/css/style.prefixed.css'
            }
        },

        // Concatenate CSS and JS
        concat: {
            css: {
                src: ['build/css/style.prefixed.css'],
                dest: 'build/css/all.css'
            },
            js: {
                src: ['src/js/script1.js', 'src/js/script2.js'],
                dest: 'build/js/all.js'
            }
        },

        // Minify CSS
        cssmin: {
            target: {
                files: {
                    'build/css/all.min.css': ['build/css/all.css']
                }
            }
        },

        // Minify JS
        uglify: {
            target: {
                files: {
                    'build/js/all.min.js': ['build/js/all.js']
                }
            }
        },

        // Markdown to HTML
        markdown: {
            all: {
                files: [{
                    expand: true,
                    cwd: 'markdown/',
                    src: '*.md',
                    dest: 'build/html/',
                    ext: '.html'
                }]
            }
        },

        // Watch for changes
        watch: {
            styles: {
                files: ['src/less/**/*.less'],
                tasks: ['styles'],
                options: { spawn: false }
            },
            scripts: {
                files: ['src/js/**/*.js'],
                tasks: ['scripts'],
                options: { spawn: false }
            },
            markdown: {
                files: ['markdown/*.md'],
                tasks: ['markdown'],
                options: { spawn: false }
            }
        }
    });

    // Load plugins
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-autoprefixer');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-markdown');
    grunt.loadNpmTasks('grunt-contrib-watch');

    // Register tasks
    grunt.registerTask('default', ['less', 'autoprefixer', 'concat', 'cssmin', 'uglify', 'markdown']);
    grunt.registerTask('styles', ['less', 'autoprefixer', 'concat:css', 'cssmin']);
    grunt.registerTask('scripts', ['concat:js', 'uglify']);
};
