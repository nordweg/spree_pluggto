module SpreePluggto
  class SendIntegrationErrors
    attr_reader   :pluggto_id

    def initialize(pluggto_id)
      @pluggto_id = pluggto_id
    end

    def call(error)
      ::SpreePluggto::Api::Request.new.put("/orders/#{pluggto_id}", params(error).to_json)
    end

    def params(error)
      {
        "log_history": [
          {
            "message": "#{error}",
            "date": "#{DateTime.now}"
          }
        ]
      }
    end
  end
end
