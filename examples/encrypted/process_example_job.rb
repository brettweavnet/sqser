#!/usr/bin/env ruby

require 'sqser'
require File.join(__FILE__, '..', 'example_job')

Sqser::Queue.queue_url = ENV['SQS_QUEUE_URL']
Sqser::Queue.new.process :secret => 'this-is-a-secret', :visibility_timeout => 180
