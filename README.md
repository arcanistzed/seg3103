# SEG3103 – Test Automation & Continuous Integration Project

This project examines **two test-automation tools** with a focus on **automation and
continuous integration (CI)**. It contains a small backend implemented twice — once in
**Python** and once in **JavaScript** — so that each tool can be shown automating a real
test suite. Both suites run automatically on every push through **GitHub Actions**.

## The two tools examined

| # | Tool | Ecosystem | Role in this project |
|---|------|-----------|----------------------|
| 1 | **pytest** (with `pytest-cov`) | Python | Automates the Python backend test suite and measures code coverage |
| 2 | **Jest** | JavaScript / Node.js | Automates the JavaScript backend test suite and measures code coverage |

Both tools are **fully automated**: they discover tests, run them without manual steps,
report pass/fail, and generate coverage. They are wired into a CI pipeline so the whole
suite re-runs on every commit — improving both **productivity** (no manual test runs) and
**test-suite quality** (coverage is tracked continuously).

### 1. pytest
- **Automation focus:** auto-discovers `test_*.py` files, parametrizes cases with
  `@pytest.mark.parametrize`, and asserts on exceptions with `pytest.raises`.
- **CI focus:** exit code signals success/failure to the CI runner; `pytest-cov` emits a
  `coverage.xml` report that CI uploads as a build artifact.
- Configured in [`python-backend/pytest.ini`](python-backend/pytest.ini).

### 2. Jest
- **Automation focus:** auto-discovers `*.test.js` files, uses `test.each` for
  data-driven cases, and `expect(...).toThrow()` for error paths.
- **CI focus:** `jest --coverage` produces a coverage report and returns a non-zero exit
  code on failure so CI can gate the build.
- Configured via the `test` script in [`js-backend/package.json`](js-backend/package.json).

## How automation + CI work together

```
push / pull request
        │
        ▼
 GitHub Actions (.github/workflows/ci.yml)
        │
        ├── job: python-tests  →  pip install → pytest --cov
        └── job: js-tests      →  npm install → jest --coverage
        │
        ▼
   pass ✅ / fail ❌ reported on the commit
```

The two jobs run **in parallel**, so a broken change in either language is caught
immediately — this is the continuous-integration payoff.

## Project structure

```
seg3103/
├── .github/workflows/ci.yml     # CI pipeline running both tools
├── python-backend/
│   ├── src/bank.py              # Python backend logic
│   ├── tests/test_bank.py       # pytest suite
│   ├── pytest.ini               # pytest + coverage config
│   └── requirements.txt
├── js-backend/
│   ├── src/bank.js              # JavaScript backend logic
│   ├── tests/bank.test.js       # Jest suite
│   └── package.json             # Jest config + scripts
└── README.md
```

## Running locally

### Python (pytest)
```bash
cd python-backend
pip install -r requirements.txt
pytest
```

### JavaScript (Jest)
```bash
cd js-backend
npm install
npm test
```

## What the backend does

Both modules implement the same small banking domain — an `Account` supporting
`deposit`, `withdraw`, `transfer`, and a compound-interest helper — with validation and
error handling. The identical behavior in two languages makes it easy to compare how
each tool automates the same set of test scenarios.
