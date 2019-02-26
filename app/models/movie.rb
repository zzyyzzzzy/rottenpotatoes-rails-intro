class Movie < ActiveRecord::Base
    def self.getRatings
       return ['G','PG','PG-13','R']
    end

    def self.with_ratings(ratings)
        return Movie.where({rating: ratings})
    end
end
