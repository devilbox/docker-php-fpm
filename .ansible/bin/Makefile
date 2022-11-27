ifneq (,)
.error This Makefile requires GNU Make.
endif

# Ensure additional Makefiles are present
MAKEFILES = Makefile.python
$(MAKEFILES): URL=https://raw.githubusercontent.com/devilbox/makefiles/master/$(@)
$(MAKEFILES):
	@if ! (curl --fail -sS -o $(@) $(URL) || wget -O $(@) $(URL)); then \
		echo "Error, curl or wget required."; \
		echo "Exiting."; \
		false; \
	fi
include $(MAKEFILES)


# -------------------------------------------------------------------------------------------------
# Default configuration
# -------------------------------------------------------------------------------------------------
MYPY_ARGS       = --strict --disable-error-code no-any-return

PYLINT_DIR      = get-modules.py
PYLINT_PIP_PKGS = yamllint
PYLINT_ARGS     = --disable=invalid-name get-modules.py

PYCODE_ARGS     = --max-line-length=100

BLACK_LINT_ARGS = -l 100 --check --diff
BLACK_FIX_ARGS  = -l 100
