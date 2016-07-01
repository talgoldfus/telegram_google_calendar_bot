require_relative 'google_calendar.rb'
require_relative 'addevent.rb'

class Event
  attr_accessor :bot ,:message, :details, :last_text


    def initialize(bot,message)
      @bot=bot
      @message=message
      @last_text =self.bot.api.getUpdates["result"].last["message"]["text"]
      @details=[]
      @details << @last_text
    end

   
    def update_last
      @last_text =self.bot.api.getUpdates["result"].last["message"]["text"]
    end


    def next_question?
     until self.details.last != self.last_text
      @details << self.bot.api.getUpdates["result"].last["message"]["text"]
      details.uniq!
     end
     update_last
    end

          
    def start_planning            
          bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
            text: "Ok, #{message.from.first_name}!\n 
           Lets start adding your new event to the calendar. First tell me the events name" )

          self.next_question?

          bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
            text: "Great, where will it be located ?")  

          self.next_question?

          bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
            text: "What is the starting date and time ?")
          
         self.next_question?

        bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
            text: "What is the end date and time ?")
          
         self.next_question?
    end


    def display
          @details.shift
          
          result= GoogleCalendar.add_event(@details)  
          result  
    end

end
