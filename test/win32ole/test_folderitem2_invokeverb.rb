#
# This script check that Win32OLE can execute InvokeVerb method of FolderItem2.
#

begin
  require 'win32ole'
rescue LoadError
end
require 'test/unit'

if defined?(WIN32OLE)
  class TestInvokeVerb < Test::Unit::TestCase
    def setup
      #
      # make dummy.txt file for InvokeVerb test.
      #

      @fso = WIN32OLE.new('Scripting.FileSystemObject')
      @dummy_path = @fso.GetTempName
      @cfolder = @fso.getFolder(".")
      f = @cfolder.CreateTextFile(@dummy_path)
      f.close
      @dummy_path = @cfolder.path + "\\" + @dummy_path

      @shell=WIN32OLE.new('Shell.Application')
      @fi2 = @shell.NameSpace(@dummy_path).ParentFolder.ParseName(@shell.NameSpace(@dummy_path).Title)
      @shortcut = nil

      #
      # Search the 'Create Shortcut (&S)' string.
      # Yes, I know the string in the Windows 2000 Japanese Edition.
      # But I do not know about the string in any other Windows.
      # 
      verbs = @fi2.verbs
      verbs.extend(Enumerable)
      @shortcut = verbs.collect{|verb| 
        verb.name
      }.find {|name|
        /.*\(\&S\)$/ =~ name
      }
    end

    def find_link(path)
      arlink = []
      @cfolder.files.each do |f|
        if /\.lnk$/ =~ f.path
          linkinfo = @shell.NameSpace(f.path).self.getlink
          arlink.push f if linkinfo.path == path
        end
      end
      arlink
    end

    def test_invokeverb
      links = find_link(@dummy_path)
      assert(0, links.size)

      # Now create shortcut to @dummy_path
      assert(@shortcut)
      arg = WIN32OLE_VARIANT.new(@shortcut)
      @fi2.InvokeVerb(arg)

      # Now search shortcut to @dummy_path
      links = find_link(@dummy_path)
      assert(1, links.size)
      @lpath = links[0].path
    end

    def teardown
      if @lpath
        @fso.deleteFile(@lpath)
      end
      if @dummy_path
        @fso.deleteFile(@dummy_path)
      end
    end

  end
end