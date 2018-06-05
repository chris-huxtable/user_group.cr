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

require "../lib_c/pwd"
require "../lib_c/limits"
require "../lib_c/unistd"

require "./group"

struct System::User
  {% if flag?(:darwin) || flag?(:openbsd) || flag?(:freebsd) %}
    UID_MAX = LibC::UID_MAX
  {% elsif flag?(:linux) %}
    UID_MAX = 0xffffffff_u32
  {% else %}
    {{ raise "Unsupported platform, only Darwin, OpenBSD, FreeBSD, and Linux (GNU, musl) are supported." }}
    #UID_MAX = 0xffff_u32 # POSIX Default
  {% end %}

  # Returns the user name for the given user ID.
  # Raises `System::User::NotFoundError` if no user exists.
  def self.name(uid : Int) : String
    name?(uid) || raise NotFoundError.new("User #{uid.inspect} was not found")
  end

  # Returns the user name for the given user ID.
  # Returns `nil` if no user exists.
  def self.name?(uid : Int) : String?
    check_uid_in_bounds(uid)
    user_struct = LibC.getpwuid(uid)
    return nil if !user_struct
    String.new(user_struct.value.pw_name)
  end

  # Returns the user ID for the given user name.
  # Raises `System::User::NotFoundError` if no user exists.
  def self.uid(username : String) : UInt32
    uid?(username) || raise NotFoundError.new("User #{username.inspect} was not found")
  end

  # Returns the user ID for the given user name.
  # Returns `nil` if no user exists.
  def self.uid?(username : String) : UInt32?
    username.check_no_null_byte
    user_struct = LibC.getpwnam(username)
    return nil if !user_struct
    user_struct.value.pw_uid
  end

  # Returns the user specified by the user ID.
  # Raises `System::User::NotFoundError` if not found.
  def self.get(uid : Int) : User
    get?(uid) || raise NotFoundError.new("User #{uid.inspect} was not found")
  end

  # Returns the user specified by the user ID.
  # Returns `nil` if not found.
  def self.get?(uid : Int) : User?
    check_uid_in_bounds(uid)
    user_struct = LibC.getpwuid(uid)
    return nil if !user_struct
    new(user_struct.value)
  end

  # Returns the user specified by the user name.
  # Raises `System::User::NotFoundError` if not found.
  def self.get(username : String) : User
    get?(username) || raise NotFoundError.new("User #{username.inspect} was not found")
  end

  # Returns the user specified by the user name.
  # Returns `nil` if not found.
  def self.get?(username : String) : User?
    username.check_no_null_byte
    user_struct = LibC.getpwnam(username)
    return nil if !user_struct
    new(user_struct.value)
  end

  # :nodoc:
  private def initialize(user : LibC::Passwd)
    @name = String.new(user.pw_name)
    @uid = user.pw_uid
    @gid = user.pw_gid
    @home = String.new(user.pw_dir)
    @shell = String.new(user.pw_shell)
    @info = String.new(user.pw_gecos)
  end

  # Returns the user name as a `String`.
  getter name : String

  # Returns the user ID.
  getter uid : UInt32

  # Returns the user group ID.
  getter gid : UInt32

  # Returns the path for the user's home as a `String`.
  getter home : String

  # Returns the path for the user's shell as a `String`.
  getter shell : String

  # Returns additional information about the user as a `String`.
  getter info : String

  # Returns the primary `Group` for the user.
  def group
    Group.get(@gid)
  end

  def_equals_and_hash(@uid)

  # Returns a `String` representation of the user, it's user name.
  def to_s
    @name
  end

  # Appends the user name to the given `IO`.
  def to_s(io : IO)
    io << @name
  end

  # :nodoc:
  def self.check_uid_in_bounds(uid : Int) : Nil
    return if 0 <= uid <= UID_MAX
    raise OutOfBoundsError.new("User id #{uid} is out of bounds")
  end

  class NotFoundError < Exception; end

  class OutOfBoundsError < Exception; end
end
