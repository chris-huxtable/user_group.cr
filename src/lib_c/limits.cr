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

{% if flag?(:freebsd) || flag?(:openbsd) %}
  lib LibC
    UID_MAX     = 0xffffffff_u32 # max value for a uid_t
    GID_MAX     = 0xffffffff_u32 # max value for a gid_t
    NGROUPS_MAX =             16 # max supplemental group id's
  end
{% elsif flag?(:darwin) %}
  lib LibC
    UID_MAX     = 2147483647_u32 # max value for a uid_t (2^31-2)
    GID_MAX     = 2147483647_u32 # max value for a gid_t (2^31-2)
    NGROUPS_MAX =             16 # max supplemental group id's
  end
{% elsif flag?(:freebsd) %}
  lib LibC
    UID_MAX     = 0xffffffff_u32 # max value for a uid_t
    GID_MAX     = 0xffffffff_u32 # max value for a gid_t
    NGROUPS_MAX =           1023 # max supplemental group id's
  end
{% elsif flag?(:gnu) %}
  lib LibC
    NGROUPS_MAX =          65536 # max supplemental group id's
  end
{% elsif flag?(:musl) %}
  lib LibC
    NGROUPS_MAX =             32 # max supplemental group id's
  end
{% else %}
  {{ raise "Unsupported platform, only Darwin, OpenBSD, FreeBSD, and Linux (GNU, musl) are supported." }}
{% end %}
