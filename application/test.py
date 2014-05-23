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
        os.path.join(gae_path, 'lib', 'yaml', 'lib'),
    ]
    sys.path.extend(libs)

    # extend tests
    application_name = 'application'
    base_dir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    sys.path.extend([
        base_dir,
    ])

    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "application.settings")

    tests = unittest.TestLoader().discover('tests')
    unittest.TextTestRunner(verbosity=2).run(tests)
