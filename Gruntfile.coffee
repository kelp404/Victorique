module.exports = (grunt) ->
    # -----------------------------------
    # options
    # -----------------------------------
    grunt.config.init
        compass:
            app:
                options:
                    sassDir: './application/static/sass'
                    cssDir: './application/static/css'

        coffee:
            app:
                files:
                    './application/static/javascript/app.js': ['./application/static/coffeescript/**/*.coffee']

        watch:
            compass:
                files: ['./application/static/scss/**/*.scss']
                tasks: ['compass']
                options:
                    spawn: no
            coffee:
                files: ['./application/static/coffeescript/**/*.coffee']
                tasks: ['coffee']
                options:
                    spawn: no

    # -----------------------------------
    # register task
    # -----------------------------------
    grunt.registerTask 'dev', ['watch']

    # -----------------------------------
    # tasks
    # -----------------------------------
    grunt.loadNpmTasks 'grunt-contrib-compass'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'