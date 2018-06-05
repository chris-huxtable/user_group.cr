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

class Process
  # Sets the real, effective, and saved `User` to the one specified.
  def self.become(user : System::User) : Nil
    return if LibC.setuid(user.uid) == 0
    raise Errno.new("The calling process was not privileged")
  end

  # Sets the real, effective, and saved `Group` to the one specified.
  def self.become(group : System::Group) : Nil
    return if LibC.setgid(group.gid) == 0
    raise Errno.new("The calling process was not privileged")
  end

  # Sets the real, effective, and saved `User` and `Group` to the ones specified.
  def self.become(user : System::User, group : System::Group) : Nil
    become(group)
    become(user)
  end

  # Returns a `Bool` indicating if the current process is running as root.
  def self.root? : Bool
    LibC.getuid == 0
  end

  # Returns the current process's `User`.
  def self.user : System::User
    System::User.get(LibC.getuid)
  end

  # Returns the current process's `Group`.
  def self.group : System::Group
    System::Group.get(LibC.getgid)
  end

  # Returns the current process's effective `User`.
  def self.effective_user : System::User
    System::User.get(LibC.geteuid)
  end

  # Returns the current process's effective `Group`.
  def self.effective_group : System::Group
    System::Group.get(LibC.getegid)
  end

  # Returns the current process's saved `User`.
  #
  # Note: Not all Unix and Unix deriviatives support a saved `User`.
  def self.saved_user : System::User
    {% if flag?(:openbsd) || flag?(:freebsd) || flag?(:linux) %}
      if LibC.getresuid(out ruid, out euid, out suid) == 0
        return System::User.get(suid)
      end

      raise Errno.new("Failed to get saved user")
    {% else %}
      raise NotImplementedError.new("Process.saved_user")
    {% end %}
  end

  # Returns the current process's saved `Group`.
  #
  # Note: Not all Unix and Unix deriviatives support a saved `Group`.
  def self.saved_group : System::Group
    {% if flag?(:openbsd) || flag?(:freebsd) || flag?(:linux) %}
      if LibC.getresuid(out rgid, out egid, out sgid) == 0
        return System::Group.get(sgid)
      end

      raise Errno.new("Failed to get saved group")
    {% else %}
      raise NotImplementedError.new("Process.saved_group")
    {% end %}
  end
end
