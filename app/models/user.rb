class User < ApplicationRecord
    has_secure_password

    has_many :books, dependent: :destroy
    #file upload
    has_one_attached :avatar

    

    #mobile number
    validates :mobile_number, presence: true, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }

    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 },on: :create
    validates :password, length: { minimum: 6 }, allow_nil: true, on: :update
    validates :name, presence: true

    
    
end
