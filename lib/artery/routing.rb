module Artery
  module Routing
    class URI
      attr_accessor :service, :model, :action, :plural
      def initialize(arg)
        case arg
        when String
          @service, model, @action = arg.split('.').map(&:to_sym)
          @model = model.to_s.singularize.to_sym
          @plural = (@model == model)
        when Hash
          @service = arg[:service] || Artery.service_name
          @model   = arg[:model].try(:to_sym)
          @action  = arg[:action].try(:to_sym)
          @plural  = arg[:plural]
        else
          raise ArgumentError, 'Unknown argument format'
        end
        raise(ArgumentError, 'service and model must be provided') if @service.blank? || @model.blank?
      end

      def to_route
        [@service, route_model, @action].join('.')
      end
      alias to_s to_route

      def plural?
        @plural
      end

      def route_model
        (plural? ? model.to_s.pluralize : model)
      end
    end

    module_function

    def uri(arg)
      URI.new arg
    end
  end
end
