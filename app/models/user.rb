class User < ActiveRecord::Base
  has_many :pledges, dependent: :nullify
  has_many :campaigns, dependent: :nullify


  #attr_accessor :password
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  before_create :generate_api_key

  def full_name
    "#{first_name} #{last_name}"
  end

  def generate_api_key
    begin
      # Recall that we use self here to reference the object (instance variable)
      # rather than the class. When we are setting a variable we use self. but
      # reading a variable it becomes redundant.
      self.api_key = SecureRandom.hex(32)
    end while User.exists?(api_key: api_key)
  end

end
