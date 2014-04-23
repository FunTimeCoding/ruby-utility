# Ruby Skeleton

## Testing

Install testing tools

```sh
#!/bin/sh
gem install rspec simplecov simplecov-rcov
```

Run specs

```sh
#!/bin/sh
rspec
```

## Continuous Integration

Install JUnit formatter for rspec

```sh
#!/bin/sh
gem install rspec_junit_formatter
```

Run rspec with JUnit output and SimpleCov coverage.

```sh
#!/bin/sh
COVERAGE=on rspec --format RspecJunitFormatter  --out rspec.xml
```

