class MutationType < Types::BaseObject
  field :assign_phone_number, mutation: AssignPhoneNumberMutation
  field :create_contact, mutation: CreateContactMutation
  field :update_contact, mutation: UpdateContactMutation
  field :delete_contact, mutation: DeleteContactMutation
  field :remove_contact_from_saved, mutation: RemoveContactFromSavedMutation
  field :create_template, mutation: CreateTemplateMutation
  field :delete_template, mutation: DeleteTemplateMutation
  field :update_template, mutation: UpdateTemplateMutation
  field :create_global_template, mutation: CreateGlobalTemplateMutation
  field :send_message, mutation: SendMessageMutation
  field :retry_failed_message, mutation: RetryFailedMessageMutation
  field :read_conversation, mutation: ReadConversationMutation
  field :register_push_notification_device, mutation: RegisterPushNotificationDeviceMutation
  field :toggle_participant_hold, mutation: ToggleParticipantHoldMutation
  field :toggle_call_recorded, mutation: ToggleCallRecordedMutation
  field :toggle_participant_muted, mutation: ToggleParticipantMutedMutation
  field :toggle_ring_group_member_availability, mutation: ToggleRingGroupMemberAvailabilityMutation
  field :send_participant_to_voicemail, mutation: SendParticipantToVoicemailMutation
  field :toggle_call_forwarding, mutation: ToggleCallForwardingMutation
  field :update_availability, mutation: UpdateAvailabilityMutation
  field :set_call_forwarding_number, mutation: SetCallForwardingNumberMutation
  field :set_caller_id_number, mutation: SetCallerIdNumberMutation
  field :view_voicemail, mutation: ViewVoicemailMutation
  field :record_voicemail_greeting, mutation: RecordVoicemailGreetingMutation
  field :record_ring_group_voicemail_greeting, mutation: RecordRingGroupVoicemailGreetingMutation
  field :transfer_participant, mutation: TransferParticipantMutation
  field :rejoin_call, mutation: RejoinCallMutation
  field :end_call, mutation: EndCallMutation
  field :end_participant_call, mutation: EndParticipantCallMutation
  field :forward_phone_number, mutation: ForwardPhoneNumberMutation
  field :viewed_calls, mutation: ViewedCallsMutation
  field :archive_voicemail, mutation: ArchiveVoicemailMutation
  field :park_participant, mutation: ParkParticipantMutation
  field :merge_call, mutation: MergeCallMutation
  field :delete_recording, mutation: DeleteRecordingMutation
  field :delete_voicemail, mutation: DeleteVoicemailMutation
  field :create_transfer_request, mutation: CreateTransferRequestMutation
  field :transfer_request_response, mutation: TransferRequestResponseMutation
  field :set_email_voicemails, mutation: SetEmailVoicemailsMutation
  field :toggle_call_quality_issue, mutation: ToggleCallQualityIssueMutation

  field :remove_contact_from_saved,
    mutation: RemoveContactFromSavedMutation,
    deprecation_reason: "Use deleteContact mutation instead."
end
