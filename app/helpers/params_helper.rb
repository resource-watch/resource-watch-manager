module ParamsHelper
    def self.permit(params, *args)
        new_params = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
        new_params = ActionController::Parameters.new(new_params)
        new_params.permit(args)
    end
end
