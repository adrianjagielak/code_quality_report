Example .gitlab-ci.yml file used internally by this program:

```YAML
stages:
  - test

dartanalyzer:
  image: google/dart
  stage: test
  before_script:
    - pub global activate code_quality_report
    - export PATH="$PATH":"$HOME/.pub-cache/bin"
  script:
    - pub get
    - dartanalyzer . --format=machine 2>&1 | tocodeclimate > code-quality-report.json
  artifacts:
    reports:
      codequality: code-quality-report.json
```

Reference: [GitLab CI/CD pipeline configuration reference](https://docs.gitlab.com/ee/ci/yaml/)