require 'telegram/bot'
require 'filmaffinity'
require_relative 'extensions/filmaffinity/movie'
require 'dotenv'

Dotenv.load

class MovieTron
  TOKEN = ENV['TELEGRAM_BOT_TOKEN']

  def run
    Telegram::Bot::Client.run(TOKEN, logger: Logger.new($stdout)) do |bot|
      bot.listen do |message|
        case message
        when Telegram::Bot::Types::InlineQuery
          search = FilmAffinity::Search.new(message.query)
          results = search.movies[0..5].map do |movie|
            Telegram::Bot::Types::InlineQueryResultArticle.new(
              id: movie.id,
              title: movie.title,
              input_message_content: Telegram::Bot::Types::InputTextMessageContent.new(message_text: movie.markdown_summary, parse_mode: 'Markdown'),
              description: movie.sinopsis,
              thumb_url: movie.poster
            )
          end

          bot.api.answer_inline_query(inline_query_id: message.id, results: results) unless results.empty?
        # when Telegram::Bot::Types::Message
        #   bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}!")
        end
      end
    end
  end
end
