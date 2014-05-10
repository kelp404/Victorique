angular.module 'v.directive', []

# ---------------------------------------------------------
# v-navigation
# ---------------------------------------------------------
.directive 'vNavigation', ->
    restrict: 'A'
    templateUrl: '/views/shared/navigation.html'
    replace: yes
    controller: 'NavigationController'

# ---------------------------------------------------------
# v-focus
# ---------------------------------------------------------
.directive 'vFocus', ->
    restrict: 'A'
    link: (scope, element) ->
        $(element).select()

# ---------------------------------------------------------
# v-scroll-to
# ---------------------------------------------------------
.directive 'vScrollTo', ->
    restrict: 'A'
    link: (scope, element) ->
        for link in $(element).find('a')
            $(link).click (event) ->
                event.preventDefault()
                $target = $($(@).attr('href'))
                return if not $target.length # target not found

                # update class 'active'
                $(element).find('li.active').removeClass 'active'
                $(@).parent('li').addClass 'active'

                # The navigation's height is 60px
                $('html,body').animate scrollTop: $target.offset().top - 60, 500, 'easeOutExpo', ->
                    $target.find('input:not([type=hidden]):first').select()
        return
