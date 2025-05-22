module.exports = function(grunt) {

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        less: {
            development: {
                options: { compress: false },
                files: {
                    'path/to/output.css': 'path/to/input.less'
                }
            }
        },

        autoprefixer: {
            options: {
                browsers: ['last 2 versions', 'ie 9']
            },
            single_file: {
                src: 'path/to/output.css',
                dest: 'path/to/output.prefixed.css'
            }
        },

        concat: {
            // sua config aqui
        },

        cssmin: {
            // sua config aqui
        },

        uglify: {
            // sua config aqui
        },

        markdown: {
            // sua config aqui
        },

        watch: {
            // sua config aqui
        }
    });

    // Load plugins
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-autoprefixer');  // cuidado para carregar só o que usa
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-markdown');

    // Register tasks
    grunt.registerTask('default', ['less','autoprefixer','concat','cssmin','uglify','markdown']);
    grunt.registerTask('styles', ['less','autoprefixer','concat','cssmin']);
};
