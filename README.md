# RubySkeleton


## Operation

Run scripts.

```sh
ruby -I lib bin/rs
```


## Testing

Install test tools.

```sh
gem install rspec simplecov simplecov-rcov rspec_junit_formatter metric_fu rubocop roodi flog
```

Run code style check, metrics and tests.

```sh
./run-style-check.sh
./run-metrics.sh
./run-tests.sh
```

Build project like Jenkins.

```sh
./build.sh
```


## Important details

* The gem dependency `rspec_junit_formatter` is for formatting rspec output in something JUnit compatible.
* The gem dependency `simplecov-rcov` is for Jenkins to be able to parse coverage output.
* The directories `lib/language_examle` and `spec/language_example` are for sharing language specific knowledge.
