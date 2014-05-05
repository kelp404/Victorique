#Victorique [![Build Status](https://secure.travis-ci.org/kelp404/Victorique.png?branch=master)](http://travis-ci.org/kelp404/Victorique) [![devDependency Status](https://david-dm.org/kelp404/Victorique/dev-status.png?branch=master)](https://david-dm.org/kelp404/Victorique#info=devDependencies&view=table)



##Development
```bash
# Install node modules, bower components and pip packages.
$ npm install
$ bower install
$ pip install -r pip_requirements.txt
```
```bash
# compile frontend files
$ grunt dev
```

```coffee
$rootScope =
    $state:
        # the $state of ui-router
    $stateParams:
        # the $stateParams of ui-router
```



##Test
```bash
# frontend unit-test
$ grunt test
# python unit-test
$ python application/test.py
```
