module Doc2Mail
  class WebService
    def initialize(certificate, env)
      @rsa_encrypt = Doc2Mail::RSAEncrypt.new(certificate)
      case env
      when 'production', :production
        wdsl_url = 'https://privat.doc2mail.dk/delivery/FileUploader.asmx?wsdl'
      when 'test', :test
        wdsl_url = 'http://www.activeform.dk/Doc2MailDelivery/FileUploader.asmx?wsdl'
      else
        raise "Unexpected environment #{env.inspect}"
      end
      @soap_client = Savon.client(wsdl: wdsl_url, soap_version: 2)
    end

    def delivery_possible?(username, meta_information)
      cleartext = "|doc2mail|#{timestamp}|#{username}|0"
      message = {
        'signer' => @rsa_encrypt.key_no,
        'crypto' => @rsa_encrypt.encrypt(cleartext),
        'sendingSystem' => 'Dogndata',
        'receiverType' => meta_information.receivertype,
        'receiver' => meta_information.receiver,
        'documentType' => meta_information.documenttype
      }

      if meta_information
        message['metaInformation'] = {
          'NameValue' => meta_information.to_a
        }
      end

      response = @soap_client.call(:is_e_delivery_possible, message: message)
      response.body
    end

    def upload(username, meta_information, filepath, attachment_filepaths = [])
      file = @rsa_encrypt.file_to_h(filepath)
      cleartext = "|doc2mail|#{timestamp}|#{username}|#{file['HashValue']}"

      message = {
        'signer' => @rsa_encrypt.key_no,
        'crypto' => @rsa_encrypt.encrypt(cleartext),
        'metaInformation' => {
          'NameValue' => meta_information.to_a
        },
        'file' => file
      }

      if attachment_filepaths.any?
        attachment_files = attachment_filepaths.map do |attachment_path|
          {
            'File' => @rsa_encrypt.file_to_h(attachment_path),
            'metaInformation' => []
          }
        end

        message['addendums'] = {}
        message['addendums']['Addendum'] = attachment_files

        upload_method = :upload_file_with_addendum
      else
        upload_method = :upload_file
      end

      response = @soap_client.call(upload_method, message: message)
      response.body
    end

    private

    def timestamp
      Time.zone.now.strftime('%Y-%m-%dT%T')
    end
  end
end
