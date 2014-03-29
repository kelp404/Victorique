module.exports = (grunt) ->
    # -----------------------------------
    # options
    # -----------------------------------
    grunt.config.init
        compass:
            build:
                options:
                    sassDir: 'application/frontend/sass'
                    cssDir: 'application/frontend/css'

        coffee:
            build:
                files:
                    'application/frontend/javascript/app.js': ['application/frontend/coffeescript/**/*.coffee']

        concurrent:
            build:
                ###
                Compile sass, coffee script and render template and copy fonts.
                ###
                tasks: [
                    'compass'
                    'coffee'
                ]
                options:
                    logConcurrentOutput: yes
            minify:
                tasks: [
                    'cssmin:build'
                    'uglify:build'
                ]
                options:
                    logConcurrentOutput: yes

        cssmin:
            build:
                options:
                    keepSpecialComments: 0
                files:
                    'application/frontend/css/site.min.css': [
                        'application/frontend/css/bootstrap.css'
                        'application/frontend/css/nprogress.css'
                        'application/frontend/css/site.css'
                    ]

        uglify:
            build:
                files:
                    'application/frontend/javascript/site.min.js': [
                        # jquery
                        'application/frontend/javascript/jquery.js'
                        'application/frontend/javascript/alert_view.js'
                        'application/frontend/javascript/nprogress.js'
                        # angular
                        'application/frontend/javascript/angular.js'
                        'application/frontend/javascript/angular-ui-router.js'
                        'application/frontend/javascript/angular-validator.js'
                        'application/frontend/javascript/app.js'
                    ]

        watch:
            compass:
                files: ['application/frontend/sass/**/*.sass']
                tasks: ['compass']
                options:
                    spawn: no
            coffee:
                files: ['application/frontend/coffeescript/**/*.coffee']
                tasks: ['coffee']
                options:
                    spawn: no

        karma:
            testFrontend:
                configFile: 'application/frontend/tests/karma.config.coffee'

    # -----------------------------------
    # register task
    # -----------------------------------
    grunt.registerTask 'dev', [
        'concurrent:build'
        'watch'
    ]
    grunt.registerTask 'build', [
        'concurrent:build'
        'concurrent:minify'
    ]
    grunt.registerTask 'test', [
        'karma:testFrontend'
    ]

    # -----------------------------------
    # tasks
    # -----------------------------------
    grunt.loadNpmTasks 'grunt-contrib-compass'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-concurrent'
    grunt.loadNpmTasks 'grunt-karma'
