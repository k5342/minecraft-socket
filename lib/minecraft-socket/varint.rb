module Minecraft
  
  module Type
    
    class VarInt
      
      @@is_variable_size = true
      @@size = 1..5
      
      def self.encode(original)
        #    0000-0001 0010-1100 : 300
        # ->  000-0010  010-1100 : separate 7bit
        # ->  010-1100  000-0010 : move containing LSB to head's octet
        # -> 1010-1100 0000-0010
    
        # -1
        #  11111111 10001111 11111111 11111111 01111111
        #  
        #  1234567890
        #  01010010 10000100 11001100 11011000 10000101
        
        if original >= 0
          num = original
        else
          num = ((original * -1) ^ 0xFFFFFFFF) + 1
        end
        
        tmp = [num].pack('w').unpack('C*').reverse
        tmp[ 0] |= 0x80
        tmp[-1] &= 0x7F
        
        res = tmp.pack('C*')
        
        return res, res.bytesize
      end
      
      def self.decode(bytes)
        encoded = ""
        bytes.each_byte do |b|
          encoded << b.chr
          if ( b & 0x80 ) >> 7 == 0x00
            break
          end
        end
        
        tmp = encoded.unpack('C*')
        tmp[-1] |= 0x80
        tmp[ 0] &= 0x7F
        tmp = tmp.reverse.pack('C*')
        
        num = tmp.unpack('w')[0]
        
        if num >> 31 == 0x01
          original = ((num - 1) ^ 0xFFFFFFFF) * -1
        else
          original = num
        end
        
        return original, encoded.bytesize
      end
      
      def self.decodable?(bytes)
        (bytes[-1].ord & 0x80) >> 7 == 0x00
      end
    end
  end
end
