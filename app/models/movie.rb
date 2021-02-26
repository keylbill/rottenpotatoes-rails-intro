class Movie < ActiveRecord::Base
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings rates, sort
    movies = rates.length > 0 ? Movie.where(:rating => rates) : Movie.all
    sort ? movies.order(sort) : movies
  end
end