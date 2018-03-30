module NetMiner
  module DataTypes
    class Rating
      include BBLib::Effortless

      TYPES = [:general, :user, :critic].freeze

      attr_float :value, arg_at: 0
      attr_float :scale, default_proc: :guess_scale
      attr_element_of TYPES, :type, default: TYPES.first
      attr_int :votes, default: 1

      def percentage
        value / scale
      end

      def at_scale(max)
        percentage * max
      end

      protected

      def guess_scale
        case value
        when 0..10
          10
        else
          100
        end
      end

    end
  end
end
