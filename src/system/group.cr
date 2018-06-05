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

require "../lib_c/grp"
require "../lib_c/limits"
require "../lib_c/unistd"

require "./user"
require "../slice"

struct System::Group
  {% if flag?(:darwin) || flag?(:openbsd) || flag?(:freebsd) %}
    GID_MAX = LibC::GID_MAX
  {% elsif flag?(:linux) %}
    GID_MAX = 0xffffffff_u32
  {% else %}
    {{ raise "Unsupported platform, only Darwin, OpenBSD, FreeBSD, and Linux (GNU, musl) are supported." }}
    #GID_MAX = 0xffff_u32 # POSIX Default
  {% end %}
  NGROUPS_MAX = LibC::NGROUPS_MAX

  # Returns the group name for the given group ID.
  # Raises `System::Group::NotFoundError` if group does not exist.
  def self.name(gid : Int) : String
    name?(gid) || raise NotFoundError.new("Group #{gid.inspect} was not found")
  end

  # Returns the group name for the given group ID.
  # Returns `nil` if no group exists.
  def self.name?(gid : Int) : String?
    check_gid_in_bounds(gid)
    group_struct = LibC.getgrgid(gid)
    return nil if !group_struct
    String.new(group_struct.value.gr_name)
  end

  # Returns the group ID for the given group name.
  # Raises `System::Group::NotFoundError` if group does not exist.
  def self.gid(groupname : String) : UInt32
    gid?(groupname) || raise NotFoundError.new("Group #{groupname.inspect} was not found")
  end

  # Returns the group ID for the given group name.
  # Returns `nil` if no group exists.
  def self.gid?(groupname : String) : UInt32?
    groupname.check_no_null_byte
    group_struct = LibC.getgrnam(groupname)
    return nil if !group_struct
    group_struct.value.gr_gid
  end

  # Returns the group specified by the group ID.
  # Raises `System::Group::NotFoundError` if not found.
  def self.get(gid : Int) : Group
    get?(gid) || raise NotFoundError.new("Group #{gid.inspect} was not found")
  end

  # Returns the group specified by the group ID.
  # Returns `nil` if not found.
  def self.get?(gid : Int) : Group?
    check_gid_in_bounds(gid)
    group_struct = LibC.getgrgid(gid)
    return nil if !group_struct
    new(group_struct.value)
  end

  # Returns the group specified by the groupname.
  # Raises `System::Group::NotFoundError` if not found.
  def self.get(groupname : String) : Group
    get?(groupname) || raise NotFoundError.new("Group #{groupname.inspect} was not found")
  end

  # Returns the group specified by the group name.
  # Returns `nil` if not found.
  def self.get?(groupname : String) : Group?
    groupname.check_no_null_byte
    group_struct = LibC.getgrnam(groupname)
    return nil if !group_struct
    new(group_struct.value)
  end

  # :nodoc:
  private def initialize(group : LibC::Group)
    @name = String.new(group.gr_name)
    @gid = group.gr_gid
    slice = Slice.new(group.gr_mem, limit: NGROUPS_MAX, read_only: true)
    @member_names = Array.new(slice.size) { |idx| String.new(slice[idx]) }
  end

  # Returns the group name as a `String`.
  getter name : String

  # Returns the group ID.
  getter gid : UInt32

  # Returns an `Array` of the member names as `String`s.
  getter member_names : Array(String)

  # Yields member names as `String`s.
  def each_member_name(&block : String -> Nil) : Nil
    @member_names.each { |member| yield(member) }
  end

  # Returns an `Array` of the members as `User`s.
  def members : Array(User)
    @member_names.map { |member| User.get(member) }
  end

  # Yields members as `User`s.
  def each_member(&block : User -> Nil) : Nil
    each_member_name { |member| yield(User.get(member)) }
  end

  def_equals_and_hash(gid)

  # Returns a `String` representation of the group, it's group name.
  def to_s
    @name
  end

  # Appends the group name to the given `IO`.
  def to_s(io : IO)
    io << @name
  end

  # :nodoc:
  def self.check_gid_in_bounds(gid : Int) : Nil
    return if 0 <= gid <= GID_MAX
    raise OutOfBoundsError.new("Group id #{gid} is out of bounds")
  end

  class NotFoundError < Exception; end

  class OutOfBoundsError < Exception; end
end
