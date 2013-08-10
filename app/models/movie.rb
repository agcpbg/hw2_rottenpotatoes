class Movie < ActiveRecord::Base

  def self.all_ratings
    ratings = []
    self.all.each do |m|
      ratings << m.rating
    end
    ratings = ratings.uniq
    return ratings
  end

end
