# Copyright (c) 2018 Christian Huxtable <chris@huxtable.ca>.
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

require "./system/user"
require "./system/group"

require "./crystal/system/file"

class File
  private alias User = System::User | String | Int32 | UInt32
  private alias Group = System::Group | String | Int32 | UInt32

  # Changes the owner of the specified file.
  #
  # ```
  # File.chown("/foo/bar/baz.cr", "a_owner", "a_group")
  # File.chown("/foo/bar", group: "a_group")
  # ```
  #
  # Unless *follow_symlinks* is set to `true`, then the owner symlink itself will
  # be changed, otherwise the owner of the symlink destination file will be
  # changed. For example, assuming symlinks as `foo -> bar -> baz`:
  #
  # ```
  # File.chown("foo", group: "a_group")                        # changes foo's group to "a_group"
  # File.chown("baz", group: "a_group", follow_symlinks: true) # changes baz's group to "a_group"
  # ```
  #
  # Raises on error.
  def self.chown(path : String, owner : User? = nil, group : Group? = nil, follow_symlinks : Bool = false) : Nil
    Crystal::System::File.chown(path, uid_from_user(owner), gid_from_group(group), follow_symlinks)
  end

  # :nodoc:
  def self.chown(path : String, uid : Int = -1, gid : Int = -1, follow_symlinks : Bool = false) : Nil
    Crystal::System::File.chown(path, uid, gid, follow_symlinks)
  end

  # Same as `chown()` but instead returns a `Bool` indicating success.
  # ```
  def self.chown?(path : String, owner : User? = nil, group : Group? = nil, follow_symlinks : Bool = false) : Bool
    Crystal::System::File.chown(path, uid_from_user(owner), gid_from_group(group), follow_symlinks)
    true
  rescue ex
    false
  end

  # :nodoc:
  private def self.uid_from_user(user : User?) : Int32 | UInt32
    case user
    when System::User then user.uid
    when String       then System::User.uid(user)
    when Int          then user
    else                   -1
    end
  end

  # :nodoc:
  private def self.gid_from_group(group : Group?) : Int32 | UInt32
    case group
    when System::Group then group.gid
    when String        then System::Group.gid(group)
    when Int           then group
    else                    -1
    end
  end
end
