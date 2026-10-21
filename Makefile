.PHONY: wheel install test clean

wheel: 
	python3 -m pip wheel . --no-deps -w dist
install:
	python3 -m pip install dist/*.whl
test: 
	python3 -m pytest -q tests/
clean: 
	rm -rf dist build __pycache__ *.egg-info
