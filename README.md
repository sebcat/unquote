# unquote

Grammar for unquoting strings encoded with golang's strconv.Quote

uses lua-lpeg

## example usage

````
> unquote = require "unquote"
> unquote.golang("\"\"")
> unquote.golang([["\u2603\n\u2603"]])
☃
☃
````
