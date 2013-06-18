require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

require 'pp'
require 'justified/standard_error'

class AnError < StandardError
end

class Test
  def bad_code
    raise AnError, 'bad'
  end

  def handle_error
    raise AnError, 'something'
  end

  def something
    bad_code
  rescue
    handle_error
  end

  def do_something
    something
  end
end


describe 'justified' do
  let :error do
    Test.new.do_something rescue $!
  end

  describe 'normal raise' do
    it { error.message.must_equal 'something' }
    it { error.cause.message.must_equal 'bad' }
    it { error.backtrace.must_include 'caused by: (AnError) bad' }
    it do
      assert error.backtrace.any? { |l| l =~ %r"test/justified_test\.rb:\d+:in `bad_code'" }
    end
  end

  describe 'erasing cause' do
    let :error2 do
      error.tap { |e| e.cause = nil }
    end

    it { error2.message.must_equal 'something' }
    it { error2.cause.must_be_nil }
    it { error2.backtrace.wont_include 'caused by: (AnError) bad' }
    it do
      refute error2.backtrace.
                 any? { |l| l =~ %r"test/justified_test\.rb:15:in `bad_code'" }
    end
  end

  describe 'set different cause' do
    let :error2 do
      cause = raise('other') rescue $!
      error.tap { |e| e.cause = cause }
    end

    it { error2.message.must_equal 'something' }
    it { error2.cause.message.must_equal 'other' }
    it { error2.backtrace.must_include 'caused by: (RuntimeError) other' }
    it do
      assert error2.backtrace.any? do |l|
        l =~ %r"test/justified_test\.rb:\d+:in `block \(\d levels\)'"
      end
    end
  end

  describe 'manual creation' do
    let :error do
      cause = raise('other') rescue $!
      error       = AnError.new 'something'
      error.cause = cause
      raise(error) rescue $!
    end

    it { error.message.must_equal 'something' }
    it { error.cause.message.must_equal 'other' }
    it { error.backtrace.must_include 'caused by: (RuntimeError) other' }
    it do
      assert error.backtrace.any? do |l|
        l =~ %r"test/justified_test\.rb:\d+:in `block \(\d levels\)'"
      end
    end
  end

end
