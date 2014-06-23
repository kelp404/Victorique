#Victorique [![Build Status](https://secure.travis-ci.org/kelp404/Victorique.png?branch=master)](http://travis-ci.org/kelp404/Victorique) [![devDependency Status](https://david-dm.org/kelp404/Victorique/dev-status.png?branch=master)](https://david-dm.org/kelp404/Victorique#info=devDependencies&view=table)

[MIT License](http://www.opensource.org/licenses/mit-license.php)


Victorique is an error reporting server on Google App Engine. You could download this project then deploy to GAE with free plan. Your app could send the error information to Victorique with RESTful API. And this project is the second generation of [Victory](https://github.com/kelp404/Victory).  
Victorique is memento for ヴィクトリカ of [GOSICK](http://www.gosick.tv/).




##Installation
```bash
$ git clone https://github.com/kelp404/Victorique.git
$ git submodule update --init
```




##API document
>####[Victorique on Apiary](http://docs.victorique.apiary.io/)




##Example API Calls
**curl**
>```bash
$ curl -XPOST https://victorique-demo.appspot.com/api/applications/2b0a8cc0-f156-11e3-ae66-bf0516da091e/logs --header "Content-Type:application/json" -d '
{
  "title": "__52-[ManaNetwork getEventsWithQuery:completionHandler:]_block_invoke +696",
  "user": "kelp<kelp@phate.org>",
  "document": {
    "exception": "Error Domain=NSURLErrorDomain Code=-1001 \"The request timed out.\" UserInfo=0x155d43d0 {NSErrorFailingURLStringKey=http://www......",
    "time": "2014-06-07T08:51:38.000Z",
    "device": "iPhone 7.1.1",
    "...": "..."
  }
}'
```

**AngularJS & jQuery**
>```coffee
$http(args).error (data, status, headers, config) =>
    delete config.data?.password
    document =
        'Request Headers': config.headers
        'Request Params': config.params
        'Request Data': config.data
        'Response Status': status
    $.ajax
        method: 'get'
        dataType: 'jsonp'
        url: 'https://victorique-demo.appspot.com/api/applications/#{yourAppKey}/logs'
        data:
            title: "#{config.method} #{location.origin}#{config.url} failed"
            user: "#{@user.name} <#{@user.email}>"
            document: JSON.stringify(document)
```




##Deploy
>You should create a GAE account.
https://appengine.google.com

**update [app.yaml](https://github.com/kelp404/Victorique/blob/master/app.yaml)**
>
Find `application: victorique-demo` then replace `victorique-demo` to your Application Identifier.

**update [application/settings.py](https://github.com/kelp404/Victorique/blob/master/application/settings.py)**
>
```python
GAE_ACCOUNT = 'kelp.phate@gmail.com' # your gae account
HOST = 'victorique-demo.appspot.com' # your domain
ALLOW_REGISTER = False # `False` will not allow register
```

**upload victorique**
>https://developers.google.com/appengine/docs/python/gettingstartedpython27/uploading




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
    $applications: # all paged applications
    $user: # current user object
```



##Test
>```bash
# frontend unit-test
$ grunt test
# python unit-test
$ python application/test.py
```
