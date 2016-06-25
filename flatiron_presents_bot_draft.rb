require 'telegram/bot'
require_relative 'google_calendar.rb'


token = '223086021:AAFsC6JjQXTDyqCNvuGosY2fthXnBAbwU7Q'

Telegram::Bot::Client.run(token) do |bot|
  # binding.pry

  bot.listen do |message|
    case message.text

      when 'hello','hi'
        bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
          text: "Hello, #{message.from.first_name}!\n 
          Would you like to hear your schedule for today?")

      when 'today','yes'
        bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
           text: "#{GoogleCalendar.get_items('today')}")

      when 'tomorrow'
        bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
          text: "#{GoogleCalendar.get_items('tomorrow')}")

      when 'week','whole week'
        bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
          text: "#{GoogleCalendar.get_items('week')}")    
      end
  end
end