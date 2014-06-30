import os

from ez_setup import use_setuptools
use_setuptools()

from setuptools import setup, find_packages

ver = '0.9.0'
if os.path.exists('version.txt'):
    ver = open('version.txt').read()

setup(name="melee",
    version = ver,
    description = "Web game of SanGuoShi.",
    url = "http://www.glearning.com.cn/melee",
    author = "Wu Xin",
    author_email = "wuxin@glearning.com.cn",
    maintainer = "Wu Xin",
    maintainer_email = "wuxin@glearning.com.cn",
    keywords = "webgame",
    platforms = ["any"],
    packages = find_packages('src'),
    package_dir = {'':'src'},
    include_package_data = True,
    package_data = {
        '': ['*.txt'],
        'data': ['data/*.csv'],
    },
    install_requires = {
        'uuid': 'uuid>=1.3.0',
        'twisted': 'Twisted==8.2.0',
        'amfast': 'amfast>=0.5.0'
    },
    classifiers = [
        "Programming Language :: Python :: 2.6",
        "Development Status :: 5 - Production/Stable",
        "Intended Audience :: Operators",
        "Topic :: Games"
    ],

    )
