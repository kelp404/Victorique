import os, sys, unittest


if __name__ == '__main__':
    application_name = 'application'
    base_dir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    tests_dir = os.path.join(base_dir, application_name, 'tests')
    sys.path.extend([
        base_dir,
        tests_dir
    ])

    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "application.settings")

    test_files = [filename for filename in os.listdir('%s' % tests_dir)
                  if filename.endswith('.py') and not filename.startswith('__')]
    test_modules = [x.replace('.py', '') for x in test_files]
    map(__import__, test_modules)

    suite = unittest.TestSuite()
    for mod in [sys.modules[modname] for modname in test_modules]:
        suite.addTest(unittest.TestLoader().loadTestsFromModule(mod))
    result = unittest.TextTestRunner(verbosity=2).run(suite)
    if len(result.failures) > 0 or len(result.errors) > 0:
        print('/n')
        raise Exception('FAILED (failures=%i, errors=%i)' % (len(result.failures), len(result.errors)))
