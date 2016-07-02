require 'telegram/bot'
require_relative 'google_calendar.rb'
require_relative 'addevent.rb'


token = '223086021:AAGppRpcZlNoGFYq2NKwuuUBUCNx4-LUtGM'

Telegram::Bot::Client.run(token) do |bot|
  # binding.pry
 

  bot.listen do |message|

    case 

      when  message.text.downcase.include?('hello') || message.text.downcase.include?('hi')
        bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
          text: "Hello, #{message.from.first_name}!\n 
          I'm can help you look up and add events to your Google calendar. How can i assit you today ?")
         message.text = ""
      when message.text.downcase.include?('today')
        bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
           text: "#{GoogleCalendar.get_items('today')}")
         message.text = ""

      when message.text.downcase.include?('tomorrow')
        bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
          text: "#{GoogleCalendar.get_items('tomorrow')}")
         message.text = ""

      when message.text.downcase.include?('week')
        bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
          text: "#{GoogleCalendar.get_items('week')}") 
         message.text = ""

       when '/add_event' 
            event=Event.new(bot,message)
            event.start_planning
            bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
            text: "#{event.display}")
            message.text = ""
        
       end

  end
end




   


  


