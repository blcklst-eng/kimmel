# Preview all emails at http://localhost:3000/rails/mailers/voicemail_mailer
require_relative "../../support/active_storage_helpers"

class VoicemailMailerPreview < ActionMailer::Preview
  def new_voicemail
    call = FactoryBot.create(:incoming_call, :with_participant)
    voicemail = FactoryBot.create(:voicemail, voicemailable: call)

    VoicemailMailer.new_voicemail(voicemail: voicemail)
  end
end
