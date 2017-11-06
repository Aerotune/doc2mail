# Based on dk/bordin/doc2mail/RSAEncryptImpl.java
module Doc2Mail
  class RSAEncrypt
    DEFAULT_PADDING = 11
    BYTE_LENGTH = 8
    attr_reader :key_no

    def initialize(certificate)
      @key_no = extract_value('KeyNo', certificate).to_i
      @bit_strength = extract_value('BitStrength', certificate).to_i
      @block_size = @bit_strength / BYTE_LENGTH - DEFAULT_PADDING
      @rsa = parse_rsa(certificate)
    end

    def file_to_h(filepath)
      data = File.read(filepath)

      result = {
        'Filename' => File.basename(filepath),
        'FileLength' => data.bytesize,
        'HashValue' => Digest::SHA256.base64digest(data),
        'File' => Base64.encode64(data)
      }

      result
    end

    def encrypt(cleartext)
      Base64.encode64(@rsa.public_encrypt(cleartext))
    end

    private

    def extract_value(name, content)
      match = content.match(/\<#{name}\>(?<value>.+)\<\//)
      raise 'Certificate not correct' unless match
      match[:value]
    end

    def parse_rsa(certificate)
      mod_raw = extract_value('Modulus', certificate)
      exp_raw = extract_value('Exponent', certificate)

      modulus  = Base64.decode64(mod_raw).unpack('B*').first.to_i(2)
      exponent = Base64.decode64(exp_raw).unpack('B*').first.to_i(2)

      # Generating public key from modulus and exponent
      # http://stackoverflow.com/a/36302768
      mod_asn1_int = OpenSSL::ASN1::Integer.new(modulus)
      exp_asn1_int = OpenSSL::ASN1::Integer.new(exponent)

      sequence = OpenSSL::ASN1::Sequence.new([mod_asn1_int, exp_asn1_int])
      base64 = Base64.encode64(sequence.to_der)
      pem = "-----BEGIN RSA PUBLIC KEY-----\n#{base64}-----END RSA PUBLIC KEY-----"
      OpenSSL::PKey::RSA.new(pem)
    end
  end
end
