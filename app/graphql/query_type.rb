class QueryType < Types::BaseObject
  field :contacts, resolver: ContactsQuery
  field :contact, resolver: ContactQuery
  field :search_contacts, resolver: SearchContactsQuery
  field :template, resolver: TemplateQuery
  field :templates, resolver: TemplatesQuery
  field :templates_search, resolver: TemplatesSearchQuery
  field :global_templates, resolver: GlobalTemplatesQuery
  field :global_templates_search, resolver: GlobalTemplatesSearchQuery
  field :conversations, resolver: ConversationsQuery
  field :conversation, resolver: ConversationQuery
  field :conversation_history, resolver: ConversationHistoryQuery
  field :search_messages, resolver: SearchMessagesQuery
  field :me, resolver: MeQuery
  field :call_token, mutation: CallTokenQuery
  field :call, resolver: CallQuery
  field :calls, resolver: CallsQuery
  field :ongoing_calls, resolver: OngoingCallsQuery
  field :voicemails, resolver: VoicemailsQuery
  field :voicemail, resolver: VoicemailQuery
  field :recordings, resolver: RecordingsQuery
  field :recording, resolver: RecordingQuery
  field :user, resolver: UserQuery
  field :directory, resolver: DirectoryQuery
  field :search_directory, resolver: SearchDirectoryQuery
  field :counts, resolver: CountsQuery
  field :call_history, resolver: CallHistoryQuery
  field :ring_group, resolver: RingGroupQuery
  field :ring_group_calls, resolver: RingGroupCallsQuery
  field :ring_group_call, resolver: RingGroupCallQuery

  field :unsaved_contacts,
    resolver: UnsavedContactsQuery,
    deprecation_reason: "Unsaved contacts will be accessed via their conversation."

  field :unread_conversations,
    resolver: UnreadConversationsQuery,
    deprecation_reason: "Unread conversations are inline with other conversations."
end
