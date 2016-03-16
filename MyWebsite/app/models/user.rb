class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :username, :email, :password, :password_confirmation
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i #For validation of email i use this regex.
  validates :username, :presence      => true,
            :uniqueness               => true,
            :length                   => { :in => 3..20 }
  #----------------------------------------------------------------------------
  validates :email,         :presence => true,
                          :uniqueness => true,
                              :format => EMAIL_REGEX
  #----------------------------------------------------------------------------
  validates :password,  :confirmation => true #password_confirmation attr
  #----------------------------------------------------------------------------
  validates_length_of  :password, :in => 6..100,
                                  :on => :create

  before_save :encrypt_password
  after_save :clear_password



  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end

  def self.change_pw(email,pswd)
    if(EMAIL_REGEX.match(email))
      user = User.find_by(:email => email)
    else
      user = User.find_by(:username => email)
    end

    user.password = nil #Do I need those two lines?
    user.password_confirmation = nil

    user.password = pswd
    user.password_confirmation = pswd

    user.save
  end

  def self.authenticate(username_or_email = "", login_password = "")
    if(EMAIL_REGEX.match(username_or_email))
      user = User.find_by(:email => username_or_email)
    else
      user = User.find_by(:username => username_or_email)
    end
    if user && user.match_password(login_password)
      return user
    else
      return false
    end
  end


  def self.get_name
    username = User.where('username = ?', 'Thang')
    return username.to_s
  end

  def match_password(login_password = "")
    encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
  end

end
