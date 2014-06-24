describe 'v.directive', ->
    beforeEach module('v')
    beforeEach ->
        # mock NProgress
        window.NProgress =
            start: ->
            done: ->
            configure: ->

    describe 'v-focus', ->
        $scope = null
        $compile = null
        template = """<input id="fake" v-focus></input>"""

        beforeEach inject ($injector) ->
            $rootScope = $injector.get '$rootScope'
            $scope = $rootScope.$new()
            $compile = $injector.get '$compile'
        it 'v-focus will call $().select()', inject ($v, $compile) ->
            spyOn($.fn, 'select').and.callFake ->
                expect($(@).attr('id')).toEqual 'fake'
            $compile(template) $scope
            expect($.fn.select).toHaveBeenCalled()
