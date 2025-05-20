list: # List all the available targets
	@grep '^[^#[:space:]].*:' Makefile

hooks: # Install git hooks, for development
	scripts/install-hooks

pre-commit: # Run pre-commit hooks
	scripts/pre-commit.bash

pigeon: # Generate Pigeon bindings
	scripts/pigeon
