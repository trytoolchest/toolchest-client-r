reset_setuptools = False
try:
  from distutils.version import LooseVersion
  import setuptools

  setuptools_version = setuptools.__version__
  reset_setuptools = (LooseVersion(setuptools_version) >= LooseVersion('58.0.2'))
except ModuleNotFoundError:
  pass
