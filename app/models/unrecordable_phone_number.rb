class UnrecordablePhoneNumber < ApplicationRecord
  validates :number, presence: true, uniqueness: true

  def self.recordable?(phone_numbers)
    !UnrecordablePhoneNumber.where(number: phone_numbers).exists?
  end
end
