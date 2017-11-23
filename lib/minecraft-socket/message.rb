require_relative "type.rb"

module Minecraft
  class Message
    class Tuple
      attr_reader :type, :value, :value_encoded, :encoded_size
      
      def initialize(**hash)
        if hash.has_key?(:value_encoded)
          
        else
          @type  = hash[:type]
          @value = hash[:value]
          
          @value_encoded, @encoded_size = hash[:type].encode(hash[:value])
        end
      end
    end
  
    def initialize
      @message_table = []
    end
    
    def append(type, value, optional_type = nil)
      @message_table << Tuple.new(type: type, value: value)
      return self
    end
    
    def encode
      return @message_table.map{|e| e.value_encoded}.join
    end
    
    def to_s
    end
    
  end
end
