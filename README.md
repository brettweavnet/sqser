[![Build Status](https://secure.travis-ci.org/brettweavnet/sqser.png)](http://travis-ci.org/brettweavnet/sqser)

# SQSer

SQSer is a library to perform simple job queuing and execution via an Amazon SQS Queue.

It provides a class which can be used as a parent to job classes which can be queued.

The job class and instance variables are converted to YAML and queued.  When the job is processed, the object is created and variables loaded from the message.

## Installation

    gem install sqser

## Usage

### Setup

Set your AWS Secret and Access Keys:

    export AWS_ACCESS_KEY_ID='...'
    export AWS_SECRET_ACCESS_KEY='...'

### Queuing Jobs

Require sqser and set the queue_url

    require 'sqser'
    Sqser::Queue.queue_url = 'https://sqs.us-west-2.amazonaws.com/123456789012/my-dev-queue'

Create a Job Class which inherits from Sqser::Job with attr_accesors for instance variables to be persisted in SQS.

    class TestJob < Sqser::Job
      attr_accessor :value

      def run
        puts "My value: #{@value}."
      end
    end

Create a new job from this class and set the instance values.

    job = TestJob.new
    job.value = 'testing 123'

Queue the job in SQS.

    job.queue_job

You can pass the following options to queue_job.

* :delay_seconds - The number of seconds to delay the message.
* :secret - Secret to encrypt message.

For example

    job.queue_job :delay_seconds => 60

### Running Jobs

To process jobs, create a new Sqser::Queue instance and call process.

    queue = Sqser::Queue.new
    queue.process

You can pass the following options to process.

* :limit - The maximum number of messages to receive.
* :secret - Secret to decrypt messages processed from queue.
* :visibility_timeout - The duration (in seconds) that the received messages are hidden from subsequent retrieve requests.
* :wait_time_seconds - The number of seconds the service should wait for a response when requesting a new message.

For example

    queue.process :visibility_timeout => 180

## Encryption

Messages can be encrypted before being placed in SQS.

If the **:secret** option is specified, the message will be symetrically encrypted with the given secret before the job is queued.

For example:

    job.queue_job :secret => 'this-is-a-secret'

Messages can then be retrieved from the queue and decrypted by specifying **:secret** option to process.

    queue.process :secret => 'this-is-a-secret'

Currently only a single secret can be used per SQS Queue.

See [examples](https://github.com/brettweavnet/sqser/tree/master/examples) for examples leveraging encryption.

## Examples

Checkout the [examples](https://github.com/brettweavnet/sqser/tree/master/examples) for working code.

## Attribution

Thanks to @bradly and @vsomayaji for providing original inspiration.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
