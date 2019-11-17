class FindCallBySid
  def initialize(id:, sid:)
    @id = id
    @sid = sid
  end

  def find
    find_call ||
      find_ring_group_call ||
      find_call_from_participant!
  end

  private

  attr_reader :id, :sid

  def find_call
    Call.find_by(id: id, sid: sid)
  end

  def find_ring_group_call
    RingGroupCall.find_by(id: id, from_sid: sid)
  end

  def find_call_from_participant!
    Participant.where(sid: sid).joins(:call).merge(Call.where(id: id)).first!.call
  end
end
