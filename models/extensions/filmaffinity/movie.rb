module Extensions
  module FilmAffinity
    module Movie
      def markdown_summary
        "*#{title} (#{year})* \n"\
        "⭐️ #{rating}\n"\
        "🎬 #{director}\n"\
        "👥 #{cast.join(', ')} \n\n"\
        "#{sinopsis}"
      end
    end
  end
end

FilmAffinity::Movie.include Extensions::FilmAffinity::Movie
