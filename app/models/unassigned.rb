class Unassigned
  def present?
    false
  end

  def email_voicemails?
    false
  end

  def receive_incoming_call(*)
    Result.success(response: InvalidPhoneNumberResponse.new.to_s)
  end

  def receive_transfer_request_call(*)
    Result.failure("Cannot transfer to an unassigned number")
  end

  def last_communication_at
    nil
  end
end
