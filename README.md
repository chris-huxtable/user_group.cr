# user_group.cr

Adds System Users and Groups.

Also adds features like:
- `Process.become(System::User.get("nobody"))`
- `Process.become(System::Group.get("nobody"))`
- `Process.user`
- `Process.group`
- `System::User.get("root").shell`
- `System::Group.get("wheel").members`
- `a_pointer.to_slice_null_terminated(a_limit)` (useful for converting the Char** to an Array(String))

This is a shard containing the contents of crystal-lang/crystal PR [#5627](https://github.com/crystal-lang/crystal/pull/5627)

Note:
 - It will be deleted when a version of Crystal is released containing it. Hopefully v0.25.0.
 - This shard only supports macOS, and OpenBSD. Open an issue or PR if you would like to include another OS.


## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  user_group:
    github: chris-huxtable/user_group.cr
```


## Usage

```crystal
require "system/user"
require "system/group"
```

TODO: Write usage instructions here


## Contributing

1. Fork it ( https://github.com/chris-huxtable/user_group.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request


## Contributors

- [Chris Huxtable](https://github.com/chris-huxtable) - creator, maintainer
