require 'telegram/bot'
require_relative 'google_calendar.rb'
require_relative 'addevent.rb'



token = '223086021:AAGppRpcZlNoGFYq2NKwuuUBUCNx4-LUtGM'

Telegram::Bot::Client.run(token) do |bot|
  # binding.pry

 

  bot.listen do |message|

     bot.api.getUpdates["result"]=[]

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


       when '/add_event' 
            event=Event.new(bot,message)
            event.start_planning
            bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
            text: "#{event.display}" )
            
       end





  end
end




   


  


