require 'json'

module Minecraft
  
  class Packet
    attr_reader :length, :packet_id, :packed_id_encoded, :data, :data_encoded
    
    def initialize(packet_id, message = Message.new)
      
      unless message.is_a?(Message)
        raise TypeError
      end
      
      @packed_id = packet_id
      @packed_id_encoded, @packed_id_encoded_size = Type::VarInt.encode(packet_id)
      @data = message
      @data_encoded = message.encode
      @length = @data_encoded.bytesize + @packed_id_encoded_size
    end
    
    def encode
      raw = ""
      raw << Type::VarInt.encode(@length)[0]
      raw << @packed_id_encoded
      raw << @data_encoded
      return raw
    end
    
    def self.decode(raw)
      if !raw || raw.empty?
        return nil
      end
      
      packet_id, packet_id_size = Type::VarInt.decode(raw)
      data = raw.byteslice(packet_id_size, raw.bytesize)
      
      response = {
        packet_id: packet_id,
      }
      
      decode_procedures = {
        0x00 => [
          [:data, Type::JSON],
        ]
      }
      
      proceed_bytes = 0
      decode_procedures[packet_id].each do |e|
        key, klass = e
        
        response[key], bytes = klass.decode(data.byteslice(proceed_bytes, data.bytesize))
        proceed_bytes += bytes
      end
      
      return response
    end
    
  end
end
