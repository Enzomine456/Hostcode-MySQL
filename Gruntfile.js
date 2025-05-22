module.exports = function(grunt) {

    // Project configuration:
    grunt.initConfig({

        // Read project settings into the pkg property:
        // (Will allow to refer to the values of the properties below)
        pkg: grunt.file.readJSON('package.json'),

        // Configuration for the less->css compiling tasks:
        less: {
            development: {
                // Note! The output css files are not compressed on this task
                options: {
                    compress: false,
                    //yuicompress: true,
                    //optimization: 2
                },
                files: {
                    // ... (todo o conteúdo original da task less permanece aqui) ...
                }
            },
        },

        // Configuration for Autoprefixing tasks:
        autoprefixer: {
            // ... (conteúdo original da task autoprefixer) ...
        },

        // Configuration for the concatenate tasks:
        concat: {
            // ... (conteúdo original da task concat) ...
        },

        // CSS minification:
        cssmin: {
            // ... (conteúdo original da task cssmin) ...
        },

        // Configuration for the uglify minifying tasks:
        uglify: {
            // ... (conteúdo original da task uglify) ...
        },

        // Markdown to HTML
        markdown: {
            // ... (conteúdo original da task markdown) ...
        },

        // Configuration for the watch tasks:
        watch: {
            // ... (conteúdo original da task watch) ...
        },

    });

    // Load the plugin that provides the tasks:
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-autoprefixer');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-markdown');

    // Task registration:
    grunt.registerTask('default', ['less','autoprefixer','concat','cssmin','uglify','markdown']);
    grunt.registerTask('styles', ['less','autoprefixer','concat','cssmin']);

}; // Final correto do module.exports
