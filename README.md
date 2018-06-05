# user_group.cr
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://chris-huxtable.github.io/user_group.cr/)
[![GitHub release](https://img.shields.io/github/release/chris-huxtable/user_group.cr.svg)](https://github.com/chris-huxtable/user_group.cr/releases)
[![Build Status](https://travis-ci.org/chris-huxtable/user_group.cr.svg?branch=master)](https://travis-ci.org/chris-huxtable/user_group.cr)

Adds System Users and Groups.

This is a shard containing the contents of crystal-lang/crystal PR [#5627](https://github.com/crystal-lang/crystal/pull/5627)

Note:
 - It will be deleted when a version of Crystal is released containing it. Hopefully v0.25.0.


## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  user_group:
    github: chris-huxtable/user_group.cr
```


## Usage

```crystal
require "user_group"
```

Adds features like:
- `Process.become(System::User.get("nobody"))`
- `Process.become(System::Group.get("nobody"))`
- `Process.user`
- `Process.group`
- `System::User.get("root").shell`
- `System::Group.get("wheel").members`
- `a_pointer.to_slice_null_terminated(a_limit)` (useful for converting the Char** to an Array(String))


## Contributing

1. Fork it ( https://github.com/chris-huxtable/user_group.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request


## Contributors

- [Chris Huxtable](https://github.com/chris-huxtable) - creator, maintainer
