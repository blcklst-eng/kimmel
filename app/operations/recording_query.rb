class RecordingQuery < Types::BaseResolver
  description "Gets the specified recording"
  argument :id, ID, required: true
  type Outputs::RecordingType, null: true
  policy RecordingPolicy, :view?

  def resolve
    Recording.find(input.id).tap { |recording| authorize recording }
  end
end
