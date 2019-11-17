class CallStateMachine
  include Statesman::Machine

  state :pending, initial: true
  state :initiated
  state :in_progress
  state :completed
  state :busy
  state :failed
  state :no_answer
  state :canceled

  transition from: :pending, to: %i[initiated failed no_answer canceled]
  transition from: :initiated, to: %i[in_progress completed busy failed no_answer canceled]
  transition from: :in_progress, to: [:completed]

  after_transition(
    to: %i[in_progress completed busy failed no_answer canceled],
    after_commit: true
  ) { |call, _transition| call.broadcast_in_progress_call }

  after_transition(to: :in_progress) { |call, _transition| call.update(viewed: true) }

  after_transition(from: :in_progress, to: :completed, after_commit: true) do |call, transition|
    call.update(duration: (transition.created_at - call.answered_at).floor)
    call.notify_stats
  end

  after_transition(
    to: %i[busy failed no_answer],
    after_commit: true
  ) { |call, _transition| BroadcastCountsJob.perform_later(call.user_id) }

  def transition_to(*)
    Statesman::Machine.retry_conflicts { super }
  end
end
