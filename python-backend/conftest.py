"""Ensure the backend package is importable during test collection.

pytest loads this file from the ``python-backend`` root before collecting
tests, and prepends its directory to ``sys.path``. That makes ``import src``
work the same way locally and in CI, regardless of how pytest is invoked.
"""

import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
