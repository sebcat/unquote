local lpeg = require "lpeg"

local unquote = {}

-- grammar for unquoting golang's strconv.Quote
local function golang_unquote_grammar()
  local unicode = function(str)
    return utf8.char(tonumber(str:sub(3), 16))
  end
  local num = lpeg.R"09"
  local oct = lpeg.R"07"
  local lowerhex = num + lpeg.R"af"
  local lowerhex2 = lowerhex * lowerhex
  local lowerhex4 = lowerhex2 * lowerhex2
  local lowerhex8 = lowerhex4 * lowerhex4
  local _a = lpeg.P[[\a]]/"\a"
  local _b = lpeg.P[[\b]]/"\b"
  local _f = lpeg.P[[\f]]/"\f"
  local _n = lpeg.P[[\n]]/"\n"
  local _r = lpeg.P[[\r]]/"\r"
  local _t = lpeg.P[[\t]]/"\t"
  local _v = lpeg.P[[\v]]/"\v"
  local _x = lpeg.P[[\x]] * lowerhex2 / function(str)
    return string.char(tonumber(str:sub(3),16))
  end
  local _u = lpeg.P[[\u]] * lowerhex4/unicode
  local _U = lpeg.P[[\U]] * lowerhex8/unicode
  local _bslash = lpeg.P[[\\]]/"\\"
  local _quot = lpeg.P[[\"]]/"\""
  local _oct = lpeg.P[[\]] * oct * oct * oct/function(str)
	return string.char(tonumber(str:sub(2),8))
  end
  local esc = _a + _b + _f + _n + _r + _t + _v + _x + _u + _U + _bslash + _quot + _oct
  local unquote = lpeg.P("\"") * lpeg.Cs((esc+(1-lpeg.P"\""))^0) * lpeg.P("\"") * -1
  return unquote
end

local golang_grammar = golang_unquote_grammar()

unquote.golang = function(str)
  if type(str) ~= "string" then return nil end
  return golang_grammar:match(str)
end

return unquote
