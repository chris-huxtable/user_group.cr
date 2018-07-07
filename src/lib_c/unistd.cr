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

lib LibC
  {% if flag?(:openbsd) %}
    SC_GETGR_R_SIZE_MAX = 100
    SC_GETPW_R_SIZE_MAX = 101
  {% elsif flag?(:darwin) || flag?(:freebsd) %}
    SC_GETGR_R_SIZE_MAX = 70
    SC_GETPW_R_SIZE_MAX = 71
  {% elsif flag?(:musl) || flag?(:gnu) %}
    SC_GETGR_R_SIZE_MAX = 69
    SC_GETPW_R_SIZE_MAX = 70
  {% else %}
    {{ raise "Unsupported platform, only Darwin, OpenBSD, FreeBSD, and Linux (GNU, musl) are supported." }}
  {% end %}

  fun getuid : UidT
  fun geteuid : UidT
  fun setuid(uid : UidT) : Int
  fun getgid : GidT
  fun getegid : GidT
  fun setgid(gid : GidT) : Int

  {% if flag?(:openbsd) || flag?(:linux) || flag?(:freebsd) %}
    fun getresuid(ruid : UidT*, euid : UidT*, suid : UidT*) : Int
    fun getresgid(rgid : GidT*, egid : GidT*, sgid : GidT*) : Int
  {% elsif !flag?(:darwin) %}
    {{ raise "Unsupported platform, only Darwin, OpenBSD, FreeBSD, and Linux (GNU, musl) are supported." }}
  {% end %}
end
