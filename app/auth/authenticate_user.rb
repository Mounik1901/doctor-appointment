class AuthenticateUser
  def initialize(email, password, user_type)
    @email = email
    @password = password
    @user_type = user_type
  end

  def tokenize
    if user
      JsonWebToken.encode(user_id: user.id, user_type: @user_type)
    else
      false
    end
  end

  private

  attr_reader :email, :password, :user_type

  def user
    user = user_type == "Patient" ? Patient.find_by(email: email) : Doctor.find_by(email: email)
    if user && user.authenticate(password)
      return user
    else
      false
    end
  end
end