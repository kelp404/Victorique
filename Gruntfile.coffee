module.exports = (grunt) ->
    # -----------------------------------
    # options
    # -----------------------------------
    grunt.config.init
        compass:
            build:
                options:
                    sassDir: 'application/frontend/sass/site'
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
                    'copy:fonts'
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

        copy:
            fonts:
                files: [
                    expand: yes
                    cwd: 'bower_components/font-awesome/fonts'
                    src: ['*']
                    dest: 'application/frontend/fonts/'
                    filter: 'isFile'
                ]

        cssmin:
            build:
                options:
                    keepSpecialComments: 0
                files:
                    'application/frontend/css/site.min.css': [
                        'bower_components/bootstrap/dist/css/bootstrap.css'
                        'bower_components/font-awesome/css/font-awesome.css'
                        'bower_components/AlertView/dist/alert_view.css'
                        'application/frontend/css/nprogress.css'
                        'application/frontend/css/site.css'
                    ]

        uglify:
            build:
                files:
                    'application/frontend/javascript/site.min.js': [
                        # jquery
                        'bower_components/jquery/dist/jquery.js'
                        'bower_components/bootstrap/dist/js/bootstrap.js'
                        'bower_components/AlertView/dist/alert_view.js'
                        'bower_components/nprogress/nprogress.js'
                        # angular
                        'bower_components/angular/angular.js'
                        'bower_components/angular-ui-router/release/angular-ui-router.js'
                        'bower_components/angular-validator/dist/angular-validator.js'
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
    grunt.loadNpmTasks 'grunt-contrib-copy'
