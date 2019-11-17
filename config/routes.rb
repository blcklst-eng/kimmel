require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  post "/graphql", to: "graphql#execute"
  post "/incoming-text", to: "incoming_text#create"
  post "/message-status/:message_id", to: "message_status#create", as: :message_status
  post "/incoming-call", to: "incoming_call#create"
  get "/voicemail/:call_id", to: "voicemail#create", as: :voicemail_create
  post "/voicemail/:call_id", to: "voicemail#store", as: :voicemail_store
  post "/recording/:call_id", to: "recording#store", as: :recording
  post "/outgoing-call", to: "outgoing_call#create"
  post "/walter/message", to: "walter#store", as: :walter_message
  post "/route-call/:call_id", to: "route_call#store", as: :route_call
  post "/queue-call/:call_id", to: "queue_call#store", as: :queue_call
  post "/connect-to-conference/:call_id",
    to: "connect_to_conference#store",
    as: :connect_to_conference
  post "/call-status", to: "call_status#store"
  post "/transfer-participant/:to/:from",
    to: "transfer_participant#store",
    as: :transfer_participant
  post "/transfer-request-call/:id", to: "transfer_request_call#store", as: :transfer_request_call
  get "/enqueued-call-wait", to: "enqueued_call_wait#show", as: :enqueued_call_wait
  post "/rails/active_storage/direct_uploads", to: "direct_uploads#create", as: :direct_uploads
end
