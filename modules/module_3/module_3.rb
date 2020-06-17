# frozen_string_literal: true

require 'oj'
require 'base64'

class Array
  def average
    sum / size
  end

  def range
    min, max = minmax
    max - min
  end
end

class Question
  attr_reader :success

  def initialize
    @success = false
    @type = %w(range average sum).sample
    @array = 5.times.map { rand(100) }
  end

  def to_s
    "What is the #{@type} of the following integers:\n\n" \
    "    #{@array}\n"
  end

  def answer
    @answer ||= @array.send(@type)
  end

  def success!
    @success = true
  end
end

class Module3
  OPTIONS = %w(source_code next_question import save quit)

  def initialize
    @storage = 3.times.map { Question.new }
    @index = 0
  end

  def start
    loop do
      menu
    end
  end

  private

  def source_code
    puts "# Running on Ruby #{RUBY_VERSION}"
    puts File.read(__FILE__)
  end

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

  def import
    puts "Enter your exported blob:"

    @storage = Oj.load(Base64.strict_decode64(gets.strip))
  end

  def save
    puts Base64.strict_encode64(Oj.dump(@storage))
  end

  def bar
    puts "-" * 80
  end

  def score
    puts "Score: #{@storage.select(&:success).size} / #{@storage.size}"
  end

  def puts(str = '')
    STDOUT.write(str.to_s + "\n")
    STDOUT.flush
  end
end

Module3.new.start

