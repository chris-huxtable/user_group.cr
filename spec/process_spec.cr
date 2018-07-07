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

describe Process do
  describe "users and groups" do
    it "has a user" do
      user = Process.user
      user.should be_a(System::User)
      user.uid.to_s.should eq(`id -ur`.strip)
    end

    it "has a group" do
      group = Process.group
      group.should be_a(System::Group)
      group.gid.to_s.should eq(`id -gr`.strip)
    end

    it "has an effective user" do
      user = Process.effective_user
      user.should be_a(System::User)
      user.uid.to_s.should eq(`id -u`.strip)
    end

    it "has an effective group" do
      group = Process.effective_group
      group.should be_a(System::Group)
      group.gid.to_s.should eq(`id -g`.strip)
    end

    {% if flag?(:openbsd) || flag?(:freebsd) || flag?(:linux) %}
      it "has a saved user" do
        user = Process.saved_user
        user.should be_a(System::User)
      end

      it "has a saved group" do
        group = Process.saved_group
        group.should be_a(System::Group)
      end
    {% end %}
  end
end
