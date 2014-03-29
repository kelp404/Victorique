module.exports = (grunt) ->
    # -----------------------------------
    # options
    # -----------------------------------
    grunt.config.init
        compass:
            options:
                sassDir: 'application/static/sass'
                cssDir: 'application/static/css'

        coffee:
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

        clean:
            build: [
                'application/static/javascript/app.min.js'
            ]

        uglify:
            build:
                files:
                    'application/static/javascript/app.min.js': ['application/static/javascript/*.js']

        watch:
            compass:
                files: ['application/static/scss/**/*.scss']
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
        'clean:build'
        'concurrent:build'
        'uglify'
    ]

    # -----------------------------------
    # tasks
    # -----------------------------------
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-compass'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-concurrent'
