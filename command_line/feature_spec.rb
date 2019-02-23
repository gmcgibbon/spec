require_relative '../spec_helper'

describe "The --enable and --disable flags" do

  it "can be used with gems" do
    ruby_exe("p defined?(Gem)", options: "--enable=gems").chomp.should == "\"constant\""
    ruby_exe("p defined?(Gem)", options: "--disable=gems").chomp.should == "nil"
  end

  it "can be used with gem" do
    ruby_exe("p defined?(Gem)", options: "--enable=gem").chomp.should == "\"constant\""
    ruby_exe("p defined?(Gem)", options: "--disable=gem").chomp.should == "nil"
  end

  it "can be used with did_you_mean" do
    ruby_exe("p defined?(DidYouMean)", options: "--enable=did_you_mean").chomp.should == "\"constant\""
    ruby_exe("p defined?(DidYouMean)", options: "--disable=did_you_mean").chomp.should == "nil"
  end

  it "can be used with rubyopt" do
    ruby_exe("p $VERBOSE", options: "--enable=rubyopt", env: {'RUBYOPT' => '-w'}).chomp.should == "true"
    ruby_exe("p $VERBOSE", options: "--disable=rubyopt", env: {'RUBYOPT' => '-w'}).chomp.should == "false"
  end

  it "can be used with frozen-string-literal" do
    ruby_exe("p 'foo'.frozen?", options: "--enable=frozen-string-literal").chomp.should == "true"
    ruby_exe("p 'foo'.frozen?", options: "--disable=frozen-string-literal").chomp.should == "false"
  end

  ruby_version_is "2.6" do
    it "can be used with jit" do
      ruby_exe("p RubyVM::MJIT.enabled?", options: "--enable=jit").chomp.should == "true"
      ruby_exe("p RubyVM::MJIT.enabled?", options: "--disable=jit").chomp.should == "false"
    end
  end

  it "prints a warning for unknown features" do
    ruby_exe("p 14", options: "--enable=ruby-spec-feature-does-not-exist 2>&1").chomp.should include('warning: unknown argument for --enable')
    ruby_exe("p 14", options: "--disable=ruby-spec-feature-does-not-exist 2>&1").chomp.should include('warning: unknown argument for --disable')
  end

end

