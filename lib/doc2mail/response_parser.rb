module Doc2Mail
  module ResponseParser
    def self.parse_delivery_possible_response(response)
      result = response.dig :is_e_delivery_possible_response,
                            :is_e_delivery_possible_result
      raise 'unable to find: is_e_delivery_possible_result' if result.nil?

      params = {}
      params[:is_delivery_possible] = result[:e_delivery_possible]
      params[:delivery_possible_error_code] = result[:error_code].to_i
      params[:delivery_possible_error_message] = result[:error_message]
      params
    end

    def self.parse_upload_response(response)
      upload_file_result = response.dig :upload_file_response,
                                        :upload_file_result
      if upload_file_result.nil?
        raise 'Unable to parse eboks upload_file_response'
      end

      params = {}
      params[:doc2mail_id] = upload_file_result[:id]
      params[:doc2mail_status] = upload_file_result[:status]
      params[:doc2mail_succeded] = upload_file_result[:succeeded]

      upload_file_information = upload_file_result.dig :information, :name_value
      return params unless upload_file_information

      upload_file_information.each do |hash|
        name = hash[:name]
        value = hash[:value]

        field = case name
                when 'destination'    then :doc2mail_destination
                when 'MailPriority'   then :doc2mail_priority
                when 'DpResponse'     then :doc2mail_dp_response
                when 'errorcode'      then :doc2mail_errorcode
                when 'Exception Type' then :doc2mail_exception_type
                when 'Error Message'  then :doc2mail_error_message
                when 'Stack Trace'    then :doc2mail_stack_trace
                when 'Error Source'   then :doc2mail_error_source
                else
                  #raise "Unknown NameValue in upload_file_information: #{name}"
                  nil
                end

        params[field] = value if field
      end

      params
    end
  end
end
