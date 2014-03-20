class User

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
         #:recoverable, :rememberable, :trackable, :timeoutable

  ## Database authenticatable
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  field :home_city, type: String

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  # roles and rights
  field :roles_ids, type: Array, default: []
  field :rights_ids, type: Array, default: []

  field :login, type: String
  field :password, type: String

  field :authentication_token

  validates :login, presence: true, uniqueness: true
  validates :password, length: { in: 6..128 }, on: :create
  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true
  validates_each :login do |record, attr, value|
    record.errors.add attr, 'spaces' if /[\W]/ =~ (value.to_s)
  end

end
