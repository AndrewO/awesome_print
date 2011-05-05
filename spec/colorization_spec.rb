require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AwesomePrint" do
  describe "colorization" do
    PLAIN = '[ 1, :two, "three", [ nil, [ true, false ] ] ]'
    COLORIZED = "[ \e[1;34m1\e[0m, \e[0;36m:two\e[0m, \e[0;33m\"three\"\e[0m, [ \e[1;31mnil\e[0m, [ \e[1;32mtrue\e[0m, \e[1;31mfalse\e[0m ] ] ]"

    before(:each) do
      AwesomePrint.force_colors!(false)
      @arr = [ 1, :two, "three", [ nil, [ true, false] ] ]
    end
    
    it "colorizes tty processes by default" do
      class << STDOUT
        def tty?
          true
        end
      end
      @arr.ai(:multiline => false).should == COLORIZED
    end
    
    it "does not colorize tty processes running in dumb terminals by default" do
      class << STDOUT
        def tty?
          true
        end
      end
      ENV["TERM"] = "dumb"
      @arr.ai(:multiline => false).should == PLAIN
    end
    
    it "does not colorize subprocesses by default" do
      class << STDOUT
        def tty?
          false
        end
      end
      @arr.ai(:multiline => false).should == PLAIN
    end
    
    describe "forced" do
      before(:each) do
        AwesomePrint.force_colors!
      end
      
      it "still colorizes tty processes" do
        class << STDOUT
          def tty?
            true
          end
        end
        @arr.ai(:multiline => false).should == COLORIZED
      end
      
      it "colorizes dumb terminals" do
        class << STDOUT
          def tty?
            true
          end
        end
        ENV["TERM"] = "dumb"
        @arr.ai(:multiline => false).should == COLORIZED
      end

      it "colorizes subprocess" do
        class << STDOUT
          def tty?
            false
          end
        end
        @arr.ai(:multiline => false).should == COLORIZED
      end
    end
  end
end