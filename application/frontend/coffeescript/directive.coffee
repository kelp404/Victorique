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
# v-settings-menu
# ---------------------------------------------------------
.directive 'vSettingsMenu', ->
    restrict: 'A'
    templateUrl: '/views/settings/menu.html'
    replace: yes
    link: (scope, element, attrs) ->
        scope.options = scope.$eval attrs.vSettingsMenu

# ---------------------------------------------------------
# v-focus
# ---------------------------------------------------------
.directive 'vFocus', ->
    restrict: 'A'
    link: (scope, element) ->
        $(element).select()

# ---------------------------------------------------------
# v-modal
# ---------------------------------------------------------
.directive 'vModal', ->
    ###
    v-modal="scope.modal"
    scope.modal:
        autoShow: {bool} If this modal should pop as automatic, it should be yes.
        hide: -> {function} After link, it is a function for hidden the modal.
        hiddenCallback: ($event) -> {function} After the modal hidden, it will be eval.
    ###
    restrict: 'A'
    scope:
        modal: '=vModal'
    link: (scope, element) ->
        # setup hide function for scope.modal
        scope.modal.hide = ->
            $(element).modal 'hide'
        if scope.modal.hiddenCallback
            # listen hidden event for scope.modal.hiddenCallback
            $(element).on 'hidden.bs.modal', (e) ->
                scope.$apply ->
                    scope.$eval scope.modal.hiddenCallback,
                        $event: e
        $(element).on 'shown.bs.modal', ->
            # focus the firest element
            $firstController = $(element).find('form .form-control:first')
            if $firstController.length
                $firstController.select()
            else
                $(element).find('form [type=submit]').focus()
        if scope.modal.autoShow
            # pop the modal
            $(element).modal 'show'

# ---------------------------------------------------------
# v-confirm
# ---------------------------------------------------------
.directive 'vConfirm', ['$injector', ($injector) ->
    ###
    v-confirm="$rootScope.$confirmModal"
    ###
    $timeout = $injector.get '$timeout'

    restrict: 'A'
    scope:
        modal: '=vConfirm'
    replace: yes
    templateUrl: '/views/modal/confirm.html'
    link: (scope, element) ->
        confirmed = no
        scope.$watch 'modal.isShow', (newValue, oldValue) ->
            return if newValue is oldValue
            if newValue
                $(element).modal 'show'
                confirmed = no
        scope.confirmed = ->
            confirmed = yes
            $timeout -> $(element).modal 'hide'
        $(element).on 'shown.bs.modal', ->
            $(element).find('[type=submit]').focus()
        $(element).on 'hidden.bs.modal', ->
            scope.$apply ->
                scope.modal.isShow = no
                scope.modal.callback(confirmed)
]

# ---------------------------------------------------------
# v-pager
# ---------------------------------------------------------
.directive 'vPager', ->
    restrict: 'A'
    scope:
        pageList: '=vPager'
        urlTemplate: '@pagerUrlTemplate'
    replace: yes
    template:
        """
        <ul ng-if="pageList.total > 0" class="pagination pagination-sm">
            <li ng-class="{disabled: !links.previous.enable}">
                <a ng-href="{{ links.previous.url }}">&laquo;</a>
            </li>
            <li ng-repeat='item in links.numbers'
                ng-if='item.show'
                ng-class='{active: item.isCurrent}'>
                <a ng-href="{{ item.url }}">{{ item.pageNumber }}</a>
            </li>
            <li ng-class="{disabled: !links.next.enable}">
                <a ng-href="{{ links.next.url }}">&raquo;</a>
            </li>
        </ul>
        """
    link: (scope) ->
        scope.links =
            previous:
                enable: scope.pageList.has_previous_page
                url: scope.urlTemplate.replace '#{index}', scope.pageList.index - 1
            numbers: []
            next:
                enable: scope.pageList.has_next_page
                url: scope.urlTemplate.replace '#{index}', scope.pageList.index + 1

        for index in [(scope.pageList.index - 3)..(scope.pageList.index + 3)] by 1
            scope.links.numbers.push
                show: index >= 0 and index <= scope.pageList.max_index
                isCurrent: index is scope.pageList.index
                pageNumber: index + 1
                url: scope.urlTemplate.replace '#{index}', index

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
