require 'pry'

class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  def initialize(hash)
    hash.each { |k, v| send("#{k}=", v) }
    @@all << self
  end

  def self.create_from_collection(array)
    array.each { |x| Student.new(x) }
  end

  def add_student_attributes(hash)
    hash.each { |k, v| send("#{k}=", v) }
  end

  def self.all
    @@all
  end
end

