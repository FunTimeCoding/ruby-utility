# Ruby Skeleton


## Operation

Run scripts.

```sh
ruby -I lib bin/example-script
```


## Testing

Install test tools.

```sh
gem install rspec simplecov simplecov-rcov rspec_junit_formatter
```

Run tests.

```sh
rspec
```

Run ant like Jenkins. Requires `ant` to be installed.

```sh
ant
```


## Important details

* `rspec_junit_formatter` is for formatting rspec output in something JUnit compatible.
* `simplecov-rcov` is for Jenkins to be able to parse coverage output.
