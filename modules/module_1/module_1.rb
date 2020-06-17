# frozen_string_literal: true

# TODO: Students complain they can't get any answer right /shrug

require 'base64'

class Question
  attr_reader :success

  def check_answer(x)
    (a * (x ** 2) + b * x + c) == 0
  end

  def to_s
    "Given f(x) = #{a}x² + #{b}x + #{c}. Find a value of x such that f(x) = 0."
  end

  def a
    @a ||= rand
  end

  def b
    @b ||= rand
  end

  def c
    @c ||= rand
  end

  def success!
    @success = true
  end
end

class Module1
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

    if question.check_answer(gets.to_i)
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

    @storage = Marshal.load(Base64.strict_decode64(gets.strip))
  end

  def save
    puts Base64.strict_encode64(Marshal.dump(@storage))
  end

  def score
    correct = @storage.select(&:success).size

    puts "Score: #{correct}  #{@storage.size}"

    if correct == @storage.size
      puts File.read('flag')
    end
  end

  def puts(str = '')
    STDOUT.write(str.to_s + "\n")
    STDOUT.flush
  end
end

Module1.new.start

