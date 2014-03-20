class User
  include Mongoid::Document
  field :name, type: String
  field :password, type: String
  field :home_city, type: String
end
