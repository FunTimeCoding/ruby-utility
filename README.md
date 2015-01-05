# Ruby Skeleton


## Operation

To run the program from the `bin` directory, pass the argument `-I`.

```sh
ruby -I lib bin/example-script
```


## Running tests

Run this command to install testing tools.

```sh
gem install rspec simplecov simplecov-rcov
```

Run this command to run specs.

```sh
rspec
```


## Continuous integration

Install `rspec_junit_formatter` for JUnit formatting rspec output.

```sh
gem install rspec_junit_formatter
```

Run rspec with JUnit output and SimpleCov coverage.

```sh
COVERAGE=on rspec --format RspecJunitFormatter --out rspec.xml
```

Run ant like CI would. Requires ant to be installed.

```sh
ant
```
