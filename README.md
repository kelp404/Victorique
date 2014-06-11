#Victorique [![Build Status](https://secure.travis-ci.org/kelp404/Victorique.png?branch=master)](http://travis-ci.org/kelp404/Victorique) [![devDependency Status](https://david-dm.org/kelp404/Victorique/dev-status.png?branch=master)](https://david-dm.org/kelp404/Victorique#info=devDependencies&view=table)

[MIT License](http://www.opensource.org/licenses/mit-license.php)


Victorique is an error reporting server on Google App Engine. You could download this project then deploy to GAE with free plan. Your app could send the error information to Victorique with RESTful API. And this project is the second generation of [Victory](https://github.com/kelp404/Victory).  
Victorique is memento for ヴィクトリカ of [GOSICK](http://www.gosick.tv/).




##API document
>####[Victorique on Apiary](http://docs.victorique.apiary.io/)




##Development
>```bash
# Install node modules, bower components and pip packages.
$ npm install
$ bower install
$ pip install -r pip_requirements.txt
```
```bash
# compile frontend files
$ grunt dev
```

>```coffee
$rootScope =
    $state:
        # the $state of ui-router
    $stateParams:
        # the $stateParams of ui-router
    $confirmModal:
        # the confirm modal
        message: {string}
        callback: (result) ->
        isShow: {bool}
```



##Test
>```bash
# frontend unit-test
$ grunt test
# python unit-test
$ python application/test.py
```
