module.exports = (grunt) ->
    # -----------------------------------
    # options
    # -----------------------------------
    grunt.config.init
        compass:
            build:
                options:
                    sassDir: 'application/static/sass'
                    cssDir: 'application/static/css'

        coffee:
            build:
                files:
                    'application/static/javascript/app.js': ['application/static/coffeescript/**/*.coffee']

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
                    'application/static/css/site.min.css': [
                        'application/static/css/bootstrap.css'
                        'application/static/css/nprogress.css'
                        'application/static/css/site.css'
                    ]

        uglify:
            build:
                files:
                    'application/static/javascript/site.min.js': [
                        # jquery
                        'application/static/javascript/jquery.js'
                        'application/static/javascript/alert_view.js'
                        'application/static/javascript/nprogress.js'
                        # angular
                        'application/static/javascript/angular.js'
                        'application/static/javascript/angular-ui-router.js'
                        'application/static/javascript/angular-validator.js'
                        'application/static/javascript/app.js'
                    ]

        watch:
            compass:
                files: ['application/static/sass/**/*.sass']
                tasks: ['compass']
                options:
                    spawn: no
            coffee:
                files: ['application/static/coffeescript/**/*.coffee']
                tasks: ['coffee']
                options:
                    spawn: no

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

    # -----------------------------------
    # tasks
    # -----------------------------------
    grunt.loadNpmTasks 'grunt-contrib-compass'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-concurrent'
