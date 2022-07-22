deps:
	pip install -r requirements/requirements.txt

pip-compile:
	pip-compile requirements/requirements.in -vvv

clean: clean-eggs clean-build
	@find . -iname '*.pyc' -exec rm -rf {} \;
	@find . -iname '*.pyo' -exec rm -rf {} \;
	@find . -iname '*~' -exec rm -rf {} \;
	@find . -iname '*.swp' -exec rm -rf {} \;
	@find . -iname '__pycache__' -exec rm -rf {} \;
	@find . -name ".pytest_cache"  -exec rm -rf {} \;
	@find . -name ".cache"  -exec rm -rf {} \;
