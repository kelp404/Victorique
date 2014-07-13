describe 'v.provider', ->
    fakeModule = null
    vProvider = null

    mackUiRouter = ($httpBackend) ->
        $httpBackend.whenGET('/views/shared/layout.html').respond ''
        $httpBackend.whenGET('/views/login.html').respond ''
        $httpBackend.whenGET('/views/index.html').respond ''

    beforeEach module('v')
    beforeEach ->
        # mock NProgress
        window.NProgress =
            start: ->
            done: ->
            configure: ->
        fakeModule = angular.module 'fakeModule', ['v']
        fakeModule.config ($vProvider) ->
            vProvider = $vProvider
    beforeEach module('fakeModule')

    describe '$v.user login', ->
        beforeEach ->
            window.user =
                id: 100
                permission: 1
        it '$v.user.isLogin will be yes when $v.user.id is not null', inject ($v) ->
            expect($v.user.isLogin).toBeTruthy()
        it '$rootScope.$user is $v.user', inject ($v, $rootScope) ->
            expect($rootScope.$user).toBe $v.user
        describe '$v.user.isRoot is yes when the permission is 1', ->
            beforeEach ->
                window.user.permission = 1
            it '$v.user.isRoot is yes when permission is 1', inject ($v) ->
                expect($v.user.isRoot).toBeTruthy()
        describe '$v.user.isRoot is no when the permission is 0', ->
            beforeEach ->
                window.user.permission = 0
            it '$v.user.isRoot is yes when permission is 1', inject ($v) ->
                expect($v.user.isRoot).toBeFalsy()
    describe '$v.user not login', ->
        beforeEach ->
            window.user = {}
        it '$v.user.isLogin will be no when $v.user.id is null', inject ($v) ->
            expect($v.user.isLogin).toBeFalsy()

    describe '$v.url', ->
        beforeEach ->
            window.url =
                login: 'login url'
        it '$v.url is window.url', inject ($v) ->
            expect($v.url).toBe window.url

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
        it '$v.alert.confirm() will set $rootScope.$confirmModal', inject ($v, $rootScope) ->
            $v.alert.confirm 'message', 'callback'
            expect($rootScope.$confirmModal.message).toEqual 'message'
            expect($rootScope.$confirmModal.callback).toEqual 'callback'
            expect($rootScope.$confirmModal.isShow).toBeTruthy()

    describe 'vProvider.http', ->
        beforeEach inject ($httpBackend) ->
            mackUiRouter $httpBackend
            $httpBackend.whenGET('/').respond 'result'
        it 'vProvider.http is $http', inject ($httpBackend) ->
            successSpy = jasmine.createSpy 'success'
            vProvider.http
                method: 'get'
                url: '/'
            .success (result) ->
                successSpy()
                expect(result).toEqual 'result'
            $httpBackend.flush()
            expect(successSpy).toHaveBeenCalled()

    describe '$rootScope.$loadings', ->
        beforeEach inject ($httpBackend) ->
            mackUiRouter $httpBackend
            $httpBackend.whenGET('/').respond 'result'
        it '$rootScope.$loadings.hasAny() will return yes when vProvider.http is progress', inject ($httpBackend, $rootScope) ->
            expect($rootScope.$loadings.hasAny()).toBeFalsy()
            successSpy = jasmine.createSpy 'success'
            vProvider.http
                method: 'get'
                url: '/'
            .success (result) ->
                successSpy()
                expect(result).toEqual 'result'
            expect($rootScope.$loadings.hasAny()).toBeTruthy()
            $httpBackend.flush()
            expect($rootScope.$loadings.hasAny()).toBeFalsy()
            expect(successSpy).toHaveBeenCalled()

    describe '$v.api.settings', ->
        it '$v.api.settings.getProfile() should call vProvider.http()', inject ($v) ->
            spyOn vProvider, 'http'
            $v.api.settings.getProfile()
            expect(vProvider.http).toHaveBeenCalledWith
                method: 'get'
                url: '/settings/profile'
        it '$v.api.settings.updateProfile() should call vProvider.http()', inject ($v) ->
            spyOn vProvider, 'http'
            profile =
                name: 'Kelp'
            $v.api.settings.updateProfile profile
            expect(vProvider.http).toHaveBeenCalledWith
                method: 'put'
                url: '/settings/profile'
                data: profile


    describe '$v', ->
        it '$v.user and $vProvider.user are the same object', inject ($v) ->
            expect($v.user).toBe vProvider.user
        it '$v.url and $vProvider.url are the same object', inject ($v) ->
            expect($v.url).toBe vProvider.url
        it '$v.alert and $vProvider.alert are the same object', inject ($v) ->
            expect($v.alert).toBe vProvider.alert
        it '$v.api and $vProvider.api are the same object', inject ($v) ->
            expect($v.api).toBe vProvider.api
