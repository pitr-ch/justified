# Justified

A mini gem to add missing **causes** to exception `backtrace`s like Java has.

        from caused by: (AnError) an ugly bug
        from justified.rb:83:in `bad_code'
        from     ... skipped 4 lines

## Example

Let's have following snippet:

```ruby
def bad_code
  raise AnError, 'an ugly bug'
end

def handle_error(error)
  raise AnError, 'something went wrong'
end

def do_something
  bad_code
rescue => error
  handle_error error
end

do_something
```

When called it will produce:

    justified.rb:93:in `handle_error': something went wrong (AnError)
        from justified.rb:89:in `rescue in do_something'
        from justified.rb:87:in `do_something'
        from justified.rb:96:in `<top (required)>'
        from -e:1:in `load'
        from -e:1:in `<main>'

The real problem `an ugly bug` is **hidden**. What will happen when `justified` is used?

```ruby
require 'justified/stadard_error'
class AnError < StadardError; end

# ... rest of the snipper
```

It will produce:

    justified.rb:93:in `handle_error': something went wrong (AnError)
        from justified.rb:89:in `rescue in do_something'
        from justified.rb:87:in `do_something'
        from justified.rb:96:in `<top (required)>'
        from -e:1:in `load'
        from -e:1:in `<main>'
        from caused by: (AnError) an ugly bug
        from justified.rb:83:in `bad_code'
        from     ... skipped 4 lines

Of course causes can be concatenated. 

## Usage

*   `require 'justified'` to include `Justified::Error` to any exception you need manualy
*   `require 'justified/standard_error'` to have causes in all exceptions which are kind of `StandardError`

### Behaviour

When an exception is risen inside rescue block a cause is automatically recorded.

```ruby
e = begin
      raise 'bug'
    rescue => error
      raise 'this does not work'
    end rescue $!
e.cause.message == 'bug' # => true
```

Cause can be set explicitly.

```ruby
e = begin
      raise 'bug'
    rescue => error
      raise StandardError.new('this does not work', error)
    end rescue $!
e.cause.message == 'bug' # => true
```

Or if signature of `.new` is changed cause can be set with a setter `#cause=`

```ruby
class InspectingError < StandardError
  def initialize(object)
    super object.inspect
  end
end

e = begin
      raise 'bug'
    rescue => error
      raise InspectingError.new(a: 'b').tap { |e| e.cause = error }
    end rescue $!
e.cause.message == 'bug' # => true
```
 
and

```ruby
e = begin
      raise 'bug'
    rescue => error
      raise InspectingError.new(a: 'b')
    end rescue $!
e.cause.message == 'bug' # => true
```

will work as well.
