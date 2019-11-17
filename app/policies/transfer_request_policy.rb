class TransferRequestPolicy < ApplicationPolicy
  def respond?
    record.receiver == user
  end
end
