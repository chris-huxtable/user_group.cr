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

require "spec"
require "../src/system/group"
require "../src/system/user"

{% if flag?(:darwin) || flag?(:openbsd) || flag?(:freebsd) %}
  private GROUP_NAME = "wheel"
  private GROUP_ID = 0
{% elsif flag?(:linux) %}
  # http://refspecs.linux-foundation.org/LSB_5.0.0/LSB-Core-generic/LSB-Core-generic/usernames.html#
  private GROUP_NAME = "root"
  private GROUP_ID = 0
{% else %}
  {{ raise "Unsupported platform, only Darwin, OpenBSD, FreeBSD, and Linux (GNU, musl) are supported." }}
{% end %}

{% if flag?(:darwin) %}
  private GROUP_MEMBERS = `dscl . -read /Groups/#{GROUP_NAME} GroupMembership`.strip.split(':').last.split(' ', remove_empty: true)
{% else %}
  private GROUP_MEMBERS = `getent group #{GROUP_NAME}`.strip.split(':').last.split(',', remove_empty: true)
{% end %}

private BAD_GROUP_NAME = "non_existant_group"
private BAD_GROUP_ID   = 123456

describe System::Group do
  it "groupname from gid" do
    System::Group.name(GROUP_ID).should eq(GROUP_NAME)
    System::Group.name?(GROUP_ID).should eq(GROUP_NAME)

    expect_raises System::Group::NotFoundError do
      System::Group.name(BAD_GROUP_ID)
    end
    System::Group.name?(BAD_GROUP_ID).should be_nil
  end

  it "gid from groupname" do
    System::Group.gid(GROUP_NAME).should eq(GROUP_ID)
    System::Group.gid?(GROUP_NAME).should eq(GROUP_ID)

    expect_raises System::Group::NotFoundError do
      System::Group.gid(BAD_GROUP_NAME)
    end
    System::Group.gid?(BAD_GROUP_NAME).should be_nil
  end

  it "gets a group" do
    System::Group.get(GROUP_NAME).should_not be_nil
    System::Group.get(GROUP_ID).should_not be_nil

    System::Group.get?(GROUP_NAME).should_not be_nil
    System::Group.get?(GROUP_ID).should_not be_nil
  end

  it "raises on group not found" do
    expect_raises System::Group::NotFoundError do
      System::Group.get(BAD_GROUP_NAME)
    end
    expect_raises System::Group::NotFoundError do
      System::Group.get(BAD_GROUP_ID)
    end

    System::Group.get?(BAD_GROUP_NAME).should be_nil
    System::Group.get?(BAD_GROUP_ID).should be_nil
  end

  it "raises GID out of bounds" do
    System::Group.check_gid_in_bounds(System::Group::GID_MAX)

    expect_raises System::Group::OutOfBoundsError do
      System::Group.get(System::Group::GID_MAX.to_u64 + 1)
    end
  end

  it "has the correct properties" do
    group = System::Group.get(GROUP_NAME)
    group.name.should eq(GROUP_NAME)
    group.gid.should eq(GROUP_ID)
    group.member_names.should eq(GROUP_MEMBERS)
    group.members.should eq(GROUP_MEMBERS.map { |n| System::User.get(n) })

    group = System::Group.get(GROUP_ID)
    group.name.should eq(GROUP_NAME)
    group.gid.should eq(GROUP_ID)
    group.member_names.should eq(GROUP_MEMBERS)
    group.members.should eq(GROUP_MEMBERS.map { |n| System::User.get(n) })
  end
end
