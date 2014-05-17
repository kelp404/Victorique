describe 'v.provider', ->
    fakeModule = null
    vProvider = null

    beforeEach module('v')
    beforeEach ->
        # mock NProgress
        window.NProgress =
            configure: ->
        fakeModule = angular.module 'fakeModule', ['v']
        fakeModule.config ($vProvider) ->
            vProvider = $vProvider
    beforeEach module('fakeModule')


    describe '$v.alert', ->
        it '$v.alert.saved() should call $.av.pop()', inject ($v) ->
            spyOn $.av, 'pop'
            $v.alert.saved()
            expect($.av.pop).toHaveBeenCalledWith
                title: 'Success'
                message: 'Saved successful.'
                expire: 3000
        it '$v.alert.saved(message) should call $av.pop()', inject ($v) ->
            spyOn $.av, 'pop'
            $v.alert.saved 'message'
            expect($.av.pop).toHaveBeenCalledWith
                title: 'Success'
                message: 'message'
                expire: 3000

    describe '$v.api.settings', ->
        it '$v.api.settings.getSettings() should call vProvider.http()', inject ($v) ->
            spyOn vProvider, 'http'
            $v.api.settings.getSettings()
            expect(vProvider.http).toHaveBeenCalledWith
                method: 'get'
                url: '/settings'


    describe '$v', ->
        it '$v.user and $vProvider.user are the same object', inject ($v) ->
            expect($v.user).toBe vProvider.user
        it '$v.url and $vProvider.url are the same object', inject ($v) ->
            expect($v.url).toBe vProvider.url
        it '$v.alert and $vProvider.alert are the same object', inject ($v) ->
            expect($v.alert).toBe vProvider.alert
        it '$v.api and $vProvider.api are the same object', inject ($v) ->
            expect($v.api).toBe vProvider.api
