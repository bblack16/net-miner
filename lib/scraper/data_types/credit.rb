module NetMiner
  module DataTypes
    class Credit
      include BBLib::Effortless

      GENDERS = [:unknown, :male, :female, :other]

      attr_str :name, required: true, arg_at: 0
      attr_str :role
      attr_of NetMiner::DataTypes::Image, :profile, allow_nil: true
      attr_element_of GENDERS, :gender, default: GENDERS.first

    end
  end
end
