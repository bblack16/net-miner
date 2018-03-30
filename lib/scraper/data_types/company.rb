module NetMiner
  module DataTypes
    class Company
      include BBLib::Effortless

      attr_str :name, required: true, arg_at: 0
      attr_str :description
      attr_str :country
      attr_of NetMiner::DataTypes::Link, :homepage, allow_nil: true
      attr_of NetMiner::DataTypes::Image, :logo, allow_nil: true

    end
  end
end
