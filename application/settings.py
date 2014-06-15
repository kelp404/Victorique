"""
Django settings for DjangoGAE project.

For more information on this file, see
https://docs.djangoproject.com/en/1.6/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.6/ref/settings/
"""

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
import os
BASE_DIR = os.path.dirname(os.path.dirname(__file__))


GAE_ACCOUNT = 'kelp.phate@gmail.com'
HOST = 'victorique-demo.appspot.com'
LOG_EXPIRATION = 30 # days
ALLOW_REGISTER = True

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.6/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'f!!w414jfulmcc862^f4#@9*4cwo#9pg$kelp)wqo2*!0()3b-'

# SECURITY WARNING: don't run with debug turned on in production!
# Auto-set debug mode based on App Engine dev environ
DEBUG = 'SERVER_SOFTWARE' in os.environ and os.environ['SERVER_SOFTWARE'].startswith('Dev')
TEMPLATE_DEBUG = DEBUG

ALLOWED_HOSTS = ['localhost']
ALLOWED_HOSTS.append(HOST)


# Application definition

INSTALLED_APPS = (
    # 'django.contrib.admin',
    # 'django.contrib.auth',
    'django.contrib.contenttypes',
    # 'django.contrib.sessions',
    # 'django.contrib.messages',
    # 'django.contrib.staticfiles',
    'application',
)

MIDDLEWARE_CLASSES = (
    # 'application.middleware.GlobalMiddleware',
    'application.middleware.AuthenticationMiddleware',
    # 'django.contrib.sessions.middleware.SessionMiddleware',
    # 'django.middleware.common.CommonMiddleware',
    # 'django.middleware.csrf.CsrfViewMiddleware',
    # 'django.contrib.auth.middleware.AuthenticationMiddleware',
    # 'django.contrib.messages.middleware.MessageMiddleware',
    # 'django.middleware.clickjacking.XFrameOptionsMiddleware',
)

ROOT_URLCONF = 'application.urls'

WSGI_APPLICATION = 'application.app'


# Database
# https://docs.djangoproject.com/en/1.6/ref/settings/#databases
DATABASES = {}

# Internationalization
# https://docs.djangoproject.com/en/1.6/topics/i18n/

LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_L10N = True
USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.6/howto/static-files/

# STATIC_URL = '/static/'

TEMPLATE_DIRS = (
    (os.path.join(BASE_DIR, 'application', 'templates')),
)

TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.Loader',
    # 'django.template.loaders.app_directories.Loader',
    # 'django.template.loaders.eggs.Loader',
)

TEMPLATE_CONTEXT_PROCESSORS = (
    'django.contrib.auth.context_processors.auth',
    # 'django.core.context_processors.debug',
    # 'django.core.context_processors.i18n',
    # 'django.core.context_processors.media',
    # 'django.core.context_processors.static',
    # 'django.core.context_processors.tz',
    # 'django.contrib.messages.context_processors.messages',
    'application.context_processors.debug'
)
