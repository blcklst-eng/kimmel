class RecordVoicemailGreetingMutation < Types::BaseMutation
  description "Saves the provided audio as the voicemail greeting message for the current user"

  argument :audio,
    Types::ActiveStorageSignedIdType,
    description: "The signed id of the audio file",
    required: true

  field :user, Outputs::UserType, null: true
  field :errors, resolver: Resolvers::Error

  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    if current_user.update(voicemail_greeting: input.audio)
      {user: current_user, errors: []}
    else
      {user: nil, errors: current_user.errors}
    end
  end
end
