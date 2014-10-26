# Ruby Skeleton

## Usage

Run this command to execute the main program.

```sh
#!/bin/sh
ruby -I lib bin/myProgram
```

## Testing

Run this command to install testing tools.

```sh
#!/bin/sh
gem install rspec simplecov simplecov-rcov
```

Run this command to run specs.

```sh
#!/bin/sh
rspec
```

## Continuous Integration

Install rspec_junit_formatter for JUnit formatting rspec output.

```sh
#!/bin/sh
gem install rspec_junit_formatter
```

Run rspec with JUnit output and SimpleCov coverage.

```sh
#!/bin/sh
COVERAGE=on rspec --format RspecJunitFormatter --out rspec.xml
```
