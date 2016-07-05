require_relative 'google_calendar.rb'

class Event
  attr_accessor :bot ,:message, :event_details, :last_text
    
    def initialize(bot,message)
      @bot=bot
      @message=message
      #Sets @last_text with the last message a user has sent to the bot through the bot API.
      @last_text =self.bot.api.getUpdates["result"].last["message"]["text"]
      @event_details=[]
      @event_details << @last_text
    end

    def update_last
      #updates @last_text with the most current message a user has sent to the bot through the bot API.
      @last_text =self.bot.api.getUpdates["result"].last["message"]["text"]
    end

    def get_new_answer
     #A.Loops until the user sends a new message to the bot. 
     #B.Add the new answer to the end of the @event_details array once a new answer has been sent 
     until self.event_details.last != self.last_text
      @event_details << self.bot.api.getUpdates["result"].last["message"]["text"]  
      event_details.uniq!
     end
     update_last
    end
          
    def start_planning            
      bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
        text: "Ok,#{message.from.first_name}!\n"+
        "Lets start adding your new event to the calendar. First tell me the events name")
      get_new_answer #@event_details => ['add event','Ruby meetup']

      bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',text: "Great, where will it be located ?")  
      get_new_answer #@event_details => ['add event','Ruby meetup','Flatiron School']

      bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',text: "What is the starting date and time ?")
      get_new_answer #@event_details => ['add event','Ruby meetup','Flatiron School','July 3 6PM']

      bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',text: "What is the end date and time ?")    
      get_new_answer   #@event_details => ['add event','Ruby meetup','Flatiron School','July 3 6PM','July 3 9PM']

      @event_details.shift #@event_details => ['Ruby meetup','Flatiron School','July 3 6PM','July 3 9PM']
    end
end
