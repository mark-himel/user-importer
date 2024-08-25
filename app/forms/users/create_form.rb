module Users
  class CreateForm
    include ActiveModel::Model
    attr_accessor :name, :password

    PASSWORD_FORMAT = /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*(.)\1{2,})/x

    validates :name, presence: true, allow_blank: false
    validates :password,
              presence: true,
              length: { within: 10..16 },
              format: { with: PASSWORD_FORMAT }

    def save
      return false unless valid?

      User.create!(name: name, password: password)
      true
    end
  end
end
