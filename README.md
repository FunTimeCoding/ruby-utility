# Ruby Skeleton

## Testing

Install testing tools

```sh
#!/bin/sh
gem install rspec simplecov
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

Run rspec with JUnit output.

```sh
#!/bin/sh
rspec --format RspecJunitFormatter  --out rspec.xml
```

