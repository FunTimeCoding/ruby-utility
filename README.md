# Ruby Skeleton

Run specs

```sh
#!/bin/sh
gem install rspec
rspec
```

Run rspec with JUnit output.

```sh
#!/bin/sh
gem install rspec_junit_formatter
rspec --format RspecJunitFormatter  --out rspec.xml
```

