require_relative 'varint.rb'

module Minecraft
  
  module Type
    
    class Boolean
      def self.encode(value)
        return ((!!value) ? 0x01 : 0x00), 1
      end
      
      def self.decode(value)
        return ((value == 0x01) ? true : false), 1
      end
    end
    
    class UnsignedShort
      def self.encode(value)
        return [value].pack("n"), 2
      end
      
      def self.decode(value)
        return value.unpack("n")[0], 2
      end
    end
    
    class String
      def self.encode(value)
        encoded = ""
        encoded << VarInt.encode(value.bytesize)[0]
        encoded << value
        return encoded, encoded.bytesize
      end
      
      def self.decode(value)
        string_size, size_size = VarInt.decode(value)
        return value.byteslice(size_size, string_size), string_size + size_size
      end
    end
    
    class JSON
      def self.encode(value)
        raise
      end
      
      def self.decode(value)
        str, str_size = String.decode(value)
        return ::JSON.parse(str, {:symbolize_names => true}), str_size
      end
    end
  end
  
end
