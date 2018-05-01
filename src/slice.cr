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


struct Slice(T)
  # Creates a `Slice` to the given *pointer*, bounded by a null-terminator, copying
  # at most `limit` elements.
  #
  # The use of a 'reasonable' value for `limit` is strongly recommended. This will
  # prevent the function from unlimited reading of unintended memory.
  #
  # ```
  # ptr = LibC.getgrnam("wheel").value.gr_mem
  # slice = Slice.new(ptr, limit: LibC::NGROUP_MAX, read_only: true)
  # ```
  def self.new(pointer : U**, *, limit : Int, read_only = false) : Slice(U*) forall U
    size = 0
    until pointer[size].null?
      if size >= limit
        raise MissingTerminatorError.new("Limit reached without finding NULL terminator")
      end
      size += 1
    end
    new(pointer, size, read_only: read_only)
  end

  class MissingTerminatorError < Exception; end

end
