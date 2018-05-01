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
require "../src/system/user"


private USER_NAME = "root"
private USER_ID   = 0

private GROUP_GID = 0

private BAD_USER_NAME = "non_existant_user"
private BAD_USER_ID   = 1234567


describe System::User do
  it "username from uid" do
    System::User.name(USER_ID).should eq(USER_NAME)
    System::User.name?(USER_ID).should eq(USER_NAME)

    expect_raises System::User::NotFoundError do
      System::User.name(BAD_USER_ID)
    end
    System::User.name?(BAD_USER_ID).should be_nil
  end

  it "uid from username" do
    System::User.uid(USER_NAME).should eq(USER_ID)
    System::User.uid?(USER_NAME).should eq(USER_ID)

    expect_raises System::User::NotFoundError do
      System::User.uid(BAD_USER_NAME)
    end
    System::User.uid?(BAD_USER_NAME).should be_nil
  end

  it "gets a user" do
    System::User.get(USER_NAME)
    System::User.get(USER_ID)

    System::User.get?(USER_NAME).should_not be_nil
    System::User.get?(USER_ID).should_not be_nil
  end

  it "raises on user not found" do
    expect_raises System::User::NotFoundError do
      System::User.get(BAD_USER_NAME)
    end
    expect_raises System::User::NotFoundError do
      System::User.get(BAD_USER_ID)
    end

    System::User.get?(BAD_USER_NAME).should be_nil
    System::User.get?(BAD_USER_ID).should be_nil
  end

  it "raises UID out of bounds" do
    System::User.check_uid_in_bounds(System::User::UID_MAX)

    expect_raises System::User::OutOfBoundsError do
      System::User.get(System::User::UID_MAX.to_u64 + 1)
    end
  end

  it "has the correct properties" do
    user = System::User.get(USER_NAME)
    user.name.should eq(USER_NAME)
    user.uid.should eq(USER_ID)
    user.gid.should eq(GROUP_GID)

    user = System::User.get(USER_ID)
    user.name.should eq(USER_NAME)
    user.uid.should eq(USER_ID)
    user.gid.should eq(GROUP_GID)

    user.home.should_not be_nil
    user.shell.should_not be_nil
    user.info.should_not be_nil
  end
end
