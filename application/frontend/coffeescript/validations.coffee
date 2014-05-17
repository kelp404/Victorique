angular.module 'v.validations', [
    'validator'
]

.config ['$validatorProvider', ($validatorProvider) ->
    # ----------------------------------------
    # required
    # ----------------------------------------
    $validatorProvider.register 'required',
        validator: /.+/
        error: 'This field is required.'
]
