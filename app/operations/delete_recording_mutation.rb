class DeleteRecordingMutation < Types::BaseMutation
  description "Delete a specified recording"

  argument :id, ID, required: true

  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error

  policy CallPolicy, :manage?

  def resolve
    recording = Recording.find(input.id)
    authorize recording.call

    if recording.call.update(recorded: false)
      {success: true, errors: []}
    else
      {success: false, errors: recording.call.errors}
    end
  end
end
