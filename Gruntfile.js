module.exports = function(grunt) {
    'use strict';
    var path = require('path');
    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        coffee: {
            compileWithMapsDir: {
                options: {
                    join: true,
                    sourceMap: true
                },
                files: {
                    'scripts/main.js': [
                        'scripts/app.coffee',
                        'scripts/map.coffee'
                    ]
                }
            }
        },
        less: {
            main: {
                files: {
                    "styles/main.css": [
                        "styles/*.less"
                    ]
                }
            }
        },
        watch: {
            coffee: {
                files: [
                    'scripts/**.coffee'
                ],
                options: {
                    livereload: true
                },
                tasks: ['coffee']
            },
            less: {
                files: [
                    'styles/**.less'
                ],
                options: {
                    livereload: true
                },
                tasks: ['less']
            }
        }
    });

    grunt.loadNpmTasks('grunt-exec');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-less');

    grunt.loadNpmTasks('grunt-contrib-watch');

    grunt.registerTask('default', ['coffee', 'less', 'watch']);

}