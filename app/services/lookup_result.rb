LookupResult = Struct.new(:phone_number, keyword_init: true) {
  def valid?
    !phone_number.nil?
  end

  def to_s
    phone_number
  end
}
