require 'openssl'
require 'json'
module File_Security
    def encrypt(string, key)
        cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt
        cipher.key = Digest::SHA1.hexdigest key
        s = cipher.update(string) + cipher.final
    
        return s.unpack('H*')[0].upcase
      end
    
      def decrypt(string, key, return_value = 'string')
        cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').decrypt
        cipher.key = Digest::SHA1.hexdigest key
        s = [string].pack("H*").unpack("C*").pack("c*")
        se =  cipher.update(s) + cipher.final
        return return_value == 'string' ? se : return_value == 'hash' ? JSON.parse(se) : se
      end

end
