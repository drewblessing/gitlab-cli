require 'rubygems'
require 'optparse'
require 'etc'
require 'yaml'
require 'fileutils'
require File.expand_path('../gitlab/config', __FILE__)
require File.expand_path('../gitlab/project', __FILE__)
require File.expand_path('../gitlab/snippet', __FILE__)
require File.expand_path('../gitlab/util', __FILE__)

class Gitlab
  def initialize
    config = "config.yml"

    Config.load(config)
  end
end

