describe EmsMiddleware do
  it ".types" do
    expected_types = [NOVAHawk::Providers::Hawkular::MiddlewareManager].collect(&:ems_type)
    expect(described_class.types).to match_array(expected_types)
  end

  it ".supported_subclasses" do
    expected_subclasses = [NOVAHawk::Providers::Hawkular::MiddlewareManager]
    expect(described_class.supported_subclasses).to match_array(expected_subclasses)
  end

  it ".supported_types" do
    expected_types = [NOVAHawk::Providers::Hawkular::MiddlewareManager].collect(&:ems_type)
    expect(described_class.supported_types).to match_array(expected_types)
  end
end
