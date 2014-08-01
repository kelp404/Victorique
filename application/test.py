import os, sys, unittest


if __name__ == '__main__':
    # extend gae libs
    if os.path.isdir('./google_appengine'):
        gae_path = './google_appengine'
    else:
        gae_path = '/usr/local/google_appengine'
    libs = [
        gae_path,
        os.path.join(gae_path, 'google'),
        os.path.join(gae_path, 'lib', 'webapp2-2.5.2'),
        os.path.join(gae_path, 'lib', 'webob-1.2.3'),
        os.path.join(gae_path, 'lib', 'yaml', 'lib'),
    ]
    sys.path.extend(libs)

    # extend tests
    base_dir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    sys.path.extend([
        base_dir,
    ])

    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "application.settings")

    tests = unittest.TestLoader().discover('tests')
    result = unittest.TextTestRunner(verbosity=2).run(tests)
    if len(result.failures) or len(result.errors):
        raise Exception()
