class CallQuery < Types::BaseResolver
  description "Gets the specified call"
  argument :identifier, String, required: true, description: "Call ID or SID"
  type Outputs::CallType, null: true
  policy CallPolicy, :view?

  def resolve
    Call.by_identifier!(input.identifier).tap { |call| authorize call }
  end
end
