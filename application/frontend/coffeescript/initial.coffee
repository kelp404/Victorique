angular.module 'v.initial', []

.config ->
    $.extend $.easing,
	    easeOutExpo: (x, t, b, c, d) ->
		    if t is d then b + c else c * (-Math.pow(2, -10 * t/d) + 1) + b

    # setup NProgress
    NProgress.configure
        showSpinner: no
