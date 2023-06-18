pip-compile: requirements.in dev-requirements.in
	docker run --rm \
		-v .:/app \
		-w /app \
		python:3.11 \
		sh -c 'pip install --upgrade pip pip-tools; pip-compile --allow-unsafe --generate-hashes --resolver=backtracking requirements.in; pip-compile --allow-unsafe --generate-hashes --resolver=backtracking dev-requirements.in'
