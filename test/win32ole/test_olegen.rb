# frozen_string_literal: true
#
begin
  require 'win32ole'
rescue LoadError
  return
end
require "test/unit"

class TestWIN32OLE_OLEGEN < Test::Unit::TestCase
  def test_xml
    samples = File.join(__dir__, "../../sample/win32ole")
    require File.join(samples, "olegen.rb")
    require 'stringio'
    expected = File.join(samples, "xml.rb")
    output = StringIO.new
    typelib = 'Microsoft XML, version 2.0'
    comgen = WIN32COMGen.new(typelib)
    begin
      comgen.generate(output)
    rescue WIN32OLE::RuntimeError => e
      assert_include(e.message, typelib)
    else
      assert_equal(expected, output.string)
    end
  end
end
