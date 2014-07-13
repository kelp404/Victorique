describe 'v.directive', ->
    beforeEach module('v')
    beforeEach ->
        # mock NProgress
        window.NProgress =
            start: ->
            done: ->
            configure: ->

    mackUiRouter = ($httpBackend) ->
        $httpBackend.whenGET('/views/shared/layout.html').respond ''
        $httpBackend.whenGET('/views/login.html').respond ''
        $httpBackend.whenGET('/views/index.html').respond ''

    describe 'v-focus', ->
        $scope = null
        $compile = null
        template = """<input id="fake" v-focus></input>"""

        beforeEach inject ($injector) ->
            $rootScope = $injector.get '$rootScope'
            $scope = $rootScope.$new()
            $compile = $injector.get '$compile'
        it 'v-focus will call $().select()', inject ($compile) ->
            spyOn($.fn, 'select').and.callFake ->
                expect($(@).attr('id')).toEqual 'fake'
            $compile(template) $scope
            expect($.fn.select).toHaveBeenCalled()

    describe 'v-enter', ->
        $scope = null
        $compile = null
        template = """<input id="fake" v-enter="enter($event)"></input>"""

        beforeEach inject ($httpBackend) ->
            mackUiRouter $httpBackend
        beforeEach inject ($injector) ->
            $rootScope = $injector.get '$rootScope'
            $scope = $rootScope.$new()
            $compile = $injector.get '$compile'
        it 'v-focus will call $().select()', inject ($compile) ->
            enterSpy = jasmine.createSpy 'enterSpy'
            $scope.enter = ($event) ->
                enterSpy($event)
            view = $compile(template) $scope
            e = $.Event 'keypress'
            e.which = 13
            spyOn e, 'preventDefault'
            $(view).trigger e
            expect(enterSpy).toHaveBeenCalledWith e
            expect(e.preventDefault).toHaveBeenCalled()
