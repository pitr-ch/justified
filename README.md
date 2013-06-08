# Justified

[![Build Status](https://travis-ci.org/pitr-ch/justified.png?branch=master)](https://travis-ci.org/pitr-ch/justified)

A mini-gem to add missing **causes** to exception `backtrace`-s like Java has. This gem will add following
at the bottom of a `backtrace`:

        from caused by: (AnError) an ugly bug
        from justified.rb:83:in `bad_code'
        from     ... skipped 4 lines
        
Exception cause can be also accessed with `#cause` method which returns `nil` or an `Exception`.

## Example

```ruby
require 'justified/standard_error'

begin 
  raise 'a cause'
rescue
  raise 'an exception'
end
```

will print 

```
file.rb:6:in `rescue in <main>': an exception (RuntimeError)
  	from file.rb:3:in `<main>'
  	from caused by: (RuntimeError) a cause
  	from file.rb:4:in `<main>'
  	from     ... skipped 0 lines
```

## Links

-   Documentation: <http://blog.pitr.ch/justified>
-   Source: <https://github.com/pitr-ch/justified>
-   Blog: <http://blog.pitr.ch/blog/categories/justified/>
