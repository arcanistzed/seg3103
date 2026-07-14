# SEG3103 – Test Automation and Continuous Integration

This project evaluates four tools used in automated software testing and
continuous integration:

* **pytest with pytest-cov** for Python test execution and coverage;
* **Jest** for JavaScript test execution and coverage;
* **Jenkins** for self-hosted continuous integration;
* **CircleCI** for managed cloud continuous integration.

The repository contains corresponding Python and JavaScript implementations of a
small banking application. The same test suites can be run locally or
automatically through Jenkins and CircleCI, allowing the project to examine both
test execution frameworks and CI platforms.

## Selected tools

| Tool                   | Category       | Ecosystem               | Role                                                       |
| ---------------------- | -------------- | ----------------------- | ---------------------------------------------------------- |
| **pytest** + pytest-cov | Test framework | Python                  | Discovers and executes Python tests, measures coverage     |
| **Jest**               | Test framework | JavaScript / Node.js    | Discovers and executes JavaScript tests, measures coverage |
| **Jenkins**            | CI platform    | Self-hosted             | Runs both test suites through a customizable pipeline      |
| **CircleCI**           | CI platform    | Managed cloud CI        | Runs both test suites through GitHub-integrated cloud jobs |

## How the tools work together

```
Python application ──▶ pytest ──┐
                                ├──▶ Jenkins
JavaScript application ▶ Jest ──┤
                                └──▶ CircleCI
                                     │
                                     ▼
                              Test and coverage results
```

**pytest** and **Jest** discover tests, run them, report pass/fail, and generate
coverage. They are not CI platforms — they do not decide when or where tests
execute. **Jenkins** and **CircleCI** automate when, where, and under what
conditions those tests run. They invoke the same pytest and Jest commands that
can be run locally.

The repository also includes a GitHub Actions workflow that runs both test
suites on pushes and pull requests. It provides an additional example of
repository-integrated continuous integration.

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

### Using the reusable scripts (from repository root)
```bash
./scripts/test-python.sh
./scripts/test-javascript.sh
```

Jenkins uses the reusable scripts directly. CircleCI and GitHub Actions execute
equivalent test commands within their respective configuration files.

## Jenkins pipeline

The [`Jenkinsfile`](Jenkinsfile) at the repository root defines a declarative
pipeline that:

1. Checks out the repository.
2. Runs Python and JavaScript test stages in parallel.
3. Archives `coverage.xml` and the JS `coverage/` directory on every build.

### Running with Jenkins

1. Install Jenkins (Docker is the quickest path).
2. Create a Pipeline or Multibranch Pipeline configured to load its pipeline
   definition from the repository's root-level `Jenkinsfile`.
3. The pipeline runs both test stages in parallel on the configured Jenkins
   agent or agents. The pipeline can be started manually. Automatic triggering
   after GitHub pushes additionally requires a reachable Jenkins webhook
   endpoint and appropriate GitHub integration.

**Agent requirements:** Git, Python 3, pip, Node.js, npm. The standard Jenkins
Docker image does not include all of these tools by default.

**Agent requirements:** Git, Python 3, pip, Node.js, npm.

## CircleCI workflow

The [`.circleci/config.yml`](.circleci/config.yml) defines two independent jobs
that execute concurrently in a single workflow:

| Job                | Image             | Purpose                      |
| ------------------ | ----------------- | ---------------------------- |
| `python-tests`     | `cimg/python:3.12`| Install deps → run pytest    |
| `javascript-tests` | `cimg/node:20.0` | `npm ci` → `npm test`        |

Coverage artifacts (`coverage.xml` and the Jest `coverage/` directory) are stored
for download.

### Connecting to CircleCI

1. Push this repository to GitHub.
2. Go to [app.circleci.com](https://app.circleci.com) and add your GitHub
   repository.
3. CircleCI automatically detects `.circleci/config.yml` and runs the workflow
   on every push.

## Additional GitHub Actions workflow

The existing [`.github/workflows/ci.yml`](.github/workflows/ci.yml) is an
additional automated validation workflow that:

- runs on every push and pull request;
- uses separate jobs for Python (pytest) and JavaScript (Jest);
- runs those jobs in parallel on `ubuntu-latest` GitHub-hosted runners;
- uploads coverage as build artifacts.

## Project structure

```
seg3103/
├── .circleci/
│   └── config.yml              # CircleCI workflow
├── .github/
│   └── workflows/
│       └── ci.yml              # GitHub Actions workflow
├── Jenkinsfile                  # Jenkins declarative pipeline
├── scripts/
│   ├── test-python.sh           # Reusable test script (Python)
│   └── test-javascript.sh       # Reusable test script (JavaScript)
├── python-backend/
│   ├── src/bank.py              # Python backend logic
│   ├── tests/test_bank.py       # pytest suite
│   ├── conftest.py              # pytest import path helper
│   ├── pytest.ini               # pytest + coverage config
│   └── requirements.txt
├── js-backend/
│   ├── src/bank.js              # JavaScript backend logic
│   ├── tests/bank.test.js       # Jest suite
│   ├── package.json             # Jest config + scripts
│   └── package-lock.json
└── README.md
```

## Demonstration application

Both modules implement a small banking domain — an `Account` supporting
`deposit`, `withdraw`, `transfer`, and a compound-interest helper — with
validation and error handling. The corresponding implementations make it
possible to compare how the two testing frameworks automate comparable test
scenarios.

At the time of writing, both test suites achieve 100% reported statement and
line coverage for their respective banking implementations. Coverage indicates
which code was executed, but does not by itself establish that every behaviour
or defect has been tested.
