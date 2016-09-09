local unquote = require "unquote"

local function golang_expect_equal(str, expected)
  actual = unquote.golang(str)
  if actual ~= expected then
    error(string.format("string: %s expected: %s actual: %s", str, expected, actual))
  end
end

golang_expect_equal(nil, nil)
golang_expect_equal("", nil)
golang_expect_equal([["""]], nil)
golang_expect_equal([[""a]], nil)
golang_expect_equal([[a""]], nil)
golang_expect_equal([[""]], "")
golang_expect_equal([["a"]], "a")
golang_expect_equal([["i\x7e\123\u2603"]], "i~S☃")
golang_expect_equal([["\000\377\xff\x00"]], "\x00\xff\xff\x00")
golang_expect_equal([["\r\n\t"]], "\r\n\t")
golang_expect_equal([["\U0001d49f"]], "𝒟")
