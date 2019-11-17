class SendNewVoicemailEmailJob < ApplicationJob
  queue_as :default

  def perform(voicemail_id)
    voicemail = Voicemail.find(voicemail_id)

    VoicemailMailer.new_voicemail(voicemail: voicemail).deliver_now
  end
end
