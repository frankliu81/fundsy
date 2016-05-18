class User < ActiveRecord::Base
  has_many :pledges, dependent: :nullify
  has_many :campaigns, dependent: :nullify


  #attr_accessor :password
  has_secure_password

  validates :first_name, presence: true, unless: :with_oauth?
  validates :last_name, presence: true, unless: :with_oauth?
  validates :email, presence: true, uniqueness: true, unless: :with_oauth?

  before_create :generate_api_key

  # This will help you easier retrieve the raw data back as a
  # Hash which will make it easire to access and manipulate.
  serialize :twitter_raw_data

  geocoded_by :address
  after_validation :geocode

  def with_oauth?
    provider.present? && uid.present?
  end

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

  def self.find_or_create_with_twitter(omniauth_data)
    user = User.where(provider: "twitter", uid: omniauth_data["uid"]).first
    unless user
      full_name = omniauth_data["info"]["name"]
      user = User.create(first_name: extract_first_name(full_name),
                         last_name: extract_last_name(full_name),
                         provider: "twitter",
                         uid: omniauth_data["uid"],
                         password: SecureRandom.hex(16),
                         twitter_token: omniauth_data["credentials"]["token"],
                         twitter_secret: omniauth_data["credentials"]["secret"],
                         twitter_raw_data: omniauth_data)
      # byebug
    end
  end

  def self.extract_first_name(full_name)
    if full_name.rindex(" ")
      full_name[0..full_name.rindex(" ")-1]
    else
      full_name
    end
  end

  def self.extract_last_name(full_name)
    if full_name.rindex(" ")
      full_name.split.last
    else
      ""
    end
  end

end
