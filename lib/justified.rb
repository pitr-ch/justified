module Justified
  SKIP_STR   = '    ... skipped %s lines'
  CAUSED_STR = 'caused by:'

  def self.version
    @version ||= Gem::Version.new File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))
  end

  module Error
    def initialize(message = nil, cause = $!)
      super(message)
      set_cause cause
      @backtrace = nil
    end

    # Set cause of the exception
    # @param [nil, Exception] exception
    def cause=(exception)
      set_cause exception
      set_backtrace
    end

    # @return [Exception] cause of the exception
    def cause
      @cause
    end

    def set_backtrace(backtrace = nil)
      @backtrace ||= backtrace
      backtrace  ||= @backtrace

      if backtrace
        unless cause
          super backtrace
        else
          cause_backtrace, rest   = split_cause_backtrace
          same_line_count         = calculate_same_line_count backtrace, cause_backtrace
          cause_backtrace_striped = cause_backtrace[0..-(same_line_count+1)]

          super backtrace +
                    ["#{CAUSED_STR} (#{cause.class}) #{cause.message}"] +
                    cause_backtrace_striped +
                    [SKIP_STR % same_line_count] +
                    recalculate_rest(rest, same_line_count)
        end
      end
    end

    private

    def set_cause(cause)
      cause.nil? or exception.kind_of? Exception or
          raise ArgumentError, 'cause must be kind of Exception'
      @cause = cause
    end

    def split_cause_backtrace
      _, cause_index = cause.backtrace.each_with_index.find { |line, _| line =~ /^#{CAUSED_STR}/ }
      if cause_index
        [cause.backtrace[0...cause_index], cause.backtrace[cause_index..-1]]
      else
        [cause.backtrace, []]
      end
    end

    def recalculate_rest(rest, same_line_count)
      rest.map do |line|
        line.gsub(/^#{SKIP_STR % '(\d+)'}$/) do
          SKIP_STR % ($1.to_i - same_line_count)
        end
      end
    end

    def calculate_same_line_count(backtrace, cause_backtrace)
      backtrace.reverse.zip(cause_backtrace.reverse).select { |a, b| a == b }.size
    end
  end
end
