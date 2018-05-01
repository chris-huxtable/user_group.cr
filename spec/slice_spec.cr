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
require "../src/slice"


describe "Slice" do
  it "does accept null terminated pointer" do
    slice_0 = "abc".to_slice
    slice_1 = "def".to_slice
    slice_2 = "ghi".to_slice
    slice_3 = "jkl".to_slice

    ptr = Pointer(Pointer(UInt8)).malloc(6)
    ptr[0] = slice_0.pointer(0)
    ptr[1] = slice_1.pointer(0)
    ptr[2] = slice_2.pointer(0)
    ptr[3] = slice_3.pointer(0)
    ptr[4] = Pointer(UInt8).null

    slice = Slice.new(ptr, limit: 8, read_only: true)
    slice.size.should eq(4)
    slice[0].should eq(slice_0.pointer(0))
    slice[1].should eq(slice_1.pointer(0))
    slice[2].should eq(slice_2.pointer(0))
    slice[3].should eq(slice_3.pointer(0))

    slice = Slice.new(ptr, limit: 4, read_only: true)
    slice.size.should eq(4)
    slice[0].should eq(slice_0.pointer(0))
    slice[1].should eq(slice_1.pointer(0))
    slice[2].should eq(slice_2.pointer(0))
    slice[3].should eq(slice_3.pointer(0))

    expect_raises(Slice::MissingTerminatorError) { Slice.new(ptr, limit: 3, read_only: true) }
    expect_raises(Slice::MissingTerminatorError) { Slice.new(ptr, limit: 2, read_only: true) }
    expect_raises(Slice::MissingTerminatorError) { Slice.new(ptr, limit: 1, read_only: true) }
  end
end
