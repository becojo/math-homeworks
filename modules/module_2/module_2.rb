# frozen_string_literal: true

require 'ox'
require 'base64'

class Operation
  attr_reader :success

  def operator
    @operator ||= %w(+ - *).sample
  end

  def answer
    @answer ||= a.public_send(operator, b)
  end

  def a
    @a ||= rand(100)
  end

  def b
    @b ||= rand(100)
  end

  def to_s
    "What is #{a} #{operator} #{b}?"
  end

  def success!
    @success = true
  end
end

class Module2
  OPTIONS = %w(source_code next_question import save quit)

  def initialize
    @storage = 3.times.map { Operation.new }
    @index = 0
  end

  def start
    loop do
      menu
    end
  end

  private

  def menu
    bar
    puts OPTIONS.each.with_index.map { |option, index|
      " [#{index + 1}. #{option}] "
    }.join
    bar
    score
    bar
    puts

    puts "Choice (1-5)?"
    send(OPTIONS[gets.to_i - 1])
  end

  def bar
    puts "-" * 80
  end

  def next_question
    question = @storage[@index % @storage.size]

    puts question
    puts "Answer?"

    if gets.to_i == question.answer
      puts "====== ( G O O D    A N S W E R ! ) ======"
      question.success!
    else
      puts "===== ( W R O N G    A N S W E R ! ) ====="
    end

    @index += 1
  end

  def quit
    exit
  end

  def source_code
    puts "# Running on Ruby #{RUBY_VERSION}"
    puts File.read(__FILE__)
  end

  def import
    puts "Enter your exported blob:"

    @storage = Ox.parse_obj(Base64.strict_decode64(gets.strip))
  end

  def save
    puts Base64.strict_encode64(Ox.dump(@storage))
  end

  def score
    puts "Score: #{@storage.select(&:success).size} / #{@storage.size}"
  end

  def puts(str = '')
    STDOUT.write(str.to_s + "\n")
    STDOUT.flush
  end
end

Module2.new.start

