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

require "./spec_helper"

describe File do
  it "chown" do
    # changing owners requires special privileges, so we test that method calls do compile
    typeof(File.chown("/tmp/test", owner: 1001))
    typeof(File.chown("/tmp/test", group: 1001))
    typeof(File.chown("/tmp/test", owner: 1001, group: 100, follow_symlinks: true))

    typeof(File.chown?("/tmp/test", owner: 1001))
    typeof(File.chown?("/tmp/test", group: 1001))
    typeof(File.chown?("/tmp/test", owner: 1001, group: 100, follow_symlinks: true))

    typeof(File.chown("/tmp/test", owner: "root"))
    typeof(File.chown("/tmp/test", group: "daemon"))
    typeof(File.chown("/tmp/test", owner: "root", group: "daemon", follow_symlinks: true))

    typeof(File.chown?("/tmp/test", owner: "root"))
    typeof(File.chown?("/tmp/test", group: "daemon"))
    typeof(File.chown?("/tmp/test", owner: "root", group: "daemon", follow_symlinks: true))

    user = System::User.get("root")
    group = System::Group.get("daemon")

    typeof(File.chown("/tmp/test", owner: user))
    typeof(File.chown("/tmp/test", group: group))
    typeof(File.chown("/tmp/test", owner: user, group: group, follow_symlinks: true))

    typeof(File.chown?("/tmp/test", owner: user))
    typeof(File.chown?("/tmp/test", group: group))
    typeof(File.chown?("/tmp/test", owner: user, group: group, follow_symlinks: true))

    typeof(File.chown("/tmp/test"))
    typeof(File.chown("/tmp/test", uid: 1001, gid: 100, follow_symlinks: true))
  end
end
